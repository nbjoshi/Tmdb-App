//
//  WatchlistViewModel.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/29/25.
//

import Foundation
import Observation

/// ViewModel for Watchlist following clean MVVM architecture
@Observable
final class WatchlistViewModel {
    // MARK: - Published Properties

    private(set) var watchlistMovies: [WatchlistMedia] = []
    private(set) var watchlistShows: [WatchlistMedia] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    // MARK: - Dependencies

    private let service: WatchlistService

    // MARK: - Initialization

    init(service: WatchlistService = WatchlistService()) {
        self.service = service
    }

    // MARK: - Public Methods

    @MainActor
    func fetchWatchlistMovies(accountId: Int, sessionId: String) async {
        isLoading = true
        errorMessage = nil

        defer { isLoading = false }

        do {
            let response = try await service.getWatchlistMovies(
                accountId: accountId,
                sessionId: sessionId
            )
            watchlistMovies = response.results ?? []
        } catch {
            errorMessage = "Couldn't retrieve watchlisted movies: \(error.localizedDescription)"
            watchlistMovies = []
        }
    }

    @MainActor
    func fetchWatchlistShows(accountId: Int, sessionId: String) async {
        isLoading = true
        errorMessage = nil

        defer { isLoading = false }

        do {
            let response = try await service.getWatchlistShows(
                accountId: accountId,
                sessionId: sessionId
            )
            watchlistShows = response.results ?? []
        } catch {
            errorMessage = "Couldn't retrieve watchlisted shows: \(error.localizedDescription)"
            watchlistShows = []
        }
    }

    // MARK: - Computed Properties

    var hasMovies: Bool {
        !watchlistMovies.isEmpty
    }

    var hasShows: Bool {
        !watchlistShows.isEmpty
    }
}
