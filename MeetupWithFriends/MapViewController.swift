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

class MapViewController: UIViewController {
    // Mark: Properties

    @IBOutlet weak var googleMapView: GMSMapView!
    var locationManager = CLLocationManager()
    
    // Mark: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up Core Location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        // create GMSCamera and assign to map
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 15.0)
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
                    // TODO: display error
                    print("There was an error")
                    return
                }
                
                // create marker and center the map

                // load results
            })
        }
        
        // close action
        let closeAction = UIAlertAction(title: "Close", style: .cancel)
        
        // add actions to the alert controller
        addressAlert.addAction(searchAction)
        addressAlert.addAction(closeAction)
        
        present(addressAlert, animated: true, completion: nil)
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

