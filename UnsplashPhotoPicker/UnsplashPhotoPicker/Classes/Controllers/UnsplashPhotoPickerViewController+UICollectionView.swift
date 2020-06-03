//
//  UnsplashPhotoPickerViewController+UICollectionView.swift
//  UnsplashPhotoPicker
//
//  Created by Bichon, Nicolas on 2018-10-15.
//  Copyright © 2018 Unsplash. All rights reserved.
//

import UIKit

// MARK: - UICollectionViewDataSource
extension UnsplashPhotoPickerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath)

        guard let photoCell = cell as? PhotoCell, let photo = dataSource.item(at: indexPath.item) else { return cell }

        photoCell.configure(with: photo)

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
        guard let photo = dataSource.item(at: indexPath.item), collectionView.hasActiveDrag == false else { return }

        if Configuration.shared.allowsMultipleSelection {
            updateTitle()
            updateDoneButtonState()
        } else {
            delegate?.unsplashPhotoPickerViewController(self, didSelectPhotos: [photo])
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if Configuration.shared.allowsMultipleSelection {
            updateTitle()
            updateDoneButtonState()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension UnsplashPhotoPickerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let photo = dataSource.item(at: indexPath.item) else { return .zero }

        let width = collectionView.frame.width
        let height = CGFloat(photo.height) * width / CGFloat(photo.width)
        return CGSize(width: width, height: height)
    }
}

// MARK: - UICollectionViewDragDelegate
extension UnsplashPhotoPickerViewController: UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let provider = dataSource.items[indexPath.row].itemProvider
        let dragItem = UIDragItem(itemProvider: provider)
        return [dragItem]
    }
    
}

// MARK: - WaterfallLayoutDelegate
extension UnsplashPhotoPickerViewController: WaterfallLayoutDelegate {
    func waterfallLayout(_ layout: WaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let photo = dataSource.item(at: indexPath.item) else { return .zero }

        return CGSize(width: photo.width, height: photo.height)
    }
}
