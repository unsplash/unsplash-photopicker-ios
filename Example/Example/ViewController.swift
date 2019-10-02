//
//  ViewController.swift
//  Example
//
//  Created by Bichon, Nicolas on 2018-10-08.
//  Copyright © 2018 Unsplash. All rights reserved.
//

import UIKit
import UnsplashPhotoPicker

enum SelectionType: Int {
    case single
    case multiple
}

class ViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var selectionTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bottomSheet: UIView!
    @IBOutlet weak var searchQueryTextField: UITextField!

    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)

    private var photos = [UnsplashPhoto]()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIApplication.keyboardWillChangeFrameNotification, object: nil)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.contentInset.bottom = bottomSheet.frame.height
    }

    @objc func keyboardWillChangeFrame(_ notification: Notification) {
        guard let endFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.3
        let curveRawValue = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int ?? 0
        let curve: UIView.AnimationCurve = UIView.AnimationCurve(rawValue: curveRawValue) ?? .easeInOut

        UIViewPropertyAnimator(duration: duration, curve: curve, animations: {
            self.additionalSafeAreaInsets.bottom = self.view.frame.height - endFrame.origin.y
            self.view.layoutIfNeeded()
        }).startAnimation()
    }

    // MARK: - Action

    @IBAction func presentUnsplashPhotoPicker(sender: AnyObject?) {
        let allowsMultipleSelection = selectionTypeSegmentedControl.selectedSegmentIndex == SelectionType.multiple.rawValue
        let configuration = UnsplashPhotoPickerConfiguration(
            accessKey: "<YOUR_ACCESS_KEY>",
            secretKey: "<YOUR_SECRET_KEY>",
            query: searchQueryTextField.text,
            allowsMultipleSelection: allowsMultipleSelection
        )
        let unsplashPhotoPicker = UnsplashPhotoPicker(configuration: configuration)
        unsplashPhotoPicker.photoPickerDelegate = self

        present(unsplashPhotoPicker, animated: true, completion: nil)
    }

}

// MARK: - UITableViewDataSource
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)

        if let photoCell = cell as? PhotoCollectionViewCell {
            let photo = photos[indexPath.row]
            photoCell.downloadPhoto(photo)
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

// MARK: - UnsplashPhotoPickerDelegate
extension ViewController: UnsplashPhotoPickerDelegate {
    func unsplashPhotoPicker(_ photoPicker: UnsplashPhotoPicker, didSelectPhotos photos: [UnsplashPhoto]) {
        print("Unsplash photo picker did select \(photos.count) photo(s)")

        self.photos = photos

        collectionView.reloadData()
    }

    func unsplashPhotoPickerDidCancel(_ photoPicker: UnsplashPhotoPicker) {
        print("Unsplash photo picker did cancel")
    }
}

// MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
