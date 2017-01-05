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
    var iconCache = [String: UIImage]()
    
    // Mark: Outlets
    
    @IBOutlet weak var googleMapView: GMSMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
    
    // Mark: Config
    
    func configureMap() {
        googleMapView.delegate = self
        
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

            self.createMarkersForNearbyPlaces()
            
            self.displayCards(startingIndex: 0)
            
            self.activityIndicator.stopAnimating()
        })
    }
    
    // Mark: Map Manipulation
    
    // wrapper method to perform necessary tasks on map when searching nearby
    func searchNearby(latitude: Double, longitude: Double) {
        googleMapView.clear()
        
        activityIndicator.startAnimating()
        
        createMarker(latitude: latitude, longitude: longitude)
        
        centerMap(latitude: latitude, longitude: longitude)
        
        loadNearbyPlaces(latitude: latitude, longitude: longitude, pageToken: nil)
    }
    
    func createMarker(latitude: Double, longitude: Double) {
        let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let marker = GMSMarker(position: position)
        marker.map = self.googleMapView
    }
    
    func centerMap(latitude: Double, longitude: Double) {
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoomLevel)
        googleMapView.animate(to: camera)
    }
    
    func createMarkersForNearbyPlaces() {
        for (index, place) in self.places.places.enumerated() {
            let position = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
            let marker = GMSMarker(position: position)
            
            marker.userData = index
            marker.title = place.name
            marker.icon = getIconImage(iconURL: place.icon)
            
            performUIUpdatesOnMain {
                marker.map = self.googleMapView
            }
        }
    }
    
    func getIconImage(iconURL: String) -> UIImage {
        // check if we already downloaded the image and reuse
        if let image = iconCache[iconURL] {
            return image
        } else {
            // download the image
            var data: Data
            do {
                data = try Data(contentsOf: URL(string: iconURL)!)
                let image = UIImage(data: data, scale: 3)!
                iconCache[iconURL] = image
                return image
            } catch {
                return UIImage()
            }
        }
    }
    

    // Mark: Actions
    
    @IBAction func didPressFindAddress(_ sender: Any) {
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
                
                // clear everything
                self.searchNearby(latitude: coordinate.latitude, longitude: coordinate.longitude)
            })
        }
        
        // close action
        let closeAction = UIAlertAction(title: "Close", style: .cancel)
        
        // add actions to the alert controller
        addressAlert.addAction(searchAction)
        addressAlert.addAction(closeAction)
        
        present(addressAlert, animated: true, completion: nil)
    }

    @IBAction func didPressCards(_ sender: Any) {
        displayCards(startingIndex: 0)
    }
    
    func displayCards(startingIndex: Int) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "PlaceCardViewController") as! PlaceCardViewController
        
        // load places
        controller.places = places
        controller.user = user
        controller.startingIndex = startingIndex
        controller.delegate = self
        
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
        

        loadNearbyPlaces(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, pageToken: nil)
        
        createMarker(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
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
    
    // drop a marker to do a search
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        searchNearby(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        displayCards(startingIndex: marker.userData as! Int)
    }
}

// Mark: - MapViewController: PlaceCardViewDelegate

extension MapViewController: PlaceCardViewDelegate {
    func viewDidDismiss() {
        tabBarController?.selectedIndex = 1
    }
}

