//
//  HourlyForecastTableViewCell.swift
//  Umbrella Today?
//
//  Created by Brandon Fong on 12/31/19.
//  Copyright © 2019 Fiesta Togo Inc. All rights reserved.
//

import UIKit

class HourlyForecastTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    // MARK: - Properties
    var isDaytime = false {
        didSet {
            if isDaytime {
                dayLabel.textColor = UIColor.dayLocationText()
                temperatureLabel.textColor = UIColor.dayTemperatureText()
                
                maxTempColor = UIColor.dayForecastMaxTemp()
                slashColor = UIColor.dayLocationText()
            } else {
                dayLabel.textColor = UIColor.nightLocationText()
                temperatureLabel.textColor = UIColor.nightTemperatureText()
                
                slashColor = UIColor.nightDetailTextHighlights()
                maxTempColor = UIColor.nightForecastMaxTemp()
            }
        }
    }
    
    var slashColor: UIColor?
    var maxTempColor: UIColor?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func update(time: String, currentTemp: Int, description: String, isDaytime: Bool) {
        dayLabel.text = time
        weatherImageView.image = WeatherImages.getImage(weatherDescription: description, isDaytime: isDaytime)
        self.selectionStyle = .none
        self.isDaytime = isDaytime
        self.backgroundColor = .none
        temperatureLabel.text = "\(currentTemp)º"

    }
}
