//
//  NetworkingManager.swift
//  Ronald Interview
//
//  Created by Ronald Kwok on 31/3/2019.
//  Copyright © 2019 Ronald Kwok. All rights reserved.
//

import Foundation
import Alamofire

enum DataResponseError {
    case network
    case decode
    
    var reason: String {
        switch self {
        case .network:
            return "An error occurred while fetching data "
        case .decode:
            return "An error occurred while decoding data"
        }
    }
}

class NetworkingManager: NSObject {
    // MARK: - Constant
    private static let APIKey = "7115f68063ef7daeff0e2143926feab9"
    
    // MARK: - Public
    static func getMovies(page: Int = 1, completionHandler: @escaping ((GetMoviesResponse?, DataResponseError?) -> Void) ) {
        
        if !Reachability.isConnectedToNetwork() {
            completionHandler(nil, DataResponseError.network)
            return
        }
        
        let parameters: Parameters = [
            "api_key" : APIKey,
            "page": page
        ]
        Alamofire
            .request("https://api.themoviedb.org/3/discover/movie",
                     parameters: parameters)
            .responseJSON { (json) in
                
                if json.error != nil {
                    completionHandler(nil, DataResponseError.network)
                    return
                }
                
                
                guard let httpResponse = json.response, 200 ... 299 ~= httpResponse.statusCode
                    else {
                        completionHandler(nil, DataResponseError.network)
                        return
                }
                
                if let dict = json.result.value as? [String: AnyObject],
                    let response = JSONDecoder().decode(GetMoviesResponse.self, from: dict) {
                    completionHandler(response, nil)
                } else {
                    completionHandler(nil, DataResponseError.decode)
                }
        }
    }
}
