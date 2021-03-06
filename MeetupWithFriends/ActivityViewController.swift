//
//  ActivityViewController.swift
//  MeetupWithFriends
//
//  Created by Paul Kim on 12/19/16.
//  Copyright © 2016 BPV, Inc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import FirebaseFacebookAuthUI

final class ActivityViewController: UIViewController {
    
    // Mark: Properties
    
    final private var user: FIRUser?
    final private var _authHandle: FIRAuthStateDidChangeListenerHandle!
    
    final private let activities = ["restaurant", "bar", "night_club", "cafe", "movie_theater"]

    // Mark: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureAuth()
    }
    
    // Mark: Config
    
    final private func configureAuth() {
        let provider: [FUIAuthProvider] = [FUIGoogleAuth(), FUIFacebookAuth()]
        FUIAuth.defaultAuthUI()?.providers = provider
        
        // listen for changes in the authorization state
        _authHandle = FIRAuth.auth()?.addStateDidChangeListener { (auth: FIRAuth, user: FIRUser?) in
            
            // check if there is a current user
            if let activeUser = user {
                // check if the current app user is the current FIRUser
                if self.user != activeUser {
                    self.user = activeUser
                }
            } else {
                // user must sign in
                AuthHelpers().loginSession(view: self)
            }
        }
    }
    
    // Mark: Actions
    
    @IBAction func didPressSignOut(_ sender: Any) {
        AuthHelpers.signOut(view: self)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let button = sender as! UIButton
        let controller = segue.destination as! MapViewController
        
        controller.user = user
        controller.type = activities[button.tag]
    }
}
