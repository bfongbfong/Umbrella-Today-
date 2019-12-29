//
//  HomeViewController.swift
//  Umbrella Today?
//
//  Created by Brandon Fong on 12/27/19.
//  Copyright © 2019 Fiesta Togo Inc. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class HomeViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!

    // MARK: - Properties
    var weatherReport: WeatherReport!
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
    }
}

// MARK: - UI Functions
extension HomeViewController {
    func updateUI() {
        if weatherReport == nil {
            print("weather report is nil. there was an error with the API or parsing the JSON")
            return
        }
        
        currentTempLabel.text = String(weatherReport.temperature.current)
        minTempLabel.text = String(weatherReport.temperature.minimum)
        maxTempLabel.text = String(weatherReport.temperature.maximum)
        feelsLikeLabel.text = String(weatherReport.temperature.feelsLike)
        locationLabel.text = weatherReport.location
        descriptionLabel.text = weatherReport.description
    }
}

// MARK: - CLLocation Manager
extension HomeViewController {
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            // setup our location manager
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // show alert telling user they have to enable it.
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            // do map stuff
            getLocation()
            break
        case .authorizedAlways:
            // no need to ask
            getLocation()
            break
        case .denied:
            // alert user to go to settings to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            // alert user that they have been restricted
            break
        @unknown default:
            print("Error: Authorization status was unknown.")
            break
        }
    }
    
    func getLocation() {
        if (CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() ==  .authorizedAlways) {
              currentLocation = locationManager.location
            populateWeatherReportData()
        }
    }
}


// MARK: - CLLocation Manager Delegate
extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //
    }
}

// MARK: - Logic Functions
extension HomeViewController {
    
    func populateWeatherReportData() {
        
        guard currentLocation != nil else { return }
//        let hurzufID = 707860
        
        OpenWeatherManager.getCurrentWeatherData(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude) { (jsonWeatherObject) in

            if let responseJson = jsonWeatherObject {
                DispatchQueue.main.async {

                    self.weatherReport = JsonParser.parseJsonWeatherObject(jsonObject: responseJson)
                    self.updateUI()
                }
            }
        }
        
//        OpenWeatherManager.getCurrentWeatherData(cityID: hurzufID) { (jsonWeatherObject) in
//            if let responseJson = jsonWeatherObject {
//                DispatchQueue.main.async {
//
//                    self.weatherReport = JsonParser.parseJsonWeatherObject(jsonObject: responseJson)
//                    self.updateUI()
//                }
//            }
//        }
//
        
        AutocompleteSearchManager.searchForCities(cityName: "dongle")
    }
}

