//
//  Weather.swift
//  Weather
//
//  Created by leeyr on 2021/05/05.
//

import Foundation

struct Weather: Codable {
  let lat: Double
  let lon: Double
  let timezone: String
  let timezone_offset: Double
  let current: Current
  let hourly: [Hourly]
  let daily: [Daily]
  
  struct Current: Codable {
    let dt: Double
    let sunrise: Double
    let sunset: Double
    let temp: Double
    let feels_like: Double
    let pressure: Double
    let humidity: Double
    let dew_point: Double
    let uvi: Double
    let clouds: Double
    let visibility: Double
    let wind_speed: Double
    let wind_deg: Double
    let wind_gust: Double?
    let weather: [CurrentWeather]
    
    struct CurrentWeather: Codable {
      let id: Double
      let main: String
      let description: String
      let icon: String
    }
  }
  
  struct Hourly: Codable {
    let dt: Double
    let temp: Double
    let feels_like: Double
    let pressure: Double
    let humidity: Double
    let dew_point: Double
    let uvi: Double
    let clouds: Double
    let visibility: Double
    let wind_speed: Double
    let wind_deg: Double
    let wind_gust: Double
    let weather: [HourlyWeather]
    let pop: Double
    
    struct HourlyWeather: Codable {
      let id: Double
      let main: String
      let description: String
      let icon: String
    }
  }
  
  struct Daily: Codable {
    let dt: Double
    let sunrise: Double
    let sunset: Double
    let moonrise: Double
    let moonset: Double
    let moon_phase: Double
    let temp: Temp
    let feels_like: FeelLike
    let pressure: Double
    let humidity: Double
    let dew_point: Double
    let wind_speed: Double
    let wind_deg: Double
    let wind_gust: Double
    let weather: [DailyWeather]
    let clouds: Double
    let pop: Double
    let rain: Double?
    let uvi: Double
    
    struct Temp: Codable {
      let day: Double
      let min: Double
      let max: Double
      let night: Double
      let eve: Double
      let morn: Double
    }
    
    struct FeelLike: Codable {
      let day: Double
      let night: Double
      let eve: Double
      let morn: Double
    }
    
    struct DailyWeather: Codable {
      let id: Double
      let main: String
      let description: String
      let icon: String
    }
  }
}

struct WeatherList: Codable {
  let latitude: Double
  let longitude: Double
  let locality: String
}
