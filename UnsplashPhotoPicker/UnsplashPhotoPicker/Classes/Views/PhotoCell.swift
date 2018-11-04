//
//  PhotoCell.swift
//  Unsplash
//
//  Created by Olivier Collet on 2017-07-26.
//  Copyright © 2017 Unsplash. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {

    // MARK: - Properties

    static let reuseIdentifier = "PhotoCell"

    var userInfo: Any?

    let photoView: PhotoView = {
        // swiftlint:disable force_cast
        let photoView = (PhotoView.nib.instantiate(withOwner: nil, options: nil).first as! PhotoView)
        photoView.translatesAutoresizingMaskIntoConstraints = false
        return photoView
    }()

    override var isSelected: Bool {
        didSet {
            isSelected ? displayBorder() : hideBorder()
        }
    }

    // MARK: - Lifetime

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

    // Override to bypass some expensive layout calculations.
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        return .zero
    }

    // MARK: - Setup

    func configure(with photo: UnsplashPhoto) {
        photoView.configure(with: photo)
    }

    private func setupPhotoView() {
        contentView.layer.borderColor = Constants.selectedColor.cgColor
        contentView.preservesSuperviewLayoutMargins = true
        contentView.addSubview(photoView)

        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            photoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    private func displayBorder() {
        contentView.layer.borderWidth = Constants.selectedBorderWidth
        photoView.alpha = Constants.selectedPhotoViewAlpha
    }

    private func hideBorder() {
        contentView.layer.borderWidth = 0.0
        photoView.alpha = 1.0
    }
}

// MARK: - Constants
private extension PhotoCell {
    struct Constants {
        static let selectedColor = UIColor.black
        static let selectedBorderWidth: CGFloat = 3.0
        static let selectedPhotoViewAlpha: CGFloat = 0.7
    }
}
