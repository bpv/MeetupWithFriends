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
    
    // get details separately so we're not making several calls to the Google Place Details API when loading search results.
    func getPlaceDetails(withCompletionHandler: @escaping (_ details: Place.PlaceDetails?, _ error: String?) -> Void) {
        
        GooglePlacesConvenience.getPlaceDetails(placeID: placeID, withCompletionHandler: { (placeDetails, error) in
            
            guard error == nil else {
                withCompletionHandler(nil, error)
                return
            }
            
            if let placeDetails = placeDetails {
                withCompletionHandler(placeDetails, nil)
            }
        })
    }
    
    func getPlaceDetailsArrayForDisplay(withCompletionHandler: @escaping (_ details: [Any]?, _ error: String?) -> Void) {
        
        let openNowString = openNow ? "Yes" : "No"
        let priceLevelString = String(repeating: "$", count: priceLevel.rawValue)
            
        self.getPlaceDetails { (placeDetails, error) in
            guard error == nil else {
                withCompletionHandler(nil, error)
                return
            }
            
            if let placeDetails = placeDetails {
                let detailsArray: [Any] = [
                    ["Open Now", openNowString],
                    ["Price", priceLevelString],
                    ["Rating", String(describing: self.rating)],
                    ["Address", placeDetails.address],
                    ["Phone", placeDetails.phoneNumber],
                    ["Website", String(describing: placeDetails.website!)],
                    ["Latitude", String(describing: self.latitude)],
                    ["Longitude", String(describing: self.longitude)],
                    // TODO: implement later
                    //["Attributions", placeDetails.attributions],
                ]
                
                withCompletionHandler(detailsArray, nil)
            }
        }
    }
    

    struct PlaceDetails {
        var address: String?
        var phoneNumber: String?
        var website: URL?
        var attributions: NSAttributedString?
        
        init(place: GMSPlace) {
            if let address = place.formattedAddress {
                self.address = address
            }
            
            if let phoneNumber = place.phoneNumber {
                self.phoneNumber = phoneNumber
            }
            
            if let website = place.website {
                self.website = website
            }
            
            if let attributions = place.attributions {
                self.attributions = attributions
            }
        }
    }
}
