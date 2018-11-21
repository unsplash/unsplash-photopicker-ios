//
//  UnsplashUser.swift
//  Submissions
//
//  Created by Olivier Collet on 2017-04-11.
//  Copyright © 2017 Unsplash. All rights reserved.
//

import Foundation

/// A struct representing a user's public profile from the Unsplash API.
public struct UnsplashUser: Codable {

    public enum ProfileImageSize: String, Codable {
        case small
        case medium
        case large
    }

    public let identifier: String
    public let username: String
    public let firstName: String?
    public let lastName: String?
    public let name: String?
    public let profileImage: [ProfileImageSize: URL]
    public let bio: String?
    public let location: String?
    public let portfolioURL: URL?
    public let totalCollections: Int
    public let totalLikes: Int
    public let totalPhotos: Int

    private enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case name
        case profileImage = "profile_image"
        case bio
        case location
        case portfolioURL = "portfolio_url"
        case totalCollections = "total_collections"
        case totalLikes = "total_likes"
        case totalPhotos = "total_photos"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try container.decode(String.self, forKey: .identifier)
        username = try container.decode(String.self, forKey: .username)
        firstName = try? container.decode(String.self, forKey: .firstName)
        lastName = try? container.decode(String.self, forKey: .lastName)
        name = try? container.decode(String.self, forKey: .name)
        profileImage = try container.decode([ProfileImageSize: URL].self, forKey: .profileImage)
        bio = try? container.decode(String.self, forKey: .bio)
        location = try? container.decode(String.self, forKey: .location)
        portfolioURL = try? container.decode(URL.self, forKey: .portfolioURL)
        totalCollections = try container.decode(Int.self, forKey: .totalCollections)
        totalLikes = try container.decode(Int.self, forKey: .totalLikes)
        totalPhotos = try container.decode(Int.self, forKey: .totalPhotos)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(username, forKey: .username)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(name, forKey: .name)
        try container.encode(profileImage.convert({ ($0.key.rawValue, $0.value.absoluteString) }), forKey: .profileImage)
        try container.encode(bio, forKey: .bio)
        try container.encode(location, forKey: .location)
        try container.encode(portfolioURL, forKey: .portfolioURL)
        try container.encode(totalCollections, forKey: .totalCollections)
        try container.encode(totalLikes, forKey: .totalLikes)
        try container.encode(totalPhotos, forKey: .totalPhotos)
    }

}

// MARK: - Convenience
extension UnsplashUser {
    var displayName: String {
        if let name = name {
            return name
        }

        if let firstName = firstName {
            if let lastName = lastName {
                return "\(firstName) \(lastName)"
            }
            return firstName
        }

        return username
    }

    var profileURL: URL? {
        return URL(string: "https://unsplash.com/@\(username)")
    }
}

// MARK: - Equatable
extension UnsplashUser: Equatable {
    public static func == (lhs: UnsplashUser, rhs: UnsplashUser) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
