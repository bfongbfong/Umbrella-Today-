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
    
    @IBOutlet weak var scrollView: UIScrollView!

    var pages = [CurrentWeatherViewController]()
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var currentWeatherReport: WeatherReport!
    
    var loadingView = UIView()
    
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
            print("user has to enable location services")
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
            print("location services are denied")
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            // alert user that they have been restricted
            print("location services are restricted")
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
            fireApiCalls()
        }
    }
}


// MARK: - CLLocation Manager Delegate
extension ScrollParentViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        getLocation()
    }
}


// MARK: - API Calls
extension ScrollParentViewController {
    func fireApiCalls() {
        guard currentLocation != nil else { return }
        
//        oldMethod()
        newMethod()
        
    }
}

extension ScrollParentViewController {
    
    func newMethod() {
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
                AutocompleteSearchManager.searchForCities(input: currentWeatherReport.location, maxNumberOfResults: 1) { (arrayOfCities) in
                    if let state = arrayOfCities[0].state {
//                        print("state is:", state)
                        let stateAbbr = Helpers.convertStateToAbbr(stateName: state)
//                        print("abbreviated state is:", stateAbbr)
                        if WeatherReport.currentLocation != nil {
                            WeatherReport.currentLocation!.state = stateAbbr
                        }
                        
//                        print("Operation 2 done")
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
                        
                        // one time, something on the line below was unwrapped to nil
                        // reason was because currentWeatherReport needs to be retrieved in op 1
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
    
//    func oldMethod() {
//        OpenWeatherManager.getCurrentWeatherData(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude) { (jsonWeatherObject) in
//
//            if let responseJson = jsonWeatherObject {
//
//                self.currentWeatherReport = JsonParser.parseJsonCurrentWeatherObject(jsonObject: responseJson)
//                WeatherReportData.currentForecast.accept(self.currentWeatherReport)
//
//                WeatherReport.currentLocation = self.currentWeatherReport
//
//                DispatchQueue.main.async {
//                    self.checkSunlight()
//                    self.setupPages()
//                }
//
//                OpenWeatherManager.getFiveDayAndHourlyForecast(latitude: self.currentLocation.coordinate.latitude, longitude: self.currentLocation.coordinate.longitude) { (jsonWeatherObject) in
//
//                    if let responseJson = jsonWeatherObject {
//                        DispatchQueue.main.async {
//
//                            let arrayOfSimpleWeatherReports = JsonParser.parseJsonFiveDayWeatherObjects(jsonObject: responseJson)
//                            if arrayOfSimpleWeatherReports.count < 8 {
//                                print("Error: API didn't send back enough forecasts.")
//                                return
//                            }
//                            var arrayOfEightHourlyWeatherReports = Array(arrayOfSimpleWeatherReports[0...7])
//                            let fiveDayReports = Helpers.findFiveDayReport(simpleWeatherReports: arrayOfSimpleWeatherReports)
//
//                            let currentWeatherSimple = self.currentWeatherReport.convertIntoSimpleWeatherReportForFirstHourlyResult()
//                            arrayOfEightHourlyWeatherReports.insert(currentWeatherSimple, at: 0)
//                            WeatherReportData.fiveDayForecast.accept(fiveDayReports)
//                            WeatherReportData.hourlyForecast.accept(arrayOfEightHourlyWeatherReports)
//                        }
//                    }
//                }
//            }
//        }
//    }
    
    func checkSunlight() {
        let now = Int(NSDate().timeIntervalSince1970)
//        print("right now is \(now) in epoch time")
        
        if currentWeatherReport != nil {
            if currentWeatherReport!.sunriseTime != nil {
//                print("sunrise time: \(currentWeatherReport!.sunriseTime!)")
            }
        }
        if currentWeatherReport != nil {
            if currentWeatherReport!.sunsetTime != nil {
//                print("sunset time: \(currentWeatherReport!.sunsetTime!)")
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

