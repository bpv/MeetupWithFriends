//
//  CustomAuthPickerViewController.swift
//  MeetupWithFriends
//
//  Created by Paul Kim on 1/3/17.
//  Copyright © 2017 BPV, Inc. All rights reserved.
//

import UIKit
import FirebaseAuthUI

// Mark: CustomAuthPickerViewController

class CustomAuthPickerViewController: FUIAuthPickerViewController {

    // Mark: Initializers
    
    // TODO: remove custom initializers once bug has been fixed in Firebase:
    // https://github.com/firebase/FirebaseUI-iOS/issues/128
    override init(nibName: String?, bundle: Bundle?, authUI: FUIAuth) {
        super.init(nibName: "FUIAuthPickerViewController", bundle: bundle, authUI: authUI)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // Mark: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        // add an image
        
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        image.image = UIImage(named: "logo")
        image.contentMode = UIViewContentMode.center
        
        view.addSubview(image)
    }
}
