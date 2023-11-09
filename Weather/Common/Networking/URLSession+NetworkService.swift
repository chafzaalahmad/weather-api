//
//  URLSession+NetworkService.swift
//  Weather
//
//  Created by Afzaal Ahmad on 9/18/23.
//

import Foundation
import Combine

extension Endpoint {
    func makeRequest() -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/" + path
        
        var queryItems = queryItems
        queryItems.append(URLQueryItem(name: "appid", value: "6286b55826a54716e4669834dc867e00"))
        components.queryItems = queryItems
        
        
        // If either the path or the query items passed contained
        // invalid characters, we'll get a nil URL back:
        guard let url = components.url else {
            return nil
        }
        
        return URLRequest(url: url)
    }
}

struct InvalidEndpointError: LocalizedError {
    let endpoint: Endpoint
}

extension URLSession: NetworkService {
    func publisher<T: Decodable>(
        for endpoint: Endpoint,
        decoder: JSONDecoder = .init()
    ) -> AnyPublisher<T, Error> {
        guard let request = endpoint.makeRequest() else {
            let error = InvalidEndpointError(endpoint: endpoint)
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}

