//
//  Temperature.swift
//  Umbrella Today?
//
//  Created by Brandon Fong on 12/29/19.
//  Copyright © 2019 Fiesta Togo Inc. All rights reserved.
//

import Foundation

class Temperature: Codable {
    var current: Int
    var minimum: Int
    var maximum: Int
    var feelsLike: Int
    
    init(currentInKelvin: Double, minimumInKelvin: Double, maximumInKelvin: Double, feelsLikeInKelvin: Double) {
        self.current = Helpers.convertKelvinToFarenheit(kelvinNumber: currentInKelvin)
        self.minimum = Helpers.convertKelvinToFarenheit(kelvinNumber: minimumInKelvin)
        self.maximum = Helpers.convertKelvinToFarenheit(kelvinNumber: maximumInKelvin)
        self.feelsLike = Helpers.convertKelvinToFarenheit(kelvinNumber: feelsLikeInKelvin)
    }
}
