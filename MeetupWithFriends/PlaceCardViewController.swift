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

// Mark: - PlaceCardViewController

class PlaceCardViewController: UIViewController {
    
    // Mark: Properties
    
    var user: FIRUser!
    var places: Places!
    var placeIndex: Int = 0
    var ref: FIRDatabaseReference!
    fileprivate var _refHandle: FIRDatabaseHandle!
    
    // Mark: Outlets
    
    @IBOutlet weak var carousel: iCarousel!
    
    // Mark: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        carousel.delegate = self
        carousel.dataSource = self
        
        configureDatabase()
    }
    
    deinit {
        ref.child("placeHistory").removeObserver(withHandle: _refHandle)
    }
    
    // Mark: Config
    
    func configureDatabase() {
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

// Mark: - PlaceCardViewController: CardViewDelegate

extension PlaceCardViewController: CardViewDelegate {
    func selectButtonPressed(place: Place) {
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
                    // show the history view
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HistoryTableViewController") as! HistoryTableViewController
                    self.present(vc, animated: true, completion: nil)
                })
            }
        }
        
        // iPad
        activityVC.popoverPresentationController?.sourceView = self.view
        
        // save the place to firebase
        present(activityVC, animated: true, completion: nil)
    }
    
    func errorMessageNeedsDisplay(error: String) {
        Helpers.displayError(view: self, errorString: error)
    }
}
