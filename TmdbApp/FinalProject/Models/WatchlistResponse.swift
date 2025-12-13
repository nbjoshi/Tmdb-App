//
//  WatchlistResponse.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/29/25.
//

import Foundation

struct WatchlistResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}

struct WatchlistMoviesResponse: Codable {
    let results: [WatchlistMovie]?
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}

struct WatchlistMovie: Identifiable, Codable {
    let id: Int
    let posterPath: String
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case title
    }
}

struct WatchlistShowsResponse: Codable {
    let results: [WatchlistShow]?
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}

struct WatchlistShow: Identifiable, Codable {
    let id: Int
    let posterPath: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case name
    }
}
