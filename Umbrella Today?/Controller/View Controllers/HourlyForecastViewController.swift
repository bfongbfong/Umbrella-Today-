//
//  HourlyForecastViewController.swift
//  Umbrella Today?
//
//  Created by Brandon Fong on 12/31/19.
//  Copyright © 2019 Fiesta Togo Inc. All rights reserved.
//

import UIKit
import RxSwift

class HourlyForecastViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var isDaytime = false {
        didSet {
            if isDaytime {
                view.backgroundColor = UIColor.dayBackground()
            } else {
                view.backgroundColor = UIColor.nightBackground()
            }
        }
    }
    
    var simpleWeatherReports = [SimpleWeatherReport]()
    var currentWeatherReport: WeatherReport?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .none
        listenForForecastUpdates()
    }
}

// MARK: - RxSwift
extension HourlyForecastViewController {
    func listenForForecastUpdates() {
        // Listens for update in hourly forecast to display in tableview
        WeatherReportData.hourlyForecast.asObservable()
            .subscribe(onNext: { weatherReports in
                print("hourly reports accepted: \(weatherReports.count) items")
                
                // this logic needs to be fixed.
                
                // if the data is already there for another day, it needs to be replaced with data for the new day
                
                
//                if self.simpleWeatherReports.count == 1 {
//                    self.simpleWeatherReports += weatherReports
//                } else {
//                    self.simpleWeatherReports = weatherReports
//                }
                self.simpleWeatherReports = weatherReports

                
                
                
//                for weatherReport in weatherReports {
//                    print(weatherReport.dayOfWeek)
//                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }).disposed(by: disposeBag)
        
        // Listens for update in current forecast, to add it as first element in table view (the NOW weather)
//        WeatherReportData.currentForecast.asObservable()
//            .subscribe(onNext: { weatherReport in
//
//                guard let weatherReport = weatherReport else { return }
//                print("current weather report accepted: \(weatherReport.temperature.current)")
//                self.currentWeatherReport = weatherReport
//                // convert current weather report into simple one
//                let currentWeatherSimple = weatherReport.convertIntoSimpleWeatherReportForFirstHourlyResult()
//                self.simpleWeatherReports.insert(currentWeatherSimple, at: 0)
//
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            }).disposed(by: disposeBag)
    }
}

// MARK: - UITableView Delegate & Data Source
extension HourlyForecastViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return simpleWeatherReports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HourlyForecastCell") as! HourlyForecastTableViewCell
        
        // first one should be current data
        let thisReport = simpleWeatherReports[indexPath.row]

        cell.update(time: thisReport.time,
                    currentTemp: thisReport.currentTemp,
                    weatherImageName: "few_clouds_day_01",
                    isDaytime: isDaytime)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

