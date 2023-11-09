//
//  AppDIContainer.swift
//  Weather
//
//  Created by Afzaal Ahmad on 9/18/23.
//

import Foundation
import Swinject

let DIContainer = AppDIContainer.shared

///`AppDIContainer` is responsible to create/manage all dependencies of the application.
final class AppDIContainer {
    static let shared = AppDIContainer()
    
    // MARK:- Private Properties
    
    private let container = Container()
    
    // MARK:- Init
    
    private init(){
        //Register dependencies
        
        container.register(NetworkService.self) { _  in URLSession.shared }.inObjectScope(.container)
        container.register(LocationCacheManager.self) { _  in DefaultLocationCacheManager() }.inObjectScope(.container)
        container.register(WeatherUseCase.self) { resolver  in
            guard let service = resolver.resolve(NetworkService.self) else {
                fatalError("NetworkService dependency not found!")
            }
            
            return NetworkWeatherUseCase(service: service)
        }.inObjectScope(.container)
        container.register(SearchCityUseCase.self) { resolver  in
            guard let service = resolver.resolve(NetworkService.self) else {
                fatalError("NetworkService dependency not found!")
            }
            
            return NetworkSearchCityUseCase(service: service, locationCacheManager: resolver.resolve(LocationCacheManager.self))
        }.inObjectScope(.container)
        
    }
    
    /// Generic function which will resolve the dependency of type T.
    /// - Returns: object of type T from the container.
    func resolve<T>() -> T {
        guard let object = container.resolve(T.self) else {
            fatalError("Can't resolve dependency of type \(T.self) ")
        }
        
        return object
    }
}
