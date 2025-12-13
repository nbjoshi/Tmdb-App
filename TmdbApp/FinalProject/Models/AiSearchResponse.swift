//
//  AiSearchResponse.swift
//  FinalProject
//
//  Created by Neel Joshi on 12/13/25.
//

import Foundation

struct AiSearchResponse: Codable, Identifiable {
    let id: UUID = UUID()
    let querySummary: String?
    let candidates: [Candidate]?
    
    enum CodingKeys: String, CodingKey {
        case querySummary = "query_summary"
        case candidates = "candidates"
    }
}

struct Candidate: Codable, Identifiable {
    let id: UUID = UUID()
    let title: String?
    let type: String?
    let year: String?
    let confidence: Double?
    let rationale: String?
    
    enum CodingKeys: String, CodingKey {
        case title, type, year, confidence, rationale
    }
}
