//
//  EmptyView.swift
//  UnsplashPhotoPicker
//
//  Created by Bichon, Nicolas on 2018-10-21.
//  Copyright © 2018 Unsplash. All rights reserved.
//

import UIKit

enum EmptyViewState {
    case noResults
    case noInternetConnection
    case serverError

    var title: String {
        switch self {
        case .noResults:
            return "error.noResults.title".localized()
        case .noInternetConnection:
            return "error.noInternetConnection.title".localized()
        case .serverError:
            return "error.serverError.title".localized()
        }
    }

    var description: String {
        switch self {
        case .noResults:
            return "error.noResults.description".localized()
        case .noInternetConnection:
            return "error.noInternetConnection.description".localized()
        case .serverError:
            return "error.serverError.description".localized()
        }
    }
}

class EmptyView: UIView {

    // MARK: - Properties

    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 24.0)
        label.numberOfLines = 0
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.numberOfLines = 0
        return label
    }()

    var state: EmptyViewState? {
        didSet {
            setupState()
        }
    }

    // MARK: - Lifetime

    init() {
        super.init(frame: .zero)

        backgroundColor = .white
        setupContainerView()
        setupTitleLabel()
        setupDescriptionLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupContainerView() {
        addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 0),
            containerView.leftAnchor.constraint(equalTo: leftAnchor),
            containerView.bottomAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 0),
            containerView.rightAnchor.constraint(equalTo: rightAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func setupTitleLabel() {
        containerView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: Constants.margin),
            titleLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -Constants.margin)
        ])
    }

    private func setupDescriptionLabel() {
        containerView.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.padding),
            descriptionLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: Constants.margin),
            descriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -Constants.margin)
        ])
    }

    private func setupState() {
        titleLabel.text = state?.title
        descriptionLabel.text = state?.description
    }

}

// MARK: - Constants
private extension EmptyView {
    struct Constants {
        static let margin: CGFloat = 20.0
        static let padding: CGFloat = 10.0
    }
}
