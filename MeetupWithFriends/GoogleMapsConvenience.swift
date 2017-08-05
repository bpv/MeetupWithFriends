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

final class GoogleMapsConvenience {
    
    // Convert an address and return coordinates
    final class func geocodeAddress(address: String!, withCompletionHandler: @escaping (_ coordinate: (latitude: Double, longitude: Double)?, _ error: String?) -> Void) {
        guard let address = address else {
            withCompletionHandler(nil, "Address was not provided")
            return
        }
        
        let parameters: [String: Any] = [
            GoogleConstants.Geocoding.ParameterKeys.address: address,
            GoogleConstants.Geocoding.ParameterKeys.apiKey: GoogleConstants.API.apiKey
        ]
        
        let geocodeURL = GoogleConstants.Geocoding.baseURL
        
        Alamofire.request(geocodeURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).validate().responseJSON { response in

            switch response.result {
            case .success:
                if let jsonObject = response.result.value {
                    let json = JSON(jsonObject)
                    
                    guard json[GoogleConstants.ResponseKeys.status].stringValue == GoogleConstants.ResponseValues.StatusValues.ok else {
                        if json[GoogleConstants.ResponseKeys.status].stringValue == GoogleConstants.ResponseValues.StatusValues.zeroResults {
                            withCompletionHandler(nil, "Could not locate that address.  Please try another.")
                        } else {
                            // TODO: handle more errors
                            withCompletionHandler(nil, "Could not locate that address.  Please try another.")
                        }
                        
                        return
                    }
                    
                    guard json[GoogleConstants.ResponseKeys.results].exists() else {
                        withCompletionHandler(nil, json[GoogleConstants.ResponseKeys.results].error?.localizedDescription)
                        return
                    }
                    
                    guard let firstResult = json[GoogleConstants.ResponseKeys.results].array?[0].dictionary else {
                        withCompletionHandler(nil, "First result did not exist")
                        return
                    }
                    
                    guard let lat = firstResult[GoogleConstants.ResponseKeys.geometry]?[GoogleConstants.ResponseKeys.location][GoogleConstants.ResponseKeys.lat].double else {
                        withCompletionHandler(nil, "Lat did not exist")
                        return
                    }
                    
                    guard let lon = firstResult[GoogleConstants.ResponseKeys.geometry]?[GoogleConstants.ResponseKeys.location][GoogleConstants.ResponseKeys.lon].double else {
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
