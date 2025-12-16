//
//  CardDetailViewModel.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/17/25.
//

import Foundation
import Observation

@Observable
class CardDetailViewModel {
    var mediaDetails: MediaDetails?
    var seasonEpisodes: [Episode]?
    var errorMessage: String?
    var similarMedia: [SimilarMedia] = []
    private let service = CardDetailService()
    var isFavorited: Bool = false
    var isWatchlisted: Bool = false
    var reviews: [Review] = []
    var videos: [Video] = []

    func getMovieDetails(movieId: Int) async {
        do {
            let response = try await service.getMovieDetails(movieId: movieId)
            mediaDetails = response
            errorMessage = nil
        } catch {
            errorMessage = "Failed to fetch movie details: \(error)"
        }
    }

    func getShowDetails(showId: Int) async {
        do {
            let response = try await service.getShowDetails(showId: showId)
            mediaDetails = response
            errorMessage = nil
        } catch {
            errorMessage = "Failed to fetch show details: \(error)"
        }
    }

    func getSimilarMovies(movieId: Int) async {
        do {
            let response = try await service.getSimilarMovies(movieId: movieId)
            similarMedia = response.results
            errorMessage = nil
        } catch {
            errorMessage = "Failed to fetch similar movies: \(error)"
        }
    }

    func getSimilarShows(showId: Int) async {
        do {
            let response = try await service.getSimilarShows(showId: showId)
            similarMedia = response.results
            errorMessage = nil
        } catch {
            errorMessage = "Failed to fetch similar shows: \(error)"
        }
    }

    func getSeasonDetails(showId: Int, seasonNumber: Int) async {
        do {
            let response = try await service.getSeasonDetails(showId: showId, seasonNumber: seasonNumber)
            seasonEpisodes = response.episodes
            errorMessage = nil
        } catch {
            errorMessage = "Failed to fetch season episodes: \(error)"
        }
    }

    func markAsFavorite(accountId: Int, sessionId: String, mediaType: MediaType, mediaId: Int, favorite: Bool) async {
        do {
            let response = try await service.markAsFavorite(accountId: accountId, sessionId: sessionId, mediaType: mediaType, mediaId: mediaId, favorite: favorite)
            if response.statusMessage == "Success" {
                errorMessage = nil
            }
        } catch {
            errorMessage = "Failed to add to favorites: \(error)"
        }
    }

    func getShowState(showId: Int, sessionId: String) async {
        do {
            let response = try await service.getShowState(showId: showId, sessionId: sessionId)
            isFavorited = response.favorite
            isWatchlisted = response.watchlist
        } catch {
            errorMessage = "Failed to retrieve show state."
        }
    }

    func getMovieState(movieId: Int, sessionId: String) async {
        do {
            let response = try await service.getMovieState(movieId: movieId, sessionId: sessionId)
            isFavorited = response.favorite
            isWatchlisted = response.watchlist
        } catch {
            errorMessage = "Failed to retrieve movie state."
        }
    }

    func markAsWatchlist(accountId: Int, sessionId: String, mediaType: MediaType, mediaId: Int, watchlist: Bool) async {
        do {
            let response = try await service.markAsWatchlist(accountId: accountId, sessionId: sessionId, mediaType: mediaType, mediaId: mediaId, watchlist: watchlist)
            if response.statusMessage == "Success" {
                errorMessage = nil
            }
        } catch {
            errorMessage = "Failed to add to watchlist: \(error)"
        }
    }

    func getMovieReviews(movieId: Int) async {
        do {
            let response = try await service.getMovieReviews(movieId: movieId)
            reviews = response.results.reversed()
            errorMessage = nil
        } catch {
            errorMessage = "Failed to load movie reviews: \(error)"
        }
    }

    func getShowReviews(showId: Int) async {
        do {
            let response = try await service.getShowReviews(showId: showId)
            reviews = response.results.reversed()
            errorMessage = nil
        } catch {
            errorMessage = "Failed to load show reviews: \(error)"
        }
    }

    func getVideos(mediaId: Int, mediaType: MediaType) async {
        do {
            let response = try await service.getVideos(mediaId: mediaId, mediaType: mediaType)
            videos = response.results
            errorMessage = nil
        } catch {
            errorMessage = "Failed to load videos: \(error)"
        }
    }
}
