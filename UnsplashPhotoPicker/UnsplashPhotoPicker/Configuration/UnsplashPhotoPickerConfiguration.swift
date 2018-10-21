//
//  UnsplashPhotoPickerConfiguration.swift
//  UnsplashPhotoPicker
//
//  Created by Bichon, Nicolas on 2018-10-09.
//  Copyright © 2018 Unsplash. All rights reserved.
//

import Foundation

public struct UnsplashPhotoPickerConfiguration {

    public var accessKey = ""
    public var secretKey = ""
    public var memoryCapacity = defaultMemoryCapacity
    public var diskCapacity = defaultDiskCapacity

    public static let defaultMemoryCapacity: Int = ImageCache.memoryCapacity
    public static let defaultDiskCapacity: Int = ImageCache.diskCapacity

    let apiURL = "https://api.unsplash.com/"
    let editorialCollectionId = "317099"

    public init(accessKey: String, secretKey: String, memoryCapacity: Int = defaultMemoryCapacity, diskCapacity: Int = defaultDiskCapacity) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.memoryCapacity = memoryCapacity
        self.diskCapacity = diskCapacity
    }

    init() {}

}
