//
//  WeatherReport.swift
//  Umbrella Today?
//
//  Created by Brandon Fong on 12/27/19.
//  Copyright © 2019 Fiesta Togo Inc. All rights reserved.
//

import Foundation

class WeatherReport: Codable, Equatable {
    
    var temperature: Temperature
    var location: String
    var description: String
    var main: String
    var id: Int
    
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
    var timeZone: Double?
    
    init(temperature: Temperature,
         location: String,
         description: String,
         main: String,
         id: Int,
         rain1hr: Double?,
         humidity: Int?,
         pressure: Int?,
         rain3hr: Double?,
         clouds: Double?,
         visibility: Int?,
         windDirection: Int?,
         windSpeed: Int?,
         sunsetTime: Int?,
         sunriseTime: Int?,
         timeZone: Double?) {
        self.temperature = temperature
        self.location = location
        self.description = description
        self.main = main
        self.id = id
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
        self.timeZone = timeZone
    }
    
    init(temperature: Temperature,
         location: String,
         description: String,
         main: String,
         id: Int) {
        self.temperature = temperature
        self.location = location
        self.description = description
        self.main = main
        self.id = id
    }
    
    func convertIntoSimpleWeatherReportForFirstHourlyResult() -> SimpleWeatherReport {
        let simpleWeatherReport = SimpleWeatherReport(currentTempInFahrenheit: temperature.current, minTempInFahrenheit: temperature.minimum, maxTempInFahrenheit: temperature.maximum, description: description, dayOfWeek: "", time: "NOW")
        return simpleWeatherReport
    }
    
    static func == (lhs: WeatherReport, rhs: WeatherReport) -> Bool {
        return lhs.location == rhs.location
    }
}
