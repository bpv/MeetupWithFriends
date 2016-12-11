//
//  GCD.swift
//  MeetupWithFriends
//
//  Created by Paul Kim on 12/10/16.
//  Copyright © 2016 BPV, Inc. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
