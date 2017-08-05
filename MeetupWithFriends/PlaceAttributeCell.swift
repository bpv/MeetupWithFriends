//
//  PlaceAttributeCell.swift
//  MeetupWithFriends
//
//  Created by Paul Kim on 12/29/16.
//  Copyright © 2016 BPV, Inc. All rights reserved.
//

import UIKit

// Mark: - PlaceAttributeCell

final class PlaceAttributeCell: UITableViewCell {
    
    // Mark: Properties
    
    static let nib = { UINib(nibName: "PlaceAttributeCell", bundle: nil) }()
    static let reuseIdentifier = "PlaceAttributeCell"
    
    // Mark: Outlets
    
    @IBOutlet weak var propertyName: UILabel!
    @IBOutlet weak var propertyValue: UILabel!
    
}
