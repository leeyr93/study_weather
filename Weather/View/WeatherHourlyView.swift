//
//  WeatherHourlyView.swift
//  Weather
//
//  Created by leeyr on 2021/05/06.
//

import UIKit

class WeatherHourlyView: UIView {
  @IBOutlet private weak var hourlyStackView: UIStackView!
  @IBOutlet private weak var topSeparatorView: UIView!
  @IBOutlet private weak var bottomSeparatorView: UIView!
  
  func hourlyConfigure(hourly: [Weather.Hourly]) {

    for hourlyItem in hourly {
      guard let hourlyItemView = Bundle.main.loadNibNamed("WeatherHourlyItemView", owner: self, options: nil)?.first as? WeatherHourlyItemView else { return }
      hourlyItemView.hourlyItemConfigure(hourly: hourlyItem)
      hourlyStackView.addArrangedSubview(hourlyItemView)
    }
  }

  func setStyle() {
    topSeparatorView.backgroundColor = .lightGray
    bottomSeparatorView.backgroundColor = .lightGray
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    setStyle()
  }
}
