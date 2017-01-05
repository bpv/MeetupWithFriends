//
//  HistoryViewController.swift
//  MeetupWithFriends
//
//  Created by Paul Kim on 1/1/17.
//  Copyright © 2017 BPV, Inc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

// Mark: - HistoryViewController

class HistoryViewController: UIViewController {

    // Mark: Properties
    
    var ref: FIRDatabaseReference!
    var places = [[String: Any]]()
    
    // Mark: Outlets
    
    @IBOutlet weak var historyTable: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // Mark: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureDatabase()
        
        historyTable.dataSource = self
    }
    
    // Mark: Config
    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("placeHistory").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let value = snapshot.value as? NSDictionary {
                for (_, placeDictRaw) in value {
                    let placeDict = placeDictRaw as! [String: Any]
                    
                    self.places.append(placeDict)
                }
                
                self.historyTable.reloadData()
                
                self.activityIndicator.stopAnimating()
            }
            
        }) { (error) in
            Helpers.displayError(view: self, errorString: error.localizedDescription)
        }
    }

    @IBAction func didPressSignOut(_ sender: Any) {
        AuthHelpers.signOut(view: self)
    }
    
}

// Mark: - HistoryViewController: UITableViewDataSource

extension HistoryViewController: UITableViewDataSource {
    
    // Mark: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell") as! HistoryTableViewCell
        
        let place = places[indexPath.item]
        
        // get the place details
        GooglePlacesConvenience.getPlaceDetails(placeID: place["placeID"] as! String, withCompletionHandler: { (details, error) in
            
            Helpers.performUIUpdatesOnMain {
                guard error == nil else {
                    // move on, quietly
                    print(error)
                    return
                }
                
                if let details = details {
                    cell.nameLabel.text = details.name
                    cell.phoneLabel.text = details.phoneNumber
                    cell.placeDetails = details
                }
            }
        })
        
        return cell
    }
}
