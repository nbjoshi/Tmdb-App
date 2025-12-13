//
//  CardDetailService.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/17/25.
//

import Foundation

class CardDetailService {
    func getMovieDetails(movieId: Int) async throws -> MovieDetails {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)") else {
            throw URLError(.badURL)
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "en-US"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(Constants.access_token)",
        ]
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response: MovieDetails = try JSONDecoder().decode(MovieDetails.self, from: data)
            return response
        } catch {
            throw error
        }
    }
    
    func getShowDetails(showId: Int) async throws -> ShowDetails {
        guard let url = URL(string: "https://api.themoviedb.org/3/tv/\(showId)") else {
            throw URLError(.badURL)
        }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "en-US"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(Constants.access_token)",
        ]
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response: ShowDetails = try JSONDecoder().decode(ShowDetails.self, from: data)
            return response
        } catch {
            throw error
        }
    }
    
    func getSimilarMovies(movieId: Int) async throws -> SimilarMoviesResponse {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)/recommendations") else {
            throw URLError(.badURL)
        }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "1"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(Constants.access_token)",
        ]
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response: SimilarMoviesResponse = try JSONDecoder().decode(SimilarMoviesResponse.self, from: data)
            return response
        } catch {
            throw error
        }
    }
    
    func getSimilarShows(showId: Int) async throws -> SimilarShowsResponse {
        guard let url = URL(string: "https://api.themoviedb.org/3/tv/\(showId)/recommendations") else {
            throw URLError(.badURL)
        }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "1"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(Constants.access_token)",
        ]
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response: SimilarShowsResponse = try JSONDecoder().decode(SimilarShowsResponse.self, from: data)
            return response
        } catch {
            throw error
        }
    }
    
    func getSeasonDetails(showId: Int, seasonNumber: Int) async throws -> SeasonDetails {
        guard let url = URL(string: "https://api.themoviedb.org/3/tv/\(showId)/season/\(seasonNumber)") else {
            throw URLError(.badURL)
        }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "en-US"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(Constants.access_token)",
        ]
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response: SeasonDetails = try JSONDecoder().decode(SeasonDetails.self, from: data)
            return response
        } catch {
            throw error
        }
    }
    
    func markAsFavorite(accountId: Int, sessionId: String, mediaType: String, mediaId: Int, favorite: Bool) async throws -> FavoritesResponse {
        let parameters = [
            "media_type": mediaType,
            "media_id": mediaId,
            "favorite": favorite,
        ] as [String: Any?]
        
        let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
        
        guard let url = URL(string: "https://api.themoviedb.org/3/account/\(accountId)/favorite") else {
            throw URLError(.badURL)
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "session_id", value: sessionId),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "POST"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "content-type": "application/json",
            "Authorization": "Bearer \(Constants.access_token)",
        ]
        request.httpBody = postData
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response: FavoritesResponse = try JSONDecoder().decode(FavoritesResponse.self, from: data)
            return response
        } catch {
            throw error
        }
    }
    
    func getShowState(showId: Int, sessionId: String) async throws -> StateResponse {
        guard let url = URL(string: "https://api.themoviedb.org/3/tv/\(showId)/account_states") else {
            throw URLError(.badURL)
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "session_id", value: sessionId),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(Constants.access_token)",
        ]
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response: StateResponse = try JSONDecoder().decode(StateResponse.self, from: data)
            return response
        } catch {
            throw error
        }
    }
    
    func getMovieState(movieId: Int, sessionId: String) async throws -> StateResponse {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)/account_states") else {
            throw URLError(.badURL)
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "session_id", value: sessionId),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(Constants.access_token)",
        ]
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response: StateResponse = try JSONDecoder().decode(StateResponse.self, from: data)
            return response
        } catch {
            throw error
        }
    }
    
    func markAsWatchlist(accountId: Int, sessionId: String, mediaType: String, mediaId: Int, watchlist: Bool) async throws -> WatchlistResponse {
        let parameters = [
            "media_type": mediaType,
            "media_id": mediaId,
            "watchlist": watchlist,
        ] as [String: Any?]

        let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])

        guard let url = URL(string: "https://api.themoviedb.org/3/account/\(accountId)/watchlist") else {
            throw URLError(.badURL)
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "session_id", value: sessionId),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "POST"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "content-type": "application/json",
            "Authorization": "Bearer \(Constants.access_token)",
        ]
        request.httpBody = postData

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response: WatchlistResponse = try JSONDecoder().decode(WatchlistResponse.self, from: data)
            return response
        } catch {
            throw error
        }
    }
    
    func getMovieReviews(movieId: Int) async throws -> ReviewResponse {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)/reviews") else {
            throw URLError(.badURL)
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "1"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(Constants.access_token)",
        ]

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response: ReviewResponse = try JSONDecoder().decode(ReviewResponse.self, from: data)
            return response
        } catch {
            throw error
        }
    }
    
    func getShowReviews(showId: Int) async throws -> ReviewResponse {
        guard let url = URL(string: "https://api.themoviedb.org/3/tv/\(showId)/reviews") else {
            throw URLError(.badURL)
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "1"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(Constants.access_token)",
        ]

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response: ReviewResponse = try JSONDecoder().decode(ReviewResponse.self, from: data)
            return response
        } catch {
            throw error
        }
    }
    
    func getVideos(mediaId: Int, mediaType: String) async throws -> VideoResponse {
        guard let url = URL(string: "https://api.themoviedb.org/3/\(mediaType)/\(mediaId)/videos") else {
            throw URLError(.badURL)
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "en-US"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(Constants.access_token)",
        ]

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response: VideoResponse = try JSONDecoder().decode(VideoResponse.self, from: data)
            return response
        } catch {
            throw error
        }
    }
}
