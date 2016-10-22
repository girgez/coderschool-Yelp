//
//  SearchParameters.swift
//  Yelp
//
//  Created by Girge on 10/20/16.
//  Copyright © 2016 Girge. All rights reserved.
//

import Foundation

class SearchParameters {
    var term: String?
    var sortMode = YelpSortMode.bestMatched
    var categories = [String]()
    var deals: Bool?
    var distance = "Auto"
    
    init() {
    }
    
    init(parameters: SearchParameters) {
        term = parameters.term
        sortMode = parameters.sortMode
        categories = parameters.categories
        deals = parameters.deals
        distance = parameters.distance
    }
    
    func setTerm(term: String) {
        self.term = term
    }
    
    func setSortMode(mode: YelpSortMode) {
        self.sortMode = mode
    }
    
    func setCategories(categories: [String]) {
        self.categories = categories
    }
    
    func setDeals(deals: Bool) {
        self.deals = deals
    }
    
    func setDistance(distance: String) {
        self.distance = distance
    }
    
    func clone() -> SearchParameters {
        return SearchParameters(parameters: self)
    }
}
