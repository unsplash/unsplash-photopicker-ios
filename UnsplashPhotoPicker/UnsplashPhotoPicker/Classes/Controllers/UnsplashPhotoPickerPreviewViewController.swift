//
//  UnsplashPhotoPickerPreviewViewController.swift
//  UnsplashPhotoPicker
//
//  Created by Bichon, Nicolas on 2018-11-04.
//  Copyright © 2018 Unsplash. All rights reserved.
//

import UIKit

class UnsplashPhotoPickerPreviewViewController: UIViewController {

    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        return imageView
    }()

    private let image: UIImage

    init(image: UIImage) {
        self.image = image

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPhotoImageView()
    }

    private func setupPhotoImageView() {
        view.addSubview(photoImageView)

        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: view.topAnchor),
            photoImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            photoImageView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }

}
