//
//  SavedLocationsViewController.swift
//  Umbrella Today?
//
//  Created by Brandon Fong on 1/1/20.
//  Copyright © 2020 Fiesta Togo Inc. All rights reserved.
//

import UIKit

class SavedLocationsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var savedLocations = [WeatherReport]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - UITableView Delegate & Data Source
extension SavedLocationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedLocationCell") as! SavedLocationTableViewCell
        
        let thisReport = savedLocations[indexPath.row]
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
}

    
// MARK: - Navigation
extension SavedLocationsViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
    }
    
}
