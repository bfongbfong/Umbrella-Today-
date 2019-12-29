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
