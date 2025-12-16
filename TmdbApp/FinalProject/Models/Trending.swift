//
//  Trending.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/17/25.
//

import Foundation

/// Response wrapper for trending content
struct TrendingResponse: Codable {
    let results: [Media]

    enum CodingKeys: String, CodingKey {
        case results
    }
}

/// Type alias for trending media items
typealias Trending = Media
