//
//  UIColor+PhotoPicker.swift
//  UnsplashPhotoPicker
//
//  Created by Olivier Collet on 2019-10-07.
//  Copyright © 2019 Unsplash. All rights reserved.
//

import UIKit

struct PhotoPickerColors {
    var background: UIColor {
        if #available(iOS 13.0, *) { return .systemBackground }
        return .white
    }
    var titleLabel: UIColor {
        if #available(iOS 13.0, *) { return .label }
        return .black
    }
    var subtitleLabel: UIColor {
        if #available(iOS 13.0, *) { return .secondaryLabel }
        return .gray
    }
}

extension UIColor {
    static let photoPicker = PhotoPickerColors()
}
