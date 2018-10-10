//
//  PhotoCell.swift
//  Unsplash
//
//  Created by Olivier Collet on 2017-07-26.
//  Copyright © 2017 Unsplash. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {

    static let reuseIdentifier = "PhotoCell"

    var userInfo: Any?

    // swiftlint:disable force_cast
    let photoView: PhotoView! = (PhotoView.nib.instantiate(withOwner: nil, options: nil).first as! PhotoView)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPhotoView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupPhotoView()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        userInfo = nil
        photoView.prepareForReuse()
    }

    func configure(with photo: UnsplashPhoto) {
        photoView.configure(with: photo)
    }

    // Override to bypass some expensive layout calculations.
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        return .zero
    }

    private func setupPhotoView() {
        contentView.preservesSuperviewLayoutMargins = true
        photoView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(photoView)
        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            photoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
