//
//  AuthHelpers.swift
//  MeetupWithFriends
//
//  Created by Paul Kim on 1/3/17.
//  Copyright © 2017 BPV, Inc. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseAuthUI

final class AuthHelpers: NSObject {
    final func loginSession(view: UIViewController) {
        let authUI = FUIAuth.defaultAuthUI()!
        authUI.delegate = self
        
        view.present(authUI.authViewController(), animated: true, completion: nil)
    }
    
    final class func signOut(view: UIViewController) {
        do {
            try FIRAuth.auth()?.signOut()
            
            // show login screen
            AuthHelpers().loginSession(view: view)
        } catch {
            Helpers.displayError(view: view, errorString: "Error signing out. Please try again later.")
        }
    }
}

extension AuthHelpers: FUIAuthDelegate {
    final func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
        // do nothing
    }
    
    final func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        return CustomAuthPickerViewController(authUI: authUI)
    }
}
