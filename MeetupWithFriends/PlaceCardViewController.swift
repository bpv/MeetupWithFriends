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

        var contentView: UIView
        var image: UIImageView
        var label: UILabel
        let place = places.places[index]
        
        //reuse view if available, otherwise create a new view
        if let view = view as? UIImageView {
            contentView = view
            //get a reference to the label in the recycled view
            image = contentView.viewWithTag(1) as! UIImageView
            label = contentView.viewWithTag(2) as! UILabel
        } else {
            //don't do anything specific to the index within
            //this `if ... else` statement because the view will be
            //recycled and used with other index values later
            contentView = UIView(frame: CGRect(x: -20, y: -20, width: carousel.frame.width - 40, height: carousel.frame.height - 40))
            contentView.backgroundColor = UIColor.lightGray
            contentView.layer.borderWidth = 2.0
            contentView.layer.borderColor = UIColor.red.cgColor
            
            // set the image
            image = UIImageView(frame: CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height * 0.25))
            image.tag = 1
            contentView.addSubview(image)
            
            // set the label
            label = UILabel(frame: CGRect(x: 0, y: image.frame.height + 1, width: contentView.frame.width, height: 40))
            label.textAlignment = .center
            label.font = label.font.withSize(20)
            label.tag = 2
            contentView.addSubview(label)
        }
        
        //set item label
        //remember to always set any properties of your carousel item
        //views outside of the `if (view == nil) {...}` check otherwise
        //you'll get weird issues with carousel item content appearing
        //in the wrong place in the carousel
        
        GooglePlacesConvenience.getPlacePhoto(reference: place.photos[0]["photo_reference"] as! String, maxWidth: Int(image.frame.width), maxHeight: Int(image.frame.width), withCompletionHandler: { (photo, error) in
            
            performUIUpdatesOnMain {
                image.image = photo
            }
        })
        
        label.text = "\(places.places[index].name)"
        
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
