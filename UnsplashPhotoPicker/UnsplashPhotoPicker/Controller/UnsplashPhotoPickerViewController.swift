//
//  UnsplashPhotoPickerViewController.swift
//  UnsplashPhotoPicker
//
//  Created by Bichon, Nicolas on 2018-10-09.
//  Copyright © 2018 Unsplash. All rights reserved.
//

import UIKit

class UnsplashPhotoPickerViewController: UIViewController {

    // MARK: - Properties

    private lazy var cancelBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelBarButtonTapped(sender:))
        )
    }()

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = NSLocalizedString("Search photos", comment: "")
        return searchBar
    }()

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupNavigationBar()
        setupSearchBar()
        setupCollectionView()
    }

    // MARK: - Setup

    private func setupNavigationBar() {
        title = NSLocalizedString("Unsplash Photo Picker", comment: "")
        navigationItem.leftBarButtonItem = cancelBarButtonItem
    }

    private func setupSearchBar() {
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1.0),
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }

    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }

    // MARK: - Actions

    @objc private func cancelBarButtonTapped(sender: AnyObject?) {
        dismiss(animated: true, completion: nil)
    }

}
