//
//  ViewController.swift
//  Umbrella Today?
//
//  Created by Brandon Fong on 12/27/19.
//  Copyright © 2019 Fiesta Togo Inc. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

//    let url =
    let apikey = "8cf99fbd36fd589f46f2813475533328"
    let homeLat = "40.920295"
    let homeLon = "-74.530521"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        runAPI()
    }
    
    func runAPI() {
//        http://maps.openweathermap.org/maps/2.0/weather/{op}/{z}/{x}/{y}
        
//        AF.request("http://maps.openweathermap.org/maps/2.0/weather/TA2/0/0/0?appid=8cf99fbd36fd589f46f2813475533328")
        AF.request("http://api.openweathermap.org/data/2.5/weather?lat=\(homeLat)&lon=\(homeLon)&APIKEY=\(apikey)").responseJSON(completionHandler: { (response) in
            
//            print(response)
//            print(response.data)
            print(response.value!)
//            print(response.result)
            
            if let json = response.value as? [String: Any] {
                if let base = json["base"] as? String {
                    print("base:", base)
                }
            }
        })

    }
    
    func convertKelvinToFarenheit(kelvinNumber: Double) -> Int {
        return Int( ( ( ( kelvinNumber - 273.15 ) * 9 ) / 5 ) + 32 )
    }


}

