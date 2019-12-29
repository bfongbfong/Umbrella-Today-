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
    
    static func findFirstMatchIndex(jsonArray: [Any], range: Range, input: [Character]) -> Int? {
        if jsonArray.count == 0 {
            return nil
        }
                
        var leftIndex = range.leftIndex
        var rightIndex = range.rightIndex
        var finalIndex: Int? = nil
        
        while leftIndex <= rightIndex {
            let middleIndex = (rightIndex + leftIndex) / 2
            finalIndex = middleIndex
            guard let middleObject = jsonArray[middleIndex] as? [String: Any] else {
                // i think return empty if the middle element doesn't exist, or isn't a dictionary?
                return nil
            }
            guard let middlePointCityName = middleObject["name"] as? String else {
                return nil
            }
            
            let midPointCityCharacters = Array(middlePointCityName)
            
            if midPointCityCharacters.count >= input.count && Array(midPointCityCharacters[0...input.count - 1]) == input {
                // i've found something that satisfies
                
                // Optimization: check if it is an exact match
                if midPointCityCharacters.count == input.count {
                    print("there's an exact match at index: \(middleIndex). City: \(middlePointCityName)")
                    // move left until it is not. (just to check)
                    
                    var index = middleIndex
                    while index - 1 >= 0 {
                        if let object = jsonArray[index - 1] as? [String: Any] {
                            if let cityName = object["name"] as? String {
                                if cityName == middlePointCityName {
//                                    print("the city name \(cityName), to the left at \(index - 1) is the same.")
                                    index -= 1
                                } else {
                                    print("the city name to the left: \(cityName), is not the same, so I'm returning \(index)")
                                    return index
                                }
                            }
                        }
                    }
                }
                
                // middleIndex is where something satisfies
                print("found a city that satisfies the autocorrect of \(String(input)). it is: \(middlePointCityName) at index: \(middleIndex), moving LEFT")
                // now move left until we find the point where it stops satisfying
      
                rightIndex = middleIndex - 1
            }

            else if String(input) > middlePointCityName {
                // target is too big, check right side
//                print("city of \(middlePointCityName) comes before \(String(input)) at index: \(middleIndex), moving RIGHT")
                leftIndex = middleIndex + 1
            }

            else {
                // target is too small, check left side
//                print("city of \(middlePointCityName) comes after \(String(input)) at index: \(middleIndex), moving LEFT")
                rightIndex = middleIndex - 1
            }
        }
        
        guard let index = finalIndex else {
            return nil
        }
        
        // the answer could be the final Index OR final index + 1
        guard let cityObject = jsonArray[index] as? [String: Any] else {
            // i think return empty if the middle element doesn't exist, or isn't a dictionary?
            return nil
        }
        guard let cityName = cityObject["name"] as? String else {
            return nil
        }
        
        let cityNameCharacters = Array(cityName)
        
        guard let secondCityObject = jsonArray[index + 1] as? [String: Any] else {
            // i think return empty if the middle element doesn't exist, or isn't a dictionary?
            return nil
        }
        guard let secondCityName = secondCityObject["name"] as? String else {
            return nil
        }
        
        let secondCityNameCharacters = Array(secondCityName)
        
        if Array(cityNameCharacters[0...input.count - 1]) == input {
            print("returning index: \(index), city: \(cityName)")
            return index
        } else if Array(secondCityNameCharacters[0...input.count - 1]) == input {
            print("returning index: \(index + 1), city: \(secondCityName)")
            return index + 1
        } else {
            print("no result found")
            return nil
        }
    }
    
    static func findLetterCheckPointAndSetRange(cityNameCharacters: [Character], range: inout Range) {
        switch cityNameCharacters[0] {
        case "A":
            range = CityListCheckPoints.letterA
        case "B":
            range = CityListCheckPoints.letterB
        case "C":
            range = CityListCheckPoints.letterC
        case "D":
            range = CityListCheckPoints.letterD
        case "E":
            range = CityListCheckPoints.letterE
        case "F":
            range = CityListCheckPoints.letterF
        case "G":
            range = CityListCheckPoints.letterG
        case "H":
            range = CityListCheckPoints.letterH
        case "I":
            range = CityListCheckPoints.letterI
        case "J":
            range = CityListCheckPoints.letterJ
        case "K":
            range = CityListCheckPoints.letterK
        case "L":
            range = CityListCheckPoints.letterL
        case "M":
            range = CityListCheckPoints.letterM
        case "N":
            range = CityListCheckPoints.letterN
        case "O":
            range = CityListCheckPoints.letterO
        case "P":
            range = CityListCheckPoints.letterP
        case "Q":
            range = CityListCheckPoints.letterQ
        case "R":
            range = CityListCheckPoints.letterR
        case "S":
            range = CityListCheckPoints.letterS
        case "T":
            range = CityListCheckPoints.letterT
        case "U":
            range = CityListCheckPoints.letterU
        case "V":
            range = CityListCheckPoints.letterV
        case "W":
            range = CityListCheckPoints.letterW
        case "X":
            range = CityListCheckPoints.letterX
        case "Y":
            range = CityListCheckPoints.letterY
        case "Z":
            range = CityListCheckPoints.letterZ
        default:
            range = CityListCheckPoints.beforeA
        }
    }
    
    
}
