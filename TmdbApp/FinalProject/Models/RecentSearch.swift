//
//  RecentSearch.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/30/25.
//

import Foundation
import SwiftData

@Model
final class RecentSearch {
    var query: String
    var timestamp: Date
    
    init(query: String, timestamp: Date = .now) {
        self.query = query
        self.timestamp = timestamp
    }
}
