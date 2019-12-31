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
}
