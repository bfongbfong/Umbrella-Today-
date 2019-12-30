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
    var sunsetTime: Int?
    var sunriseTime: Int?
    
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
         windSpeed: Int?,
         sunsetTime: Int?,
         sunriseTime: Int?) {
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
        self.sunsetTime = sunsetTime
        self.sunriseTime = sunriseTime
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
