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
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        listenForCurrentWeatherUpdate()
        updateUI()
    }
}

// MARK: - IBActions & Objc Functions
extension CurrentWeatherViewController {
    
    @IBAction func userButtonTapped(_ sender: Any) {
        // Check current user, if user doesn't exist, navigate to log in / sign up
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
    func updateUI() {
        guard let unwrappedWeatherReport = weatherReport else {
            print("weather report is nil. there was an error with the API or parsing the JSON")
            return
        }
        
        view.backgroundColor = backgroundColor
        currentTempLabel.textColor = temperatureTextColor
        
        weatherImageView.image = WeatherImages.getImage(weatherDescription: unwrappedWeatherReport.description, isDaytime: isDaytime)
        
        // handle these errors later
        currentTempLabel.text = "\(unwrappedWeatherReport.temperature.current)º"
        var uppercasedLocation = "\(unwrappedWeatherReport.location.uppercased())"

        if let state = unwrappedWeatherReport.state {
            uppercasedLocation = "\(unwrappedWeatherReport.location.uppercased()), \(state)"
        }
        
        locationLabel.text = uppercasedLocation
        locationLabel.addCharacterSpacing(2)
        locationLabel.textColor = locationTextColor
        
        descriptionLabel.textColor = descriptionTextColor
        
        let capitalizedDescription = unwrappedWeatherReport.description.capitalized

        let description = "\(capitalizedDescription),\n\(unwrappedWeatherReport.humidity!)% humidity. Feels like \(weatherReport!.temperature.feelsLike)º"
        
        let range1 = (description as NSString).range(of: "\(unwrappedWeatherReport.temperature.feelsLike)º")
        let range2 = (description as NSString).range(of: "\(unwrappedWeatherReport.humidity!)%")
        let range3 = (description as NSString).range(of: capitalizedDescription)

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
}

// MARK: - Setup RxSwift Listeners
extension CurrentWeatherViewController {
    func listenForCurrentWeatherUpdate() {
        WeatherReportData.currentForecast.asObservable()
            .subscribe(onNext: { weatherReport in
                
                guard let weatherReport = weatherReport else { return }
                print("current weather report accepted: \(weatherReport.temperature.current)")
                self.weatherReport = weatherReport
                
                DispatchQueue.main.async {
                    self.updateUI()
                }
            }).disposed(by: disposeBag)
    }
}

