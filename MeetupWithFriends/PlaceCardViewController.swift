//
//  PlaceCardViewController.swift
//  MeetupWithFriends
//
//  Created by Paul Kim on 12/20/16.
//  Copyright © 2016 BPV, Inc. All rights reserved.
//

import UIKit
import iCarousel
import Firebase

// Mark: - PlaceCardViewDelegate {
protocol PlaceCardViewDelegate {
    func viewDidDismiss()
}

// Mark: - PlaceCardViewController

final class PlaceCardViewController: UIViewController {
    
    // Mark: Properties
    
    final var user: FIRUser!
    final var places: Places!
    final var startingIndex: Int = 0
    final var delegate: PlaceCardViewDelegate! = nil
    final fileprivate var ref: FIRDatabaseReference!
    final fileprivate var _refHandle: FIRDatabaseHandle!
    
    // Mark: Outlets
    
    @IBOutlet weak var carousel: iCarousel!
    
    // Mark: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        carousel.delegate = self
        carousel.dataSource = self
        
        configureDatabase()
        
        // set the first card
        if startingIndex > 0 {
            carousel.scrollToItem(at: startingIndex, animated: true)
        }
    }
    
    deinit {
        if let _refHandle = _refHandle {
            ref.child("placeHistory").removeObserver(withHandle: _refHandle)
        }
    }
    
    // Mark: Config
    
    final private func configureDatabase() {
        ref = FIRDatabase.database().reference()
    }

    
    // MARK: Actions
    
    @IBAction func closeButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }

}

// Mark: - PlaceCardViewController: iCarouselDelegate, iCarouselDataSource

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
            contentView.place = place
        } else {
            //don't do anything specific to the index within
            //this `if ... else` statement because the view will be
            //recycled and used with other index values later
            
            contentView = CardView(place: place, frame: CGRect(x: 10, y: 10, width: carousel.frame.width - 20, height: carousel.frame.height - 20)).view
        }
        
        contentView.delegate = self
        contentView.loadPlaceDetails()
        
        if place.photos.count > 0 {
            GooglePlacesConvenience.getPlacePhoto(reference: place.photos[0]["photo_reference"] as! String, maxWidth: Int(contentView.imageView.frame.width), maxHeight: Int(contentView.imageView.frame.height), withCompletionHandler: { (photo, error) in
                
                Helpers.performUIUpdatesOnMain {
                    contentView.imageView.image = photo
                    contentView.activityIndicator.stopAnimating()
                }
            })
        } else {
            contentView.imageView.image = nil
        }
        
        contentView.nameLabel.text = "\(place.name)"
        
        // disable arrow buttons as necessary
        if index == 0 {
            contentView.leftArrow.isEnabled = false
        } else {
            contentView.leftArrow.isEnabled = true
        }
        
        if index == (places.places.count - 1) {
            contentView.rightArrow.isEnabled = false
        } else {
            contentView.rightArrow.isEnabled = true
        }
        
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

// Mark: - PlaceCardViewController: CardViewDelegate

extension PlaceCardViewController: CardViewDelegate {
    func didPressShare(place: Place) {
        let url = NSURL(string: place.placeDetails!.url)
        
        let activityItems: [Any] = [place.name, url]
        
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        activityVC.excludedActivityTypes = [UIActivityType.addToReadingList]
        
        activityVC.completionWithItemsHandler = {(activity, success, items, error) in
            if success {
                let value: [String: Any] = [
                    "placeID": place.placeID,
                    "dateTimeAdded": NSDate().timeIntervalSince1970
                ]
                
                // insert this Place into the Database
                self.ref.child("placeHistory").child(self.user.uid).childByAutoId().setValue(value)
                
                self.dismiss(animated: true, completion: {
                    self.delegate!.viewDidDismiss()
                })
            }
        }
        
        // iPad
        activityVC.popoverPresentationController?.sourceView = self.view
        
        // save the place to firebase
        present(activityVC, animated: true, completion: nil)
    }
    
    func didPressLeftArrow() {
        carousel.scroll(byNumberOfItems: -1, duration: TimeInterval(carousel.scrollSpeed))
    }
    
    func didPressRightArrow() {
        carousel.scroll(byNumberOfItems: 1, duration: TimeInterval(carousel.scrollSpeed))
    }
    
    func errorMessageNeedsDisplay(error: String) {
        Helpers.displayError(view: self, errorString: error)
    }
}
