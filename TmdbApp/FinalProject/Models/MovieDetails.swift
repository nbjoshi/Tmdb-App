//
//  MovieDetails.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/17/25.
//

import Foundation

struct MovieDetails: Identifiable, Codable {
    let genres: [Genre]
    let id: Int
    let overview: String
    let posterPath: String
    let releaseDate: String
    let tagline: String
    let title: String
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case genres
        case id
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case tagline
        case title
        case voteAverage = "vote_average"
    }
}

struct Genre: Identifiable, Codable {
    let id: Int
    let name: String
}
