//
//  LocationSearchViewController.swift
//  Umbrella Today?
//
//  Created by Brandon Fong on 1/1/20.
//  Copyright © 2020 Fiesta Togo Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LocationSearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    var searchResultCities = [City]()
    var savedWeatherReports = [WeatherReport]()

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        listenForSavedLocationsUpdate()
    }
}


// MARK: - IBActions & Objc Functions
extension LocationSearchViewController {
    
    @IBAction func textFieldEditingChanged(_ sender: Any) {
        guard let text = textField.text else {
            print("textfield.text was nil")
            searchResultCities.removeAll()
            tableView.reloadData()
            return
        }
        
        guard let firstLetter = Array(text).first else {
            searchResultCities.removeAll()
            tableView.reloadData()
            return
        }

        guard text != "" && firstLetter != " " else {
            searchResultCities.removeAll()
            tableView.reloadData()
            return
        }
        
        AutocompleteSearchManager.searchForCities(input: text, maxNumberOfResults: 5) { cities in
            self.searchResultCities = cities
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension LocationSearchViewController {
    func listenForSavedLocationsUpdate() {
        
        // the only reaosn this is here, is so i can get the beginning of the array, and attach the new part to send it back
//        WeatherReportData.savedLocationsWeatherReports.asObservable()
//            .subscribe(onNext: { weatherReports in
//
//                print("LOCATION SEARCH VC - receiving: \(weatherReports.count) report(s)")
//                self.savedWeatherReports = weatherReports
//
//            }).disposed(by: disposeBag)
    }

}


// MARK: - UITableView Delegate & Data Source
extension LocationSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCityCell") as! AutocompleteCitySearchTableViewCell
        let thisCity = searchResultCities[indexPath.row]
        cell.update(city: thisCity)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = searchResultCities[indexPath.row]
        
        // i think maybe this should be called in the vc underneath it.. but how?
        OpenWeatherManager.getCurrentWeatherData(cityID: selectedCity.id) { (jsonData) in
            if let jsonData = jsonData {
                if let weatherReport = JsonParser.parseJsonCurrentWeatherObject(jsonObject: jsonData) {
                    self.savedWeatherReports.append(weatherReport)
//                    print("LOCATION SEARCH VC - sending: \(self.savedWeatherReports.count) with newest being in \(weatherReport.location)")
//                    WeatherReportData.savedLocationsWeatherReports.accept(self.savedWeatherReports)
                    // pass on a single one instead
                    
                    print("LOCATION SEARCH VC - sending addition \(weatherReport.location)")
                    WeatherReportData.savedLocationsWeatherReports.accept([weatherReport])
                    
                } else {
                    print("error parsing json for current weather object in LocationSearchVC")
                }
            } else {
                print("Error: get current weather data returned nothing in LocationSearchVC")
            }
        }
        dismiss(animated: true, completion: nil)
    }

}
