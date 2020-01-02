//
//  AutocompleteSearchManager.swift
//  Umbrella Today?
//
//  Created by Brandon Fong on 12/29/19.
//  Copyright © 2019 Fiesta Togo Inc. All rights reserved.
//

import Foundation

class AutocompleteSearchManager {
    
    /// Accesses JSON file of city objects to complete city autocomplete search.
    ///
    /// - Parameters:
    ///     - input: String of input for autocomplete search
    ///     - maxNumberOfResults: The maximum number of results desired to be returned
    /// - Returns: An array of cities
    ///
    /// Calls on findLetterCheckPointAndSetRange(), which segments the json array of cities into sections based on first letter.
    /// Then, calls getAutoCompleteCities() , which runs a binary search to find the first element that satisfies the autocomplete input within the range.
    ///
    /// (Ex: executes binary search within range of "L" for city names matching "Lon", then returns the amount specified by maxNumerOfResults)
    static func searchForCities(input: String, maxNumberOfResults: Int, completion: @escaping((_ cities: [City]) -> Void)) {
        let capitalizedCityName = input.capitalized
        let cityNameCharacters = Array(capitalizedCityName)

        if let path = Bundle.main.url(forResource: "cities.us.fromAPI", withExtension: "json") {
            do {
                let data = try Data(contentsOf: path)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: [])
                
                guard let jsonArray = jsonResult as? [Any] else {
                    print("Data of file could not be made casted into an array")
                    return
                }
                
                var range = Range(leftIndex: 0, rightIndex: jsonArray.count)

                setRange(cityNameCharacters: cityNameCharacters, range: &range)
//                print("range ---- leftIndex:", range.leftIndex)
//                print("range ---- rightIndex:", range.rightIndex)
                
                let cities = getAutocompleteCities(jsonArray: jsonArray, range: range, input: cityNameCharacters, maxNumberOfResults: maxNumberOfResults)
//                cities.forEach { (city) in
//                    print(city.name)
//                }
                completion(cities)
                
            } catch {
               // handle error
                print("Error accessing JSON file")
                return
            }
        }
        return
    }
    
    /// Finds first alphanumeric city name within JSON file, and returns an array of cities that match.
    ///
    /// - Parameters:
    ///     - jsonArray: Array of JSON data with city objects.
    ///     - range: Object of type Range, with a left index and a right index, to be searched.
    ///     - input: Input of the user for autocomplete search.
    ///     - maxNumberOfResults: The maximum number or cities to return.
    /// - Returns: An array of cities with the desired quantity.
    static func getAutocompleteCities(jsonArray: [Any], range: Range, input: [Character], maxNumberOfResults: Int) -> [City] {
        
        var cities = [City]()
        
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
        
        guard let cityId = cityObject["id"] as? Int else {
            print("city id not found")
            return []
        }
        
        if let stateName = cityObject["state"] as? String {
            let firstMatchedCity = City(name: cityName, state: stateName, country: countryName, id: cityId)
            cities.append(firstMatchedCity)
        } else {
            let firstMatchedCity = City(name: cityName, country: countryName, id: cityId)
            cities.append(firstMatchedCity)
        }
        
        for i in 1...(maxNumberOfResults - 1) {
            guard let cityObject = jsonArray[firstMatchIndex + i] as? [String: Any] else {
                // i think return empty if the middle element doesn't exist, or isn't a dictionary?
                return cities
            }
            guard let cityName = cityObject["name"] as? String else {
                return cities
            }
            
            let cityNameChars = Array(cityName)
            
            if cityNameChars.count >= input.count && Array(cityNameChars[0...input.count - 1]) == input {
                guard let countryName = cityObject["country"] as? String else {
                    return cities
                }
                
                guard let cityId = cityObject["id"] as? Int else {
                    return cities
                }
                
                if let stateName = cityObject["state"] as? String {
                    let thisCity = City(name: cityName, state: stateName, country: countryName, id: cityId)
                    cities.append(thisCity)

                } else {
                    let thisCity = City(name: cityName, country: countryName, id: cityId)
                    cities.append(thisCity)
                }
            }
        }
        
        return cities
    }
    
    /// Uses modified binary search to find first index of a city name that matches the user's input.
    ///
    /// - Parameters:
    ///     - jsonArray: An array of JSON city objects.
    ///     - range: Object of type Range, with a left index and a right index, to be searched.
    ///     - input: Input of the user for autocomplete search.
    /// - Returns: An optional Int of the index of the first matching city.
    ///
    /// Uses binary search to find a city name that matches the user's input.
    ///
    /// Ex: Input: "Man" --- "Manhattan", "Manhasset", "Mandalorian", etc.
    ///
    /// Once an element is found that matches the requirements, the binary search will jump left, until there are only two indexes left, of which one is the starting index of the pattern.
    ///
    /// One optimization is that if the middle object chosen matches exactly with the user's input, (ex. "Man" and "Man"), then it will check the indexes before it to see if there are any other cities with the same name which would come first, then it would return that index.
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
                return nil
            }
            guard let middlePointCityName = middleObject["name"] as? String else {
                return nil
            }
            
            let midPointCityCharacters = Array(middlePointCityName)
            
            if midPointCityCharacters.count >= input.count && Array(midPointCityCharacters[0...input.count - 1]) == input {
                // There is a match
                
                // Optimization: check if it is an exact match
                if midPointCityCharacters.count == input.count {
                    print("there's an exact match at index: \(middleIndex). City: \(middlePointCityName)")
                    // Move left to see if leftward city names are exactly the same as well. Returns first same city name.
                    
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
                
                print("found a city that satisfies the autocorrect of \(String(input)). it is: \(middlePointCityName) at index: \(middleIndex), moving LEFT")
      
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
        
        // the answer could be the final Index OR final index + 1, so we need to check that here.
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
                
        if cityNameCharacters.count >= input.count && Array(cityNameCharacters[0...input.count - 1]) == input {
            print("returning index: \(index), city: \(cityName)")
            return index
        } else if secondCityNameCharacters.count >= input.count && Array(secondCityNameCharacters[0...input.count - 1]) == input {
            print("returning index: \(index + 1), city: \(secondCityName)")
            return index + 1
        } else {
            // overlay label on top of table view that says no results found.
            print("no results found")
            return nil
        }
    }
    
    /// Sets range for city name to be searched upon. The JSON file of cities is segmented into sections each beginning with a letter. This method finds the corresponding section based on the first letter of the input.
    ///
    /// - Parameters:
    ///     - cityNameCharacters: An array of characters for the input the user typed in to be searched for.
    ///     - range: An inout property for the range to be searched on.
    /// - Returns: Void
    static func setRange(cityNameCharacters: [Character], range: inout Range) {
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
