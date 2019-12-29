//
//  AutocompleteSearchManager.swift
//  Umbrella Today?
//
//  Created by Brandon Fong on 12/29/19.
//  Copyright © 2019 Fiesta Togo Inc. All rights reserved.
//

import Foundation

class AutocompleteSearchManager {
    static func searchForCityID(cityName: String) {
        let capitalizedCityName = cityName.capitalized
        let cityNameCharacters = Array(capitalizedCityName)

        if let path = Bundle.main.url(forResource: "city.list.sorted", withExtension: "json") {
            do {
                let data = try Data(contentsOf: path)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: [])
                
                guard let jsonArray = jsonResult as? [Any] else {
                    print("Data of file could not be made casted into an array")
                    return
                }
                
                var range = Range(leftIndex: 0, rightIndex: jsonArray.count)

                findLetterCheckPointAndSetRange(cityNameCharacters: cityNameCharacters, range: &range)
                print("range ---- leftIndex:", range.leftIndex)
                print("range ---- rightIndex:", range.rightIndex)
                
                let cities = getAutocompleteCities(jsonArray: jsonArray, range: range, input: cityNameCharacters)
                cities.forEach { (city) in
                    print(city.name)
                }
                
            } catch {
               // handle error
                print("caught error")
            }
        }
    }
    
    static func getAutocompleteCities(jsonArray: [Any], range: Range, input: [Character]) -> [City] {
        // it is a modified binary search
        
        var cities = [City]()
        // goal is to use binary search to search within the range for first appearance of city name matching what the user has typed
        // ex: man == manhattan, manhasset, mandalorian, etc.
        // we want to display at max 10 results.
        
        // maybe what we can do is do binary search until we find something that satisfies
        // then move left until we find what doesn't. using what we have cached (the places we've already looked on the left)
        // then, if we haven't hit our max of 10, we can also move rightwards too
        
        guard let firstMatchIndex = findFirstMatchIndex(jsonArray: jsonArray, range: range, input: input) else {
            return []
        }
        
        guard let cityObject = jsonArray[firstMatchIndex] as? [String: Any] else {
            // i think return empty if the middle element doesn't exist, or isn't a dictionary?
            return []
        }
        guard let cityName = cityObject["name"] as? String else {
            return []
        }
        
        guard let countryName = cityObject["country"] as? String else {
            return []
        }
        
        let firstMatchedCity = City(name: cityName, country: countryName)
        cities.append(firstMatchedCity)
        
        for i in 1...9 {
            guard let cityObject = jsonArray[firstMatchIndex + i] as? [String: Any] else {
                // i think return empty if the middle element doesn't exist, or isn't a dictionary?
                return cities
            }
            guard let cityName = cityObject["name"] as? String else {
                return cities
            }
            
            let cityNameChars = Array(cityName)
            
            if Array(cityNameChars[0...input.count - 1]) == input {
                guard let countryName = cityObject["country"] as? String else {
                    return cities
                }
                
                let thisCity = City(name: cityName, country: countryName)
                cities.append(thisCity)
            }
        }
        
        return cities
    }
}
