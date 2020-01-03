//
//  Helpers.swift
//  Umbrella Today?
//
//  Created by Brandon Fong on 12/27/19.
//  Copyright © 2019 Fiesta Togo Inc. All rights reserved.
//

import UIKit

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
            return "TUE"
        case 3:
            return "WED"
        case 4:
            return "THU"
        case 5:
            return "FRI"
        case 6:
            return "SAT"
        default:
            return ""
        }
    }
    
    static func convertToTime(unixTimeStamp: Double, accurateToMinute: Bool, currentTimeZone: Bool) -> String {
        let date = Date(timeIntervalSince1970: unixTimeStamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short //Set time style
        
        if currentTimeZone {
            dateFormatter.timeZone = .current
        }
        
        var time = dateFormatter.string(from: date)
        
        if !accurateToMinute {
            var timeInCharacters = Array(time)
            if timeInCharacters[1] == ":" {
                timeInCharacters.removeSubrange(1...4)
            } else if timeInCharacters[2] == ":" {
                timeInCharacters.removeSubrange(2...5)
            }
            time = String(timeInCharacters)
        }
        return time
    }
    
    static func createArrayOfNextSevenDaysOfWeek() -> [String] {
        let todaysDate = Date()
        let rightNow = todaysDate.timeIntervalSince1970
        let todaysDayOfWeek = convertToDayOfWeek(unixTimeStamp: rightNow)
        let week = Week()
        return week.generateWeekFrom(dayOfWeek: todaysDayOfWeek, amountOfDays: 7)
    }
    
    /// Sifts through array of simple weather objects to find the mid-day temperature for each day.
    ///
    /// - Parameter simpleWeatherReports: The array of SimpleWeatherReport objects parsed from the 5 day forecast API call.
    /// - Returns: The array of mid-day temperatures to represent the week
    static func findFiveDayReport(simpleWeatherReports: [SimpleWeatherReport]) -> [SimpleWeatherReport] {
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
            case "TUE":
                tueArray.append(weatherReport)
            case "WED":
                wedArray.append(weatherReport)
            case "THU":
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
        
        // so maybe out these into some kind of circular linked list?
        
        let arrayOfDaysOfWeek = createArrayOfNextSevenDaysOfWeek()
        
        var arrayOfWeekArrays = [[SimpleWeatherReport]]()
        
        for dayOfWeek in arrayOfDaysOfWeek {
            switch dayOfWeek {
            case "MON":
                arrayOfWeekArrays.append(monArray)
            case "TUE":
                arrayOfWeekArrays.append(tueArray)
            case "WED":
                arrayOfWeekArrays.append(wedArray)
            case "THU":
                arrayOfWeekArrays.append(thuArray)
            case "FRI":
                arrayOfWeekArrays.append(friArray)
            case "SAT":
                arrayOfWeekArrays.append(satArray)
            case "SUN":
                arrayOfWeekArrays.append(sunArray)
            default:
                break
            }
        }
        
        // remove empty elements in array
        arrayOfWeekArrays = arrayOfWeekArrays.filter {
            $0.count != 0
        }
        
        // if it's like 10 pm, meaning it won't include it's own day in the weekly forecast, then go into next day.
        
        for weekArray in arrayOfWeekArrays {
            if weekArray.count != 0 {
                
                // finds the lowest and highest temp from every available report on the day and sets the summary min amd max temp
                var lowestTemp = Int.max
                var highestTemp = Int.min
                for report in weekArray {
                    if report.minTemp < lowestTemp {
                        lowestTemp = report.minTemp
                    }
                    if report.maxTemp > highestTemp {
                        highestTemp = report.maxTemp
                    }
                }
                
                // finds mid-day report to be summary for the day
                let middleIndex = weekArray.count / 2
                let midDayReport = weekArray[middleIndex]
                midDayReport.minTemp = lowestTemp
                midDayReport.maxTemp = highestTemp
                returnArray.append(midDayReport)
            }
        }

        return returnArray
    }
    
    static func convertStateToAbbr(stateName: String) -> String {
        switch stateName {
        case "Alabama":
            return "AL"
        case "Alaska":
            return "AK"
        case "Arizona":
            return "AZ"
        case "Arkansas":
            return "AR"
        case "California":
            return "CA"
        case "Colorado":
            return "CO"
        case "Connecticut":
            return "CT"
        case "Delaware":
            return "DE"
        case "District of Columbia":
            return "DC"
        case "Florida":
            return "FL"
        case "Georgia":
            return "GA"
        case "Hawaii":
            return "HI"
        case "Idaho":
            return "ID"
        case "Illinois":
            return "IL"
        case "Indiana":
            return "IN"
        case "Iowa":
            return "IA"
        case "Kansas":
            return "KS"
        case "Kentucky":
            return "KY"
        case "Louisiana":
            return "LA"
        case "Maine":
            return "ME"
        case "Maryland":
            return "MD"
        case "Massachusetts":
            return "MA"
        case "Michigan":
            return "MI"
        case "Minnesota":
            return "MN"
        case "Mississippi":
            return "MS"
        case "Missouri":
            return "MO"
        case "Montana":
            return "MT"
        case "Nebraska":
            return "NE"
        case "Nevada":
            return "NV"
        case "New Hampshire":
            return "NH"
        case "New Jersey":
            return "NJ"
        case "New Mexico":
            return "NM"
        case "New York":
            return "NY"
        case "North Carolina":
            return "NC"
        case "North Dakota":
            return "ND"
        case "Ohio":
            return "OH"
        case "Oklahoma":
            return "OK"
        case "Oregon":
            return "OR"
        case "Pennsylvania":
            return "PA"
        case "Rhode Island":
            return "RI"
        case "South Carolina":
            return "SC"
        case "South Dakota":
            return "SD"
        case "Tennessee":
            return "TN"
        case "Texas":
            return "TX"
        case "Utah":
            return "UT"
        case "Vermont":
            return "VT"
        case "Virginia":
            return "VA"
        case "Washington":
            return "WA"
        case "West Virginia":
            return "WV"
        case "Wisconsin":
            return "WI"
        case "Wyoming":
            return "WY"
        default:
            return ""
        }
    }
    
    static func styleTextField(_ textfield: UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    static func styleFilledButton(_ button: UIButton) {
        
        // Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton(_ button: UIButton) {
        
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
    }
    
    static func isPasswordValid(_ password: String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
}

