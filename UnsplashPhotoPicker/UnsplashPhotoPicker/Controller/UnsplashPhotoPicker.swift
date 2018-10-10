//
//  UnsplashPhotoPicker.swift
//  UnsplashPhotoPicker
//
//  Created by Bichon, Nicolas on 2018-10-09.
//  Copyright © 2018 Unsplash. All rights reserved.
//

import UIKit

public class UnsplashPhotoPicker: UINavigationController {

    // MARK: - Properties

    private let photoPickerViewController: UnsplashPhotoPickerViewController

    // MARK: - Lifetime

    public init(configuration: UnsplashPhotoPickerConfiguration) {
        Configuration.shared = configuration

        self.photoPickerViewController = UnsplashPhotoPickerViewController()

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle

    override public func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.isTranslucent = false
        viewControllers = [photoPickerViewController]
    }

}
