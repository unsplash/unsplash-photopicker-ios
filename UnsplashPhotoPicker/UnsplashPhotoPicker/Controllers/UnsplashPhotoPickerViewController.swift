//
//  UnsplashPhotoPickerViewController.swift
//  UnsplashPhotoPicker
//
//  Created by Bichon, Nicolas on 2018-10-09.
//  Copyright © 2018 Unsplash. All rights reserved.
//

import UIKit

protocol UnsplashPhotoPickerViewControllerDelegate: class {
    func unsplashPhotoPickerViewController(_ viewController: UnsplashPhotoPickerViewController, didSelectPhotos photos: [UnsplashPhoto])
    func unsplashPhotoPickerViewControllerDidCancel(_ viewController: UnsplashPhotoPickerViewController)
}

class UnsplashPhotoPickerViewController: UIViewController {

    // MARK: - Properties

    private lazy var cancelBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelBarButtonTapped(sender:))
        )
    }()

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = NSLocalizedString("Search photos", comment: "")
        return searchController
    }()

    private lazy var spinner = UIActivityIndicatorView()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.dragDelegate = self
        collectionView.dragInteractionEnabled = true
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        collectionView.register(PagingView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: PagingView.reuseIdentifier)
        collectionView.contentInsetAdjustmentBehavior = contentInsetAdjustmentBehavior
        collectionView.layoutMargins = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        collectionView.backgroundColor = .white
        return collectionView
    }()

    var dataSource: PagedDataSource! {
        didSet {
            if let oldValue = oldValue {
                oldValue.cancelFetch()
                oldValue.removeObserver(self)
            }
            dataSource?.addObserver(self)
        }
    }
    weak var delegate: UnsplashPhotoPickerViewControllerDelegate?
    var showsUsernames = true
    var selectionFeedbackGenerator: UISelectionFeedbackGenerator?
    lazy var layout = WaterfallLayout(with: self)

    var scrollView: UIScrollView { return collectionView }
    var contentInsetAdjustmentBehavior: UIScrollView.ContentInsetAdjustmentBehavior = .automatic

    private let operationQueue = OperationQueue(with: "com.unsplash.Unsplash.PhotoPicker")

    // MARK: - Lifetime

    deinit {
        NotificationCenter.default.removeObserver(self)
        operationQueue.cancelAllOperations()
        dataSource = nil
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupNavigationBar()
        setupSearchController()
        setupCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if dataSource.items.count == 0 {
            refresh()
        } else {
            reloadData()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        operationQueue.cancelAllOperations()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { (_) in
            self.layout.invalidateLayout()
        }, completion: nil)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        reloadLayout()
    }

    // MARK: - Setup

    private func setupNavigationBar() {
        title = NSLocalizedString("Unsplash Photo Picker", comment: "")
        navigationItem.leftBarButtonItem = cancelBarButtonItem
    }

    private func setupSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        extendedLayoutIncludesOpaqueBars = true
    }

    private func setupCollectionView() {
        dataSource = PhotosDataSourceFactory.collection(identifier: Configuration.shared.editorialCollectionId).dataSource

        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1.0),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }

    // MARK: - Actions

    @objc private func cancelBarButtonTapped(sender: AnyObject?) {
        searchController.searchBar.resignFirstResponder()

        delegate?.unsplashPhotoPickerViewControllerDidCancel(self)
    }

