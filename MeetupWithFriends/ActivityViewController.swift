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

class ActivityViewController: UIViewController {
    
    // Mark: Properties
    
    var user: FIRUser?
    fileprivate var _authHandle: FIRAuthStateDidChangeListenerHandle!
    
    let activities = ["restaurant", "bar", "night_club", "cafe", "movie_theater"]

    // Mark: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureAuth()
    }
    
    // Mark: Config
    
    func configureAuth() {
        let provider: [FUIAuthProvider] = [FUIGoogleAuth(), FUIFacebookAuth()]
        FUIAuth.defaultAuthUI()?.providers = provider
        
        // listen for changes in the authorization state
        _authHandle = FIRAuth.auth()?.addStateDidChangeListener { (auth: FIRAuth, user: FIRUser?) in
            // TODO: refresh data if necessary
            
            // check if there is a current user
            if let activeUser = user {
                // check if the current app user is the current FIRUser
                if self.user != activeUser {
                    self.user = activeUser
                }
            } else {
                // user must sign in
                Helpers.loginSession(view: self)
            }
        }
    }
    
    // Mark: Actions
    
    @IBAction func signOutButtonPressed(_ sender: Any) {
        // sign out
        do {
            try FIRAuth.auth()?.signOut()
            
            // show login screen
            Helpers.loginSession(view: self)
        } catch {
            Helpers.displayError(view: self, errorString: "Error signing out. Please try again later.")
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let button = sender as! UIButton
        let controller = segue.destination as! MapViewController
        
        controller.user = user
        controller.type = activities[button.tag]
    }
}
