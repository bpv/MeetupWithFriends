//
//  ActivityViewController.swift
//  MeetupWithFriends
//
//  Created by Paul Kim on 12/19/16.
//  Copyright © 2016 BPV, Inc. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController {
    
    // Mark: Properties
    
    let activities = ["restaurant", "bar", "night_club", "cafe", "movie_theater"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // Mark: Actions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if segue.identifier == "ActivityToMap" {
            let button = sender as! UIButton
            let controller = segue.destination as! MapViewController
            controller.type = activities[button.tag]
        //}
    }
}
