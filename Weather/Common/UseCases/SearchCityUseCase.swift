//
//  SearchCityUseCase.swift
//  Weather
//
//  Created by Afzaal Ahmad on 11/7/23.
//

import Foundation
import Combine

protocol SearchCityUseCase {
    var locationCacheManager: LocationCacheManager? { get }
    
    func setLocation(location: Location)
    
    func fetchCities(with query: String) -> AnyPublisher<[SearchCity], Error>
}

final class NetworkSearchCityUseCase: SearchCityUseCase {
    func setLocation(location: Location) {
        self.locationCacheManager?.setLastLocation(location: location)
    }
    
    internal var locationCacheManager: LocationCacheManager?
    
    private let service: NetworkService

    init(service: NetworkService = URLSession.shared, locationCacheManager: LocationCacheManager?) {
        self.service = service
        self.locationCacheManager = locationCacheManager
    }

    func fetchCities(with query: String) -> AnyPublisher<[SearchCity], Error> {
        service.publisher(for: .cities(with: query + ", US"))
    }
}
