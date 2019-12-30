//
//  Bundle+Extensions.swift
//  UnsplashPhotoPicker
//
//  Created by Tysiachnik, Roman on 2021-01-05.
//  Copyright © 2021 Unsplash. All rights reserved.
//

import UIKit

extension Bundle {
    static var local: Bundle {
        #if SWIFT_PACKAGE
        return Bundle.module
        #else
        return Bundle(for: BundleToken.self)
        #endif
    }
}

private class BundleToken {}
