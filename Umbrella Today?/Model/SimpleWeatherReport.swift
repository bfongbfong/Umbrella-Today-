//
//  SimpleWeatherReport.swift
//  Umbrella Today?
//
//  Created by Brandon Fong on 12/31/19.
//  Copyright © 2019 Fiesta Togo Inc. All rights reserved.
//

import Foundation

class SimpleWeatherReport {
    var currentTemp: Int
    var minTemp: Int
    var maxTemp: Int
    var description: String
    var dayOfWeek: String
    var time: String
    
    init(currentTempInKelvin: Double, minTempInKelvin: Double, maxTempInKelvin: Double, description: String, dayOfWeek: String, time: String) {
        self.currentTemp = Helpers.convertKelvinToFarenheit(kelvinNumber: currentTempInKelvin)
        self.minTemp = Helpers.convertKelvinToFarenheit(kelvinNumber: minTempInKelvin)
        self.maxTemp = Helpers.convertKelvinToFarenheit(kelvinNumber: maxTempInKelvin)
        self.description = description
        self.dayOfWeek = dayOfWeek
        self.time = time
    }
    
    init(currentTempInFahrenheit: Int, minTempInFahrenheit: Int, maxTempInFahrenheit: Int, description: String, dayOfWeek: String, time: String) {
        self.currentTemp = currentTempInFahrenheit
        self.minTemp = minTempInFahrenheit
        self.maxTemp = maxTempInFahrenheit
        self.description = description
        self.dayOfWeek = dayOfWeek
        self.time = time
    }
}
