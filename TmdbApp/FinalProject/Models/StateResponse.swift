//
//  StateResponse.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/27/25.
//

import Foundation

struct StateResponse: Identifiable, Codable {
    let id: Int
    let favorite: Bool
    let watchlist: Bool
}
