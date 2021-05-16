//
//  WeatherWeekCell.swift
//  Weather
//
//  Created by leeyr on 2021/04/19.
//

import UIKit

class WeatherWeekCell: UITableViewCell {
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var weatherImageView: UIImageView!
    @IBOutlet private weak var weatherPercentLabel: UILabel!
    @IBOutlet private weak var weatherHighsLabel: UILabel!
    @IBOutlet private weak var weatherLowsLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
    }
  
    private func getDay(dt: Double) -> String {
      let date = Date(timeIntervalSince1970: dt)
      let dateFormatter = DateFormatter()
      dateFormatter.timeZone = TimeZone(abbreviation: "GMT") 
      dateFormatter.locale = Locale(identifier: "ko_KR")
      dateFormatter.dateFormat = "EEEE"
      let day = dateFormatter.string(from: date)
      return day
    }
  
    func weekConfigure(data: Weather, indexPath: IndexPath) {
      dayLabel.text = getDay(dt: data.daily[indexPath.row].dt)
      weatherHighsLabel.text = "\(Int(data.daily[indexPath.row].temp.max))"
      weatherLowsLabel.text = "\(Int(data.daily[indexPath.row].temp.min))"
      
      let url = "https://openweathermap.org/img/wn/\(data.daily[indexPath.row].weather[0].icon)@2x.png"
      
      RequestImage.imageLoad(url: url) { [weak self] img in
        DispatchQueue.main.async {
          self?.weatherImageView.image = img
        }
      }
      
      let pop = Int(data.daily[indexPath.row].pop * 100)
      
      if pop != 0 {
        weatherPercentLabel.text = "\(pop)%"
      } else {
        weatherPercentLabel.text = ""
      }
    }
}
