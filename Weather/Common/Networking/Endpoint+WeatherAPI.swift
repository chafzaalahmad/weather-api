//
//  Endpoint+WeatherAPI.swift
//  Weather
//
//  Created by Afzaal Ahmad on 9/18/23.
//

import Foundation

extension Endpoint {
    static func weather(with lat: Double, lon: Double) -> Self {
        let queryItems = [URLQueryItem(name: "lat", value: "\(lat)"),
                      URLQueryItem(name: "lon", value: "\(lon)"),
                      URLQueryItem(name: "units", value: "Imperial")
                    ]
        
        return .init(path: "data/2.5/weather", queryItems: queryItems)
    }
    
    static func cities(with query: String) -> Self {
        let queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "limit", value: "10")
        ]
            
        return .init(path: "geo/1.0/direct", queryItems: queryItems)
    }
}
