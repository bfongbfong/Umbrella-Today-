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
    var id: Int
    
    init(name: String, country: String, id: Int) {
        self.name = name
        self.country = country
        self.id = id
    }
    
    init(name: String, state: String, country: String, id: Int) {
        self.name = name
        self.country = country
        self.state = state
        self.id = id
    }
}
