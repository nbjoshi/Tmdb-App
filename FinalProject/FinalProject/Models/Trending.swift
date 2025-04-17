//
//  Trending.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/17/25.
//

import Foundation

struct TrendingResponse: Codable {
    let results: [Trending]

    enum CodingKeys: String, CodingKey {
        case results
    }
}

struct Trending: Identifiable, Codable {
    let id: Int
    let mediaType: String
    let posterPath: String

    // Movie-specific
    let title: String?

    // TV-specific
    let name: String?
    
    var displayName: String {
        return title ?? name ?? ""
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case mediaType = "media_type"
        case posterPath = "poster_path"
        case title
        case name
    }
}
