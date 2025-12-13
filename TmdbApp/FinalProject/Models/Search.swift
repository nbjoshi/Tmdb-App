//
//  Search.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/17/25.
//

import Foundation

struct SearchResponse: Codable {
    let results: [Search]

    enum CodingKeys: String, CodingKey {
        case results
    }
}

struct Search: Identifiable, Codable {
    let id: Int
    let mediaType: String
    let posterPath: String?
    let profilePath: String?
    
    // Movie-specific
    let title: String?

    // TV-specific
    let name: String?
    
    var imagePath: String? {
        if mediaType == "person" {
            return profilePath
        } else {
            return posterPath
        }
    }
    
    var displayName: String? {
        if mediaType == "movie" {
            return title
        } else {
            return name
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case mediaType = "media_type"
        case posterPath = "poster_path"
        case profilePath = "profile_path"
        case title
        case name
    }
}
