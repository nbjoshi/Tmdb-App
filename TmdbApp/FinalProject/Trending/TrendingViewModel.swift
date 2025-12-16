//
//  TrendingViewModel.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/17/25.
//

import Foundation
import Observation

/// ViewModel for Trending content following clean MVVM architecture
@Observable
final class TrendingViewModel {
    // MARK: - Published Properties

    private(set) var trending: [Media] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    // MARK: - Dependencies

    private let service: TrendingService

    // MARK: - Initialization

    init(service: TrendingService = TrendingService()) {
        self.service = service
    }

    // MARK: - Public Methods

    @MainActor
    func fetchTrending(type: TrendingTab) async {
        isLoading = true
        errorMessage = nil

        defer { isLoading = false }

        do {
            let response = try await service.getTrending(type: type.pathValue)
            trending = response.results
        } catch {
            errorMessage = "Failed to fetch trending \(type.pathValue): \(error.localizedDescription)"
            trending = []
        }
    }

    // MARK: - Computed Properties

    var hasContent: Bool {
        !trending.isEmpty
    }

    var movies: [Media] {
        trending.filter { $0.mediaType == .movie }
    }

    var tvShows: [Media] {
        trending.filter { $0.mediaType == .tv }
    }

    var featuredMedia: Media? {
        trending.first
    }
}
