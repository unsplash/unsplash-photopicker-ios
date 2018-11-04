//
//  WaterfallLayout.swift
//  Unsplash
//
//  Created by Olivier Collet on 2017-07-29.
//  Copyright © 2017 Unsplash. All rights reserved.
//

import UIKit

protocol WaterfallLayoutDelegate: class {
    func waterfallLayout(_ layout: WaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
}

class WaterfallLayout: UICollectionViewLayout {

    // MARK: - Public properties

    weak var delegate: WaterfallLayoutDelegate?

    var topInset: CGFloat = 16 {
        didSet {
            invalidateLayout()
        }
    }

    // MARK: - Private properties

    private var layoutAttributes = [UICollectionViewLayoutAttributes]()
    private var frames = [CGRect]()
    private var pagingViewAttributes: UICollectionViewLayoutAttributes?
    private var contentHeight: CGFloat = 0

    // MARK: - Private computed properties

    private var numberOfColumns: Int {
        guard let collectionView = collectionView else { return 1 }

        let numberOfColumns = WaterfallLayout.numberOfColumns(for: collectionView.frame.width)
        return min(numberOfColumns, 3)
    }

    private var isSingleColumn: Bool {
        return numberOfColumns == 1
    }

    private var itemSpacing: CGFloat {
        return isSingleColumn ? 1 : 16
    }

    private var columnWidth: CGFloat {
        if isSingleColumn { return collectionViewContentSize.width }
        return (collectionViewContentSize.width - (CGFloat(numberOfColumns - 1) * itemSpacing)) / CGFloat(numberOfColumns)
    }

    init(with delegate: WaterfallLayoutDelegate?) {
        self.delegate = delegate

        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else {
            return CGSize.zero
        }

        var width = collectionView.frame.width
        if !isSingleColumn {
            width -= (collectionView.layoutMargins.left + collectionView.layoutMargins.right)
        }

        return CGSize(width: width, height: contentHeight)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes]()
        var firstFrameIndex: Int = 0
        var lastFrameIndex: Int = frames.count

        for index in 0 ..< lastFrameIndex {
            if rect.intersects(frames[index]) {
                firstFrameIndex = index
                break
            }
        }

        for index in (0 ..< frames.count).reversed() {
            if rect.intersects(frames[index]) {
                lastFrameIndex = min((index + 1), layoutAttributes.count)
                break
            }
        }

        for index in firstFrameIndex ..< lastFrameIndex {
            let attr = layoutAttributes[index]
            attributes.append(attr)
        }

        if let pagingViewAttributes = pagingViewAttributes, pagingViewAttributes.frame.intersects(rect) {
            attributes.append(pagingViewAttributes)
        }

        return attributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributes[indexPath.item]
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == UICollectionView.elementKindSectionFooter {
            return pagingViewAttributes
        }

        return nil
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let bounds = collectionView?.bounds else { return false }
        return bounds.width != newBounds.width
    }

    // swiftlint:disable function_body_length
    override func prepare() {
        super.prepare()

        reset()

        guard let collectionView = collectionView, let delegate = delegate, self.numberOfColumns > 0 else {
            return
        }

        let itemSpacing = self.itemSpacing
        let numberOfColumns = self.numberOfColumns
        let isSingleColumn = self.isSingleColumn
        let columnWidth = self.columnWidth

        var columnHeights = [CGFloat](repeating: topInset, count: numberOfColumns)
        func originForColumn(_ column: Int) -> CGPoint {
            let pointX = isSingleColumn ? 0 : collectionView.layoutMargins.left + CGFloat(column) * (columnWidth + itemSpacing)
            let pointY = columnHeights[column]
            return CGPoint(x: pointX, y: pointY)
        }

        func indexOfNextColumn() -> Int {
            guard let minHeight = columnHeights.min() else {
                return 0
            }
            return columnHeights.index(where: { $0 == minHeight }) ?? 0
        }

        var numberOfItems = 0
        (0 ..< collectionView.numberOfSections).forEach {
            numberOfItems += collectionView.numberOfItems(inSection: $0)
        }

        for index in 0 ..< numberOfItems {
            let indexPath = IndexPath(item: index, section: 0)
            let itemSize = delegate.waterfallLayout(self, sizeForItemAt: indexPath)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            let columnIndex = indexOfNextColumn()
            let origin = originForColumn(columnIndex)
            let size = self.itemSize(from: itemSize, with: columnWidth)
            columnHeights[columnIndex] = origin.y + size.height + itemSpacing
            attributes.frame = CGRect(origin: origin, size: size)
            layoutAttributes.append(attributes)
            frames.append(attributes.frame)
        }

        contentHeight = columnHeights.max() ?? 0

        if numberOfItems > 0 {
            let pagingViewIndexPath = IndexPath(item: numberOfItems-1, section: 0)
            let pagingViewAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: pagingViewIndexPath)
            pagingViewAttributes.frame = CGRect(x: 0, y: contentHeight, width: collectionView.frame.width, height: PagingView.height)
            self.pagingViewAttributes = pagingViewAttributes

            contentHeight += PagingView.height
        } else {
            self.pagingViewAttributes = nil
        }

        contentHeight += itemSpacing
    }

    private func reset() {
        pagingViewAttributes = nil
        layoutAttributes.removeAll()
        frames.removeAll()
        contentHeight = 0
    }

    // MARK: - Utilities

    class func numberOfColumns(for width: CGFloat, itemSpacing: CGFloat = 16, minimumWidth: CGFloat = 150) -> Int {
        return Int(floor(width - itemSpacing) / (minimumWidth + itemSpacing))
    }

    private func itemSize(from size: CGSize, with columnWidth: CGFloat) -> CGSize {
        let height = size.height * columnWidth / size.width
        return CGSize(width: floor(columnWidth), height: floor(height))
    }
}
