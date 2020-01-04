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
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
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
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    // MARK: - View Controller Life Cycle
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
//                print("hourly reports accepted: \(weatherReports.count) items")
                
                self.simpleWeatherReports = weatherReports

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }).disposed(by: disposeBag)
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
                    description: thisReport.description,
                    isDaytime: isDaytime)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

