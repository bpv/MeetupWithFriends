//
//  MapViewController.swift
//  MeetupWithFriends
//
//  Created by Paul Kim on 12/9/16.
//  Copyright © 2016 BPV, Inc. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class MapViewController: UIViewController {
    // Mark: Properties

    @IBOutlet weak var googleMapView: GMSMapView!
    var locationManager = CLLocationManager()
    var placesClient: GMSPlacesClient!
    var places: Places!
    
    // Mark: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up placesClient
        placesClient = GMSPlacesClient.shared()
        
        // set up Core Location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        // create GMSCamera and assign to map
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: GoogleConstants.Configuration.startingZoom)
        googleMapView.camera = camera
        
        // map configuration
        googleMapView.settings.compassButton = true
        googleMapView.settings.zoomGestures = true
        googleMapView.settings.myLocationButton = true
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
    
    func loadNearbyPlaces(latitude: Double, longitude: Double, pageToken: String?) {
        // load resuts from Places API
        GooglePlacesConvenience.getNearbyPlaces(latitude: latitude, longitude: longitude, pageToken: nil, withCompletionHandler: { (places, error) in
            
            guard error == nil else {
                Helpers.displayError(view: self, errorString: error)
                return
            }
            
            self.places = places

            self.createMarkers()
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
                marker.icon = UIImage(data: data, scale: 2)
                marker.map = self.googleMapView
            }
        }
    }
    
    // center the map on coordinates
    func centerMap(latitude: Double, longitude: Double) {
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: GoogleConstants.Configuration.startingZoom)
        googleMapView.animate(to: camera)
    }
}

// Mark: - GMSMapViewDelegate
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            googleMapView.isMyLocationEnabled = true
        } else {
            // TODO: prompt for location
        }
    }
}

// Mark: - GMSMapViewDelegate
extension MapViewController: GMSMapViewDelegate {
    
}

