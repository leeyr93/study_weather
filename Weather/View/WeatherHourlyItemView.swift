//
//  WeatherHourlyItemView.swift
//  Weather
//
//  Created by leeyr on 2021/05/06.
//

import UIKit

class WeatherHourlyItemView: UIView {
  @IBOutlet private weak var hourLabel: UILabel!
  @IBOutlet private weak var weatherImageView: UIImageView!
  @IBOutlet private weak var degreeLabel: UILabel!

  private func getTime(dt: Double) -> String {
    let date = Date(timeIntervalSince1970: dt)
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(abbreviation: "KST")
    dateFormatter.locale = Locale(identifier: "ko_KR")
    dateFormatter.dateFormat = "a hh"
    dateFormatter.amSymbol = "오전"
    dateFormatter.pmSymbol = "오후"
    let day = dateFormatter.string(from: date)
    return day
  }
  
  func hourlyItemConfigure(hourly: Weather.Hourly) {
    hourLabel.text = getTime(dt: hourly.dt) + "시"
    degreeLabel.text = "\(Int(hourly.temp))º"
    
    let url = "https://openweathermap.org/img/wn/\(hourly.weather[0].icon)@2x.png"
    
    RequestImage.imageLoad(url: url) { [weak self] img in
      DispatchQueue.main.async {
        self?.weatherImageView.image = img
      }
    }
  }
}
