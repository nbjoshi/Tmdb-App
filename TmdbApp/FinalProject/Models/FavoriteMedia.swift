//
//  FavoriteMedia.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/25/25.
//

import Foundation

/// Unified favorite media item (replaces FavoriteMovie and FavoriteShow)
struct FavoriteMedia: Identifiable, Codable {
    let id: Int
    let posterPath: String
    let title: String?
    let name: String?
    let mediaType: MediaType

    /// Display name (title for movies, name for shows)
    var displayName: String {
        switch mediaType {
        case .movie:
            return title ?? ""
        case .tv:
            return name ?? ""
        case .person:
            return name ?? ""
        }
    }

    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case title
        case name
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        posterPath = try container.decode(String.self, forKey: .posterPath)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        name = try container.decodeIfPresent(String.self, forKey: .name)

        // Determine media type based on which property is present
        if title != nil {
            mediaType = .movie
        } else if name != nil {
            mediaType = .tv
        } else {
            mediaType = .movie // Default fallback
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(posterPath, forKey: .posterPath)
        if let title = title {
            try container.encode(title, forKey: .title)
        }
        if let name = name {
            try container.encode(name, forKey: .name)
        }
    }
}

/// Response wrapper for favorite media lists
struct FavoriteMediaResponse: Codable {
    let results: [FavoriteMedia]
}

/// Response for favorite operations
struct FavoritesResponse: Codable {
    let statusCode: Int
    let statusMessage: String

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}
