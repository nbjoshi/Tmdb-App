//
//  SimilarShows.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/22/25.
//

import Foundation

struct SimilarShowsResponse: Codable {
    let results: [SimilarShow]
}

struct SimilarShow: Codable, Identifiable {
    let id: Int
    let posterPath: String?
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case name
    }
}
