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

    let apiURL = "https://api.unsplash.com/"
    let editorialCollectionId = "317099"

    public init(accessKey: String, secretKey: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
    }

    init() {}

}
