//
//  ScrollParentViewController.swift
//  Umbrella Today?
//
//  Created by Brandon Fong on 12/30/19.
//  Copyright © 2019 Fiesta Togo Inc. All rights reserved.
//

import UIKit
import CoreLocation
import RxSwift
import RxCocoa

class ScrollParentViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!

    // MARK: - Properties
    var pages = [CurrentWeatherViewController]()
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var currentWeatherReport: WeatherReport!
    
    // For white layer
    var loadingView = UIView()
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    var isDaytime = false {
        didSet {
            if isDaytime {
                view.backgroundColor = UIColor.dayBackground()
            } else {
                view.backgroundColor = UIColor.nightBackground()
            }
        }
    }
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addWhiteLayer()
        listenForSceneBecomingActive()
    }
}

// MARK: - Setup
extension ScrollParentViewController {
    func listenForSceneBecomingActive() {
        SceneDelegateObservables.sceneDidBecomeActive.asObservable()
            .skip(1)
            .subscribe(onNext: { active in
                
                self.checkLocationServices()
                
            }).disposed(by: disposeBag)
    }
    
    // MARK: Setup Pages
    func setupPages() {
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        let page1 = setupCurrentWeatherVC()
        whiteFadeAwayAnimation()
        let page2 = setupHourlyForecastVC()
        let page3 = setupFiveDayForecastVC()
        
        NSLayoutConstraint(item: page1.view!, attribute: .top, relatedBy: .equal, toItem: self.scrollView, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: page1.view!, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 1.0, constant: 0).isActive = true

        NSLayoutConstraint(item: page1.view!, attribute: .left, relatedBy: .equal, toItem: self.scrollView, attribute: .left, multiplier: 1.0, constant: 0).isActive = true


        NSLayoutConstraint(item: page1.view!, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: page2.view!, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: page3.view!, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: 0).isActive = true
        
        NSLayoutConstraint(item: page1.view!, attribute: .right, relatedBy: .equal, toItem: page2.view!, attribute: .left, multiplier: 1.0, constant: 0).isActive = true
        
        NSLayoutConstraint(item: page2.view!, attribute: .right, relatedBy: .equal, toItem: page3.view!, attribute: .left, multiplier: 1.0, constant: 0).isActive = true

        NSLayoutConstraint(item: page3.view!, attribute: .right, relatedBy: .equal, toItem: self.scrollView, attribute: .right, multiplier: 1.0, constant: 0).isActive = true

        // align all top
        NSLayoutConstraint(item: page1.view!, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: page2.view!, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: page3.view!, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0).isActive = true

        // align all bottom
        NSLayoutConstraint(item: page1.view!, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: page2.view!, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: page3.view!, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        
//        let views: [String: UIView] = ["view": view, "page1": page1.view, "page2": page2.view, "page3": page3.view]
//        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[page1(==view)]", options: [], metrics: nil, views: views)
//        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[page1(==view)][page2(==view)][page3(==view)]|", options: [.alignAllTop, .alignAllBottom], metrics: nil, views: views)
//        NSLayoutConstraint.activate(verticalConstraints + horizontalConstraints)
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


// MARK: - UIFunctions
extension ScrollParentViewController {
    
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
    
    private func showAlert(title: String, message: String, navigateToSettings: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert) in
            if navigateToSettings {
                self.navigateToLocationServicesSettings()
            }
        }))
        self.present(alert, animated: true)
    }
}

// MARK: - CLLocation Manager & Location Services
extension ScrollParentViewController: CLLocationManagerDelegate {
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            // setup our location manager
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // show alert telling user they have to enable it.
            print("user has to enable location services")
            showAlert(title: "Location Services Not Enabled", message: "Please enable location services in your device's settings.", navigateToSettings: true)
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            // do map stuff
            getLocation()
        case .authorizedAlways:
            // no need to ask
            getLocation()
        case .denied:
            // alert user to go to settings to turn on permissions
            print("location services are denied")
            showAlert(title: "Location Permissions Denied", message: "Please enable location services in your device's settings.", navigateToSettings: true)
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // alert user that they have been restricted
            print("location services are restricted")
            showAlert(title: "Location Permissions Denied", message: "Location services have been restricted.", navigateToSettings: false)
        @unknown default:
            print("Error: Authorization status was unknown.")
            showAlert(title: "Unknown Error", message: "Please try restarting the app.", navigateToSettings: false)
        }
    }
    
    func getLocation() {
        if (CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() ==  .authorizedAlways) {
              currentLocation = locationManager.location
            fireApiCalls()
        }
    }
    
    func navigateToLocationServicesSettings() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        getLocation()
    }
}

