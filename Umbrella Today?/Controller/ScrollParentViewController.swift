//
//  ScrollParentViewController.swift
//  Umbrella Today?
//
//  Created by Brandon Fong on 12/30/19.
//  Copyright © 2019 Fiesta Togo Inc. All rights reserved.
//

import UIKit
import CoreLocation

class ScrollParentViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!

    var pages = [CurrentWeatherViewController]()
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var currentWeatherReport: WeatherReport!
    
    var loadingView = UIView()
    
    var isDaytime = false {
        didSet {
            if isDaytime {
                view.backgroundColor = UIColor.dayBackground()
            } else {
                view.backgroundColor = UIColor.nightBackground()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addWhiteLayer()
        checkLocationServices()
    }
    
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
    
    func setupPages() {
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        let page1 = setupCurrentWeatherVC()
        whiteFadeAwayAnimation()
        let page2 = setupHourlyForecastVC()
        let page3 = setupFiveDayForecastVC()
        
        let views: [String: UIView] = ["view": view, "page1": page1.view, "page2": page2.view, "page3": page3.view]
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[page1(==view)]", options: [], metrics: nil, views: views)
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[page1(==view)][page2(==view)][page3(==view)]|", options: [.alignAllTop, .alignAllBottom], metrics: nil, views: views)
        NSLayoutConstraint.activate(verticalConstraints + horizontalConstraints)
    }
    
    private func setupCurrentWeatherVC() -> UIViewController {
        let page = storyboard!.instantiateViewController(identifier: "CurrentWeatherViewController") as! CurrentWeatherViewController
        
        page.weatherReport = currentWeatherReport
        page.isDaytime = isDaytime

        page.view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(page.view)
        addChild(page)
        page.didMove(toParent: self)
        return page
    }
    
    private func setupFiveDayForecastVC() -> UIViewController {
        let page = storyboard!.instantiateViewController(identifier: "FiveDayForecastViewController") as! FiveDayForecastViewController

        page.isDaytime = isDaytime

        page.view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(page.view)
        addChild(page)
        page.didMove(toParent: self)
        return page
    }
    
    private func setupHourlyForecastVC() -> UIViewController {
        let page = storyboard!.instantiateViewController(identifier: "HourlyForecastViewController") as! HourlyForecastViewController

        page.isDaytime = isDaytime

        page.view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(page.view)
        addChild(page)
        page.didMove(toParent: self)
        return page
    }
    
    
}

// MARK: - CLLocation Manager
extension ScrollParentViewController {
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
            apiCall()
        }
    }
}


// MARK: - CLLocation Manager Delegate
extension ScrollParentViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        getLocation()
    }
}


extension ScrollParentViewController {
    func apiCall() {
        guard currentLocation != nil else { return }
        
        OpenWeatherManager.getCurrentWeatherData(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude) { (jsonWeatherObject) in

            if let responseJson = jsonWeatherObject {
                DispatchQueue.main.async {

                    self.currentWeatherReport = JsonParser.parseJsonCurrentWeatherObject(jsonObject: responseJson)
                    self.checkSunlight()
                    self.setupPages()
                    WeatherReportData.currentForecast.accept(self.currentWeatherReport)
                }
            }
        }
        
        OpenWeatherManager.getFiveDayForecast(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude) { (jsonWeatherObject) in
            
            if let responseJson = jsonWeatherObject {
                DispatchQueue.main.async {

                    let arrayOfSimpleWeatherReports = JsonParser.parseJsonFiveDayWeatherObjects(jsonObject: responseJson)
                    let fiveDayReports = Helpers.findFiveDayReport(simpleWeatherReports: arrayOfSimpleWeatherReports)
                    WeatherReportData.fiveDayForecast.accept(fiveDayReports)
                    WeatherReportData.hourlyForecast.accept(arrayOfSimpleWeatherReports)
//                    for report in fiveDayReports {
//                        print("\(report.dayOfWeek) - \(report.time) - \(report.currentTemp)º")
//                    }
                }
            }
        }
    }
}

extension ScrollParentViewController {
    
    func checkSunlight() {
        let now = Int(NSDate().timeIntervalSince1970)
        print("right now is \(now) in epoch time")
        
        if currentWeatherReport != nil {
            if currentWeatherReport!.sunriseTime != nil {
                print("sunrise time: \(currentWeatherReport!.sunriseTime!)")
            }
        }
        if currentWeatherReport != nil {
            if currentWeatherReport!.sunsetTime != nil {
                print("sunset time: \(currentWeatherReport!.sunsetTime!)")
                if now > currentWeatherReport!.sunsetTime! {
                    // it's night time.
                    isDaytime = false
                } else {
                    if currentWeatherReport != nil {
                        if currentWeatherReport!.sunriseTime != nil {
                            if now > currentWeatherReport!.sunriseTime! {
                                // it's daytime
                                isDaytime = true
                            } else {
                                // it's early morning and still dark
                                isDaytime = false
                            }
                        }
                    }
                }
            }
            
            // for testing
//            isDaytime = true
        }
    }
}

