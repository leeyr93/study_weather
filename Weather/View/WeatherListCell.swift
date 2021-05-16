//
//  WeatherListCell.swift
//  Weather
//
//  Created by leeyr on 2021/05/13.
//

import UIKit
import Alamofire

protocol PresentWeatherMainDelegate: class {
  func presentWeatherMain(latitude: Double?, longitude: Double?)
}

class WeatherListCell: UITableViewCell {
  @IBOutlet private weak var timeLabel: UILabel!
  @IBOutlet private weak var locationLabel: UILabel!
  @IBOutlet private weak var temperatureLabel: UILabel!
  private var latitude: Double?
  private var longitude: Double?
  weak var presentWeatherMainDelegate: PresentWeatherMainDelegate?
  
  func listConfigure(latitude: Double?, longitude: Double?, locality: String?) {
    getWeather(latitude: latitude, longitude: longitude)
    self.latitude = latitude
    self.longitude = longitude
    locationLabel.text = locality
  }

  private func getTime(dt: Double) -> String {
    let date = Date(timeIntervalSince1970: dt)
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    dateFormatter.dateFormat = "a hh:mi"
    dateFormatter.amSymbol = "오전"
    dateFormatter.pmSymbol = "오후"
    let day = dateFormatter.string(from: date)
    return day
  }
  
  private func getWeather(latitude: Double?, longitude: Double?) {
    guard let latitude = latitude, let longitude = longitude else { return }
    
    let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=metric&lang=kr&appid=ebaa9d30dbab1d822bb74efadc829542"
    
    AF.request(url,
               method: .get,
               parameters: nil,
               encoding: URLEncoding.default,
               headers: ["Content-Type":"application/json", "Accept":"application/json"])
      .validate(statusCode: 200..<300)
      .responseJSON { [weak self] response in
        switch response.result {
        case .success(let res):
          do {
            let jsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
            let json = try JSONDecoder().decode(Weather.self, from: jsonData)
            self?.timeLabel.text = self?.getTime(dt: json.current.dt + json.timezone_offset)
            self?.temperatureLabel.text = "\(Int(json.current.temp))º"
          } catch (let error){
            print("error : \(error)")
          }
        case .failure(let error):
          print("error : \(error.localizedDescription)")
        }
      }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    if selected {
      presentWeatherMainDelegate?.presentWeatherMain(latitude: latitude, longitude: longitude)
    }
  }
}
