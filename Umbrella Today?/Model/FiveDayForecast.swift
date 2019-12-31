//
//  FiveDayForecast.swift
//  Umbrella Today?
//
//  Created by Brandon Fong on 12/31/19.
//  Copyright © 2019 Fiesta Togo Inc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class FiveDayForecast {
    static var simpleWeatherReports = BehaviorRelay<[SimpleWeatherReport]>(value: [])
}
