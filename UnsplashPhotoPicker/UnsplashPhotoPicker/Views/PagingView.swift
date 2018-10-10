//
//  PagingView.swift
//  Unsplash
//
//  Created by Olivier Collet on 2017-10-30.
//  Copyright © 2017 Unsplash. All rights reserved.
//

import UIKit

class PagingView: UICollectionReusableView {

    static var height: CGFloat = 44
    static var reuseIdentifier = "PagingView"

    var isLoading = false {
        didSet {
            if isLoading {
                spinner.startAnimating()
            } else {
                spinner.stopAnimating()
            }
        }
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
        spinner.translatesAutoresizingMaskIntoConstraints = false
        addSubview(spinner)

        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private let spinner = UIActivityIndicatorView(style: .gray)

}
