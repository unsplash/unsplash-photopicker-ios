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

protocol PagedDataSourceObserver: AnyObject {
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
    private var observers = NSHashTable<AnyObject>(options: NSPointerFunctions.Options.weakMemory)

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

    func fetchNextPage(completion: (([UnsplashPhoto]?, Error?) -> Void)?) {
        if isFetching {
            fetchDidComplete(withItems: nil, error: DataSourceError.dataSourceIsFetching, completion: completion)
            return
        }

        if canFetchMore == false {
            fetchDidComplete(withItems: [], error: nil, completion: completion)
            return
        }

        iterateObservers { (observer) in
            observer.dataSourceWillStartFetching(self)
        }

        isFetching = true

        let request = factory.request(with: cursor)
        request.completionBlock = {
            if let error = request.error {
                self.isFetching = false
                self.fetchDidComplete(withItems: nil, error: error, completion: completion)
                return
            }

            guard let items = request.items as? [UnsplashPhoto] else {
                self.isFetching = false
                self.fetchDidComplete(withItems: nil, error: DataSourceError.wrongItemsType(request.items), completion: completion)
                return
            }

            if items.count < self.cursor.perPage {
                self.canFetchMore = false
            } else {
                self.cursor = request.nextCursor()
            }

            self.items.append(contentsOf: items)

            self.isFetching = false
            self.fetchDidComplete(withItems: items, error: nil, completion: completion)
        }

        operationQueue.addOperationWithDependencies(request)
    }

    func cancelFetch() {
        operationQueue.cancelAllOperations()
        isFetching = false
    }

    func addObserver(_ observer: PagedDataSourceObserver) {
        observers.add(observer)
    }

    func removeObserver(_ observer: PagedDataSourceObserver) {
        observers.remove(observer)
    }

    // MARK: - Private

    private func fetchDidComplete(withItems items: [UnsplashPhoto]?, error: Error?, completion: (([UnsplashPhoto]?, Error?) -> Void)?) {
        self.error = error

        iterateObservers { (observer) in
            if let error = error {
                observer.dataSource(self, fetchDidFailWithError: error)
            } else {
                let items = items ?? []
                observer.dataSource(self, didFetch: items)
            }
        }

        completion?(items, error)
    }

    private func iterateObservers(handler: (PagedDataSourceObserver) -> Void) {
        for observer in self.observers.allObjects {
            if let observer = observer as? PagedDataSourceObserver {
                handler(observer)
            }
        }
    }

}
