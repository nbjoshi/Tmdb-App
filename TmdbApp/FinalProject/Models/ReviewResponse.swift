//
//  ReviewResponse.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/29/25.
//

import Foundation

struct ReviewResponse: Codable {
    let id: Int
    let results: [Review]

    enum CodingKeys: String, CodingKey {
        case id
        case results
    }
}

struct Review: Codable, Identifiable {
    let id: String
    let author: String
    let authorDetails: AuthorDetails
    let content: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case author
        case content
        case authorDetails = "author_details"
        case createdAt = "created_at"
    }
}

struct AuthorDetails: Codable {
    let name: String?
    let username: String
    let avatarPath: String?

    enum CodingKeys: String, CodingKey {
        case name
        case username
        case avatarPath = "avatar_path"
    }
}
