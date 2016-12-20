//
//  Place.swift
//  MeetupWithFriends
//
//  Created by Paul Kim on 12/13/16.
//  Copyright © 2016 BPV, Inc. All rights reserved.
//

import Foundation
import GooglePlaces
import SwiftyJSON

struct Place {
    var icon: String
    var latitude: Double
    var longitude: Double
    var name: String
    var openNow: Bool
    var photos: [[String: Any]]?
    var placeID: String
    var priceLevel: GMSPlacesPriceLevel
    var rating: Double
    var types: [String]
    
    init(json: SwiftyJSON.JSON) {
        let keys = GoogleConstants.ResponseKeys.self
        
        icon = json[keys.icon].stringValue
        latitude = json[keys.geometry][keys.location][keys.lat].doubleValue
        longitude = json[keys.geometry][keys.location][keys.lon].doubleValue
        name = json[keys.name].stringValue
        openNow = json[keys.openingHours]["open_now"].boolValue
        placeID = json[keys.placeID].stringValue
        priceLevel = GMSPlacesPriceLevel(rawValue: json[keys.priceLevel].intValue)!
        rating = json[keys.rating].doubleValue
        types = json[keys.types].arrayValue.map({$0.stringValue})

    }
}

struct Places {
    var places: [Place]
    var nextPageToken: String
}
