//
//  ViewController.swift
//  Example
//
//  Created by Bichon, Nicolas on 2018-10-08.
//  Copyright © 2018 Unsplash. All rights reserved.
//

import UIKit
import UnsplashPhotoPicker
import os

class ViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var imageView: UIImageView!

    private var imageDataTask: URLSessionDataTask?

    // MARK: - Action

    @IBAction func presentUnsplashPhotoPicker(sender: AnyObject?) {
        let configuration = UnsplashPhotoPickerConfiguration(
            accessKey: "<YOUR_ACCESS_KEY>",
            secretKey: "<YOUR_SECRET_KEY>",
            allowsMultipleSelection: true
        )
        let unsplashPhotoPicker = UnsplashPhotoPicker(configuration: configuration)
        unsplashPhotoPicker.photoPickerDelegate = self

        present(unsplashPhotoPicker, animated: true, completion: nil)
    }

    private func downloadPhoto(_ photo: UnsplashPhoto) {
        guard let url = photo.urls[.regular] else { return }

        imageDataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let strongSelf = self else { return }

            strongSelf.imageDataTask = nil

            if let error = error { return os_log("%@", log: .default, type: .error, error.localizedDescription) }

            guard let data = data, let image = UIImage(data: data) else { return }

            DispatchQueue.main.async {
                UIView.transition(with: strongSelf.imageView, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                    strongSelf.imageView.image = image
                }, completion: nil)
            }
        }

        imageDataTask?.resume()
    }

}

// MARK: - UnsplashPhotoPickerDelegate
extension ViewController: UnsplashPhotoPickerDelegate {
    func unsplashPhotoPicker(_ photoPicker: UnsplashPhotoPicker, didSelectPhotos photos: [UnsplashPhoto]) {
        print("Unsplash photo picker did select photos: \(photos)")

        guard let photo = photos.first else { return }

        downloadPhoto(photo)
    }

    func unsplashPhotoPickerDidCancel(_ photoPicker: UnsplashPhotoPicker) {
        print("Unsplash photo picker did cancel")
    }
}

