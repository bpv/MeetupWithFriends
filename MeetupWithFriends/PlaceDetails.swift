//
//  PlaceDetails.swift
//  MeetupWithFriends
//
//  Created by Paul Kim on 1/2/17.
//  Copyright © 2017 BPV, Inc. All rights reserved.
//

import Foundation
import SwiftyJSON

struct PlaceDetails {
    var placeID: String
    var longitude: Double
    var latitude: Double
    var name: String
    var openNow: Bool?
    var priceLevel: Int?
    var rating = Double()
    var address = String()
    var phoneNumber: String?
    var website: String?
    var url: String
    
    init(json: [String: SwiftyJSON.JSON]) {
        let keys = GoogleConstants.ResponseKeys.self
    
        placeID = (json[keys.placeID]?.stringValue)!
        latitude = (json[keys.geometry]?[keys.location][keys.lat].doubleValue)!
        longitude = (json[keys.geometry]?[keys.location][keys.lon].doubleValue)!
        name = (json[keys.name]?.stringValue)!
        
        if let openingHours = json[keys.openingHours]?.dictionary {
            if let openNow = openingHours[keys.openNow] {
                self.openNow = openNow.boolValue
            }
        }
        
        if let priceLevel = json[keys.priceLevel] {
            self.priceLevel = priceLevel.intValue
        }
        
        if let rating = json[keys.rating] {
            self.rating = rating.doubleValue
        }
        
        if let address = json[keys.formattedAddress] {
            self.address = address.stringValue
        }
        
        if let phoneNumber = json[keys.formattedPhoneNumber] {
            self.phoneNumber = phoneNumber.stringValue
        }
        
        if let website = json[keys.website] {
            self.website = website.stringValue
        }
        
        if let url = json[keys.url] {
            self.url = url.stringValue
        } else {
            self.url = ""
        }
    }
    
    func getPlaceDetailsArrayForDisplay() -> [Any] {
        
        var openNowString = "Unavailable"
        if let openNow = openNow {
            openNowString = openNow ? "Yes" : "No"
        }
        
        var priceLevelString = "Unavailable"
        if let priceLevel = priceLevel {
            priceLevelString = String(repeating: "$", count: priceLevel)
        }
        
        let detailsArray: [Any] = [
            ["Open Now", openNowString],
            ["Price", priceLevelString],
            ["Rating", String(describing: rating)],
            ["Address", address],
            ["Phone", phoneNumber],
            ["Website", website],
            ["Latitude", String(describing: latitude)],
            ["Longitude", String(describing: longitude)],
        ]
        
        return detailsArray
    }
}
