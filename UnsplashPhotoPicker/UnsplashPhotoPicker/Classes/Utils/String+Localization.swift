//
//  NSLocalizedString+Extensions.swift
//  UnsplashPhotoPicker
//
//  Created by Bichon, Nicolas on 2018-11-04.
//  Copyright © 2018 Unsplash. All rights reserved.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle(for: UnsplashPhotoPicker.self), comment: "")
    }
}
