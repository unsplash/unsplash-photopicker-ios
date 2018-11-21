//
//  PagedDataSource.swift
//  Unsplash
//
//  Created by Olivier Collet on 2017-10-10.
//  Copyright © 2017 Unsplash. All rights reserved.
//

import UIKit

protocol PagedDataSourceFactory {
    func initialCursor() -> UnsplashPagedRequest.Cursor
    func request(with cursor: UnsplashPagedRequest.Cursor) -> UnsplashPagedRequest
}

protocol PagedDataSourceDelegate: AnyObject {
    func dataSourceWillStartFetching(_ dataSource: PagedDataSource)
    func dataSource(_ dataSource: PagedDataSource, didFetch items: [UnsplashPhoto])
    func dataSource(_ dataSource: PagedDataSource, fetchDidFailWithError error: Error)
}

class PagedDataSource {

    enum DataSourceError: Error {
        case dataSourceIsFetching
        case wrongItemsType(Any)

        var localizedDescription: String {
            switch self {
            case .dataSourceIsFetching:
                return "The data source is already fetching."
            case .wrongItemsType(let returnedItems):
                return "The request return the wrong item type. Expecting \([UnsplashPhoto].self), got \(returnedItems.self)."
            }
        }
    }

    private(set) var items = [UnsplashPhoto]()
    private(set) var error: Error?
    private let factory: PagedDataSourceFactory
    private var cursor: UnsplashPagedRequest.Cursor
    private(set) var isFetching = false
    private var canFetchMore = true
    private lazy var operationQueue = OperationQueue(with: "com.unsplash.pagedDataSource")

    weak var delegate: PagedDataSourceDelegate?

    init(with factory: PagedDataSourceFactory) {
        self.factory = factory
        self.cursor = factory.initialCursor()
    }

    func reset() {
        operationQueue.cancelAllOperations()
        items.removeAll()
        isFetching = false
        canFetchMore = true
        cursor = factory.initialCursor()
        error = nil
    }

    func fetchNextPage() {
        if isFetching {
            fetchDidComplete(withItems: nil, error: DataSourceError.dataSourceIsFetching)
            return
        }

        if canFetchMore == false {
            fetchDidComplete(withItems: [], error: nil)
            return
        }

        delegate?.dataSourceWillStartFetching(self)

        isFetching = true

        let request = factory.request(with: cursor)
        request.completionBlock = {
            if let error = request.error {
                self.isFetching = false
                self.fetchDidComplete(withItems: nil, error: error)
                return
            }

            guard let items = request.items as? [UnsplashPhoto] else {
                self.isFetching = false
                self.fetchDidComplete(withItems: nil, error: DataSourceError.wrongItemsType(request.items))
                return
            }

            if items.count < self.cursor.perPage {
                self.canFetchMore = false
            } else {
                self.cursor = request.nextCursor()
            }

            self.items.append(contentsOf: items)

            self.isFetching = false
            self.fetchDidComplete(withItems: items, error: nil)
        }

        operationQueue.addOperationWithDependencies(request)
    }

    func cancelFetch() {
        operationQueue.cancelAllOperations()
        isFetching = false
    }

    func item(at index: Int) -> UnsplashPhoto? {
        guard index < items.count else {
            return nil
        }

        return items[index]
    }

    // MARK: - Private

    private func fetchDidComplete(withItems items: [UnsplashPhoto]?, error: Error?) {
        self.error = error

        if let error = error {
            delegate?.dataSource(self, fetchDidFailWithError: error)
        } else {
            let items = items ?? []
            delegate?.dataSource(self, didFetch: items)
        }
    }

}
