//
//  MapViewController.swift
//  MeetupWithFriends
//
//  Created by Paul Kim on 12/9/16.
//  Copyright © 2016 BPV, Inc. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    // Mark: - Properties
    
    @IBOutlet weak var googleMapView: UIView!
    var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create GMSCameraPosition that tells the map to display the
        // user's current location at zoom level 6
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        mapView = GMSMapView.map(withFrame: googleMapView.bounds, camera: camera)
        
        // map configuration
        mapView.isMyLocationEnabled = true
        mapView.settings.compassButton = true
        mapView.settings.zoomGestures = true
        mapView.settings.myLocationButton = true
        
        // add to view
        googleMapView.addSubview(mapView)
        
        // creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }
}

// Mark: - GoogleMaps Methods
extension MapViewController {

}

