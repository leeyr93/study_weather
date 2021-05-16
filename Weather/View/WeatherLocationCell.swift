//
//  WeatherLocationCell.swift
//  Weather
//
//  Created by leeyr on 2021/04/20.
//

import UIKit

protocol OpenMapDelagate: class {
  func openMap()
}

class WeatherLocationCell: UITableViewCell {
  @IBOutlet private weak var currentLocationLabel: UILabel!
  @IBOutlet private weak var openMapLabel: UILabel!
  weak var openMapDelegate: OpenMapDelagate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    setTapGesture()
  }
  
  func setTapGesture() {
    openMapLabel.isUserInteractionEnabled = true
    
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewMapTapped(_:)))
    openMapLabel.addGestureRecognizer(tapGestureRecognizer)
  }
  
  @objc func viewMapTapped(_ sender: UITapGestureRecognizer) {
    openMapDelegate?.openMap()
  }
  
  func locationConfigure(addressName: String) {
    currentLocationLabel.text = "\(addressName) 날씨."
    openMapLabel.attributedText = NSAttributedString(string: "지도에서 열기", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    openMapLabel.textColor = .systemBlue
  }
}
