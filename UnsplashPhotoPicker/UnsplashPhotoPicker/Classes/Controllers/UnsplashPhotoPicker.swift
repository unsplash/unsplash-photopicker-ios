//
//  UnsplashPhotoPicker.swift
//  UnsplashPhotoPicker
//
//  Created by Bichon, Nicolas on 2018-10-09.
//  Copyright © 2018 Unsplash. All rights reserved.
//

import UIKit

/// A protocol describing an object that can be notified of events from UnsplashPhotoPicker.
public protocol UnsplashPhotoPickerDelegate: class {

    /**
     Notifies the delegate that UnsplashPhotoPicker has selected photos.

     - parameter photoPicker: The `UnsplashPhotoPicker` instance responsible for selecting the photos.
     - parameter photos:      The selected photos.
     */
    func unsplashPhotoPicker(_ photoPicker: UnsplashPhotoPicker, didSelectPhotos photos: [UnsplashPhoto])

    /**
     Notifies the delegate that UnsplashPhotoPicker has been canceled.

     - parameter photoPicker: The `UnsplashPhotoPicker` instance responsible for selecting the photos.
     */
    func unsplashPhotoPickerDidCancel(_ photoPicker: UnsplashPhotoPicker)
}

/// `UnsplashPhotoPicker` is an object that can be used to select photos from Unsplash.
public class UnsplashPhotoPicker: UINavigationController {

    // MARK: - Properties

    private let photoPickerViewController: UnsplashPhotoPickerViewController

    /// A delegate that is notified of significant events.
    public weak var photoPickerDelegate: UnsplashPhotoPickerDelegate?

    // MARK: - Lifetime

    /**
     Initializes an `UnsplashPhotoPicker` object with a configuration.

     - parameter configuration: The configuration struct that specifies how UnsplashPhotoPicker should be configured.
     */
    public init(configuration: UnsplashPhotoPickerConfiguration) {
        Configuration.shared = configuration

        self.photoPickerViewController = UnsplashPhotoPickerViewController()

        super.init(nibName: nil, bundle: nil)

        photoPickerViewController.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.isTranslucent = false
        viewControllers = [photoPickerViewController]
    }

    // MARK: - Download tracking

    private func trackDownloads(for photos: [UnsplashPhoto]) {
        for photo in photos {
            if let downloadLocationURL = photo.links[.downloadLocation]?.appending(queryItems: [URLQueryItem(name: "client_id", value: Configuration.shared.accessKey)]) {
                URLSession.shared.dataTask(with: downloadLocationURL).resume()
            }
        }
    }

}

// MARK: - UnsplashPhotoPickerViewControllerDelegate
extension UnsplashPhotoPicker: UnsplashPhotoPickerViewControllerDelegate {
    func unsplashPhotoPickerViewController(_ viewController: UnsplashPhotoPickerViewController, didSelectPhotos photos: [UnsplashPhoto]) {
        trackDownloads(for: photos)
        photoPickerDelegate?.unsplashPhotoPicker(self, didSelectPhotos: photos)
        dismiss(animated: true, completion: nil)
    }

    func unsplashPhotoPickerViewControllerDidCancel(_ viewController: UnsplashPhotoPickerViewController) {
        photoPickerDelegate?.unsplashPhotoPickerDidCancel(self)
        dismiss(animated: true, completion: nil)
    }
}
