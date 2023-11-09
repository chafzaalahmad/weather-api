//
//  SearchCityViewControllerFactory.swift
//  Weather
//
//  Created by Afzaal Ahmad on 11/7/23.
//

import UIKit

final class SearchCityViewControllerFactory {
    static func make(navigator: SearchCityNavigator) -> SearchCityViewController? {
        let storyboard = UIStoryboard(name: .searchCity )
        let useCase: SearchCityUseCase = DIContainer.resolve()
        let controller = storyboard.instantiateInitialViewController { coder in
            SearchCityViewController(coder: coder, viewModel: .init(useCase: useCase, navigator: navigator))
        }
        
        return controller
    }
}
