//
//  WeatherViewController.swift
//  Weather
//
//  Created by leeyr on 2021/04/19.
//

import UIKit
import CoreLocation
import Alamofire
import CoreData

protocol DismissSearchDelegate: class {
  func dismissSearch()
}

class WeatherViewController: UIViewController, OpenMapDelagate {
  @IBOutlet private weak var weatherTableView: UITableView!
  @IBOutlet private weak var separatorView: UIView!
  @IBOutlet private weak var weatherBottomView: UIView!
  @IBOutlet private weak var weatherLinkButton: UIButton!
  @IBOutlet private weak var weatherListButton: UIButton!
  @IBOutlet private weak var weatherLocation: UILabel!
  @IBOutlet private weak var weatherDesc: UILabel!
  @IBOutlet private weak var cancelButton: UIButton!
  @IBOutlet private weak var addButton: UIButton!
  @IBOutlet private weak var headerTopView: UIView!
  
  weak var dismissSearchDelegate: DismissSearchDelegate?
  
  var locationManager: CLLocationManager!
  var latitude: Double? ///위도
  var longitude: Double? ///경도
  var weatherData: Weather?
  var addressName: String?
  var addressLocality: String?
  var isMain: Bool = true
  var isInitialized: Bool = true
  
  @IBAction private func weatherLinkButtonTouch() {
    guard let url = URL(string: "https://weather.com/ko-KR/weather/today/l/KSXX0037:1:KS"), UIApplication.shared.canOpenURL(url) else { return }
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
  }
  
