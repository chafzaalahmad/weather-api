//
//  SearchCityContentView.swift
//  Weather
//
//  Created by Afzaal Ahmad on 11/8/23.
//

import SwiftUI

class SearchCityData: ObservableObject {
    @Published var searchCities: [SeachCityRowViewModel]
    
    init(searchCities: [SeachCityRowViewModel]) {
        self.searchCities = searchCities
    }
}

struct SearchCityContentView: View {

    let viewModel: SearchCityViewModel?
    
    @ObservedObject var data: SearchCityData
    
    @State private var searchTerm = ""
    
    var body: some View {
        NavigationStack {
            List(data.searchCities, id: \.id) { city in
                CityRow(city: city).buttonStyle(PlainButtonStyle())
                    .onTapGesture {
                        viewModel?.didSelectLocation(location: Location(lat: city.lat, lon: city.lon))
                    }
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .searchable(text: $searchTerm, prompt: "Search City")
        .onChange(of: searchTerm) { value in
            Task.init {
                viewModel?.searchQuery = value
            }
        }
        
    }
    
    struct CityRow: View {
        let city: SeachCityRowViewModel
        var body: some View {
            HStack {
                Text(city.name).font(.title).fontWeight(.bold)
                Spacer()
                Text(city.state ?? "").fontWeight(.light)
                Text(city.country ?? "").fontWeight(.light).foregroundStyle(.secondary)
            }
        }
    }
}


#Preview {
    let cities = [
        SeachCityRowViewModel(id: "1", name: "Elmont 1", lat: 1, lon: 1, state: "NY", country: "USA"),
        SeachCityRowViewModel(id: "2", name: "Elmont 2", lat: 2, lon: 1, state: "NY", country: "USA"),
        SeachCityRowViewModel(id: "3", name: "Elmont 3", lat: 3, lon: 1, state: "NY", country: "USA"),
        SeachCityRowViewModel(id: "4", name: "Elmont 4", lat: 4, lon: 1, state: "NY", country: "USA"),
        SeachCityRowViewModel(id: "5", name: "Elmont 5", lat: 5, lon: 1, state: "NY", country: "USA"),
        SeachCityRowViewModel(id: "6", name: "Deonton", lat: 5, lon: 1, state: "TX", country: "USA")
    ]
    return SearchCityContentView(viewModel: nil, data: SearchCityData(searchCities: cities))
}
