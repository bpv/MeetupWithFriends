//
//  Helpers.swift
//  MeetupWithFriends
//
//  Created by Paul Kim on 12/12/16.
//  Copyright © 2016 BPV, Inc. All rights reserved.
//

import Foundation
import UIKit

// Mark: - Helpers

final class Helpers {
    
    final class func displayError(view: UIViewController, errorString: String!) {
        if let errorString = errorString {
            let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            view.present(alert, animated: true, completion: nil)
        }
    }
    
    final class func launchNavigationApp(name: String, latitude: Double, longitude: Double) {
        
        let latString = String(latitude)
        let lonString = String(longitude)
        
        var googleTargetURL = URLComponents(string: "comgooglemaps://")
        googleTargetURL?.queryItems = [
            URLQueryItem(name: "q", value: name),
            URLQueryItem(name: "center", value: latString + "," + lonString)
        ]
        
        var appleTargetURL = URLComponents(string: "http://maps.apple.com/")
        appleTargetURL?.queryItems = [
            URLQueryItem(name: "q", value: name),
            URLQueryItem(name: "ll", value: latString + "," + lonString)
        ]
        
        if (UIApplication.shared.canOpenURL((googleTargetURL?.url)!)) {
            UIApplication.shared.open((googleTargetURL?.url)!, options: [String: Any](), completionHandler: nil)
        } else {
            UIApplication.shared.open((appleTargetURL?.url)!, options: [String: Any](), completionHandler: nil)
        }
    }
    
    final class func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
        DispatchQueue.main.async {
            updates()
        }
    }
}
