//
//  WeatherReportData.swift
//  Umbrella Today?
//
//  Created by Brandon Fong on 12/31/19.
//  Copyright © 2019 Fiesta Togo Inc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class WeatherReportData {
    static var currentForecast = BehaviorRelay<WeatherReport?>(value: nil)
    static var fiveDayForecast = BehaviorRelay<[SimpleWeatherReport]>(value: [])
    static var hourlyForecast = BehaviorRelay<[SimpleWeatherReport]>(value: [])
    static var savedLocations = BehaviorRelay<[WeatherReport]>(value: [])
}
