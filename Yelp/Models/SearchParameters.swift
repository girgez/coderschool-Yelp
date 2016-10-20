//
//  SearchParameters.swift
//  Yelp
//
//  Created by Girge on 10/20/16.
//  Copyright © 2016 Girge. All rights reserved.
//

import Foundation

class SearchParameters: NSObject {
    var term: String?
    var sortMode: YelpSortMode?
    var categories: [String]?
    var deals: Bool?
}
