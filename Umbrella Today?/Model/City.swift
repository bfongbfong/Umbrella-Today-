//
//  City.swift
//  Umbrella Today?
//
//  Created by Brandon Fong on 12/29/19.
//  Copyright © 2019 Fiesta Togo Inc. All rights reserved.
//

import Foundation

class City {
    var name: String
    var state: String?
    var country: String
    
    init(name: String, country: String) {
        self.name = name
        self.country = country
    }
    
    init(name: String, state: String, country: String) {
        self.name = name
        self.country = country
        self.state = state
    }
}