// MARK: - API Calls
extension ScrollParentViewController {
    func fireApiCalls() {
        guard currentLocation != nil else {
            showAlert(title: "Unable to retrieve location.", message: "Please try restarting the app.", navigateToSettings: false)
            print("location was nil")
            return
        }
        
        let queue = OperationQueue()
        let group = DispatchGroup()

        let operation1 = BlockOperation {
            group.enter()
            OpenWeatherManager.getCurrentWeatherData(latitude: self.currentLocation.coordinate.latitude, longitude: self.currentLocation.coordinate.longitude) { (jsonWeatherObject) in

                if let responseJson = jsonWeatherObject {

                    self.currentWeatherReport = JsonParser.parseJsonCurrentWeatherObject(jsonObject: responseJson)
                    WeatherReportData.currentForecast.accept(self.currentWeatherReport)
                    
                    WeatherReport.currentLocation = self.currentWeatherReport
//                    print("operation 1 done")
                    group.leave()
                }
            }
            group.wait()
        }
        
        let operation2 = BlockOperation {
            group.enter()
            if let currentWeatherReport = WeatherReport.currentLocation {
                AutocompleteSearchManager.getExactMatchingCities(input: currentWeatherReport.location) { (arrayOfMatchingCities) in
                    
                    for city in arrayOfMatchingCities {
                        if city.id == currentWeatherReport.id {
                            if let state = city.state {
                                let stateAbbr = Helpers.convertStateToAbbr(stateName: state)
                                currentWeatherReport.state = stateAbbr
                            }
                        }
                    }
                    group.leave()
                }
            }
            group.wait()
        }
    
        let operation3 = BlockOperation {
            DispatchQueue.main.async {
//                print("operation 3 - main thread")
                self.checkSunlight()
                self.setupPages()
            }
        }
        
        let operation4 = BlockOperation {
            OpenWeatherManager.getFiveDayAndHourlyForecast(latitude: self.currentLocation.coordinate.latitude, longitude: self.currentLocation.coordinate.longitude) { (jsonWeatherObject) in
                
//                print("operation 4")
                if let responseJson = jsonWeatherObject {
                    DispatchQueue.main.async {
//                        print("operation 4 main thread")
                        
                        let arrayOfSimpleWeatherReports = JsonParser.parseJsonFiveDayWeatherObjects(jsonObject: responseJson, byCityId: false)
                        if arrayOfSimpleWeatherReports.count < 8 {
                            print("Error: API didn't send back enough forecasts.")
                            return
                        }
                        var arrayOfEightHourlyWeatherReports = Array(arrayOfSimpleWeatherReports[0...7])
                        let fiveDayReports = Helpers.findFiveDayReport(simpleWeatherReports: arrayOfSimpleWeatherReports)
                        
                        let currentWeatherSimple = self.currentWeatherReport.convertIntoSimpleWeatherReportForFirstHourlyResult()
                        arrayOfEightHourlyWeatherReports.insert(currentWeatherSimple, at: 0)
                        WeatherReportData.fiveDayForecast.accept(fiveDayReports)
                        WeatherReportData.hourlyForecast.accept(arrayOfEightHourlyWeatherReports)
                    }
                }
            }
        }
        
        operation3.addDependency(operation2)
        operation2.addDependency(operation1)
        operation4.addDependency(operation1)
        queue.addOperation(operation1)
        queue.addOperation(operation2)
        queue.addOperation(operation3)
        queue.addOperation(operation4)
    }
}


// MARK: - Logic Functions
extension ScrollParentViewController {
    // MARK: Check Sunlight
    func checkSunlight() {
        let now = NSDate().timeIntervalSince1970
        if currentWeatherReport != nil {
            if currentWeatherReport.sunriseTime != nil && currentWeatherReport.sunsetTime != nil {
                isDaytime = Helpers.checkIfIsDaytime(unixTimeStamp: now, sunriseTime: Double(currentWeatherReport.sunriseTime!), sunsetTime: Double(currentWeatherReport!.sunsetTime!))
            }
        }
    }
}

