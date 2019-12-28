//
//  ViewController.swift
//  Umbrella Today?
//
//  Created by Brandon Fong on 12/27/19.
//  Copyright © 2019 Fiesta Togo Inc. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class ViewController: UIViewController {

//    let url =
    let apikey = "8cf99fbd36fd589f46f2813475533328"
    let homeLat = "40.920295"
    let homeLon = "-74.530521"
    
    var weatherReport: WeatherReport!
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getLocation()
    }
    
    func setup() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func getLocation() {
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() ==  .authorizedAlways) {
              currentLocation = locationManager.location
            runAPI()
        }
    }
    
    func runAPI() {
       
        guard currentLocation != nil else { return }
        AF.request("http://api.openweathermap.org/data/2.5/weather?lat=\(currentLocation.coordinate.latitude)&lon=\(currentLocation.coordinate.longitude)&APIKEY=\(apikey)").responseJSON(completionHandler: { (response) in

            print(response.value!)

            if let responseJson = response.value as? [String: Any] {
                self.weatherReport = self.parseJson(jsonObject: responseJson)
                DispatchQueue.main.async {
                    // update ui
                }
            }
            
        })
    }
    
    func parseJson(jsonObject: [String: Any]) -> WeatherReport? {
        
        guard let temperatureObject = jsonObject["main"] as? [String: Any] else { return nil }
        
        // parsing temperature
        guard let currentTemp = temperatureObject["temp"] as? Double else { return nil }
        guard let tempMax = temperatureObject["temp_max"] as? Double else { return nil }
        guard let tempMin = temperatureObject["temp_min"] as? Double else { return nil }
        guard let feelsLike = temperatureObject["feels_like"] as? Double else { return nil }
        let temperature = Temperature(currentInKevlvin: currentTemp, minimumInKelvin: tempMin, maximumInKelvin: tempMax, feelsLikeInKelvin: feelsLike)
        
        guard let location = jsonObject["name"] as? String else { return nil }
        
        guard let weatherObject = jsonObject["weather"] as? [String: Any] else { return nil }
        guard let description = weatherObject["description"] as? String else { return nil }
        guard let main = weatherObject["main"] as? String else { return nil }
        
        guard let rainObject = jsonObject["rain"] as? [String: Any] else { return nil }
        
        guard let rain1hr = rainObject["1h"] as? Double else { return nil }
        
        let thisWeatherReport = WeatherReport(temperature: temperature, location: location, description: description, main: main, rain1hr: rain1hr)
        
        
        // optional properties
        if let humidity = temperatureObject["humidity"] as? Int {
            thisWeatherReport.humidity = humidity
        }
        if let pressure = temperatureObject["pressure"] as? Int {
            thisWeatherReport.pressure = pressure
        }
        
        if let rain3hr = rainObject["3h"] as? Double {
            thisWeatherReport.rain3hr = rain3hr
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
        return thisWeatherReport
    }

}

