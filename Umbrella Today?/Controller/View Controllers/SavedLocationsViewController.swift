//
//  SavedLocationsViewController.swift
//  Umbrella Today?
//
//  Created by Brandon Fong on 1/1/20.
//  Copyright © 2020 Fiesta Togo Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SavedLocationsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var savedLocationsWeatherReports = [WeatherReport]()
//    var savedCities = [City]()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        listenForSavedLocationsUpdate()
        if savedLocationsWeatherReports.count == 1 {
            savedLocationsWeatherReports += PersistenceManager.loadWeatherReports()
        }
    }
}

extension SavedLocationsViewController {
    func listenForSavedLocationsUpdate() {
        // listener to get first time loading data for current location weather
//        WeatherReportData.savedLocationsWeatherReports.asObservable()
//            .take(1)
//            .subscribe(onNext: { weatherReports in
//
//                print("first element taken from listener: \(weatherReports[0].location), the rest from local storage")
//                // ScrollParentVC sends the current weather
//                self.savedLocationsWeatherReports = weatherReports
//                self.savedLocationsWeatherReports += PersistenceManager.loadWeatherReports()
//                self.tableView.reloadData()
//
//            }).disposed(by: disposeBag)
        
        // listener for every time besides first time.
        WeatherReportData.savedLocationsWeatherReports.asObservable()
            .skip(1)
            .subscribe(onNext: { weatherReports in
                
                print("SAVED LOCATIONS VC - receiving: \(weatherReports.count) report(s)")
                if weatherReports.count == 1 {
                    self.savedLocationsWeatherReports += weatherReports
                } else {
                    self.savedLocationsWeatherReports = weatherReports
                }
                
                
                
//                if weatherReports.count == 1 {
//                    self.savedLocationsWeatherReports += weatherReports
//                } else {
//                    self.savedLocationsWeatherReports = weatherReports
//                }
                
                
                var savedLocationsWithoutFirst = self.savedLocationsWeatherReports
                savedLocationsWithoutFirst.removeFirst()
                PersistenceManager.persistWeatherReports(savedLocationsWithoutFirst)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }).disposed(by: disposeBag)
        
        
    }
}

// MARK: - UITableView Delegate & Data Source
extension SavedLocationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedLocationsWeatherReports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedLocationCell") as! SavedLocationTableViewCell
        
        let thisReport = savedLocationsWeatherReports[indexPath.row]
        // get the time zone, and figure out the time based on that.
        let currentDate = Date()
        let unixTimeStamp = currentDate.timeIntervalSince1970 + thisReport.timeZone!
        let time = Helpers.convertToTime(unixTimeStamp: unixTimeStamp, accurateToMinute: true, currentTimeZone: false)
        // bug - the time isn't even right
//        print("time is \(time)")
        
        cell.update(location: thisReport.location, time: time, temperature: thisReport.temperature.current, weatherImageName: "rain_01", currentLocation: false)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedWeatherReport = savedLocationsWeatherReports[indexPath.row]
        WeatherReportData.currentForecast.accept(selectedWeatherReport)
        // TODO - what to do here. add logic to add hourly and daily info into the UI
        
        OpenWeatherManager.getFiveDayAndHourlyForecast(cityID: selectedWeatherReport.id) { (jsonData) in
            if let jsonData = jsonData {
                
                DispatchQueue.main.async {
                    let arrayOfSimpleWeatherReports = JsonParser.parseJsonFiveDayWeatherObjects(jsonObject: jsonData)
                    var arrayOfEightHourlyWeatherReports = Array(arrayOfSimpleWeatherReports[0...7])
                    let fiveDayReports = Helpers.findFiveDayReport(simpleWeatherReports: arrayOfSimpleWeatherReports)
                    let simpleCurrentReport = selectedWeatherReport.convertIntoSimpleWeatherReportForFirstHourlyResult()
                    arrayOfEightHourlyWeatherReports.insert(simpleCurrentReport, at: 0)
                    WeatherReportData.fiveDayForecast.accept(fiveDayReports)
                    WeatherReportData.hourlyForecast.accept(arrayOfEightHourlyWeatherReports)
                }
                
            } else {
                print("Error: get five day and hourly weather data returned nothing in SavedLocationsVC")
            }
        }
        dismiss(animated: true, completion: nil)
    }
}

    
// MARK: - Navigation
extension SavedLocationsViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
    }
    
}
