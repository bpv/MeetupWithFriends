//
//  PlaceCardViewController.swift
//  MeetupWithFriends
//
//  Created by Paul Kim on 12/20/16.
//  Copyright © 2016 BPV, Inc. All rights reserved.
//

import UIKit
import iCarousel

class PlaceCardViewController: UIViewController {
    
    // Mark: Properties
    
    @IBOutlet weak var carousel: iCarousel!
    
    var places: Places!
    var placeIndex: Int = 0
    
    // Mark: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        carousel.delegate = self
        carousel.dataSource = self
    }
    
    // MARK: - Actions
    
    @IBAction func closeButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }

}

// Mark: - iCarouselDelegate, iCarouselDataSource
extension PlaceCardViewController: iCarouselDelegate, iCarouselDataSource {
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return places.places.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {

        var contentView: CardView
        let place = places.places[index]
        
        if let view = view {
            //reuse view if available, otherwise create a new view
            
            contentView = view as! CardView
        } else {
            //don't do anything specific to the index within
            //this `if ... else` statement because the view will be
            //recycled and used with other index values later
            
            contentView = CardView(place: place, frame: carousel.frame).view
            contentView.clipsToBounds = true
        }
        
        contentView.loadPlaceDetails()
        
        GooglePlacesConvenience.getPlacePhoto(reference: place.photos[0]["photo_reference"] as! String, maxWidth: Int(contentView.imageView.frame.width), maxHeight: Int(contentView.imageView.frame.height), withCompletionHandler: { (photo, error) in
            
            performUIUpdatesOnMain {
                contentView.imageView.image = photo
            }
        })
        
        contentView.nameLabel.text = "\(place.name)"
        
        return contentView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        
        var newValue: CGFloat
        switch option {
        case .spacing:
            newValue = 1.2
            break
        default:
            newValue = value
            break
        }
        
        return newValue
    }
}
