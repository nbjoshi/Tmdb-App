//
//  SeasonDetails.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/22/25.
//

import Foundation

struct SeasonDetails: Codable, Identifiable {
    let id: Int
    let episodes: [Episode]
}

struct Episode: Codable, Identifiable {
    let airDate: String
    let episodeNumber: Int
    let id: Int
    let name: String
    let overview: String
    let runtime: Int
    let seasonNumber: Int
    let stillPath: String?

    enum CodingKeys: String, CodingKey {
        case airDate = "air_date"
        case episodeNumber = "episode_number"
        case seasonNumber = "season_number"
        case id
        case name
        case overview
        case runtime
        case stillPath = "still_path"
    }
}
