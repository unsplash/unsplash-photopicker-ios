//
//  UnsplashPhotoPicker.swift
//  UnsplashPhotoPicker
//
//  Created by Bichon, Nicolas on 2018-10-09.
//  Copyright © 2018 Unsplash. All rights reserved.
//

import UIKit

public protocol UnsplashPhotoPickerDelegate: class {
    func unsplashPhotoPicker(_ photoPicker: UnsplashPhotoPicker, didSelectPhotos photos: [UnsplashPhoto])
    func unsplashPhotoPickerDidCancel(_ photoPicker: UnsplashPhotoPicker)
}

public class UnsplashPhotoPicker: UINavigationController {

    // MARK: - Properties

    private let photoPickerViewController: UnsplashPhotoPickerViewController

    public weak var photoPickerDelegate: UnsplashPhotoPickerDelegate?

    // MARK: - Lifetime

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

}

// MARK: - UnsplashPhotoPickerViewControllerDelegate
extension UnsplashPhotoPicker: UnsplashPhotoPickerViewControllerDelegate {
    func unsplashPhotoPickerViewController(_ viewController: UnsplashPhotoPickerViewController, didSelectPhotos photos: [UnsplashPhoto]) {
        dismiss(animated: true, completion: nil)

        photoPickerDelegate?.unsplashPhotoPicker(self, didSelectPhotos: photos)
    }

    func unsplashPhotoPickerViewControllerDidCancel(_ viewController: UnsplashPhotoPickerViewController) {
        dismiss(animated: true, completion: nil)

        photoPickerDelegate?.unsplashPhotoPickerDidCancel(self)
    }
}
