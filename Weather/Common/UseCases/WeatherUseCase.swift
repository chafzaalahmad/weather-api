//
//  WeatherUseCase.swift
//  Weather
//
//  Created by Afzaal Ahmad on 9/18/23.
//

import Foundation
import Combine

protocol LocationCacheManager {
    func getLastLocation() -> Location?
    
    func setLastLocation(location: Location?)
}

class DefaultLocationCacheManager : LocationCacheManager {
    func getLastLocation() -> Location? {
        guard let locationData = UserDefaults.standard.object(forKey: "last-location") as? Data else {
            return nil
        }
        
        return try? JSONDecoder().decode(Location.self, from: locationData)
    }
    
    func setLastLocation(location: Location?) {
        if let encoded = try? JSONEncoder().encode(location) {
            UserDefaults.standard.set(encoded, forKey: "last-location")
        }
    }
}


protocol WeatherUseCase {
    
    /// it will fetch weather information.
    /// - Returns: publisher which will be triggered once execution is completed.
    func fetchWeather(with lat: Double, lon: Double) -> AnyPublisher<WeatherLocation, Error>
}

final class NetworkWeatherUseCase: WeatherUseCase {
    private let service: NetworkService
    
    init(service: NetworkService) {
        self.service = service
    }
    
    func fetchWeather (with lat: Double, lon: Double) -> AnyPublisher<WeatherLocation, Error> {
        service.publisher(for: .weather(with: lat, lon: lon))
    }
}
