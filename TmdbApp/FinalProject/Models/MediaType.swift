//
//  MediaType.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/17/25.
//

import Foundation

/// Represents the type of media content
enum MediaType: String, Codable, CaseIterable {
    case movie
    case tv
    case person

    var displayName: String {
        switch self {
        case .movie:
            return "Movie"
        case .tv:
            return "TV Show"
        case .person:
            return "Person"
        }
    }
}
