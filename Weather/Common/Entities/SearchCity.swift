//
//  SearchCity.swift
//  Weather
//
//  Created by Afzaal Ahmad on 11/7/23.
//

struct SearchCity: Decodable {
    let name: String
    let lat: Double
    let lon: Double
    let state: String?
    let country: String?
}
