//
//  VideosResponse.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/30/25.
//

import Foundation

struct VideoResponse: Codable {
    let id: Int
    let results: [Video]
}

struct Video: Codable, Identifiable {
    let name: String
    let key: String
    let site: String
    let size: Int
    let type: String
    let publishedAt: String
    let id: String

    enum CodingKeys: String, CodingKey {
        case name
        case key
        case site
        case size
        case type
        case publishedAt = "published_at"
        case id
    }
}
