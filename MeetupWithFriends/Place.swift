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
    var photos = [[String: Any]]()
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
        
        for photoRow in json[keys.photos].arrayValue {
            var tempDict = [String: Any]()
            
            if let height = photoRow[keys.height].int {
                tempDict[keys.height] = height
            }
            
            if let width = photoRow[keys.width].int {
                tempDict[keys.width] = width
            }
            
            if let photo_reference = photoRow[keys.photoReference].string {
                tempDict[keys.photoReference] = photo_reference
            }
            
            if let attributions = photoRow[keys.htmlAttributions].array {
                var attributionsArray = [String]()
                for attribution in attributions {
                    if let attributionString = attribution.string {
                       attributionsArray.append(attributionString)
                    }
                }
                
                tempDict[keys.htmlAttributions] = attributionsArray
            }
            
            photos.append(tempDict)
        }
        
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
