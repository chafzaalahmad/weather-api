//
//  LocationManager.swift
//  Weather
//
//  Created by Afzaal Ahmad on 9/19/23.
//


import CoreLocation

class UserLocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    @Published var isLoading = false
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func requestLocation() {
        if CLLocationManager.locationServicesEnabled() {
            switch manager.authorizationStatus
            {
            case .notDetermined,.authorizedAlways, .authorizedWhenInUse:
                manager.requestWhenInUseAuthorization()
                manager.startUpdatingLocation()
                isLoading = true
            case .restricted, .denied:
                isLoading = false
            @unknown default:
                isLoading = false
            }
            
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        location = locations.first?.coordinate
        isLoading = false
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        isLoading = false
    }
}
