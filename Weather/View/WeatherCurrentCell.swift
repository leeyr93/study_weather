//
//  WeatherCurrentCell.swift
//  Weather
//
//  Created by leeyr on 2021/04/19.
//

import UIKit

class WeatherCurrentCell: UITableViewCell {
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var topSeparator: UIView!
    @IBOutlet private weak var bottomSeparator: UIView!
        
    private func setupStyle() {
        topSeparator.backgroundColor = .lightGray
        bottomSeparator.backgroundColor = .lightGray
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupStyle()
    }
  
    func currentConfigure(data: Weather.Current) {
      contentLabel.text = "오늘 : 현재 날씨 \(data.weather[0].description), 기온은 \(Int(data.temp))º입니다."
    }
}
