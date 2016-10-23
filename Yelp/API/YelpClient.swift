//
//  YelpClient.swift
//  Yelp
//
//  Created by Girge on 10/18/16.
//  Copyright © 2016 Girge. All rights reserved.
//

import Foundation
import AFNetworking
import BDBOAuth1Manager

enum YelpSortMode: Int {
    case bestMatched = 0, distance, highestRated
}

class YelpClient: BDBOAuth1RequestOperationManager {
    var accessToken: String!
    var accessSecret: String!
    
    static var _shared: YelpClient?
    static func shared() -> YelpClient! {
        if _shared == nil {
            _shared = YelpClient(consumerKey: Constant.YELP_CONSUMERKEY, consumerSecret: Constant.YELP_CONSUMERSECRET, accessToken: Constant.YELP_TOKEN, accessSecret: Constant.YELP_TOKENSECRET)
        }
        return _shared
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
        self.accessToken = accessToken
        self.accessSecret = accessSecret
        let baseUrl = URL(string: Constant.BASE_URL)
        super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);
        
        let token = BDBOAuth1Credential(token: accessToken, secret: accessSecret, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
    }
    
    @discardableResult
    func search(with parameters: SearchParameters, completion: @escaping ([Business]?, Error?) -> Void) -> AFHTTPRequestOperation {
        return search(with: parameters.term, sort: parameters.sortMode, categories: parameters.categories, deals: parameters.deals, distance: parameters.distance, offset: parameters.offset, completion: completion)
    }
    
//    @discardableResult
//    func search(with term: String, completion: @escaping ([Business]?, Error?) -> Void) -> AFHTTPRequestOperation {
//        return search(with: term, sort: nil, categories: nil, deals: nil, completion: completion)
//    }
    
    @discardableResult
    func search(with term: String?, sort: YelpSortMode?, categories: [String]?, deals: Bool?, distance: String?, offset: Int, completion: @escaping ([Business]?, Error?) -> Void) -> AFHTTPRequestOperation {
        // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
        
        // Default the location to San Francisco
        var parameters: [String : AnyObject] = ["ll": "37.785771,-122.406165" as AnyObject]
        
        if term != nil {
            parameters["term"] = term! as AnyObject
        }
        
        if sort != YelpSortMode.bestMatched {
            parameters["sort"] = sort!.rawValue as AnyObject?
        }
        
        if categories!.count > 0 {
            parameters["category_filter"] = (categories!).joined(separator: ",") as AnyObject?
        }
        
        if deals != nil {
            parameters["deals_filter"] = deals! as AnyObject?
        }
        
        if distance != nil && distance != "Auto" {
            let temp =  Double(distance!.components(separatedBy: " ")[0])
            parameters["radius_filter"] = temp!/0.000621371 as AnyObject?
        }
        
        if offset > 0 {
            parameters["offset"] = offset as AnyObject
        }
        
        print("para \(parameters)")
        
        return self.get("search", parameters: parameters, success: { (operation: AFHTTPRequestOperation, response: Any) in
            if let response = response as? NSDictionary {
                let dictionaries = response["businesses"] as? [NSDictionary]
                if dictionaries != nil {
                    completion(Business.businesses(array: dictionaries!), nil)
                }
            }
            }, failure: { (operation: AFHTTPRequestOperation?, error: Error) in
                completion(nil, error)
        })!
    }
}
