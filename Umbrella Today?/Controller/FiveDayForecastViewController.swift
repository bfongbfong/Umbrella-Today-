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
    let disposeBag = DisposeBag()
    
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
        FiveDayForecast.simpleWeatherReports.asObservable()
            .subscribe(onNext: { weatherReports in
                print("five day reports accepted: \(weatherReports.count) items")
                self.simpleWeatherReports = weatherReports
                for weatherReport in weatherReports {
                    print(weatherReport.dayOfWeek)
                }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell") as! ForecastTableViewCell
        let thisReport = simpleWeatherReports[indexPath.row]
        
        let dayOfWeekText = thisReport.dayOfWeek
        let temperatureText = "\(thisReport.minTemp)º / \(thisReport.maxTemp)º"
        
        cell.update(day: dayOfWeekText, temperatureText: temperatureText, weatherImageName: "few_clouds_day_01", isDaytime: isDaytime)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
