//
//  AutocompleteCitySearchTableViewCell.swift
//  Umbrella Today?
//
//  Created by Brandon Fong on 1/1/20.
//  Copyright © 2020 Fiesta Togo Inc. All rights reserved.
//

import UIKit

class AutocompleteCitySearchTableViewCell: UITableViewCell {

    @IBOutlet weak var cityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func update(city: City) {
        var cityText = ""
        
        if let state = city.state {
            cityText = "\(city.name), \(state), \(city.country)"
        } else {
            cityText = "\(city.name), \(city.country)"
        }
        
        cityLabel.text = cityText
    }
    
}
