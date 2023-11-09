//
//  SearchCityViewModel.swift
//  Weather
//
//  Created by Afzaal Ahmad on 11/7/23.
//

import Foundation
import Combine

enum SearchCityViewState: Equatable {
    case message(String)
    case showRows([SeachCityRowViewModel])
}

protocol SearchCityNavigator {
    func showWeatherDetail(location: Location)
}

final class SearchCityViewModel {
    let screenTitle = NSLocalizedString("cities_screen_title", comment: "")
    let searchTextFieldPlaceHolder = NSLocalizedString("cities_screen_search_filed_place_holder", comment: "")

    private(set) lazy var output = outputSubject.receive(on: DispatchQueue.main).eraseToAnyPublisher()


    //MARK: - Private Properties
    private let outputSubject = PassthroughSubject<SearchCityViewState, Never>()
    private var cancellable = Set<AnyCancellable>()
    private var cities: [SearchCity] = []
    private let useCase: SearchCityUseCase
    private let navigator: SearchCityNavigator
    private var isLoading = false

    @Published var searchQuery: String = String()

    init(useCase: SearchCityUseCase, navigator: SearchCityNavigator) {
        self.useCase = useCase
        self.navigator = navigator
        configSearchQuery()
    }

    private func configSearchQuery(){
        $searchQuery
            // debounces the string publisher, such that it delays the process of sending request to remote server.
            .debounce(for: .milliseconds(700), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { (_) in
                    //
            } receiveValue: { [self] (query) in
                if query.isEmpty {
                    self.process([])
                }
                else {
                    fetchCities(query: query)
                }
                
            }.store(in: &cancellable)
    }

    // MARK: - Public Methods

    //MARK: - Public Methods
    
    func viewDidLoad() {
        
    }
    
    func didSelectLocation(location: Location){
        navigator.showWeatherDetail(location: location)
        self.saveSelectedLocation(location: location)
    }
    
    private func saveSelectedLocation(location: Location) {
        self.useCase.setLocation(location: location)
    }

    // MARK: - Private Methods

    private func fetchCities(query: String){
        isLoading = true

        useCase.fetchCities(with: query)
            .sink { [weak self] completion in
                self?.isLoading = false
                guard case let .failure(error) = completion else {
                    return
                }

                self?.outputSubject.send(.message(error.localizedDescription))
            } receiveValue: { [weak self] response in
                self?.isLoading = false
                self?.process(response)
            }.store(in: &cancellable)
    }

    private func process(_ response: [SearchCity]) {
        let cities = response
        let rows = cities.map { city in
            let id = "\(city.name) \(city.lat) \(city.lon)"
            return SeachCityRowViewModel(id: id, name: city.name, lat: city.lat, lon: city.lon, state: city.state, country: city.country)
        }
        self.cities = cities

        outputSubject.send(.showRows(rows))
    }

}
