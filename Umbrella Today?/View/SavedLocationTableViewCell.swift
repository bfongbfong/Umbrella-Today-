//
//  SavedLocationTableViewCell.swift
//  Umbrella Today?
//
//  Created by Brandon Fong on 1/1/20.
//  Copyright © 2020 Fiesta Togo Inc. All rights reserved.
//

import UIKit

class SavedLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        locationLabel.textColor = UIColor.dayLocationText()
        temperatureLabel.textColor = UIColor.dayTemperatureText()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func update(location: String, time: String, temperature: Int, description: String, currentLocation: Bool) {
        
        locationLabel.text = location.uppercased()
        timeLabel.text = time
        temperatureLabel.text = "\(temperature)º"
        weatherImageView.image = WeatherImages.getImage(weatherDescription: description, isDaytime: true)
    }

}
