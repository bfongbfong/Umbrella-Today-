//
//  LocationSearchViewController.swift
//  Umbrella Today?
//
//  Created by Brandon Fong on 1/1/20.
//  Copyright © 2020 Fiesta Togo Inc. All rights reserved.
//

import UIKit

class LocationSearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    var searchResultCities = [City]()

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

}
