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
}
