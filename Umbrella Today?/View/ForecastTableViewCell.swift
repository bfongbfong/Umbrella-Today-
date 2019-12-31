//
//  ForecastTableViewCell.swift
//  Umbrella Today?
//
//  Created by Brandon Fong on 12/30/19.
//  Copyright © 2019 Fiesta Togo Inc. All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    var isDaytime = false {
        didSet {
            if isDaytime {

            } else {
                dayLabel.textColor = UIColor.nightLocationText()
                temperatureLabel.textColor = UIColor.nightTemperatureText()
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(day: String, temperatureText: String, weatherImageName: String, isDaytime: Bool) {
        dayLabel.text = day
        temperatureLabel.text = temperatureText
        weatherImageView.image = UIImage(named: weatherImageName)!
        self.selectionStyle = .none
        self.isDaytime = isDaytime
        self.backgroundColor = .none
    }

}
