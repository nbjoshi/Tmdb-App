//
//  TrendingViewModel.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/17/25.
//

import Foundation
import Observation

@Observable
class TrendingViewModel {
    var trending: [Trending] = []
    var errorMessage: String? = nil
    private let service = TrendingService()
    
    func getTrending() async {
        do {
            let response = try await service.getTrending()
            trending = response.results
            errorMessage = nil
        } catch {
            errorMessage = "Failed to fetch trending: \(error)"
        }
    }
}
