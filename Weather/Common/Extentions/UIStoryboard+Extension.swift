//
//  UIStoryboard+Extension.swift
//  Weather
//
//  Created by Afzaal Ahmad on 9/18/23.
//

import UIKit

extension UIStoryboard {
    enum Name: String {
        case weather = "Weather"
        case searchCity = "SearchCity"
    }
    
    convenience init(name: Name, bundle: Bundle? = nil) {
        self.init(name: name.rawValue, bundle: bundle)
    }
}
