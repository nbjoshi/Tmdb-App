//
//  SimilarMovies.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/21/25.
//

import Foundation

struct SimilarMoviesResponse: Codable {
    let results: [SimilarMovie]
}

struct SimilarMovie: Codable, Identifiable {
    let id: Int
    let posterPath: String?
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case title
    }
}
