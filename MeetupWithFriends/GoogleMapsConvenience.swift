//
//  GoogleMapsConvenience.swift
//  MeetupWithFriends
//
//  Created by Paul Kim on 12/10/16.
//  Copyright © 2016 BPV, Inc. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class GoogleMapsConvenience {
    
    // Convert an address and return coordinates
    class func geocodeAddress(address: String!, withCompletionHandler: @escaping (_ coordinate: (latitude: Double, longitude: Double)?, _ error: String?) -> Void) {
        guard let address = address else {
            withCompletionHandler(nil, "Address was not provided")
            return
        }
        
        let parameters: [String: Any] = [
            GoogleConstants.Geocoding.ParameterKeys.Address: address,
            GoogleConstants.Geocoding.ParameterKeys.APIKey: GoogleConstants.API.APIKey
        ]
        
        let geocodeURL = GoogleConstants.Geocoding.BaseURL
        
        Alamofire.request(geocodeURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).validate().responseJSON { response in
            
            // shortcut for geocoding constants
            let constants = GoogleConstants.Geocoding.self

            switch response.result {
            case .success:
                if let jsonObject = response.result.value {
                    let json = JSON(jsonObject)
                    
                    guard json[constants.ResponseKeys.Status].stringValue == constants.ResponseValues.OK else {
                        if json[constants.ResponseKeys.Status].stringValue == constants.ResponseValues.ZeroResults {
                            withCompletionHandler(nil, "Could not locate that address.  Please try another.")
                        } else {
                            // TODO: handle more errors
                            withCompletionHandler(nil, "Could not locate that address.  Please try another.")
                        }
                        
                        return
                    }
                    
                    guard json[constants.ResponseKeys.Results].exists() else {
                        withCompletionHandler(nil, json[constants.ResponseKeys.Results].error?.localizedDescription)
                        return
                    }
                    
                    guard let firstResult = json[constants.ResponseKeys.Results].array?[0].dictionary else {
                        withCompletionHandler(nil, "First result did not exist")
                        return
                    }
                    
                    guard let lat = firstResult[constants.ResponseKeys.Geometry]?[GoogleConstants.Geocoding.ResponseKeys.Location][GoogleConstants.Geocoding.ResponseKeys.Lat].double else {
                        withCompletionHandler(nil, "Lat did not exist")
                        return
                    }
                    
                    guard let lon = firstResult[constants.ResponseKeys.Geometry]?[constants.ResponseKeys.Location][constants.ResponseKeys.Lon].double else {
                        withCompletionHandler(nil, "Lon did not exist")
                        return
                    }
                    
                    // passed all validation, success!
                    withCompletionHandler((latitude: lat, longitude: lon), nil)
                }
            case .failure(let error):
                withCompletionHandler(nil, error.localizedDescription)
            }
        }
    }
}
