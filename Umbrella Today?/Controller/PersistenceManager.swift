//
//  PersistenceManager.swift
//  Umbrella Today?
//
//  Created by Brandon Fong on 1/1/20.
//  Copyright © 2020 Fiesta Togo Inc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PersistenceManager {
    
    static let disposeBag = DisposeBag()
    
    static var savedWeatherReportsDataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("SavedWeatherReports.plist")
    
    static var persistedWeatherReports = [WeatherReport]()

    static func persistWeatherReports(_ weatherReports: [WeatherReport]) {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(weatherReports)
            try data.write(to: self.savedWeatherReportsDataFilePath!)
            print("Succeeded persisting \(weatherReports.count) item(s)")
        } catch {
            print("Weather reports couldn't be encoded. Error: \(error)")
        }
    }
    
    static func loadWeatherReports() -> [WeatherReport] {
        var returnArray = [WeatherReport]()
        
        guard let data = try? Data(contentsOf: self.savedWeatherReportsDataFilePath!) else { return returnArray }
        
        let decoder = PropertyListDecoder()
        do {
            returnArray = try decoder.decode([WeatherReport].self, from: data)
        } catch {
            print("Error: \(error)")
        }
        
        print("loaded \(returnArray.count) item(s)")
        
        return returnArray
    }
}
