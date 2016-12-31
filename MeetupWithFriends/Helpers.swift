//
//  Helpers.swift
//  MeetupWithFriends
//
//  Created by Paul Kim on 12/12/16.
//  Copyright © 2016 BPV, Inc. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuthUI

// Mark: - Helpers

class Helpers {
    
    class func displayError(view: UIViewController!, errorString: String!) {
        if let errorString = errorString {
            let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            view.present(alert, animated: true, completion: nil)
        }
    }
    
    class func loginSession(view: UIViewController!) {
        let authViewController = FUIAuth.defaultAuthUI()!.authViewController()
        view.present(authViewController, animated: true, completion: nil)
    }
}
