//
//  WatchlistResponse.swift
//  FinalProject
//
//  Created by Neel Joshi on 5/14/25.
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
