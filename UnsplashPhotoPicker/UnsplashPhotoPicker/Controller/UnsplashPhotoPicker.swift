//
//  UnsplashPhotoPicker.swift
//  UnsplashPhotoPicker
//
//  Created by Bichon, Nicolas on 2018-10-09.
//  Copyright © 2018 Unsplash. All rights reserved.
//

import UIKit

public class UnsplashPhotoPicker: UINavigationController {

    private let photoPickerViewController: UnsplashPhotoPickerViewController

    public init() {
        self.photoPickerViewController = UnsplashPhotoPickerViewController()

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.isTranslucent = false
        viewControllers = [photoPickerViewController]
    }

}
