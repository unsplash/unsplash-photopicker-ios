//
//  UnsplashPhotoExif.swift
//  Unsplash
//
//  Created by Olivier Collet on 2017-07-27.
//  Copyright © 2017 Unsplash. All rights reserved.
//

import Foundation

struct UnsplashPhotoExif: Codable {

    let aperture: String
    let exposureTime: String
    let focalLength: String
    let iso: String
    let make: String
    let model: String

    private enum CodingKeys: String, CodingKey {
        case aperture
        case exposureTime = "exposure_time"
        case focalLength = "focal_length"
        case iso
        case make
        case model
    }

}
