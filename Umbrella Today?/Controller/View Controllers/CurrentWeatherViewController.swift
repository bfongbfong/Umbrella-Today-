//
//  CurrentWeatherViewController.swift
//  Umbrella Today?
//
//  Created by Brandon Fong on 12/27/19.
//  Copyright © 2019 Fiesta Togo Inc. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import RxSwift
import RxCocoa
import FirebaseAuth

class CurrentWeatherViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var buttonToSavedLocations: UIButton!

    // MARK: - Properties
    var weatherReport: WeatherReport?
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var isDaytime = false {
        didSet {
            if isDaytime {
                backgroundColor = UIColor.dayBackground()
                temperatureTextColor = UIColor.dayTemperatureText()
                locationTextColor = UIColor.dayLocationText()
                descriptionTextColor = UIColor.dayDetailText()
                detailTextHighlightsColor = UIColor.dayDetailTextHighlights()
            } else {
                backgroundColor = UIColor.nightBackground()
                temperatureTextColor = UIColor.nightTemperatureText()
                locationTextColor = UIColor.nightLocationText()
                descriptionTextColor = UIColor.nightDetailText()
                detailTextHighlightsColor = UIColor.nightDetailTextHighlights()
            }
        }
    }
    
    // Changing weather conditions
    var backgroundColor: UIColor!
    var temperatureTextColor: UIColor!
    var locationTextColor: UIColor!
    var descriptionTextColor: UIColor!
    var detailTextHighlightsColor: UIColor!
    
    var weatherImage: UIImage!
    
    var loadingView = UIView()
    
    let disposeBag = DisposeBag()
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listenForCurrentWeatherUpdate()
        weatherImage = WeatherImages.rain
        
//        addWhiteLayer()
//        checkLocationServices()
        updateUI()
    }
    
    // Navigate to User auth or User info
    @IBAction func userButtonTapped(_ sender: Any) {
        if let user = FirebaseManager.currentUser {
            print(user)
            // there's a user
            if let userInfoVC = storyboard!.instantiateViewController(identifier: "UserInfoViewController") as? UserInfoViewController {
                
                if let name = user.displayName {
                    print("display name exists")
                    userInfoVC.nameOfUser = name
                } else if let email = user.email {
                    userInfoVC.nameOfUser = email
                }
                
                present(userInfoVC, animated: true, completion: nil)
            }
        } else {
            // there's no user
            if let authenticationNavController = storyboard!.instantiateViewController(identifier: "AuthenticationNavigationController") as? UINavigationController {
                present(authenticationNavController, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - UI Functions
extension CurrentWeatherViewController {
    
    func addWhiteLayer() {
        loadingView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        loadingView.backgroundColor = .white
        view.addSubview(loadingView)
        view.bringSubviewToFront(loadingView)
    }
    
    func whiteFadeAwayAnimation() {
        UIView.animate(withDuration: 0.5, animations: {
            self.loadingView.alpha = 0
        }) { (_) in
            self.loadingView.removeFromSuperview()
        }
    }
    
    func updateUI() {
        if weatherReport == nil {
            print("weather report is nil. there was an error with the API or parsing the JSON")
            return
        }
        
        view.backgroundColor = backgroundColor
        currentTempLabel.textColor = temperatureTextColor
        
        weatherImageView.image = weatherImage
        
        // handle these errors later
        currentTempLabel.text = "\(weatherReport?.temperature.current ?? 0)º"
        var uppercasedLocation = "\(weatherReport!.location.uppercased())"

        if let state = weatherReport!.state {
            uppercasedLocation = "\(weatherReport!.location.uppercased()), \(state)"
        }
        
        locationLabel.text = uppercasedLocation
        locationLabel.addCharacterSpacing(2)
        locationLabel.textColor = locationTextColor
        
        descriptionLabel.textColor = descriptionTextColor
        
        let capitalizedDescription = weatherReport?.description.capitalized

        let description = "\(capitalizedDescription!),\n\(weatherReport!.humidity!)% humidity. Feels like \(weatherReport!.temperature.feelsLike)º"
        
        let range1 = (description as NSString).range(of: "\(weatherReport!.temperature.feelsLike)º")
        let range2 = (description as NSString).range(of: "\(weatherReport!.humidity!)%")
        let range3 = (description as NSString).range(of: capitalizedDescription!)

        let attributedText = NSMutableAttributedString.init(string: description)
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: detailTextHighlightsColor!, range: range1)
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: detailTextHighlightsColor!, range: range2)
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: detailTextHighlightsColor!, range: range3)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        paragraphStyle.alignment = .center
        attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))

        descriptionLabel.attributedText = attributedText
        
        buttonToSavedLocations.tintColor = temperatureTextColor
    }
    
    func showErrorAlert() {
        // to be called if weather report is ever nil
        
    }
}

// MARK: - Setup RxSwift Listeners
extension CurrentWeatherViewController {
    func listenForCurrentWeatherUpdate() {
        WeatherReportData.currentForecast.asObservable()
            .subscribe(onNext: { weatherReport in
                
                guard let weatherReport = weatherReport else { return }
                print("current weather report accepted: \(weatherReport.temperature.current)")
                self.weatherReport = weatherReport
                
//                let currentReportSimple = self.weatherReport!.convertIntoSimpleWeatherReportForFirstHourlyResult()
                
                DispatchQueue.main.async {
                    self.updateUI()
                }
            }).disposed(by: disposeBag)
    }
}

// MARK: - CLLocation Manager
extension CurrentWeatherViewController {
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
//            populateWeatherReportData()
        }
    }
}


// MARK: - CLLocation Manager Delegate
extension CurrentWeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        getLocation()
    }
}

// MARK: - Logic Functions
extension CurrentWeatherViewController {
    
    func checkSunlight() {
        let now = Int(NSDate().timeIntervalSince1970)
//        print("right now is \(now) in epoch time")
        
        if weatherReport != nil {
            if weatherReport!.sunriseTime != nil {
//                print("sunrise time: \(weatherReport!.sunriseTime!)")
            }
        }
        if weatherReport != nil {
            if weatherReport!.sunsetTime != nil {
//                print("sunset time: \(weatherReport!.sunsetTime!)")
                if now > weatherReport!.sunsetTime! {
                    // it's night time.
                    isDaytime = false
                } else {
                    // it's daytime.
                    isDaytime = true
                }
            }
        }
    }
    
    func populateWeatherReportData() {
        
        guard currentLocation != nil else { return }
        
        OpenWeatherManager.getCurrentWeatherData(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude) { (jsonWeatherObject) in

            if let responseJson = jsonWeatherObject {
                self.weatherReport = JsonParser.parseJsonCurrentWeatherObject(jsonObject: responseJson)
                
                DispatchQueue.main.async {
                    self.updateUI()
                    
                }
            }
        }
        
//        OpenWeatherManager.getCurrentWeatherData(cityID: hurzufID) { (jsonWeatherObject) in
//            if let responseJson = jsonWeatherObject {
//                DispatchQueue.main.async {
//
//                    self.weatherReport = JsonParser.parseJsonCurrentWeatherObject(jsonObject: responseJson)
//                    self.updateUI()
//                }
//            }
//        }
//
    
        
//        AutocompleteSearchManager.searchForCities(cityName: "dog", maxNumberOfResults: 10)
    }
}


// MARK: - Navigation
extension CurrentWeatherViewController {
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ToSavedLocationsViewController" {
//            if let savedLocationsViewController = segue.destination as? SavedLocationsViewController {
//                savedLocationsViewController.savedLocationsWeatherReports.append(self.weatherReport!)
//            }
//        }
//    }
}

