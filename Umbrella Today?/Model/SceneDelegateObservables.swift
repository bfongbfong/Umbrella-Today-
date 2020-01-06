//
//  SceneDelegateObservables.swift
//  Umbrella Today?
//
//  Created by Brandon Fong on 1/5/20.
//  Copyright © 2020 Fiesta Togo Inc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SceneDelegateObservables {
    static var sceneDidBecomeActive = BehaviorRelay<Bool>(value: true)
}
