//
//  RequestTokenResponse.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/23/25.
//

import Foundation

struct RequestTokenResponse: Codable {
    let success: Bool
    let expiresAt: String?
    let requestToken: String

    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
    }
}
