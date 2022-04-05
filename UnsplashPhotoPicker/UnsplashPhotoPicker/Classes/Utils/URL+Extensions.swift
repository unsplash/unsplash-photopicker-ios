//
//  URL+Extensions.swift
//  Unsplash
//
//  Created by Olivier Collet on 2017-10-23.
//  Copyright © 2017 Unsplash. All rights reserved.
//

import Foundation

extension URL {
    func appending(queryItems newQueryItems: [URLQueryItem]) -> URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true),
              var queryItems = components.queryItems else { return self }

        for newItem in newQueryItems {
            if let existingIndex = queryItems.firstIndex(where: { $0.name == newItem.name }) {
                queryItems[existingIndex].value = newItem.value
            } else {
                queryItems.append(newItem)
            }
        }

        // make sure url won't change so the url cache will work fine
        queryItems.sort { (item1, item2) -> Bool in
            return item1.name > item2.name
        }

        components.queryItems = queryItems
        return components.url ?? self
    }
}
