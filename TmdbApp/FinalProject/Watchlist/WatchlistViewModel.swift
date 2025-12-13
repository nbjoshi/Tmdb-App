//
//  WatchlistViewModel.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/29/25.
//

import Foundation
import Observation

@Observable
class WatchlistViewModel {
    private let service = WatchlistService()
    var errorMessage: String? = nil
    var watchlistMovies: [WatchlistMovie] = []
    var watchlistShows: [WatchlistShow] = []
    
    func getWatchlistMovies(accountId: Int, sessionId: String) async {
        do {
            let response = try await service.getWatchlistMovies(accountId: accountId, sessionId: sessionId)
            if let movies = response.results {
                watchlistMovies = movies
            }
            errorMessage = nil
        } catch {
            errorMessage = "Couldn't retrieve watchlisted movies"
        }
    }
    
    func getWatchlistShows(accountId: Int, sessionId: String) async {
        do {
            let response = try await service.getWatchlistShows(accountId: accountId, sessionId: sessionId)
            if let shows = response.results {
                watchlistShows = shows
            }
            errorMessage = nil
        } catch {
            errorMessage = "Couldn't retrieve watchlisted shows"
        }
    }
}
