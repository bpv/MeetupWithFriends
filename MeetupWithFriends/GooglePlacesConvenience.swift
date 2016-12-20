//
//  GooglePlacesConvenience.swift
//  MeetupWithFriends
//
//  Created by Paul Kim on 12/12/16.
//  Copyright © 2016 BPV, Inc. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class GooglePlacesConvenience {
    class func getNearbyPlaces(latitude: Double, longitude: Double, pageToken: String?, withCompletionHandler: @escaping (_ places: Places?, _ error: String?) -> Void) {
        let url = GoogleConstants.Places.baseURL
        
        let parameters: [String: Any] = [
            GoogleConstants.Places.ParameterKeys.apiKey: GoogleConstants.API.apiKey,
            GoogleConstants.Places.ParameterKeys.location: "\(latitude),\(longitude)",
            GoogleConstants.Places.ParameterKeys.radius: 5000,
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).validate().responseJSON { (response) in
            
            switch response.result {
            case .success:
                if let jsonObject = response.result.value {
                    let json = JSON(jsonObject)
                    
                    guard json[GoogleConstants.ResponseKeys.status].stringValue == GoogleConstants.ResponseValues.StatusValues.ok else {
                        if json[GoogleConstants.ResponseKeys.status].stringValue == GoogleConstants.ResponseValues.StatusValues.zeroResults {
                            withCompletionHandler(nil, "No results found. Please try another location.")
                        } else {
                            // TODO: handle more errors
                            withCompletionHandler(nil, "There was an error. Please try another location.")
                        }
                        
                        return
                    }
                    
                    guard json[GoogleConstants.ResponseKeys.results].exists() else {
                        withCompletionHandler(nil, json[GoogleConstants.ResponseKeys.results].error?.localizedDescription)
                        return
                    }
                    
                    guard let places = json[GoogleConstants.ResponseKeys.results].array else {
                        withCompletionHandler(nil, "There were no results. Please try another address")
                        return
                    }
                    
                    var placesToReturn = [Place]()
                    for place in places {
                        guard let placeDict = place.dictionary else {
                            withCompletionHandler(nil, "There was an error. Please try again.")
                            return
                        }
                        
                        placesToReturn.append(Place(json: place))
                    }
                    
                    withCompletionHandler(Places(places: placesToReturn, nextPageToken: json[GoogleConstants.ResponseKeys.nextPageToken].stringValue), nil)
                }
            case .failure(let error):
                withCompletionHandler(nil, error.localizedDescription)
            }
        }
    }
}
