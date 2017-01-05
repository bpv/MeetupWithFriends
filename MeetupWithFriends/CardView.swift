//
//  CardView.swift
//  MeetupWithFriends
//
//  Created by Paul Kim on 12/27/16.
//  Copyright © 2016 BPV, Inc. All rights reserved.
//

import UIKit

// Mark: - CardViewDelegate

protocol CardViewDelegate {
    func didPressShare(place: Place)
    
    func didPressLeftArrow()
    
    func didPressRightArrow()
    
    func errorMessageNeedsDisplay(error: String)
}

// Mark: - CardView

class CardView: UIView {
    
    // Mark: Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var detailsTable: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // Mark: Properties
    
    let nibName = "CardView"
    var view: CardView!
    var place: Place!
    var placeDetailsArray = [Any]()
    var delegate: CardViewDelegate! = nil
    
    // Mark: Initializers
    
    init(place: Place, frame: CGRect) {
        super.init(frame: frame)
        
        xibSetup(place: place)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Mark: Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        detailsTable.register(PlaceAttributeCell.nib, forCellReuseIdentifier: PlaceAttributeCell.reuseIdentifier)
        
        detailsTable.dataSource = self
    }
    
    // Mark: Actions
    
    @IBAction func didPressShare(_ sender: Any) {
        delegate!.didPressShare(place: place)
    }
    
    @IBAction func didPressLeftArrow(_ sender: Any) {
        delegate!.didPressLeftArrow()
    }

    @IBAction func didPressRightArrow(_ sender: Any) {
        delegate!.didPressRightArrow()
    }
    
    func loadPlaceDetails() {
        place.getPlaceDetails { (placeDetails, error) in
            Helpers.performUIUpdatesOnMain {
                guard error == nil else {
                    self.delegate!.errorMessageNeedsDisplay(error: error!)
                    return
                }
                
                // set the details
                self.place.placeDetails = placeDetails
                
                self.placeDetailsArray = (self.place.placeDetails?.getPlaceDetailsArrayForDisplay())!
                
                // reload the table
                self.detailsTable.reloadData()
                
                self.activityIndicator.stopAnimating()
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

// Mark: - CardView: UITableViewDataSource

extension CardView: UITableViewDataSource {
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


