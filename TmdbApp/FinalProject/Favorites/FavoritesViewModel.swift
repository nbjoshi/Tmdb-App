//
//  FavoritesViewModel.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/26/25.
//

import Foundation
import Observation

/// ViewModel for Favorites following clean MVVM architecture
@Observable
final class FavoritesViewModel {
    // MARK: - Published Properties

    private(set) var favoriteMovies: [FavoriteMedia] = []
    private(set) var favoriteShows: [FavoriteMedia] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    // MARK: - Dependencies

    private let service: FavoritesService

    // MARK: - Initialization

    init(service: FavoritesService = FavoritesService()) {
        self.service = service
    }

    // MARK: - Public Methods

    @MainActor
    func addToFavorites(
        mediaType: MediaType,
        mediaId: Int,
        accountId: Int,
        sessionId: String
    ) async -> Bool {
        do {
            let response = try await service.addToFavorite(
                mediaType: mediaType,
                mediaId: mediaId,
                accountId: accountId,
                sessionId: sessionId
            )
            errorMessage = response.statusMessage == "Success." ? nil : response.statusMessage
            return response.statusMessage == "Success."
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }

    @MainActor
    func fetchFavoriteMovies(accountId: Int, sessionId: String) async {
        isLoading = true
        errorMessage = nil

        defer { isLoading = false }

        do {
            let response = try await service.getFavoriteMovies(
                accountId: accountId,
                sessionId: sessionId
            )
            favoriteMovies = response.results
        } catch {
            errorMessage = error.localizedDescription
            favoriteMovies = []
        }
    }

    @MainActor
    func fetchFavoriteShows(accountId: Int, sessionId: String) async {
        isLoading = true
        errorMessage = nil

        defer { isLoading = false }

        do {
            let response = try await service.getFavoriteShows(
                accountId: accountId,
                sessionId: sessionId
            )
            favoriteShows = response.results
        } catch {
            errorMessage = error.localizedDescription
            favoriteShows = []
        }
    }

    // MARK: - Computed Properties

    var hasMovies: Bool {
        !favoriteMovies.isEmpty
    }

    var hasShows: Bool {
        !favoriteShows.isEmpty
    }
}
