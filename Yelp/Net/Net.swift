//
//  Net.swift
//  Yelp
//
//  Created by Girge on 10/18/16.
//  Copyright © 2016 Girge. All rights reserved.
//

import Foundation
import AFNetworking

class Net {
    var url: String = Constant.BASE_URL
    var method: String
    var parameters: [String: Any]?
//    var headers: HTTPHeaders?
    
    init(method: String, path: String?, parameters: [String: Any]?) {
        self.method = method
        self.url += (path ?? "")
        self.parameters = parameters
//        self.parameters?["api_key"] = Constant.API_KEY
//        self.headers = headers
    }
    
    func request() {
        
        
    }
}
