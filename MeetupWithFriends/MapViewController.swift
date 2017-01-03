//
//  MapViewController.swift
//  MeetupWithFriends
//
//  Created by Paul Kim on 12/9/16.
//  Copyright © 2016 BPV, Inc. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import Firebase

// Mark: - MapViewController

class MapViewController: UIViewController {
    
    // Mark: Properties
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var places: Places!
    var type: String!
    var user: FIRUser!
    var zoomLevel = GoogleConstants.Configuration.startingZoom
    var defaultLocation = GoogleConstants.Configuration.defaultLocation
    var didLoadInitialNearbyPlaces = false
    
    // Mark: Outlets
    
    @IBOutlet weak var googleMapView: GMSMapView!
    
    // Mark: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up Core Location
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        configureMap()
    }
    
    func configureMap() {
        // create GMSCamera and assign to map
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.latitude, zoom: zoomLevel)
        googleMapView.camera = camera
        
        // map configuration
        googleMapView.settings.compassButton = true
        googleMapView.settings.zoomGestures = true
        googleMapView.settings.myLocationButton = true
    }
    
    // Mark: Load Nearby Places
    
    func loadNearbyPlaces(latitude: Double, longitude: Double, pageToken: String?) {
        // load resuts from Places API
        GooglePlacesConvenience.getNearbyPlaces(latitude: latitude, longitude: longitude, type: type, pageToken: nil, withCompletionHandler: { (places, error) in
            
            guard error == nil else {
                Helpers.displayError(view: self, errorString: error)
                return
            }
            
            self.places = places

            self.createMarkers()
            
            self.displayCards()
        })
    }
    
    func createMarkers() {
        performUIUpdatesOnMain {
            for place in self.places.places {
                let position = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
                let marker = GMSMarker(position: position)
                marker.title = place.name
                
                // get the image
                // TODO: cache icon images
                var data: Data
                do {
                    data = try Data(contentsOf: URL(string: place.icon)!)
                } catch {
                    continue
                }
                marker.icon = UIImage(data: data, scale: 3)
                marker.map = self.googleMapView
            }
        }
    }
    
    // Mark: Center Map
    
    func centerMap(latitude: Double, longitude: Double) {
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoomLevel)
        googleMapView.animate(to: camera)
    }

    // Mark: Actions
    
    @IBAction func findAddress(_ sender: Any) {
        // present an alertView to get address
        let addressAlert = UIAlertController(title: "Search by Address", message: "Enter an address to search around.", preferredStyle: .alert)
        
        addressAlert.addTextField { (textField) in
            textField.placeholder = "Address or City, State or Zip"
        }
        
        // search action
        let searchAction = UIAlertAction(title: "Search", style: .default) { (alertAction) in
            // TODO: perform validation on textfield
            let address = ((addressAlert.textFields?[0])! as UITextField).text! as String
            
            GoogleMapsConvenience.geocodeAddress(address: address, withCompletionHandler: { (coordinate, error) in
                
                guard error == nil else {
                    Helpers.displayError(view: self, errorString: error)
                    return
                }
                
                guard let coordinate = coordinate else {
                    Helpers.displayError(view: self, errorString: "Please try another address or try again later")
                    return
                }
                
                // create marker
                let position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
                let marker = GMSMarker(position: position)
                marker.map = self.googleMapView
                
                // center the map
                self.centerMap(latitude: coordinate.latitude, longitude: coordinate.longitude)
                
                self.loadNearbyPlaces(latitude: coordinate.latitude, longitude: coordinate.longitude, pageToken: nil)
            })
        }
        
        // close action
        let closeAction = UIAlertAction(title: "Close", style: .cancel)
        
        // add actions to the alert controller
        addressAlert.addAction(searchAction)
        addressAlert.addAction(closeAction)
        
        present(addressAlert, animated: true, completion: nil)
    }
    
    @IBAction func displayCards() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "PlaceCardViewController") as! PlaceCardViewController
        
        // load places
        controller.places = places
        controller.user = user
        
        present(controller, animated: true, completion: nil)
    }
}

// Mark: - MapViewController: CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        
        if googleMapView.isHidden {
            googleMapView.isHidden = false
            googleMapView.camera = camera
        } else {
            googleMapView.animate(to: camera)
        }
        
        // only load places once automatically, subsequent requests must be triggered manually
        if didLoadInitialNearbyPlaces == false {
            loadNearbyPlaces(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, pageToken: nil)
            didLoadInitialNearbyPlaces = true
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            googleMapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            googleMapView.isMyLocationEnabled = true
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        Helpers.displayError(view: self, errorString: error.localizedDescription)
    }
    
}

// Mark: - MapViewController: GMSMapViewDelegate

extension MapViewController: GMSMapViewDelegate {
    
}

