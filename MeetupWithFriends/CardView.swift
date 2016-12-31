//
//  CardView.swift
//  MeetupWithFriends
//
//  Created by Paul Kim on 12/27/16.
//  Copyright © 2016 BPV, Inc. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    // Mark: Properties
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var detailsTable: UITableView!
    let nibName = "CardView"
    var view: CardView!
    var place: Place!
    var placeDetailsArray = [Any]()
    
    // Mark: Initializers
    
    init(place: Place, frame: CGRect) {
        super.init(frame: frame)
        
        xibSetup(place: place)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        detailsTable.register(PlaceAttributeCell.nib, forCellReuseIdentifier: PlaceAttributeCell.reuseIdentifier)
        
        detailsTable.dataSource = self
        detailsTable.delegate = self
    }
    
    // Mark: Actions
    
    @IBAction func bookmarkButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        /*
        if let details = placeDetails {
            let url = URL(string: details.url)
            
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            // for iPads
            activityVC.popoverPresentationController?.sourceView = self.view
            
            self.window.
        }*/ // TODO: what should be done if details not present
    }
    
    func loadPlaceDetails() {
        place.getPlaceDetails { (placeDetails, error) in
            performUIUpdatesOnMain {
                guard error == nil else {
                    // TODO: delegate error to VC
                    print(error)
                    return
                }
                
                // set the details
                self.place.placeDetails = placeDetails
                
                self.placeDetailsArray = self.place.getPlaceDetailsArrayForDisplay()
                
                // reload the table
                self.detailsTable.reloadData()
            }
        }
    }
}

// Mark: - Load from Nib

extension CardView {
    func xibSetup(place: Place) {
        view = loadViewFromNib() as! CardView
        
        view.frame = bounds
        view.place = place
        
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let nib = UINib(nibName: nibName, bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
}

// Mark: - UITableViewDelegate, UITableViewDataSource

extension CardView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeDetailsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PlaceAttributeCell.reuseIdentifier, for: indexPath) as! PlaceAttributeCell
        
        let placeDetail = placeDetailsArray[indexPath.item] as! [String]
        
        cell.propertyName.text = placeDetail[0]
        cell.propertyValue.text = placeDetail[1]
        
        return cell
    }
}


