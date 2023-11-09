//
//  WeatherCoordinator.swift
//  Weather
//
//  Created by Afzaal Ahmad on 9/18/23.
//

import UIKit

final class WeatherCoordinator: BaseCoordinator<UINavigationController> {
    let location: Location?
    
    init(location: Location?, rootViewController: UINavigationController) {
        self.location = location
        super.init(rootViewController: rootViewController)
    }
    
    override func start() {
        guard let weatherViewController = WeatherViewControllerFactory.make(location: location) else {
            return assertionFailure()
        }
        rootViewController.pushViewController(weatherViewController, animated: true)
    }
}
