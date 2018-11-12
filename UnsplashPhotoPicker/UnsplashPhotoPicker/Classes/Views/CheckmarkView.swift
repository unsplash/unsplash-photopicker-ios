//
//  CheckmarkView.swift
//  UnsplashPhotoPicker
//
//  Created by Olivier Collet on 2018-11-07.
//  Copyright © 2018 Unsplash. All rights reserved.
//

import UIKit

class CheckmarkView: UIView {

    override class var layerClass: AnyClass { return CAShapeLayer.self }
    override var intrinsicContentSize: CGSize { return CGSize(width: 24, height: 24) }

    private lazy var checkmark: UIImageView = {
        let bundle = Bundle(for: type(of: self))
        let image = UIImage(named: "checkmark", in: bundle, compatibleWith: nil)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    init() {
        super.init(frame: .zero)
        postInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        postInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        postInit()
    }

    private func postInit() {
        guard let shapeLayer = layer as? CAShapeLayer else { return }
        shapeLayer.fillColor = tintColor.cgColor
        shapeLayer.shadowOffset = CGSize(width: 0, height: 0)
        shapeLayer.shadowRadius = 1
        shapeLayer.shadowOpacity = 0.25

        addSubview(checkmark)
        NSLayoutConstraint.activate([
            checkmark.centerXAnchor.constraint(equalTo: centerXAnchor),
            checkmark.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let shapeLayer = layer as? CAShapeLayer else { return }
        shapeLayer.path = UIBezierPath(ovalIn: bounds).cgPath
        shapeLayer.shadowPath = shapeLayer.path
    }

    override func tintColorDidChange() {
        super.tintColorDidChange()
        guard let shapeLayer = layer as? CAShapeLayer else { return }
        shapeLayer.fillColor = tintColor.cgColor
    }

}
