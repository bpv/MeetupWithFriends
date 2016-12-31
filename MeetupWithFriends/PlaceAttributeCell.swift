//
//  PlaceAttributeCell.swift
//  MeetupWithFriends
//
//  Created by Paul Kim on 12/29/16.
//  Copyright © 2016 BPV, Inc. All rights reserved.
//

import UIKit

class PlaceAttributeCell: UITableViewCell {
    static let nib = { UINib(nibName: "PlaceAttributeCell", bundle: nil) }()
    static let reuseIdentifier = "PlaceAttributeCell"
    @IBOutlet weak var propertyName: UILabel!
    @IBOutlet weak var propertyValue: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
