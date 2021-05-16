//
//  WeatherListViewController.swift
//  Weather
//
//  Created by leeyr on 2021/05/13.
//

import UIKit
import CoreData

class WeatherListViewController: UIViewController, presentSearchDelegate, ReloadWeatherListDelegate, PresentWeatherMainDelegate {
  @IBOutlet private weak var weatherListTableView: UITableView!
  var weatherListData: [NSManagedObject] = []

  private func fetch() {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Location")
    let result = try! context.fetch(fetchRequest)
    weatherListData = result
    weatherListTableView.reloadData()
  }
  
  private func delete(object: NSManagedObject) -> Bool {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    
    context.delete(object)
    
    do {
      try context.save()
      return true
    } catch {
      context.rollback()
      return false
    }
  }
  
  private func setStyle() {
    weatherListTableView.separatorStyle = .none
  }
  
  private func setCell() {
    let listCellNib: UINib = UINib.init(nibName: "WeatherListCell", bundle: nil)
    weatherListTableView.register(listCellNib, forCellReuseIdentifier: "listCell")
    
    let listBottomCellNib: UINib = UINib.init(nibName: "WeatherListBottomCell", bundle: nil)
    weatherListTableView.register(listBottomCellNib, forCellReuseIdentifier: "listBottomCell")
  }
  
  func realodWeatherList() {
    fetch()
  }
  
  func presentWeatherMain(latitude: Double?, longitude: Double?) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "weatherMain") as! WeatherViewController
    vc.latitude = latitude
    vc.longitude = longitude
    vc.isMain = true
    vc.isInitialized = false
    vc.modalPresentationStyle = .fullScreen
    present(vc, animated: true)
  }
  
  func presentSearch() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "weatherSearch") as! WeatherSearchViewController
    vc.reloadWeatherListDelegate = self
    present(vc, animated: true)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    weatherListTableView.delegate = self
    weatherListTableView.dataSource = self
    
    setCell()
    setStyle()
    fetch()
  }
}

extension WeatherListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return weatherListData.count + 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == weatherListData.count {
      let cell: WeatherListBottomCell = weatherListTableView.dequeueReusableCell(withIdentifier: "listBottomCell", for: indexPath) as! WeatherListBottomCell
      cell.presentSearchDelegate = self
      return cell
    } else {
      let listData = weatherListData[indexPath.row]
      let cell: WeatherListCell = weatherListTableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! WeatherListCell
      cell.listConfigure(latitude: listData.value(forKey: "latitude") as? Double, longitude: listData.value(forKey: "longitude") as? Double, locality: listData.value(forKey: "locality") as? String)
      cell.presentWeatherMainDelegate = self
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let object = self.weatherListData[indexPath.row]
      if self.delete(object: object) {
        weatherListData.remove(at: indexPath.row)
        weatherListTableView.deleteRows(at: [indexPath], with: .automatic)
      }
    }
  }
}
