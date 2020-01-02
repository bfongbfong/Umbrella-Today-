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
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        listenForSavedLocationsUpdate()
    }
}

extension SavedLocationsViewController {
    func listenForSavedLocationsUpdate() {
        WeatherReportData.savedLocationsWeatherReports.asObservable()
            .subscribe(onNext: { weatherReports in
                
                print("current weather reports accepted: \(weatherReports.count)")
                self.savedLocationsWeatherReports = weatherReports
                
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
        print("time is \(time)")
        
        cell.update(location: thisReport.location, time: time, temperature: thisReport.temperature.current, weatherImageName: "rain_01", currentLocation: false)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        WeatherReportData.currentForecast.accept(savedLocationsWeatherReports[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
}

    
// MARK: - Navigation
extension SavedLocationsViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
    }
    
}
