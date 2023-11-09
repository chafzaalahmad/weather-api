//
//  UIImageView+Extension.swift
//  Weather
//
//  Created by Afzaal Ahmad on 9/18/23.
//

import UIKit
import SDWebImage

extension UIImageView {
    func loadImage(with url: URL) {
        self.sd_setImage(with: url, placeholderImage: nil, options: [.progressiveLoad])
    }
}
