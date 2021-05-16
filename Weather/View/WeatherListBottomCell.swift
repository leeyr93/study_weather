//
//  WeatherListBottomCell.swift
//  Weather
//
//  Created by leeyr on 2021/05/13.
//

import UIKit

protocol presentSearchDelegate: class {
  func presentSearch()
}

class WeatherListBottomCell: UITableViewCell {
  @IBOutlet private weak var slashLabel: UILabel!
  @IBOutlet private weak var celsiusButton: UIButton!
  @IBOutlet private weak var fahrenheitButton: UIButton!
  @IBOutlet private weak var weatherLinkButton: UIButton!
  @IBOutlet private weak var searchButton: UIButton!
  
  weak var presentSearchDelegate: presentSearchDelegate?
  
  @IBAction private func celsiusButtonTouch() {
    celsiusButton.setTitleColor(.white, for: .normal)
    fahrenheitButton.setTitleColor(.gray, for: .normal)
  }
  
  @IBAction private func fahrenheitButtonTouch() {
    fahrenheitButton.setTitleColor(.white, for: .normal)
    celsiusButton.setTitleColor(.gray, for: .normal)
  }
  
  @IBAction private func weatherLinkButtonTouch() {
    guard let url = URL(string: "https://weather.com/ko-KR/weather/today/l/KSXX0037:1:KS"), UIApplication.shared.canOpenURL(url) else { return }
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
  }
  
  @IBAction private func searchButtonTouch() {
    presentSearchDelegate?.presentSearch()
  }
  
  private func setStyle() {
    self.contentView.backgroundColor = .black
    celsiusButton.setTitle("ºC", for: .normal)
    celsiusButton.setTitleColor(.white, for: .normal)
    celsiusButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
    fahrenheitButton.setTitle("ºF", for: .normal)
    fahrenheitButton.setTitleColor(.gray, for: .normal)
    fahrenheitButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
    
    slashLabel.text = "/"
    slashLabel.textColor = .gray
    slashLabel.font = .boldSystemFont(ofSize: 15)
    
    weatherLinkButton.setImage(UIImage(named: "TheWeatherChannel"), for: .normal)
    
    searchButton.tintColor = .white
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    setStyle()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
