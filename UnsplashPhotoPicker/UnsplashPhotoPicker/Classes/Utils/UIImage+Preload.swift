//
//  UIImage+Preload.swift
//  UnsplashPhotoPicker
//
//  Created by Hendrik Kueck on 2020-09-28.
//

import UIKit

extension UIImage {

    func preloadedImage() -> UIImage {
        guard let imageRef = self.cgImage else {
            return self
        }
        let width = imageRef.width
        let height = imageRef.height
        let colourSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo: UInt32 = CGImageAlphaInfo.noneSkipLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
        guard let imageContext = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: colourSpace, bitmapInfo: bitmapInfo) else {
            return self //failed
        }
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        imageContext.draw(imageRef, in: rect)
        if let outputImage = imageContext.makeImage() {
            let cachedImage = UIImage(cgImage: outputImage, scale: scale, orientation: imageOrientation)
            return cachedImage
        }
        return self
    }

}
