//
//  PhotosDataSource.swift
//  UnsplashPhotoPicker
//
//  Created by Dodda Srinivasan on 18/09/19.
//  Copyright © 2019 Unsplash. All rights reserved.
//

import Foundation

open class PhotoSearchService {
    private lazy var operationQueue = OperationQueue(with: "com.unsplash.photoSearchService")

    public init() {}
    
    public typealias Completion = ([UnsplashPhoto]?, Error?) -> Void

    public func search(query: String, page: Int, perPage: Int, completion: @escaping Completion) -> Operation {
        let request = SearchPhotosRequest(with: query, page: page, perPage: perPage)
        request.completionBlock = {
            guard request.error == nil else {
                completion(nil, request.error)
                return
            }

            guard let items = request.items as? [UnsplashPhoto] else {
                completion(nil, PagedDataSource.DataSourceError.wrongItemsType(request.items))
                return
            }

            completion(items, nil)
        }
        operationQueue.addOperationWithDependencies(request)
        return request
    }

}
