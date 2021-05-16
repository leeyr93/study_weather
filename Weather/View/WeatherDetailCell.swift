//
//  WeatherDetailCell.swift
//  Weather
//
//  Created by leeyr on 2021/04/19.
//

import UIKit

enum WeatherDetailType: Int {
  case sunrise = 0
  case sunset = 1
  case pop = 2
  case humidity = 3
  case windSpeed = 4
  case feelsLike = 5
  case rain = 6
  case pressure = 7
  case visibility = 8
  case uvi = 9
}

class WeatherDetailCell: UITableViewCell {
  @IBOutlet private weak var leftKeyLabel: UILabel!
  @IBOutlet private weak var leftValueLabel: UILabel!
  @IBOutlet private weak var rightKeyLabel: UILabel!
  @IBOutlet private weak var rightValueLabel: UILabel!
  @IBOutlet private weak var bottomSeparatorView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    setStyle()
  }
  
  private func setStyle() {
    bottomSeparatorView.backgroundColor = .lightGray
  }
  
  private func getTime(dt: Double) -> String {
    let date = Date(timeIntervalSince1970: dt)
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(abbreviation: "KST")
    dateFormatter.locale = Locale(identifier: "ko_KR")
    dateFormatter.dateFormat = "hh:mm"
    let day = dateFormatter.string(from: date)
    return day
  }
  
  func detailConfigure(daily: Weather.Daily, current: Weather.Current, indexPath: IndexPath) {
    let row = (indexPath.row - 9) * 2
    
    switch row {
    case 0:
      leftKeyLabel.text = "일출"
      leftValueLabel.text = "오전 \(getTime(dt: current.sunrise))"
      rightKeyLabel.text = "일몰"
      rightValueLabel.text = "오후 \(getTime(dt: current.sunset))"
    case 2:
      leftKeyLabel.text = "비 올 확률"
      leftValueLabel.text = "\(Int(daily.pop))%"
      rightKeyLabel.text = "습도"
      rightValueLabel.text = "\(Int(current.humidity))%"
    case 4:
      leftKeyLabel.text = "바람"
      leftValueLabel.text = "\(Int(current.wind_speed))m/s"
      rightKeyLabel.text = "체감"
      rightValueLabel.text = "\(Int(current.feels_like))º"
    case 6:
      leftKeyLabel.text = "강수량"
      leftValueLabel.text = "\(Int(daily.rain ?? 0))cm"
      rightKeyLabel.text = "기압"
      rightValueLabel.text = "\(Int(current.pressure))hPa"
    case 8:
      leftKeyLabel.text = "가시거리"
      leftValueLabel.text = "\(Double(current.visibility/1000))km"
      rightKeyLabel.text = "자외선 지수"
      rightValueLabel.text = "\(Int(current.uvi))"
    default:
      break
    }
  }
}
