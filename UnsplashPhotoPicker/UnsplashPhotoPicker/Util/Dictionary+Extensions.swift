//
//  Dictionary+Extensions.swift
//  Unsplash
//
//  Created by Olivier Collet on 2017-11-16.
//  Copyright © 2017 Unsplash. All rights reserved.
//

import Foundation

extension Dictionary {
    public func convert<T, U>(_ transform: ((key: Key, value: Value)) throws -> (T, U)) rethrows -> [T: U] {
        var dictionary = [T: U]()
        for (key, value) in self {
            let transformed = try transform((key, value))
            dictionary[transformed.0] = transformed.1
        }
        return dictionary
    }
}

extension Dictionary where Key == String, Value == Any {
    func nestedValue(forKey keyToFind: String) -> Any? {
        if let value = self[keyToFind] {
            return value
        }

        for (_, value) in self {
            guard let dictionary = value as? [String: Any] else { continue }
            guard let foundValue = dictionary.nestedValue(forKey: keyToFind) else { continue }
            return foundValue
        }

        return nil
    }
}
