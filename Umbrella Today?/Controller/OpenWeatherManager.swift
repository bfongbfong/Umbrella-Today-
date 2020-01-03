//
//  OpenWeatherManager.swift
//  Umbrella Today?
//
//  Created by Brandon Fong on 12/28/19.
//  Copyright © 2019 Fiesta Togo Inc. All rights reserved.
//

import Foundation
import Alamofire

class OpenWeatherManager {
    
    static let apikey = "8cf99fbd36fd589f46f2813475533328"
    
    // coordinates for my house for test
    static let homeLat = "40.920295"
    static let homeLon = "-74.530521"

    static func getCurrentWeatherData(latitude: Double, longitude: Double, completion: @escaping((_ jsonWeatherObject: [String: Any]?) -> Void)) {
       
//        print("latitude is \(latitude)")
//        print("longitude is \(longitude)")
        AF.request("http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&APIKEY=\(apikey)").responseJSON(completionHandler: { (response) in

//            print(response.value!)
            
            if let responseJson = response.value as? [String: Any] {
                completion(responseJson)
            } else {
                completion(nil)
            }
        })
    }
    
    static func getCurrentWeatherData(cityID: Int, completion: @escaping((_ jsonWeatherObject: [String: Any]?) -> Void)) {
        
        AF.request("http://api.openweathermap.org/data/2.5/weather?id=\(cityID)&APIKEY=\(apikey)").responseJSON(completionHandler: { (response) in
            
//            print(response.value!)
            
            if let responseJson = response.value as? [String: Any] {
                completion(responseJson)
            } else {
                completion(nil)
            }
            
        })
    }
    
    static func getFiveDayAndHourlyForecast(latitude: Double, longitude: Double, completion: @escaping((_ jsonWeatherObject: [String: Any]?) -> Void)) {
        AF.request("http://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&APIKEY=\(apikey)").responseJSON(completionHandler: { (response) in

//            print(response.value!)
            
            if let responseJson = response.value as? [String: Any] {
                completion(responseJson)
            } else {
                completion(nil)
            }
        })
    }
    
    static func getFiveDayAndHourlyForecast(cityID: Int, completion: @escaping((_ jsonWeatherObject: [String: Any]?) -> Void)) {
        AF.request("http://api.openweathermap.org/data/2.5/forecast?id=\(cityID)&APIKEY=\(apikey)").responseJSON(completionHandler: { (response) in

//            print(response.value!)
            
            if let responseJson = response.value as? [String: Any] {
                completion(responseJson)
            } else {
                completion(nil)
            }
        })
    }
    
}
