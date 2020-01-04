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
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    // MARK: - Properties
    var searchResultCities = [City]()
    var savedWeatherReport: WeatherReport?

    // RxSWift
    let disposeBag = DisposeBag()
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
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

// MARK: - Retrieve Data
extension LocationSearchViewController {
    func findAndSendDataForSelectedCity(city: City) {
        let queue = OperationQueue()
        let group = DispatchGroup()
        
        let operation1 = BlockOperation {
            group.enter()
            OpenWeatherManager.getCurrentWeatherData(cityID: city.id) { (jsonData) in
                if let jsonData = jsonData {
                    if let weatherReport = JsonParser.parseJsonCurrentWeatherObject(jsonObject: jsonData) {
                        self.savedWeatherReport = weatherReport
                    } else {
                        print("error parsing json for current weather object in LocationSearchVC")
                    }
                } else {
                    print("Error: get current weather data returned nothing in LocationSearchVC")
                }
                group.leave()
            }
            group.wait()
        }
        
        let operation2 = BlockOperation {
            AutocompleteSearchManager.searchForCities(input: self.savedWeatherReport!.location, maxNumberOfResults: 1) { (arrayOfCities) in
                let foundCity = arrayOfCities[0]
                let abbreviatedState = Helpers.convertStateToAbbr(stateName: foundCity.state!)
                self.savedWeatherReport!.state = abbreviatedState
            }
        }
        
        let operation3 = BlockOperation {
//            print("LOCATION SEARCH VC - sending addition \(self.savedWeatherReport!.location)")
            WeatherReportData.savedLocationsWeatherReports.accept([self.savedWeatherReport!])
        }
        
        operation2.addDependency(operation1)
        operation3.addDependency(operation2)
        queue.addOperation(operation1)
        queue.addOperation(operation2)
        queue.addOperation(operation3)
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
        
        findAndSendDataForSelectedCity(city: selectedCity)
        dismiss(animated: true, completion: nil)
    }
}

