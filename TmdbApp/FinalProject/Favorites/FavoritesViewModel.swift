//
//  FavoritesViewModel.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/26/25.
//

import Foundation
import Observation

@Observable
class FavoritesViewModel {
    private let service = FavoritesService()
    var errorMessage: String? = nil
    var favoriteMovies: [FavoriteMovie] = []
    var favoriteShows: [FavoriteShow] = []
    
    func addToFavorite(mediaType: String, mediaId: Int, accountId: Int, sessionId: String) async {
        do {
            let response: FavoritesResponse = try await service.addToFavorite(mediaType: mediaType, mediaId: mediaId, accountId: accountId, sessionId: sessionId)
            if response.statusMessage == "Success." {
                errorMessage = nil
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func getFavoriteMovies(accountId: Int, sessionId: String) async {
        do {
            let response: FavoriteMoviesResponse = try await service.getFavoriteMovies(accountId: accountId, sessionId: sessionId)
            favoriteMovies = response.results
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func getFavoriteShows(accountId: Int, sessionId: String) async {
        do {
            let response: FavoriteShowsResponse = try await service.getFavoriteShows(accountId: accountId, sessionId: sessionId)
            favoriteShows = response.results
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
