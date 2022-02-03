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

    // MARK: - Enumerations
    public enum NavigationBarAppearance {
        case `default`
        case opaque
        case translucent
    }
    
    public enum Usage {
        case picker, wallpaper
    }
    
    /// Your application’s access key.
    public var accessKey = ""

    /// Your application’s secret key.
    public var secretKey = ""

    /// A search query. When set, hides the search bar and shows results instead of the editorial photos.
    public var query: String?

    /// Controls whether the picker allows multiple or single selection.
    public var allowCancelButton = false
    public var allowsMultipleSelection = false
    
    /// Controls the navigation bar's appearance.
    public var navigationBarAppearance: NavigationBarAppearance = .opaque

    /// Controls the navigation bar title.
    public var title: String? = nil
    
    /// The memory capacity used by the cache.
    public var memoryCapacity = defaultMemoryCapacity

    /// The disk capacity used by the cache.
    public var diskCapacity = defaultDiskCapacity

    /// The default memory capacity used by the cache.
    public static let defaultMemoryCapacity: Int = ImageCache.memoryCapacity

    /// The default disk capacity used by the cache.
    public static let defaultDiskCapacity: Int = ImageCache.diskCapacity

    public var usage: Usage = .picker
    
    var selectAction: (UnsplashPhoto) -> Void = { _ in }
    var downloadAction: (UnsplashPhoto) -> Void = { _ in }
    
    /// The Unsplash API url.
    let apiURL = "https://api.unsplash.com/"

    /// The Unsplash editorial collection id.
    let editorialCollectionId = "317099"

    /**
     Initializes an `UnsplashPhotoPickerConfiguration` object with optionally customizable behaviors.

     - parameter accessKey:               Your application’s access key.
     - parameter secretKey:               Your application’s secret key.
     - parameter query:                   A search query.
     - parameter allowsMultipleSelection: Controls whether the picker allows multiple or single selection.
     - parameter memoryCapacity:          The memory capacity used by the cache.
     - parameter diskCapacity:            The disk capacity used by the cache.
     */
    public init(
        accessKey: String,
        secretKey: String,
        query: String? = nil,
        title: String? = nil,
        allowCancelButton: Bool = false,
        allowsMultipleSelection: Bool = false,
        memoryCapacity: Int = defaultMemoryCapacity,
        diskCapacity: Int = defaultDiskCapacity,
        navigationBarAppearance: NavigationBarAppearance = .opaque,
        usage: Usage = .picker,
        selectAction: @escaping (UnsplashPhoto) -> Void = { _ in },
        downloadAction: @escaping (UnsplashPhoto) -> Void = { _ in }
    ) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.query = query
        self.title = title
        self.allowCancelButton = allowCancelButton
        self.allowsMultipleSelection = allowsMultipleSelection
        self.memoryCapacity = memoryCapacity
        self.diskCapacity = diskCapacity
        self.navigationBarAppearance = navigationBarAppearance
        self.usage = usage
        self.selectAction = selectAction
        self.downloadAction = downloadAction
    }

    init() {}

}
