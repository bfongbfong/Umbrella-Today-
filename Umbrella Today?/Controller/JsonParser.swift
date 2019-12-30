//
//  JsonParser.swift
//  Umbrella Today?
//
//  Created by Brandon Fong on 12/29/19.
//  Copyright © 2019 Fiesta Togo Inc. All rights reserved.
//

import Foundation

class JsonParser {
    static func parseJsonWeatherObject(jsonObject: [String: Any]) -> WeatherReport? {
        
        guard let temperatureObject = jsonObject["main"] as? [String: Any] else { return nil }
        
        // parsing temperature
        guard let currentTemp = temperatureObject["temp"] as? Double else { return nil }
        guard let tempMax = temperatureObject["temp_max"] as? Double else { return nil }
        guard let tempMin = temperatureObject["temp_min"] as? Double else { return nil }
        guard let feelsLike = temperatureObject["feels_like"] as? Double else { return nil }
        let temperature = Temperature(currentInKevlvin: currentTemp, minimumInKelvin: tempMin, maximumInKelvin: tempMax, feelsLikeInKelvin: feelsLike)
        
        guard let location = jsonObject["name"] as? String else { return nil }
        
        guard let weatherArray = jsonObject["weather"] as? [Any] else { return nil }
        guard let weatherObject = weatherArray[0] as? [String: Any] else { return nil }
        guard let description = weatherObject["description"] as? String else { return nil }
        guard let main = weatherObject["main"] as? String else { return nil }
                        
        let thisWeatherReport = WeatherReport(temperature: temperature, location: location, description: description, main: main)
        
        if let rainObject = jsonObject["rain"] as? [String: Any] {
            if let rain1hr = rainObject["1hr"] as? Double {
                thisWeatherReport.rain1hr = rain1hr
            }
            if let rain3hr = rainObject["3h"] as? Double {
                thisWeatherReport.rain3hr = rain3hr
            }
        }
        
        // optional properties
        if let humidity = temperatureObject["humidity"] as? Int {
            thisWeatherReport.humidity = humidity
        }
        if let pressure = temperatureObject["pressure"] as? Int {
            thisWeatherReport.pressure = pressure
        }
        
        if let cloudsObject = jsonObject["clouds"] as? [String: Any] {
            if let clouds = cloudsObject["all"] as? Double {
                thisWeatherReport.clouds = clouds
            }
        }
        
        if let visibility = jsonObject["visibility"] as? Int {
            thisWeatherReport.visibility = visibility
        }
        
        if let windObject = jsonObject["wind"] as? [String: Any] {
            if let deg = windObject["deg"] as? Int {
                thisWeatherReport.windDirection = deg
            }
            if let windSpeed = windObject["speed"] as? Int {
                thisWeatherReport.windSpeed = windSpeed
            }
        }
        
        if let sysObject = jsonObject["sys"] as? [String: Any] {
            if let sunriseTime = sysObject["sunrise"] as? Int {
                thisWeatherReport.sunriseTime = sunriseTime
            }
            if let sunsetTime = sysObject["sunset"] as? Int {
                thisWeatherReport.sunsetTime = sunsetTime
            }
        }
        
        return thisWeatherReport
    }
}
