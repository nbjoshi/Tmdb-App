//
//  Media.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/17/25.
//

import Foundation

/// Protocol for media items that can be displayed in lists
protocol MediaItem: Identifiable, Codable {
    var id: Int { get }
    var mediaType: MediaType { get }
    var posterPath: String? { get }
    var profilePath: String? { get }
    var title: String? { get }
    var name: String? { get }
}

extension MediaItem {
    /// Returns the appropriate image path based on media type
    var imagePath: String? {
        if mediaType == .person {
            return profilePath
        } else {
            return posterPath
        }
    }

    /// Returns the display name (title for movies, name for shows/people)
    var displayName: String? {
        switch mediaType {
        case .movie:
            return title
        case .tv, .person:
            return name
        }
    }
}

/// Base media item used in trending, search, and similar content
struct Media: MediaItem {
    let id: Int
    let mediaType: MediaType
    let posterPath: String?
    let profilePath: String?
    let title: String?
    let name: String?

    // MARK: - Initializers

    init(
        id: Int,
        mediaType: MediaType,
        posterPath: String? = nil,
        profilePath: String? = nil,
        title: String? = nil,
        name: String? = nil
    ) {
        self.id = id
        self.mediaType = mediaType
        self.posterPath = posterPath
        self.profilePath = profilePath
        self.title = title
        self.name = name
    }

    enum CodingKeys: String, CodingKey {
        case id
        case mediaType = "media_type"
        case posterPath = "poster_path"
        case profilePath = "profile_path"
        case title
        case name
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)

        // Decode media_type as string and convert to enum
        let mediaTypeString = try container.decode(String.self, forKey: .mediaType)
        mediaType = MediaType(rawValue: mediaTypeString) ?? .movie

        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        profilePath = try container.decodeIfPresent(String.self, forKey: .profilePath)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        name = try container.decodeIfPresent(String.self, forKey: .name)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(mediaType.rawValue, forKey: .mediaType)
        try container.encodeIfPresent(posterPath, forKey: .posterPath)
        try container.encodeIfPresent(profilePath, forKey: .profilePath)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(name, forKey: .name)
    }
}

/// Response wrapper for media lists
struct MediaResponse<T: Codable>: Codable {
    let results: [T]
}
