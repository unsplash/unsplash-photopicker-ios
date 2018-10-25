//
//  UnsplashPhotoPickerConfiguration.swift
//  UnsplashPhotoPicker
//
//  Created by Bichon, Nicolas on 2018-10-09.
//  Copyright © 2018 Unsplash. All rights reserved.
//

import Foundation

/// Encapsulates configuration information for the behavior of UnsplashPhotoPicker.
public struct UnsplashPhotoPickerConfiguration {

    /// Your application’s access key.
    public var accessKey = ""

    /// Your application’s secret key.
    public var secretKey = ""

    /// The memory capacity used by the cache.
    public var memoryCapacity = defaultMemoryCapacity

    /// The disk capacity used by the cache.
    public var diskCapacity = defaultDiskCapacity

    /// The default memory capacity used by the cache.
    public static let defaultMemoryCapacity: Int = ImageCache.memoryCapacity

    /// The default disk capacity used by the cache.
    public static let defaultDiskCapacity: Int = ImageCache.diskCapacity

    /// The Unsplash API url.
    let apiURL = "https://api.unsplash.com/"

    /// The Unsplash editorial collection id.
    let editorialCollectionId = "317099"

    /**
     Initializes an `UnsplashPhotoPickerConfiguration` object with optionally customizable behaviors.

     - parameter accessKey:      Your application’s access key.
     - parameter secretKey:      Your application’s secret key.
     - parameter memoryCapacity: The memory capacity used by the cache.
     - parameter diskCapacity:   The disk capacity used by the cache.
     */
    public init(accessKey: String, secretKey: String, memoryCapacity: Int = defaultMemoryCapacity, diskCapacity: Int = defaultDiskCapacity) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.memoryCapacity = memoryCapacity
        self.diskCapacity = diskCapacity
    }

    init() {}

}
