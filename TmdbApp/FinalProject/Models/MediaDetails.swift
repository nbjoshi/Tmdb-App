//
//  MediaDetails.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/17/25.
//

import Foundation

/// Unified media details that can represent both movies and TV shows
struct MediaDetails: Identifiable, Codable {
    let id: Int
    let mediaType: MediaType
    let overview: String
    let posterPath: String
    let tagline: String
    let genres: [Genre]
    let voteAverage: Double

    // Movie-specific properties
    let title: String?
    let releaseDate: String?

    // TV show-specific properties
    let name: String?
    let firstAirDate: String?
    let seasons: [Season]?
    let numberOfEpisodes: Int?
    let numberOfSeasons: Int?

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

    /// Release/air date (releaseDate for movies, firstAirDate for shows)
    var dateString: String? {
        switch mediaType {
        case .movie:
            return releaseDate
        case .tv:
            return firstAirDate
        case .person:
            return nil
        }
    }

    enum CodingKeys: String, CodingKey {
        case id
        case overview
        case posterPath = "poster_path"
        case tagline
        case genres
        case voteAverage = "vote_average"
        case title
        case releaseDate = "release_date"
        case name
        case firstAirDate = "first_air_date"
        case seasons
        case numberOfEpisodes = "number_of_episodes"
        case numberOfSeasons = "number_of_seasons"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        overview = try container.decode(String.self, forKey: .overview)
        posterPath = try container.decode(String.self, forKey: .posterPath)
        tagline = try container.decodeIfPresent(String.self, forKey: .tagline) ?? ""
        genres = try container.decode([Genre].self, forKey: .genres)
        voteAverage = try container.decode(Double.self, forKey: .voteAverage)

        // Movie-specific
        title = try container.decodeIfPresent(String.self, forKey: .title)
        releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)

        // TV show-specific
        name = try container.decodeIfPresent(String.self, forKey: .name)
        firstAirDate = try container.decodeIfPresent(String.self, forKey: .firstAirDate)
        seasons = try container.decodeIfPresent([Season].self, forKey: .seasons)
        numberOfEpisodes = try container.decodeIfPresent(Int.self, forKey: .numberOfEpisodes)
        numberOfSeasons = try container.decodeIfPresent(Int.self, forKey: .numberOfSeasons)

        // Determine media type based on which properties are present
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
        try container.encode(overview, forKey: .overview)
        try container.encode(posterPath, forKey: .posterPath)
        try container.encode(tagline, forKey: .tagline)
        try container.encode(genres, forKey: .genres)
        try container.encode(voteAverage, forKey: .voteAverage)

        if let title = title {
            try container.encode(title, forKey: .title)
        }
        if let releaseDate = releaseDate {
            try container.encode(releaseDate, forKey: .releaseDate)
        }
        if let name = name {
            try container.encode(name, forKey: .name)
        }
        if let firstAirDate = firstAirDate {
            try container.encode(firstAirDate, forKey: .firstAirDate)
        }
        if let seasons = seasons {
            try container.encode(seasons, forKey: .seasons)
        }
        if let numberOfEpisodes = numberOfEpisodes {
            try container.encode(numberOfEpisodes, forKey: .numberOfEpisodes)
        }
        if let numberOfSeasons = numberOfSeasons {
            try container.encode(numberOfSeasons, forKey: .numberOfSeasons)
        }
    }
}

/// Genre information
struct Genre: Identifiable, Codable {
    let id: Int
    let name: String
}

/// Season information for TV shows
struct Season: Identifiable, Codable, Hashable {
    let episodeCount: Int
    let id: Int
    let seasonNumber: Int

    enum CodingKeys: String, CodingKey {
        case episodeCount = "episode_count"
        case seasonNumber = "season_number"
        case id
    }
}
