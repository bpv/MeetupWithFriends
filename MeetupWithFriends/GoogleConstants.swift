//
//  GoogleConstants.swift
//  MeetupWithFriends
//
//  Created by Paul Kim on 12/9/16.
//  Copyright © 2016 BPV, Inc. All rights reserved.
//

import Foundation

struct GoogleConstants {
    static var settingsDict: [String: AnyObject] {
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
        static var ProjectID = GoogleConstants.settingsDict["googleProjectID"] as! String
        static var APIKey = GoogleConstants.settingsDict["googleMapsAPIKey"] as! String
    }
    
    struct Configuration {
        static var StartingZoom: Float = 15.0
    }
    
    struct Geocoding {
        static var BaseURL = "https://maps.googleapis.com/maps/api/geocode/json"
        
        struct ParameterKeys {
            static var Address = "address"
            static var Components = "components"
            static var APIKey = "key"
        }
        
        struct ResponseKeys {
            static var Results = "results"
            static var Geometry = "geometry"
            static var Location = "location"
            static var Lat = "lat"
            static var Lon = "lng"
            static var Status = "status"
        }
        
        struct ResponseValues {
            static var OK = "OK"
            static var ZeroResults = "ZERO_RESULTS"
        }
    }
}
