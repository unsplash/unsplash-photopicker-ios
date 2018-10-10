//
//  PhotoView.swift
//  Unsplash
//
//  Created by Olivier Collet on 2017-11-06.
//  Copyright © 2017 Unsplash. All rights reserved.
//

import UIKit
import os

class PhotoView: UIView {

    static var nib: UINib { return UINib(nibName: "PhotoView", bundle: Bundle(for: PhotoView.self)) }

    private var imageDataTask: URLSessionDataTask?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet var overlayViews: [UIView]!

    var showsUsername = true {
        didSet {
            userNameLabel.alpha = showsUsername ? 1 : 0
            gradientView.alpha = showsUsername ? 1 : 0
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        accessibilityIgnoresInvertColors = true
        gradientView.setColors([
            GradientView.Color(color: .clear, location: 0),
            GradientView.Color(color: UIColor(white: 0, alpha: 0.4), location: 1)
        ])
    }

    func prepareForReuse() {
        userNameLabel.text = nil
        imageView.backgroundColor = .clear
        imageView.image = nil
    }

    func configure(with photo: UnsplashPhoto, showsUsername: Bool = true) {
        self.showsUsername = showsUsername
        userNameLabel.text = photo.user.displayName
        imageView.backgroundColor = photo.color

        downloadImage(with: photo)
    }

    private func downloadImage(with photo: UnsplashPhoto) {
        guard let url = photo.urls[.regular] else { return }

        imageDataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let strongSelf = self else { return }

            strongSelf.imageDataTask = nil

            if let error = error { return os_log("%@", log: .default, type: .error, error.localizedDescription) }

            guard let data = data, let image = UIImage(data: data) else { return }

            DispatchQueue.main.async {
                UIView.transition(with: strongSelf, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                    strongSelf.imageView.image = image
                }, completion: nil)
            }
        }

        imageDataTask?.resume()
    }

    // MARK: - Utility

    class func view(with photo: UnsplashPhoto) -> PhotoView? {
        guard let photoView = nib.instantiate(withOwner: nil, options: nil).first as? PhotoView else {
            return nil
        }

        photoView.configure(with: photo)

        return photoView
    }

}
