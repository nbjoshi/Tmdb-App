//
//  ShowDetails.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/17/25.
//

import Foundation

struct ShowDetails: Identifiable, Codable {
    let id: Int
    let name: String
    let tagline: String
    let seasons: [Season]
    let numberOfEpisodes: Int
    let numberOfSeasons: Int
    let overview: String
    let posterPath: String
    let genres: [Genre]
    let firstAirDate: String
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case tagline
        case name
        case seasons
        case firstAirDate = "first_air_date"
        case numberOfEpisodes = "number_of_episodes"
        case numberOfSeasons = "number_of_seasons"
        case overview
        case posterPath = "poster_path"
        case genres
        case voteAverage = "vote_average"
    }
}

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
