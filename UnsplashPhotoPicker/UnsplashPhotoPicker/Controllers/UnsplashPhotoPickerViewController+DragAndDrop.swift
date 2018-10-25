//
//  UnsplashPhotoPickerViewController+DragAndDrop.swift
//  UnsplashPhotoPicker
//
//  Created by Bichon, Nicolas on 2018-10-09.
//  Copyright © 2018 Unsplash. All rights reserved.
//

import UIKit

// MARK: - UICollectionViewDragDelegate
extension UnsplashPhotoPickerViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        selectionFeedbackGenerator = UISelectionFeedbackGenerator()
        selectionFeedbackGenerator?.prepare()
        selectionFeedbackGenerator?.selectionChanged()
        return dragItems(for: session, at: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        selectionFeedbackGenerator?.selectionChanged()
        return dragItems(for: session, at: indexPath)
    }

    func dragItems(for session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard let photo = dataSource.item(at: indexPath.item) else {
            return []
        }

        // Do not add the photo if it is already in the session.
        for item in session.items {
            if let sessionPhoto = item.localObject as? UnsplashPhoto, photo.identifier == sessionPhoto.identifier {
                return []
            }
        }

        return [photo.dragItem]
    }

    func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: UIDragSession) {
        selectionFeedbackGenerator = nil
    }
}
