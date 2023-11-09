//
//  SearchCityCoordinator.swift
//  Weather
//
//  Created by Afzaal Ahmad on 11/7/23.
//

import UIKit

final class SearchCityCoordinator: BaseCoordinator<UINavigationController> {
    
    init(locationCacheManager: LocationCacheManager, rootViewController: UINavigationController) {
        super.init(rootViewController: rootViewController)
    }
    
    override func start() {
        guard let weatherViewController = SearchCityViewControllerFactory.make(navigator: self) else {
            return assertionFailure()
        }
        rootViewController.pushViewController(weatherViewController, animated: true)
    }
}

extension SearchCityCoordinator: SearchCityNavigator {
    func showWeatherDetail(location: Location) {
        let coordinator = WeatherCoordinator(location: location, rootViewController: rootViewController)
        
        startChild(coordinator)
    }
}
