//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Afzaal Ahmad on 9/18/23.
//

import Foundation
import Combine
import CoreLocation

struct WeatherViewContent: Equatable {
    let temperature: String
    let weatherCitiName: String
    let fullDayTemperature: String
    let description: String
    let weatherIconUrl: URL?
}

enum WeatherViewState {
    case loading(Bool)
    case message(String)
    case weather(WeatherViewContent)
}

final class WeatherViewModel {
    //MARK: - Public Properties
    
    var location: Location? {
        didSet {
            DispatchQueue.main.async {
                if let location = self.location {
                    self.fetchWeather(location: location)
                }
                else {
                    return self.outputSubject.send(.message(NSLocalizedString("empty_state_text", comment: "")))
                }
            }
        }
    }
    
    let screenTitle = NSLocalizedString("weather_screen_title", comment: "")
    
    
    //MARK: - Private Properties
    private var locationManager: UserLocationManager?
    
    private(set) lazy var output = outputSubject.eraseToAnyPublisher()
    private var cancellable = Set<AnyCancellable>()
    
    private let currentDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSS-hh:mm"
    private let applicableDateFormat = "yyyy-MM-dd"
    private let dateFormatter: DateFormatter = DateFormatter()
    private let outputSubject = PassthroughSubject<WeatherViewState, Never>()
    private var weathers: [Weather]?
    
    private lazy var formatter: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .temperatureWithoutUnit
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 1
        numberFormatter.roundingMode = .halfUp
        formatter.numberFormatter = numberFormatter
        return formatter
    }()
    
    private let weatherUseCase: WeatherUseCase
    
    //MARK: - Init
    
    init(weatherUseCase: WeatherUseCase, location: Location?) {
        self.weatherUseCase = weatherUseCase
        self.location = location
    }
    
    //MARK: - Public Methods
    
    func viewDidLoad() {
        if let location = self.location {
            fetchWeather(location: location)
        }
    }
    
    func fetchWeather(location: Location){
        outputSubject.send(.loading(true))
        weatherUseCase.fetchWeather(with: location.lat, lon: location.lon)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.outputSubject.send(.loading(false))
                
                guard case let .failure(error) = completion else {
                    return
                }
                
                self?.outputSubject.send(.message(error.localizedDescription))
            } receiveValue: { [weak self] location in
                self?.outputSubject.send(.loading(false))
                self?.process(with: location)
            }
            .store(in: &cancellable)
    }
    
    //MARK: - Private Methods
    
    private func process(with location: WeatherLocation) {
        guard let weather = location.weather.first else {
            return outputSubject.send(.message(NSLocalizedString("empty_state_text", comment: "")))
        }
        
        let temperature = Measurement(value: location.main.temp, unit: UnitTemperature.fahrenheit)
        let minTemperature = Measurement(value: location.main.temp_min, unit: UnitTemperature.fahrenheit)
        let maxTemperature = Measurement(value: location.main.temp_max, unit: UnitTemperature.fahrenheit)
        self.weathers = location.weather
        
        outputSubject.send(
            .weather(
                .init(
                    temperature: formatter.string(from: temperature),
                    weatherCitiName: location.name,
                    fullDayTemperature: "L: \(formatter.string(from: minTemperature)) H: \(formatter.string(from: maxTemperature))", description: weather.main, weatherIconUrl: URL(string: "https://openweathermap.org/img/wn/\(weather.icon)@2x.png")
                )
            )
        )
    }
}
