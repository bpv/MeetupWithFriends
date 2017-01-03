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
import GooglePlaces

class GooglePlacesConvenience {
    class func getNearbyPlaces(latitude: Double, longitude: Double, type: String, pageToken: String?, withCompletionHandler: @escaping (_ places: Places?, _ error: String?) -> Void) {
        
        let url = GoogleConstants.Places.baseURL + GoogleConstants.Places.Methods.nearbySearch
        
        let parameters: [String: Any] = [
            GoogleConstants.Places.ParameterKeys.apiKey: GoogleConstants.API.apiKey,
            GoogleConstants.Places.ParameterKeys.location: "\(latitude),\(longitude)",
            GoogleConstants.Places.ParameterKeys.radius: 2500,
            GoogleConstants.Places.ParameterKeys.type: type
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
                        placesToReturn.append(Place(json: place))
                    }
                    
                    withCompletionHandler(Places(places: placesToReturn, nextPageToken: json[GoogleConstants.ResponseKeys.nextPageToken].stringValue), nil)
                }
            case .failure(let error):
                withCompletionHandler(nil, error.localizedDescription)
            }
        }
    }
    
    class func getPlaceDetails(placeID: String, withCompletionHandler: @escaping (_ data: PlaceDetails?, _ error: String?) -> Void) {
        
        let url = GoogleConstants.Places.baseURL + GoogleConstants.Places.Methods.details
        
        let parameters: [String: Any] = [
            GoogleConstants.Places.ParameterKeys.apiKey: GoogleConstants.API.apiKey,
            GoogleConstants.Places.ParameterKeys.placeID: placeID
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).validate().responseJSON { (response) in
            
            switch response.result {
            case .success:
                if let jsonObject = response.result.value {
                    let json = JSON(jsonObject)
                    
                    guard json[GoogleConstants.ResponseKeys.status].stringValue == GoogleConstants.ResponseValues.StatusValues.ok else {
                        if json[GoogleConstants.ResponseKeys.status].stringValue == GoogleConstants.ResponseValues.StatusValues.zeroResults {
                            withCompletionHandler(nil, "No results found. Please try again later.")
                        } else {
                            // TODO: handle more errors
                            withCompletionHandler(nil, "There was an error. Please try again later.")
                        }
                        
                        return
                    }
                    
                    guard json[GoogleConstants.ResponseKeys.result].exists() else {
                        withCompletionHandler(nil, json[GoogleConstants.ResponseKeys.result].error?.localizedDescription)
                        return
                    }
                    
                    guard let detailsJSON = json[GoogleConstants.ResponseKeys.result].dictionary else {
                        withCompletionHandler(nil, "There were no results. Please try again later.")
                        return
                    }
                
                    withCompletionHandler(PlaceDetails(json: detailsJSON), nil)
                }
            case .failure(let error):
                withCompletionHandler(nil, error.localizedDescription)
            }
        }
    }
    
    class func getPlacePhoto(reference: String, maxWidth: Int, maxHeight: Int, withCompletionHandler: @escaping (_ photo: UIImage?, _ error: String?) -> Void) {
        
        let url = GoogleConstants.Places.baseURL + GoogleConstants.Places.Methods.photo
        
        let parameters: [String: Any] = [
            GoogleConstants.Places.ParameterKeys.apiKey: GoogleConstants.API.apiKey,
            GoogleConstants.Places.ParameterKeys.photoReference: reference,
            GoogleConstants.Places.ParameterKeys.maxWidth: maxWidth,
            GoogleConstants.Places.ParameterKeys.maxHeight: maxHeight
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).validate().responseData { (response) in
            
            switch response.result {
            case .success:
                if let data = response.result.value {
                    withCompletionHandler(UIImage(data: data), nil)
                } else {
                    withCompletionHandler(nil, "No image was returned")
                }
            case .failure(let error):
                withCompletionHandler(nil, error.localizedDescription)
            }
        }
    }
}
