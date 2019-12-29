//
//  Temperature.swift
//  Umbrella Today?
//
//  Created by Brandon Fong on 12/29/19.
//  Copyright © 2019 Fiesta Togo Inc. All rights reserved.
//

import Foundation

class Temperature {
    var current: Int
    var minimum: Int
    var maximum: Int
    var feelsLike: Int
    
    init(currentInKevlvin: Double, minimumInKelvin: Double, maximumInKelvin: Double, feelsLikeInKelvin: Double) {
        self.current = Helpers.convertKelvinToFarenheit(kelvinNumber: currentInKevlvin)
        self.minimum = Helpers.convertKelvinToFarenheit(kelvinNumber: minimumInKelvin)
        self.maximum = Helpers.convertKelvinToFarenheit(kelvinNumber: maximumInKelvin)
        self.feelsLike = Helpers.convertKelvinToFarenheit(kelvinNumber: feelsLikeInKelvin)
    }
}
