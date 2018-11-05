//
//  PhotoCollectionViewCell.swift
//  Example
//
//  Created by Bichon, Nicolas on 2018-10-25.
//  Copyright © 2018 Unsplash. All rights reserved.
//

import UIKit
import UnsplashPhotoPicker

class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var photoImageView: UIImageView!

    private var imageDataTask: URLSessionDataTask?
    private static var cache = URLCache(memoryCapacity: 50 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: "unsplash")

    func downloadPhoto(_ photo: UnsplashPhoto) {
        guard let url = photo.urls[.regular] else { return }

        if let cachedResponse = PhotoCollectionViewCell.cache.cachedResponse(for: URLRequest(url: url)),
            let image = UIImage(data: cachedResponse.data) {
            photoImageView.image = image
            return
        }

        imageDataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            guard let strongSelf = self else { return }

            strongSelf.imageDataTask = nil

            guard let data = data, let image = UIImage(data: data), error == nil else { return }

            DispatchQueue.main.async {
                UIView.transition(with: strongSelf.photoImageView, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                    strongSelf.photoImageView.image = image
                }, completion: nil)
            }
        }

        imageDataTask?.resume()
    }

}
