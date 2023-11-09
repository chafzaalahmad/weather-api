//
//  WeatherViewControllerFactory.swift
//  Weather
//
//  Created by Afzaal Ahmad on 9/18/23.
//

import UIKit

final class WeatherViewControllerFactory {
    static func make(location: Location?) -> WeatherViewController? {
        let storyboard = UIStoryboard(name: .weather )
        let useCase: WeatherUseCase = DIContainer.resolve()
        let controller = storyboard.instantiateInitialViewController { coder in
            WeatherViewController(coder: coder, viewModel: .init(weatherUseCase: useCase, location: location))
        }
        
        return controller
    }
}
