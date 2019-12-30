//
//  UIColor+Extensions.swift
//  Umbrella Today?
//
//  Created by Brandon Fong on 12/29/19.
//  Copyright © 2019 Fiesta Togo Inc. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func dayBackground() -> UIColor {
        return UIColor(red: 254/255, green: 247/255, blue: 225/255, alpha: 1.0)
    }
    
    static func nightBackground() -> UIColor {
        return UIColor(red: 53/255, green: 56/255, blue: 68/255, alpha: 1.0)
    }
    
    static func dayTemperatureText() -> UIColor {
        return UIColor(red: 251/255, green: 182/255, blue: 173/255, alpha: 1.0)
    }
    
    static func nightTemperatureText() -> UIColor {
        return UIColor(red: 232/255, green: 223/255, blue: 190/255, alpha: 1.0)
    }
    
    static func dayLocationText() -> UIColor {
        return UIColor(red: 177/255, green: 177/255, blue: 177/255, alpha: 1.0)
    }
    
    static func nightLocationText() -> UIColor {
        return UIColor(red: 114/255, green: 114/255, blue: 114/255, alpha: 1.0)
    }
    
    static func dayDetailText() -> UIColor {
        return UIColor(red: 82/255, green: 82/255, blue: 82/255, alpha: 1.0)
    }
    
    static func nightDetailText() -> UIColor {
        return UIColor(red: 151/255, green: 160/255, blue: 165/255, alpha: 1.0)
    }
    
    static func dayDetailTextHighlights() -> UIColor {
        return UIColor(red: 252/255, green: 110/255, blue: 97/255, alpha: 1.0)
    }
    
    static func nightDetailTextHighlights() -> UIColor {
        return UIColor(red: 224/255, green: 201/255, blue: 160/255, alpha: 1.0)
    }
    
}
