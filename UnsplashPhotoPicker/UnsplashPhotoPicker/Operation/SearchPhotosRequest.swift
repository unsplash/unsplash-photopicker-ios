//
//  SearchPhotosRequest.swift
//  Unsplash
//
//  Created by Olivier Collet on 2017-09-27.
//  Copyright © 2017 Unsplash. All rights reserved.
//

import Foundation

class SearchPhotosRequest: UnsplashPagedRequest {

    static func cursor(with query: String, page: Int = 1, perPage: Int = 10) -> UnsplashPagedRequest.Cursor {
        let parameters = ["query": query]
        return Cursor(page: page, perPage: perPage, parameters: parameters)
    }

    convenience init(with query: String, page: Int = 1, perPage: Int = 10) {
        let cursor = SearchPhotosRequest.cursor(with: query, page: page, perPage: perPage)
        self.init(with: cursor)
    }

    // MARK: - Prepare the request

    override var endpoint: String { return "/search/photos" }

    // MARK: - Process the response

    override func processJSONResponse() {
        if let photos = photosFromJSONResponse() {
            self.items = photos
        }
        super.processJSONResponse()
    }

    func photosFromJSONResponse() -> [UnsplashPhoto]? {
        guard let jsonResponse = jsonResponse as? [String: Any],
            let results = jsonResponse["results"] as? [Any] else {
            return nil
        }

        do {
            let data = try JSONSerialization.data(withJSONObject: results, options: [])
            return try JSONDecoder().decode([UnsplashPhoto].self, from: data)
        } catch {
            self.error = error
        }
        return nil
    }

}
