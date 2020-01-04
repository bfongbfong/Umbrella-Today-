//
//  FiveDayForecastViewController.swift
//  Umbrella Today?
//
//  Created by Brandon Fong on 12/30/19.
//  Copyright © 2019 Fiesta Togo Inc. All rights reserved.
//

import UIKit
import RxSwift

class FiveDayForecastViewController: UIViewController {
    
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
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .none
        setupRxSwift()
    }
}

// MARK: - RxSwift
extension FiveDayForecastViewController {
    func setupRxSwift() {
        WeatherReportData.fiveDayForecast.asObservable()
            .subscribe(onNext: { weatherReports in
                print("five day reports accepted: \(weatherReports.count) items")
                self.simpleWeatherReports = weatherReports
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }).disposed(by: disposeBag)
    }
}

// MARK: - UITableView Delegate & Data Source
extension FiveDayForecastViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return simpleWeatherReports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FiveDayForecastCell") as! FiveDayForecastTableViewCell
        let thisReport = simpleWeatherReports[indexPath.row]
        
        let dayOfWeekText = thisReport.dayOfWeek
        let minTemp = thisReport.minTemp
        let maxTemp = thisReport.maxTemp
        let description = thisReport.description
        
        cell.update(day: dayOfWeekText,
                    minTemp: minTemp,
                    maxTemp: maxTemp,
                    description: description,
                    isDaytime: isDaytime)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
