//
//  Weather.swift
//  Weather
//
//  Created by Afzaal Ahmad on 9/18/23.
//

import Foundation

struct WeatherLocation: CustomStringConvertible, Decodable {
    let id: Double
    let name: String
    let weather: [Weather]
    let main: WeatherMain
    let coord: Location
    
    /// Not in scope
    var description: String {
        return "id: \(id), name: \(name), weather: \(weather), coord: \(coord)"
    }
}

struct Weather: CustomStringConvertible, Decodable {
    
    let id: Double
    let main: String
    let description: String
    let icon: String
    
}

struct WeatherMain: CustomStringConvertible, Decodable {
    
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Double
    let humidity: Double
    
    /// Not in scope
    var description: String {
        return "temp:\(temp), feels_like: \(feels_like), temp_min: \(temp_min), temp_max: \(temp_max), pressure: \(pressure), humidity: \(humidity)"
    }
}


struct Location: CustomStringConvertible, Codable {
    let lat: Double
    let lon: Double
    
    /// Not in scope
    var description: String {
        return "lat: \(lat), lon: \(lon)"
    }
}
