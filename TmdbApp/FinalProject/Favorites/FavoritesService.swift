//
//  FavoritesService.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/25/25.
//

import Foundation

class FavoritesService {
    func addToFavorite(mediaType: MediaType, mediaId: Int, accountId: Int, sessionId: String) async throws -> FavoritesResponse {
        let parameters = [
            "media_type": mediaType.rawValue,
            "media_id": mediaId,
            "favorite": true,
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

    func getFavoriteMovies(accountId: Int, sessionId: String) async throws -> FavoriteMediaResponse {
        guard let url = URL(string: "https://api.themoviedb.org/3/account/\(accountId)/favorite/movies") else {
            throw URLError(.badURL)
        }

        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "sort_by", value: "created_at.asc"),
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
            let response: FavoriteMediaResponse = try JSONDecoder().decode(FavoriteMediaResponse.self, from: data)
            return response
        } catch {
            throw error
        }
    }

    func getFavoriteShows(accountId: Int, sessionId: String) async throws -> FavoriteMediaResponse {
        guard let url = URL(string: "https://api.themoviedb.org/3/account/\(accountId)/favorite/tv") else {
            throw URLError(.badURL)
        }

        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "sort_by", value: "created_at.asc"),
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
            let response: FavoriteMediaResponse = try JSONDecoder().decode(FavoriteMediaResponse.self, from: data)
            return response
        } catch {
            throw error
        }
    }
}
