//
//  ImageDownloader.swift
//  UnsplashPhotoPicker
//
//  Created by Bichon, Nicolas on 2018-10-15.
//  Copyright © 2018 Unsplash. All rights reserved.
//

import UIKit
import os

class ImageDownloader {

    private var imageDataTask: URLSessionDataTask?
    private let cache = ImageCache.cache

    func downloadPhoto(with url: URL, cachedImage: @escaping ((UIImage?) -> Void), downloadedImage: @escaping ((UIImage?) -> Void)) {
        guard imageDataTask == nil else { return }

        if let cachedResponse = cache.cachedResponse(for: URLRequest(url: url)),
            let image = UIImage(data: cachedResponse.data) {

            DispatchQueue.main.async {
                cachedImage(image)
            }

            return
        }

        imageDataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let strongSelf = self else { return }
            strongSelf.imageDataTask = nil

            if let error = error { return os_log("%@", log: .default, type: .error, error.localizedDescription) }
            guard let data = data, let response = response, let image = UIImage(data: data) else { return }

            let cachedResponse = CachedURLResponse(response: response, data: data)
            strongSelf.cache.storeCachedResponse(cachedResponse, for: URLRequest(url: url))

            DispatchQueue.main.async {
                downloadedImage(image)
            }
        }

        imageDataTask?.resume()
    }

}
