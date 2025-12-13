//
//  Profile.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/23/25.
//

import Foundation

struct Profile: Codable, Identifiable {
    let avatar: Avatar
    let id: Int
    let name: String
    let username: String

    enum CodingKeys: String, CodingKey {
        case avatar
        case id
        case name
        case username
    }
}

struct Avatar: Codable {
    let gravatar: Gravatar
    let tmdb: TMDBAvatar
}

struct Gravatar: Codable {
    let hash: String
}

struct TMDBAvatar: Codable {
    let avatarPath: String?

    enum CodingKeys: String, CodingKey {
        case avatarPath = "avatar_path"
    }
}
