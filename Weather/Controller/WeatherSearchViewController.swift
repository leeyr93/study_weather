//
//  WeatherSearchViewController.swift
//  Weather
//
//  Created by leeyr on 2021/05/13.
//

import UIKit
import MapKit
import CoreLocation

protocol ReloadWeatherListDelegate: class {
  func realodWeatherList()
}

class WeatherSearchViewController: UIViewController, DismissSearchDelegate {
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var searchResultTableView: UITableView!
  
  weak var reloadWeatherListDelegate: ReloadWeatherListDelegate?
  
  private var searchCompleter = MKLocalSearchCompleter()
  private var searchResults = [MKLocalSearchCompletion]()
  
  func dismissSearch() {
    self.dismiss(animated: true) {
      self.reloadWeatherListDelegate?.realodWeatherList()
    }
  }
  
  private func setCell() {
    let searchCellNib: UINib = UINib.init(nibName: "WeatherSearchCell", bundle: nil)
    searchResultTableView.register(searchCellNib, forCellReuseIdentifier: "searchCell")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    searchBar.delegate = self
    searchBar.showsCancelButton = true
    searchBar.becomeFirstResponder()
    searchCompleter.delegate = self
    searchCompleter.resultTypes = .address
    searchResultTableView.dataSource = self
    searchResultTableView.delegate = self
    
    setCell()
  }
}

extension WeatherSearchViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText == "" {
      searchResults.removeAll()
      searchResultTableView.reloadData()
    } else {
      searchCompleter.queryFragment = searchText
    }
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    self.dismiss(animated: true, completion: nil)
  }
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    let cancelButton = searchBar.value(forKey: "cancelButton") as! UIButton
    cancelButton.setTitle("취소", for: .normal)
    cancelButton.setTitleColor(.gray, for: .normal)
  }
}

extension WeatherSearchViewController: MKLocalSearchCompleterDelegate {
  func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
    searchResults = completer.results
    searchResultTableView.reloadData()
  }
  
  func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
    print("error : \(error)")
  }
}

extension WeatherSearchViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return searchResults.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = searchResultTableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
    let searchResult = searchResults[indexPath.row]
    cell.textLabel?.text = searchResult.title
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedResult = searchResults[indexPath.row]
    let searchRequest = MKLocalSearch.Request(completion: selectedResult)
    
    let search = MKLocalSearch(request: searchRequest)
    search.start { (response, error) in
      guard let response = response else {
        print(error?.asAFError ?? "")
        return
      }
      
      for item in response.mapItems {
        if let name = item.name,
           let location = item.placemark.location {
          let storyboard = UIStoryboard(name: "Main", bundle: nil)
          let weatherVC = storyboard.instantiateViewController(withIdentifier: "weatherMain") as! WeatherViewController
          weatherVC.latitude = location.coordinate.latitude
          weatherVC.longitude = location.coordinate.longitude
          weatherVC.addressLocality = name
          weatherVC.isMain = false
          weatherVC.isInitialized = false
          weatherVC.dismissSearchDelegate = self
          self.present(weatherVC, animated: true)
        }
      }
    }
  }
}

extension WeatherSearchViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    self.searchBar.resignFirstResponder()
  }
}
