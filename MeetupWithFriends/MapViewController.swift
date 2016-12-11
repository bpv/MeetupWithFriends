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
}

// Mark: - MapViewController: GMSMapViewDelegate
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            googleMapView.isMyLocationEnabled = true
        } else {
            // TODO: prompt for location
        }
    }
}

// Mark: - MapViewController: GMSMapViewDelegate
extension MapViewController: GMSMapViewDelegate {
    
}

