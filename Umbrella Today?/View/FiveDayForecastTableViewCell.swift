//
//  ForecastTableViewCell.swift
//  Umbrella Today?
//
//  Created by Brandon Fong on 12/30/19.
//  Copyright © 2019 Fiesta Togo Inc. All rights reserved.
//

import UIKit

class FiveDayForecastTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    // need to pass in min temp
    func update(day: String, minTemp: Int, maxTemp: Int, description: String, isDaytime: Bool) {
        dayLabel.text = day
        // weather images for days of the week should always be day time images
        weatherImageView.image = WeatherImages.getImage(weatherDescription: description, isDaytime: true)
        self.selectionStyle = .none
        self.isDaytime = isDaytime
        self.backgroundColor = .none
        let temperatureText = "\(minTemp)º / \(maxTemp)º"
        
        let rangeOfSlash = (temperatureText as NSString).range(of: "/")
        // i added a space to the range of max temp in case the numbers for min and max were the same
        let rangeOfMaxTemp = (temperatureText as NSString).range(of: " \(maxTemp)º")
        let attributedText = NSMutableAttributedString.init(string: temperatureText)
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: slashColor!, range: rangeOfSlash)
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: maxTempColor!, range: rangeOfMaxTemp)
        temperatureLabel.attributedText = attributedText

    }
}
