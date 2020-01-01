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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(location: String, time: String, temperature: Int, weatherImageName: String, currentLocation: Bool) {
        
        locationLabel.text = location
        timeLabel.text = time
        temperatureLabel.text = "\(temperature)º"
        weatherImageView.image = UIImage(named: weatherImageName)!
        
    }

}
