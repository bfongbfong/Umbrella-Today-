//
//  WeatherImages.swift
//  Umbrella Today?
//
//  Created by Brandon Fong on 12/30/19.
//  Copyright © 2019 Fiesta Togo Inc. All rights reserved.
//

import UIKit

class WeatherImages {
    
    static var fewCloudsDay: UIImage {
        let fewCloudsDayImages = [UIImage(named: "few_clouds_day_01")!,
                                  UIImage(named: "few_clouds_day_02")!,
                                  UIImage(named: "few_clouds_day_03")!]
        return UIImage.animatedImage(with: fewCloudsDayImages, duration: 1.0)!
    }
    
    static var rain: UIImage {
        let rainImages = [UIImage(named: "rain_01")!,
                          UIImage(named: "rain_02")!,
                          UIImage(named: "rain_03")!,
                          UIImage(named: "rain_04")!,
                          UIImage(named: "rain_05")!,
                          UIImage(named: "rain_06")!,
                          UIImage(named: "rain_07")!,
                          UIImage(named: "rain_08")!,
                          UIImage(named: "rain_09")!,
                          UIImage(named: "rain_10")!,
                          UIImage(named: "rain_11")!,
                          UIImage(named: "rain_12")!,
                          UIImage(named: "rain_13")!,
                          UIImage(named: "rain_14")!,
        ]
        return UIImage.animatedImage(with: rainImages, duration: 1.0)!
    }
    
    static func getImage(weatherDescription: String, isDaytime: Bool) -> UIImage? {
        let description = weatherDescription.lowercased()
        
        switch description {
            
        case "clear sky":
        // do clear sky
            break
            
        case "few clouds":
            return fewCloudsDay
            
        case "scattered clouds", "broken clouds", "overcast clouds":
        // do clouds
            break
            
        case "light rain", "moderate rain", "heavy intensity rain", "very heavy rain", "extreme rain", "light intensity shower rain", "shower rain", "heavy intensity shower rain", "ragged shower rain", "light intensity drizzle", "drizzle", "heavy intensity drizzle", "light intensity drizzle rain", "drizzle rain", "heavy intensity drizzle rain", "shower rain and drizzle", "heavy shower rain and drizzle", "shower drizzle":
            return rain
            
        case "light snow", "snow", "heavy snow", "sleet", "light shower sleet", "shower sleet", "light rain and snow", "rain and snow", "light shower snow", "shower snow", "heavey shower snow", "freezing rain":
        // do snow
            break
            
        case "thunderstorm with light rain", "thunderstorm with rain", "thunderstorm with heavy rain", "light thunderstorm", "thunderstorm", "heavy thunderstorm", "ragged thunderstorm", "thunderstorm with light drizzle", "thunderstorm with drizzle", "thunderstorm with heavy drizzle":
        // do thunderstorm
            break
            
        default:
        // return mist
            return fewCloudsDay
        }
        return nil
    }

}
