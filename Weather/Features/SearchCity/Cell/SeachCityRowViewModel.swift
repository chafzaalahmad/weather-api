//
//  SeachCityRowViewModel.swift
//  Weather
//
//  Created by Afzaal Ahmad on 11/7/23.
//

import Foundation


struct SeachCityRowViewModel: Hashable {
    let id: String
    let name: String
    let lat: Double
    let lon: Double
    let state: String?
    let country: String?
}