//    func setTopInset(_ topInset: CGFloat) {
//        layout.topInset = topInset
//    }

    private func reloadLayout() {
        let visibleIndexPaths = collectionView.indexPathsForVisibleItems

        collectionView.collectionViewLayout = layout

        if let firstVisibleIndexPath = visibleIndexPaths.first {
            collectionView.scrollToItem(at: firstVisibleIndexPath, at: UICollectionView.ScrollPosition.top, animated: false)
        }
    }

    // MARK: - Data

    @objc func refresh() {
        guard dataSource.items.isEmpty else { return }

        if dataSource.isFetching == false && dataSource.items.count == 0 {
            dataSource.reset()
            reloadData()
            fetchNextItems()
        }
    }

    func reloadData() {
        collectionView.reloadData()
    }

    func fetchNextItems() {
        dataSource.fetchNextPage(completion: nil)
    }

    private func fetchNextItemsIfNeeded() {
        if dataSource.items.count == 0 {
            fetchNextItems()
        }
    }

    func photo(at indexPath: IndexPath) -> UnsplashPhoto? {
        guard indexPath.item < dataSource.items.count else {
            return nil
        }

        return dataSource.items[indexPath.item]
    }

    func indexPath(for photo: UnsplashPhoto) -> IndexPath? {
        for index in 0..<dataSource.items.count where dataSource.items[index].identifier == photo.identifier {
            return IndexPath(item: index, section: 0)
        }

        return nil
    }

}

// MARK: - UISearchBarDelegate
extension UnsplashPhotoPickerViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }

        dataSource = PhotosDataSourceFactory.search(query: text).dataSource
        refresh()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dataSource = PhotosDataSourceFactory.collection(identifier: Configuration.shared.editorialCollectionId).dataSource
        refresh()
    }
}

// MARK: - PagedDataSourceObserver
extension UnsplashPhotoPickerViewController: PagedDataSourceObserver {
    func dataSourceWillStartFetching(_ dataSource: PagedDataSource) {
        if dataSource.items.count == 0 {
            spinner.startAnimating()
        }
    }

    func dataSource(_ dataSource: PagedDataSource, didFetch items: [UnsplashPhoto]) {
        guard items.count > 0 else {
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
            }
            return
        }

        let newPhotosCount = items.count
        let startIndex = self.dataSource.items.count - newPhotosCount
        let endIndex = startIndex + newPhotosCount
        var newIndexPaths = [IndexPath]()
        for index in startIndex..<endIndex {
            newIndexPaths.append(IndexPath(item: index, section: 0))
        }

        DispatchQueue.main.async { [unowned self] in
            self.spinner.stopAnimating()

            let hasWindow = self.collectionView.window != nil
            let collectionViewItemCount = self.collectionView.numberOfItems(inSection: 0)
            if hasWindow && collectionViewItemCount < dataSource.items.count {
                self.collectionView.insertItems(at: newIndexPaths)
            } else {
                self.reloadData()
            }
        }
    }

    func dataSource(_ dataSource: PagedDataSource, fetchDidFailWithError error: Error) {}
}

// MARK: - UICollectionViewDataSource
extension UnsplashPhotoPickerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath)

        guard let photoCell = cell as? PhotoCell, let photo = self.photo(at: indexPath) else { return cell }

        photoCell.configure(with: photo)
        photoCell.userInfo = photo.identifier
        photoCell.photoView.showsUsername = showsUsernames

        return photoCell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PagingView.reuseIdentifier, for: indexPath)

        guard let pagingView = view as? PagingView else { return view }

        pagingView.isLoading = dataSource.isFetching

        return pagingView
    }
}

// MARK: - UICollectionViewDelegate
extension UnsplashPhotoPickerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let prefetchCount = 19
        if indexPath.item == dataSource.items.count - prefetchCount {
            fetchNextItems()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView.hasActiveDrag == false else { return }

        guard let photo = photo(at: indexPath) else { return }

        delegate?.unsplashPhotoPickerViewController(self, didSelectPhotos: [photo])
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension UnsplashPhotoPickerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let photo = self.photo(at: indexPath) else { return .zero }

        let width = collectionView.frame.width
        let height = CGFloat(photo.height) * width / CGFloat(photo.width)
        return CGSize(width: width, height: height)
    }
}

// MARK: - WaterfallLayoutDelegate
extension UnsplashPhotoPickerViewController: WaterfallLayoutDelegate {
    func waterfallLayout(_ layout: WaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let photo = self.photo(at: indexPath) else { return .zero }

        return CGSize(width: photo.width, height: photo.height)
    }
}
