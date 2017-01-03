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
    var openNow: Bool?
    var photos = [[String: Any]]()
    var placeID = String()
    var priceLevel: Int?
    var rating: Double?
    var types: [String]
    var placeDetails: PlaceDetails?
    
    init(json: SwiftyJSON.JSON) {
        let keys = GoogleConstants.ResponseKeys.self
        
        icon = json[keys.icon].stringValue
        latitude = json[keys.geometry][keys.location][keys.lat].doubleValue
        longitude = json[keys.geometry][keys.location][keys.lon].doubleValue
        name = json[keys.name].stringValue
        
        if let openingHours = json[keys.openingHours].dictionary {
            if let openNow = openingHours[keys.openNow] {
                self.openNow = openNow.bool
            }
        }
        
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
        priceLevel = json[keys.priceLevel].int
        rating = json[keys.rating].double
        
        types = json[keys.types].arrayValue.map({$0.stringValue})

    }
    
    // get details separately so we're not making several calls to the Google Place Details API when loading search results.
    func getPlaceDetails(withCompletionHandler: @escaping (_ details: PlaceDetails?, _ error: String?) -> Void) {
        
        GooglePlacesConvenience.getPlaceDetails(placeID: placeID, withCompletionHandler: { (details, error) in
            
            guard error == nil else {
                withCompletionHandler(nil, error)
                return
            }
            
            if let details = details {
                withCompletionHandler(details, nil)
            }
        })
    }
}
