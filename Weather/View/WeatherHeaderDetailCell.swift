//
//  WeatherHeaderDetailCell.swift
//  Weather
//
//  Created by leeyr on 2021/05/06.
//

import UIKit

class WeatherHeaderDetailCell: UITableViewCell {
    @IBOutlet private weak var degreeLabel: UILabel!
    @IBOutlet private weak var highslowsLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func headerDetailConfigure(daily: Weather.Daily, current: Weather.Current) {
      degreeLabel.text = "\(Int(current.temp))º"
      highslowsLabel.text = "최고:\(Int(daily.temp.max)) 최저:\(Int(daily.temp.min))"
    }
}
