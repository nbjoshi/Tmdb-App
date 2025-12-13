//
//  FavoritesResponse.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/25/25.
//

import Foundation

struct FavoritesResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}

struct FavoriteMoviesResponse: Codable {
    let results: [FavoriteMovie]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}

struct FavoriteMovie: Identifiable, Codable {
    let id: Int
    let posterPath: String
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case title
    }
}

struct FavoriteShowsResponse: Codable {
    let results: [FavoriteShow]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}

struct FavoriteShow: Identifiable, Codable {
    let id: Int
    let posterPath: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case name
    }
}
