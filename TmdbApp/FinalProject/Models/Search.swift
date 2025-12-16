//
//  Search.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/17/25.
//

import Foundation

/// Response wrapper for search results
struct SearchResponse: Codable {
    let results: [Media]

    enum CodingKeys: String, CodingKey {
        case results
    }
}

/// Type alias for search media items
typealias Search = Media
