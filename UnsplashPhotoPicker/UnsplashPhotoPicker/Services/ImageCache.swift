//
//  ImageCache.swift
//  UnsplashPhotoPicker
//
//  Created by Bichon, Nicolas on 2018-10-15.
//  Copyright © 2018 Unsplash. All rights reserved.
//

import UIKit

class ImageCache {
    static let cache = URLCache(memoryCapacity: 50.megabytes, diskCapacity: 100.megabytes, diskPath: "unsplash")
}

private extension Int {
    var megabytes: Int { return self * 1024 * 1024 }
}
