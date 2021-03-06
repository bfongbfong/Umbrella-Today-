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
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var savedLocationsWeatherReports = [WeatherReport]()

    // RxSwift
    let disposeBag = DisposeBag()
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        listenForSavedLocationsUpdate()
        if let currentLocationWeatherReport = WeatherReport.currentLocation {
            savedLocationsWeatherReports.append(currentLocationWeatherReport)
            savedLocationsWeatherReports += PersistenceManager.loadWeatherReports()
        }
    }
}

// MARK: - Retrieve Data
extension SavedLocationsViewController {
    func listenForSavedLocationsUpdate() {
        // listener for every time besides first time. Because the first time is when this VC is loaded.
        WeatherReportData.savedLocationsWeatherReports.asObservable()
            .skip(1)
            .subscribe(onNext: { weatherReports in
                
//                print("SAVED LOCATIONS VC - receiving: \(weatherReports.count) report(s)")
                if weatherReports.count == 1 {
                    self.savedLocationsWeatherReports += weatherReports
                } else {
                    self.savedLocationsWeatherReports = weatherReports
                }
                
                self.persistSavedLocations()
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }).disposed(by: disposeBag)
    }
    
    private func persistSavedLocations() {
        var savedLocationsWithoutFirst = self.savedLocationsWeatherReports
        savedLocationsWithoutFirst.removeFirst()
        PersistenceManager.persistWeatherReports(savedLocationsWithoutFirst)
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
        let description = thisReport.description
        let location = thisReport.location
        let timeZoneOffset = thisReport.timeZone!
        let unixTimeStamp = Date().timeIntervalSince1970
        
        var isDaytime = true
        if let sunriseTime = thisReport.sunriseTime {
            if let sunsetTime = thisReport.sunsetTime {
                if Helpers.checkIfIsDaytime(unixTimeStamp: unixTimeStamp, sunriseTime: Double(sunriseTime), sunsetTime: Double(sunsetTime)) {
                    isDaytime = true
                } else {
                    isDaytime = false
                }
            }
        }
        
        let time = Helpers.convertToTime(unixTimeStamp: unixTimeStamp, timeZoneOffset: timeZoneOffset, accurateToMinute: true, currentTimeZone: false)
        
        cell.update(location: location, time: time, temperature: thisReport.temperature.current, description: description, currentLocation: false, isDaytime: isDaytime)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedWeatherReport = savedLocationsWeatherReports[indexPath.row]
        WeatherReportData.currentForecast.accept(selectedWeatherReport)
        
        OpenWeatherManager.getFiveDayAndHourlyForecast(cityID: selectedWeatherReport.id) { (jsonData) in
            if let jsonData = jsonData {
                
                DispatchQueue.main.async {
                    let arrayOfSimpleWeatherReports = JsonParser.parseJsonFiveDayWeatherObjects(jsonObject: jsonData, byCityId: true)
                    // index out of range
                    if arrayOfSimpleWeatherReports.count < 8 {
                        print("json parsing for five day weather reports returned empty array (saved locations vc)")
                        return
                    }
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row != 0 {
            return true
        } else {
            return false
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            savedLocationsWeatherReports.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        persistSavedLocations()
    }
}
