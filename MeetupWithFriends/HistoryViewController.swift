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
    fileprivate var _refHandle: FIRDatabaseHandle!
    
    // Mark: Outlets
    
    @IBOutlet weak var historyTable: UITableView!
    
    // Mark: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureDatabase()
        
        historyTable.dataSource = self
        historyTable.delegate = self
    }
    
    // Mark: Config
    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("placeHistory").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let value = snapshot.value as? NSDictionary {
                for (key, placeDictRaw) in value {
                    var placeDict = placeDictRaw as! [String: Any]
                    
                    // get the place details
                    GooglePlacesConvenience.getPlaceDetails(placeID: placeDict["placeID"]! as! String, withCompletionHandler: { (details, error) in

                        performUIUpdatesOnMain {
                            guard error == nil else {
                                // quietly omit from results
                                return
                            }
                            
                            if let details = details {
                                placeDict["details"] = details
                                self.places.append(placeDict)
                            }
                            

                            // reload the table data once all place details have been retrieved
                            // TODO: load only once
                            self.historyTable.reloadData()
                        }
                    })
                }
            }
            
        }) { (error) in
            Helpers.displayError(view: self, errorString: error.localizedDescription)
        }
    }

    
}

// Mark: - HistoryViewController: UITableViewDelegate, UITableViewDataSource

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Mark: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell")
        
        let place = places[indexPath.item]
        
        cell?.textLabel?.text = (place["details"] as! PlaceDetails).name
        cell?.detailTextLabel?.text = (place["details"] as! PlaceDetails).phoneNumber
        
        return cell!
    }
    
    // Mark: UITableViewDelegate
    
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }*/
}
