//
//  GradientView.swift
//  FeedMe
//
//  Created by Olivier Collet on 2017-03-19.
//  Copyright © 2017 FeedMe. All rights reserved.
//

import UIKit

class GradientView: UIView {

    struct Color {
        let color: UIColor
        let location: CGFloat
    }

    private var colors = [Color]()

    func setColors(_ colors: [Color]) {
        self.colors = colors
        updateGradient()
    }

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    private func updateGradient() {
        guard let gradientLayer = layer as? CAGradientLayer else {
            return
        }

        gradientLayer.colors = colors.map({ $0.color.cgColor })
        gradientLayer.locations = colors.map({ $0.location}) as [NSNumber]
    }

}
