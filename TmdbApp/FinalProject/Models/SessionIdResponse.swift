//
//  SessionIdResponse.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/23/25.
//

import Foundation

struct SessionIdResponse: Codable {
    let success: Bool
    let sessionId: String
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case sessionId = "session_id"
    }
}
