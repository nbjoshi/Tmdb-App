//
//  Media.swift
//  FinalProject
//
//  Created by Neel Joshi on 5/14/25.
//

import Foundation

struct MediaResponse: Codable {
    let results: [Media]?
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}

struct Media: Identifiable, Codable {
    let id: Int
    let mediaType: String?
    let posterPath: String?
    let profilePath: String?
    let title: String?
    let name: String?
    
    var displayName: String {
        title ?? name ?? ""
    }
    
    var imagePath: String {
        profilePath ?? posterPath ?? ""
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case title
        case name
        case mediaType = "media_type"
        case profilePath = "profile_path"
    }
}

struct SelectedMedia: Identifiable {
    var id: Int
    var mediaType: String
}
