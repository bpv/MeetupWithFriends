//
//  GoogleConstants.swift
//  MeetupWithFriends
//
//  Created by Paul Kim on 12/9/16.
//  Copyright © 2016 BPV, Inc. All rights reserved.
//

import Foundation

struct GoogleConstants {
    private static var settingsDict: [String: AnyObject] {
        var format = PropertyListSerialization.PropertyListFormat.xml //format of the property list
        var plistData:[String:AnyObject] = [:]  //our data
        let plistPath:String? = Bundle.main.path(forResource: "Settings", ofType: "plist")! //the path of the data
        let plistXML = FileManager.default.contents(atPath: plistPath!)! //the data in XML format
        do { //convert the data to a dictionary and handle errors.
            plistData = try PropertyListSerialization.propertyList(from: plistXML, options: .mutableContainersAndLeaves, format: &format) as! [String : AnyObject]
            
            return plistData
        }
        catch { // error condition
            print("Error reading plist: \(error), format: \(format)")
            return [String: AnyObject]()
        }
    }
    
    struct API {
        static var projectID = GoogleConstants.settingsDict["googleProjectID"] as! String
        static var apiKey = GoogleConstants.settingsDict["googleMapsAPIKey"] as! String
    }
    
    struct Configuration {
        static var startingZoom: Float = 14.0
    }
    
    struct Geocoding {
        static var baseURL = "https://maps.googleapis.com/maps/api/geocode/json"
        
        struct ParameterKeys {
            static var address = "address"
            static var components = "components"
            static var apiKey = "key"
        }
    }
    
    struct Places {
        static var baseURL = "https://maps.googleapis.com/maps/api/place/"
        
        struct Methods {
            static var nearbySearch = "nearbysearch/json"
            static var photo = "photo"
        }
        
        struct ParameterKeys {
            static var apiKey = "key"
            static var location = "location"
            static var radius = "radius"
            static var rankBy = "rankby"
            static var type = "type"
            static var pageToken = "pagetoken"
            
            static var photoReference = "photoreference"
            static var maxHeight = "maxheight"
            static var maxWidth = "maxWidth"
        }
    }
    
    struct ResponseKeys {
        static var results = "results"
        static var id = "id"
        static var geometry = "geometry"
        static var location = "location"
        static var lat = "lat"
        static var lon = "lng"
        static var status = "status"
        
        // Places API specifc keys
        static var icon = "icon"
        static var name = "name"
        static var openingHours = "opening_hours"
        static var photos = "photos"
        static var placeID = "place_id"
        static var priceLevel = "price_level"
        static var rating = "rating"
        static var types = "types"
        static var nextPageToken = "next_page_token"
        
        // Place photo specific keys
        static var height = "height"
        static var width = "width"
        static var htmlAttributions = "html_attributions"
        static var photoReference = "photo_reference"
    }
    
    struct ResponseValues {
        struct StatusValues {
            static var ok = "OK"
            static var zeroResults = "ZERO_RESULTS"
            static var overQueryLimit = "OVER_QUERY_LIMIT"
            static var requestDenied = "REQUEST_DENIED"
            static var invalidRequest = "INVALID_REQUEST"
        }
    }
}
