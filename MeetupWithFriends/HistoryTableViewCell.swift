//
//  HistoryTableViewCell.swift
//  MeetupWithFriends
//
//  Created by Paul Kim on 1/2/17.
//  Copyright © 2017 BPV, Inc. All rights reserved.
//

import UIKit

// Mark: - HistoryTableViewCell
class HistoryTableViewCell: UITableViewCell {

    // Mark: Properties
    
    var placeDetails: PlaceDetails!
    
    // Mark: Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    // Mark: Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // Mark: Actions
    
    @IBAction func didPressNavigate(_ sender: Any) {
        Helpers.launchNavigationApp(name: placeDetails.name, latitude: placeDetails.latitude, longitude: placeDetails.longitude)
    }

}
