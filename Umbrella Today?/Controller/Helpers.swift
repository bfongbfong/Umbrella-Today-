//
//  Helpers.swift
//  Umbrella Today?
//
//  Created by Brandon Fong on 12/27/19.
//  Copyright © 2019 Fiesta Togo Inc. All rights reserved.
//

import Foundation

class Helpers {
    static func convertKelvinToFarenheit(kelvinNumber: Double) -> Int {
        return Int( ( ( ( kelvinNumber - 273.15 ) * 9 ) / 5 ) + 32 )
    }
    
    static func convertToDayOfWeek(unixTimeStamp: Double) -> String {
        let secondsFromGMT = Double(TimeZone.current.secondsFromGMT())
        let dayOfWeekNumber = Int(floor((unixTimeStamp + secondsFromGMT)/86400) + 4) % 7
        
        // to test if method is working correctly.
//        let date = Date(timeIntervalSince1970: unixTimeStamp)
//        let dateFormatter = DateFormatter()
//        dateFormatter.timeStyle = DateFormatter.Style.short //Set time style
//        dateFormatter.dateStyle = DateFormatter.Style.full //Set date style
//        dateFormatter.timeZone = .current
//        let localDate = dateFormatter.string(from: date)
//        print("local date:", localDate)

        switch dayOfWeekNumber {
        case 0:
            return "SUN"
        case 1:
            return "MON"
        case 2:
            return "TUES"
        case 3:
            return "WED"
        case 4:
            return "THUR"
        case 5:
            return "FRI"
        case 6:
            return "SAT"
        default:
            return ""
        }
    }
    
    static func convertToTime(unixTimeStamp: Double) -> String {
        let date = Date(timeIntervalSince1970: unixTimeStamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short //Set time style
        dateFormatter.timeZone = .current
        var time = dateFormatter.string(from: date)
        
        var timeInCharacters = Array(time)
        if timeInCharacters[1] == ":" {
            timeInCharacters.removeSubrange(1...4)
        } else if timeInCharacters[2] == ":" {
            timeInCharacters.removeSubrange(2...5)
        }
        
        time = String(timeInCharacters)
        return time
    }
    
    /// Sifts through array of simple weather objects to find the mid-day temperature for each day.
    ///
    /// - Parameter simpleWeatherReports: The array of SimpleWeatherReport objects parsed from the 5 day forecast API call.
    /// - Returns: The array of mid-day temperatures to represent the week
    static func findFiveDayReports(simpleWeatherReports: [SimpleWeatherReport]) -> [SimpleWeatherReport] {
        var returnArray = [SimpleWeatherReport]()
        var monArray = [SimpleWeatherReport]()
        var tueArray = [SimpleWeatherReport]()
        var wedArray = [SimpleWeatherReport]()
        var thuArray = [SimpleWeatherReport]()
        var friArray = [SimpleWeatherReport]()
        var satArray = [SimpleWeatherReport]()
        var sunArray = [SimpleWeatherReport]()

        for weatherReport in simpleWeatherReports {
            switch weatherReport.dayOfWeek {
            case "MON":
                monArray.append(weatherReport)
            case "TUES":
                tueArray.append(weatherReport)
            case "WED":
                wedArray.append(weatherReport)
            case "THUR":
                thuArray.append(weatherReport)
            case "FRI":
                friArray.append(weatherReport)
            case "SAT":
                satArray.append(weatherReport)
            case "SUN":
                sunArray.append(weatherReport)
            default:
                break
            }
        }
        
        let arrayOfWeekArrays = [monArray, tueArray, wedArray, thuArray, friArray, satArray, sunArray]
        
        for weekArray in arrayOfWeekArrays {
            if weekArray.count != 0 {
                let middleIndex = weekArray.count / 2
                returnArray.append(weekArray[middleIndex])
            }
        }
        
        return returnArray
    }
}