  @IBAction private func weatherListButtonTouch() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "weatherList")
    vc.modalPresentationStyle = .fullScreen
    present(vc, animated: true)
  }
  
  @IBAction private func cancelButtonTouch() {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction private func addButtonTouch() {
    dismiss(animated: true) {
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      let context = appDelegate.persistentContainer.viewContext
      let entity = NSEntityDescription.entity(forEntityName: "Location", in: context)
      
      if let entity = entity {
        let weather = NSManagedObject(entity: entity, insertInto: context)
        weather.setValue(self.latitude, forKey: "latitude")
        weather.setValue(self.longitude, forKey: "longitude")
        weather.setValue(self.addressLocality, forKey: "locality")
        
        do {
          try context.save()
        } catch {
          print(error.localizedDescription)
        }
      }
      
      self.dismissSearchDelegate?.dismissSearch()
    }
  }
  
  func openMap() {
    guard let latitude = latitude,
          let longitude = longitude,
          let url = URL(string: "http://maps.apple.com/maps?saddr=&daddr=\(latitude),\(longitude)") else { return }
    UIApplication.shared.open(url)
  }
  
  private func setStyle() {
    separatorView.backgroundColor = .lightGray
    
    weatherTableView.separatorStyle = .none
    weatherLinkButton.setImage(UIImage(named: "TheWeatherChannel"), for: .normal)
  
    if isMain {
      headerTopView.isHidden = true
      weatherBottomView.isHidden = false
    } else {
      headerTopView.isHidden = false
      weatherBottomView.isHidden = true
      
      cancelButton.setTitle("취소", for: .normal)
      cancelButton.setTitleColor(.gray, for: .normal)
      addButton.setTitle("추가", for: .normal)
      addButton.setTitleColor(.gray, for: .normal)
      addButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
    }
  }
  
  private func setCell() {
    let headerDetailCellNib: UINib = UINib.init(nibName: "WeatherHeaderDetailCell", bundle: nil)
    weatherTableView.register(headerDetailCellNib, forCellReuseIdentifier: "headerDetailCell")
    
    let weekCellNib: UINib = UINib.init(nibName: "WeatherWeekCell", bundle: nil)
    weatherTableView.register(weekCellNib, forCellReuseIdentifier: "weekCell")
    
    let currentCellNib: UINib = UINib.init(nibName: "WeatherCurrentCell", bundle: nil)
    weatherTableView.register(currentCellNib, forCellReuseIdentifier: "currentCell")
    
    let detailCellNib: UINib = UINib.init(nibName: "WeatherDetailCell", bundle: nil)
    weatherTableView.register(detailCellNib, forCellReuseIdentifier: "detailCell")
    
    let locationCellNib: UINib = UINib.init(nibName: "WeatherLocationCell", bundle: nil)
    weatherTableView.register(locationCellNib, forCellReuseIdentifier: "locationCell")
  }
  
  private func sizeHeaderToFit() {
    if let headerView = weatherTableView.tableHeaderView {
      headerView.setNeedsLayout()
      headerView.layoutIfNeeded()
      
      let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
      var frame = headerView.frame
      frame.size.height = height
      headerView.frame = frame
      
      weatherTableView.tableHeaderView = headerView
    }
  }
  
  private func getLocation() {
    locationManager = CLLocationManager()
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.startUpdatingLocation()

    if isMain && isInitialized {
      let coor = locationManager.location?.coordinate
      latitude = coor?.latitude
      longitude = coor?.longitude
    }
    
    getWeather(latitude: latitude, longitude: longitude)

    let findLocation = CLLocation(latitude: latitude ?? 0, longitude: longitude ?? 0)
    let geocoder = CLGeocoder()
    geocoder.reverseGeocodeLocation(findLocation, preferredLocale: nil, completionHandler: {(placemarks, error) in
      if let address: [CLPlacemark] = placemarks {
        if let name: String = address.last?.name, let locality = address.last?.locality {
          self.addressName = name
          self.addressLocality = locality
        }
      }
    })
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
            self?.weatherData = json
            self?.weatherLocation.text = self?.addressLocality
            self?.weatherDesc.text = self?.weatherData?.current.weather[0].description
            self?.weatherTableView.reloadData()
          } catch (let error){
            print("error : \(error)")
          }
        case .failure(let error):
          self?.setAlert(msg: "\(error.failureReason ?? "")")
        }
      }
  }
  
  ///알림 화면
  private func setAlert(msg: String) {
    let alert =  UIAlertController(title: nil, message: msg, preferredStyle: .alert)
    let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
    alert.addAction(ok)
    present(alert, animated: true, completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    weatherTableView.delegate = self
    weatherTableView.dataSource = self
    
    setStyle()
    setCell()
    sizeHeaderToFit()
    getLocation()
  }
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    switch section {
    case 1:
      return 120
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    switch section {
    case 1:
      guard let weatherData = weatherData else { return UIView() }
      guard let hourlyView = Bundle.main.loadNibNamed("WeatherHourlyView", owner: self, options: nil)?.first as? WeatherHourlyView else { return UIView()}
      hourlyView.hourlyConfigure(hourly: weatherData.hourly)
      return hourlyView
    default:
      return nil
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      return 15
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      guard let weatherData = weatherData else { return UITableViewCell() }
      
      let cell: WeatherHeaderDetailCell = weatherTableView.dequeueReusableCell(withIdentifier: "headerDetailCell", for: indexPath) as! WeatherHeaderDetailCell
      cell.headerDetailConfigure(daily: weatherData.daily[0], current: weatherData.current)
      return cell
    case 1:
      guard let weatherData = weatherData else { return UITableViewCell() }
      var cell = UITableViewCell()
      
      if indexPath.row < weatherData.daily.count {
        let weekCell: WeatherWeekCell = weatherTableView.dequeueReusableCell(withIdentifier: "weekCell", for: indexPath) as! WeatherWeekCell
        weekCell.weekConfigure(data: weatherData, indexPath: indexPath)
        cell = weekCell
      } else if indexPath.row < weatherData.daily.count + 1 {
        let currentCell = weatherTableView.dequeueReusableCell(withIdentifier: "currentCell", for: indexPath) as! WeatherCurrentCell
        currentCell.currentConfigure(data: weatherData.current)
        cell = currentCell
      } else if indexPath.row < weatherData.daily.count + 6 {
        let detailCell = weatherTableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! WeatherDetailCell
        detailCell.detailConfigure(daily: weatherData.daily[0], current: weatherData.current, indexPath: indexPath)
        cell = detailCell
      } else {
        let locationCell = weatherTableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! WeatherLocationCell
        locationCell.locationConfigure(addressName: addressName ?? "")
        locationCell.openMapDelegate = self
        cell = locationCell
      }
      return cell
    default:
      return UITableViewCell()
    }
  }
}

extension WeatherViewController: CLLocationManagerDelegate {
  
}
