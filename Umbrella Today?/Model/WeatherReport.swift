//
//  WeatherReport.swift
//  Umbrella Today?
//
//  Created by Brandon Fong on 12/27/19.
//  Copyright © 2019 Fiesta Togo Inc. All rights reserved.
//

import Foundation

class WeatherReport {
    var temperature: Temperature
    var location: String
    var description: String
    var main: String
    
    var humidity: Int?
    var pressure: Int?
    var rain1hr: Double?
    var rain3hr: Double?
    var clouds: Double?
    var visibility: Int?
    var windDirection: Int?
    var windSpeed: Int?
    
    init(temperature: Temperature,
         location: String,
         description: String,
         main: String,
         rain1hr: Double?,
         humidity: Int?,
         pressure: Int?,
         rain3hr: Double?,
         clouds: Double?,
         visibility: Int?,
         windDirection: Int?,
         windSpeed: Int?) {
        self.temperature = temperature
        self.location = location
        self.description = description
        self.main = main
        self.rain1hr = rain1hr
        self.humidity = humidity
        self.pressure = pressure
        self.rain3hr = rain3hr
        self.clouds = clouds
        self.visibility = visibility
        self.windDirection = windDirection
        self.windSpeed = windSpeed
    }
    
    init(temperature: Temperature,
         location: String,
         description: String,
         main: String) {
        self.temperature = temperature
        self.location = location
        self.description = description
        self.main = main
    }
}

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
