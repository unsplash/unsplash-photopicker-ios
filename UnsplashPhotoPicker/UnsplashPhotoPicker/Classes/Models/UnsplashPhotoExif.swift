//
//  UnsplashPhotoExif.swift
//  Unsplash
//
//  Created by Olivier Collet on 2017-07-27.
//  Copyright © 2017 Unsplash. All rights reserved.
//

import Foundation

/// A struct representing exif informations of a photo from the Unsplash API.
public struct UnsplashPhotoExif: Codable {

    public let aperture: String
    public let exposureTime: String
    public let focalLength: String
    public let iso: String
    public let make: String
    public let model: String

    private enum CodingKeys: String, CodingKey {
        case aperture
        case exposureTime = "exposure_time"
        case focalLength = "focal_length"
        case iso
        case make
        case model
    }

}
