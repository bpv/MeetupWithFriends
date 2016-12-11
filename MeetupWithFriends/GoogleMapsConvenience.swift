//
//  GoogleMapsConvenience.swift
//  MeetupWithFriends
//
//  Created by Paul Kim on 12/10/16.
//  Copyright © 2016 BPV, Inc. All rights reserved.
//

import Foundation
import Alamofire

class GoogleMapsConvenience {
    class func forwardGeocodeAddress(address: String!, withCompletionHandler: (_ status: String?, _ success: Bool) -> Void) {
        guard let address = address else {
            withCompletionHandler(nil, false)
            return
        }
        
        let parameters: [String: Any] = [
            GoogleConstants.Geocoding.ParameterKeys.Address: address,
            GoogleConstants.Geocoding.ParameterKeys.APIKey: GoogleConstants.API.APIKey
        ]
        
        let geocodeURL = GoogleConstants.Geocoding.BaseURL
        
        Alamofire.request(geocodeURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).validate().responseJSON { response in
            
            switch response.result {
            case .success:
                if let json = response.result.value {
                    print(json)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
