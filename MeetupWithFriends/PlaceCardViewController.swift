//
//  PlaceCardViewController.swift
//  MeetupWithFriends
//
//  Created by Paul Kim on 12/20/16.
//  Copyright © 2016 BPV, Inc. All rights reserved.
//

import UIKit
import Cartography

public func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

class PlaceCardViewController: UIViewController {
    
    // Mark: Properties
    
    @IBOutlet weak var swipeableView: ZLSwipeableView!
    let backgroundColor = UIColor.groupTableViewBackground
    var loadCardsFromXib = false
    
    // Mark: View Lifecycle
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        swipeableView.nextView = {
            return self.nextCardView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
        
        // debug text
        swipeableView.didStart = {view, location in
            print("Did start swiping view at location: \(location)")
        }
        swipeableView.swiping = {view, location, translation in
            print("Swiping at view location: \(location) translation: \(translation)")
        }
        swipeableView.didEnd = {view, location in
            print("Did end swiping view at location: \(location)")
        }
        swipeableView.didSwipe = {view, direction, vector in
            print("Did swipe view in direction: \(direction), vector: \(vector)")
        }
        swipeableView.didCancel = {view in
            print("Did cancel swiping view")
        }
        swipeableView.didTap = {view, location in
            print("Did tap at location \(location)")
        }
        swipeableView.didDisappear = { view in
            print("Did disappear swiping view")
        }
        
        
        swipeableView.numberOfHistoryItem = UInt.max
        swipeableView.allowedDirection = Direction.All
        
        swipeableView.previousView = {
            if let view = self.nextCardView() {
                self.applyRandomTansform(view)
                return view
            }
            return nil
        }
    }
    
    // MARK: - Actions
    
    @IBAction func closeButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func previousButtonClicked() {
        self.swipeableView.rewind()
    }
    
    // MARK: ()
    func nextCardView() -> UIView? {
        
        let cardView = CardView(frame: swipeableView.bounds)
        cardView.backgroundColor = backgroundColor
        
        if loadCardsFromXib {
            let contentView = Bundle.main.loadNibNamed("CardContentView", owner: self, options: nil)?.first! as! UIView
            contentView.translatesAutoresizingMaskIntoConstraints = false
            contentView.backgroundColor = cardView.backgroundColor
            cardView.addSubview(contentView)
            
            // This is important:
            // https://github.com/zhxnlai/ZLSwipeableView/issues/9
            /*// Alternative:
             let metrics = ["width":cardView.bounds.width, "height": cardView.bounds.height]
             let views = ["contentView": contentView, "cardView": cardView]
             cardView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[contentView(width)]", options: .AlignAllLeft, metrics: metrics, views: views))
             cardView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[contentView(height)]", options: .AlignAllLeft, metrics: metrics, views: views))
             */
            constrain(contentView, cardView) { view1, view2 in
                view1.left == view2.left
                view1.top == view2.top
                view1.width == cardView.bounds.width
                view1.height == cardView.bounds.height
            }
        }
        return cardView
    }
    
    func applyRandomTansform(_ view: UIView) {
        let width = swipeableView.bounds.width
        let height = swipeableView.bounds.height
        let distance = max(width, height)
        
        func randomRadian() -> CGFloat {
            return CGFloat(arc4random() % 360)  * CGFloat(M_PI / 180)
        }
        
        var transform = CGAffineTransform(rotationAngle: randomRadian())
        transform = transform.translatedBy(x: distance, y: 0)
        transform = transform.rotated(by: randomRadian())
        view.transform = transform
    }

}
