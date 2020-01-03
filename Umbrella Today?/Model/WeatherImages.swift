//
//  WeatherImages.swift
//  Umbrella Today?
//
//  Created by Brandon Fong on 12/30/19.
//  Copyright © 2019 Fiesta Togo Inc. All rights reserved.
//

import UIKit

class WeatherImages {
    
    static var clearSkiesDay: UIImage {
        let clearSkiesDayImages = [UIImage(named: "clear_skies_day_01")!,
                                   UIImage(named: "clear_skies_day_02")!,
                                   UIImage(named: "clear_skies_day_03")!]
        return UIImage.animatedImage(with: clearSkiesDayImages, duration: 1.0)!
    }
    
    static var clearSkiesNight: UIImage {
        let clearSkiesNightImages = [UIImage(named: "clear_skies_night_01")!,
                                   UIImage(named: "clear_skies_night_02")!,
                                   UIImage(named: "clear_skies_night_03")!,
                                   UIImage(named: "clear_skies_night_04")!]
        return UIImage.animatedImage(with: clearSkiesNightImages, duration: 1.0)!
    }
    
    static var cloudy: UIImage {
        let cloudyImages = [UIImage(named: "cloudy_01")!,
                                   UIImage(named: "cloudy_02")!,
                                   UIImage(named: "cloudy_03")!,
                                   UIImage(named: "cloudy_04")!]
        return UIImage.animatedImage(with: cloudyImages, duration: 1.0)!
    }
    
    
    
    static var fewCloudsDay: UIImage {
        let fewCloudsDayImages = [UIImage(named: "few_clouds_day_01")!,
                                  UIImage(named: "few_clouds_day_02")!,
                                  UIImage(named: "few_clouds_day_03")!]
        return UIImage.animatedImage(with: fewCloudsDayImages, duration: 1.0)!
    }
    
    static var fewCloudsNight: UIImage {
        let fewCloudsNightImages = [UIImage(named: "few_clouds_night_01")!,
                                  UIImage(named: "few_clouds_night_02")!,
                                  UIImage(named: "few_clouds_night_03")!]
        return UIImage.animatedImage(with: fewCloudsNightImages, duration: 1.0)!
    }
    
    static var mistDay: UIImage {
        let mistDayImages = [UIImage(named: "mist_day_01")!,
                          UIImage(named: "mist_day_02")!,
                          UIImage(named: "mist_day_03")!,
                          UIImage(named: "mist_day_04")!,
                          UIImage(named: "mist_day_05")!,
        ]
        return UIImage.animatedImage(with: mistDayImages, duration: 1.0)!
    }
    
    static var mistNight: UIImage {
        let mistNightImages = [UIImage(named: "mist_night_01")!,
                          UIImage(named: "mist_night_02")!,
                          UIImage(named: "mist_night_03")!,
                          UIImage(named: "mist_night_04")!,
                          UIImage(named: "mist_night_05")!,
        ]
        return UIImage.animatedImage(with: mistNightImages, duration: 1.0)!
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
    
    static var drizzle: UIImage {
        let drizzleImages = [UIImage(named: "drizzle_01")!,
                          UIImage(named: "drizzle_02")!,
                          UIImage(named: "drizzle_03")!,
                          UIImage(named: "drizzle_04")!,
                          UIImage(named: "drizzle_05")!,
                          UIImage(named: "drizzle_06")!,
                          UIImage(named: "drizzle_07")!,
                          UIImage(named: "drizzle_08")!,
                          UIImage(named: "drizzle_09")!,
                          UIImage(named: "drizzle_10")!,
                          UIImage(named: "drizzle_11")!,
                          UIImage(named: "drizzle_12")!,
                          UIImage(named: "drizzle_13")!,
                          UIImage(named: "drizzle_14")!,
        ]
        return UIImage.animatedImage(with: drizzleImages, duration: 1.0)!
    }
    
    static var thunderStorm: UIImage {
        let thunderStormImages = [UIImage(named: "thunderstorm_01")!,
                          UIImage(named: "thunderstorm_02")!,
                          UIImage(named: "thunderstorm_03")!,
                          UIImage(named: "thunderstorm_04")!,
                          UIImage(named: "thunderstorm_05")!,
                          UIImage(named: "thunderstorm_05")!,
        ]
        return UIImage.animatedImage(with: thunderStormImages, duration: 1.0)!
    }
    
    static var snow: UIImage {
        let snowImages = [UIImage(named: "snow_01")!,
                                  UIImage(named: "snow_02")!,
                                  UIImage(named: "snow_03")!]
        return UIImage.animatedImage(with: snowImages, duration: 1.0)!
    }
    
    static func getImage(weatherDescription: String, isDaytime: Bool) -> UIImage? {
        let description = weatherDescription.lowercased()
        
        switch description {
            
        case "clear sky":
            return isDaytime ? clearSkiesDay : clearSkiesNight
        case "few clouds":
            return isDaytime ? fewCloudsDay : fewCloudsNight
        case "scattered clouds", "broken clouds", "overcast clouds":
            return cloudy
        case "light rain", "moderate rain", "heavy intensity rain", "very heavy rain", "extreme rain", "light intensity shower rain", "shower rain", "heavy intensity shower rain", "ragged shower rain", "light intensity drizzle", "drizzle", "heavy intensity drizzle", "light intensity drizzle rain", "drizzle rain", "heavy intensity drizzle rain", "shower rain and drizzle", "heavy shower rain and drizzle", "shower drizzle":
            return rain
        case "light snow", "snow", "heavy snow", "sleet", "light shower sleet", "shower sleet", "light rain and snow", "rain and snow", "light shower snow", "shower snow", "heavey shower snow", "freezing rain":
            return snow
        case "thunderstorm with light rain", "thunderstorm with rain", "thunderstorm with heavy rain", "light thunderstorm", "thunderstorm", "heavy thunderstorm", "ragged thunderstorm", "thunderstorm with light drizzle", "thunderstorm with drizzle", "thunderstorm with heavy drizzle":
            return thunderStorm
        default:
            return isDaytime ? mistDay : mistNight
        }
        return nil
    }

}
