//
//  ImageDownloader.swift
//  UnsplashPhotoPicker
//
//  Created by Bichon, Nicolas on 2018-10-15.
//  Copyright © 2018 Unsplash. All rights reserved.
//

import UIKit

class ImageDownloader {

    private var imageDataTask: URLSessionDataTask?
    private let cache = ImageCache.cache

    func downloadPhoto(with url: URL, completion: @escaping ((UIImage?, Bool) -> Void)) {

        if let cachedResponse = cache.cachedResponse(for: URLRequest(url: url)),
            let image = UIImage(data: cachedResponse.data) {
            completion(image, true)
            return
        }

        imageDataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let strongSelf = self else { return }
            strongSelf.imageDataTask = nil

            guard let data = data, let response = response, let image = UIImage(data: data), error == nil else { return }

            let cachedResponse = CachedURLResponse(response: response, data: data)
            strongSelf.cache.storeCachedResponse(cachedResponse, for: URLRequest(url: url))

            // Decode the JPEG image in a background thread
            DispatchQueue.global(qos: .userInteractive).async {
                let decodedImage = image.preloadedImage()
                DispatchQueue.main.async {
                    completion(decodedImage, false)
                }
            }
        }

        imageDataTask?.resume()
    }

    func cancel() {
        imageDataTask?.cancel()
    }

}
