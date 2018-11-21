//
//  PhotoView.swift
//  Unsplash
//
//  Created by Olivier Collet on 2017-11-06.
//  Copyright © 2017 Unsplash. All rights reserved.
//

import UIKit

class PhotoView: UIView {

    static var nib: UINib { return UINib(nibName: "PhotoView", bundle: Bundle(for: PhotoView.self)) }

    private var imageDownloader = ImageDownloader()
    private var screenScale: CGFloat { return UIScreen.main.scale }

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
            GradientView.Color(color: UIColor(white: 0, alpha: 0.5), location: 1)
        ])
    }

    func prepareForReuse() {
        userNameLabel.text = nil
        imageView.backgroundColor = .clear
        imageView.image = nil
        imageDownloader.cancel()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        let fontSize: CGFloat = traitCollection.horizontalSizeClass == .compact ? 10 : 13
        userNameLabel.font = UIFont.systemFont(ofSize: fontSize)
    }

    // MARK: - Setup

    func configure(with photo: UnsplashPhoto, showsUsername: Bool = true) {
        self.showsUsername = showsUsername
        userNameLabel.text = photo.user.displayName
        imageView.backgroundColor = photo.color
        downloadImage(with: photo)
    }

    private func downloadImage(with photo: UnsplashPhoto) {
        guard let regularUrl = photo.urls[.regular] else { return }

        let url = sizedImageURL(from: regularUrl)

        imageDownloader.downloadPhoto(with: url, completion: { [weak self] (image, isCached) in
            guard let strongSelf = self, strongSelf.imageDownloader.isCancelled == false else { return }

            if isCached {
                strongSelf.imageView.image = image
            } else {
                UIView.transition(with: strongSelf, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                    strongSelf.imageView.image = image
                }, completion: nil)
            }
        })
    }

    private func sizedImageURL(from url: URL) -> URL {
        let width: CGFloat = frame.width * screenScale
        let height: CGFloat = frame.height * screenScale

        return url.appending(queryItems: [
            URLQueryItem(name: "max-w", value: "\(width)"),
            URLQueryItem(name: "max-h", value: "\(height)")
        ])
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
