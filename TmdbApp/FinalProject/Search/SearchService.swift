//
//  SearchService.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/17/25.
//

import Foundation

class SearchService {
    func getSearch(query: String) async throws -> SearchResponse {
        guard let url = URL(string: "https://api.themoviedb.org/3/search/multi") else {
            throw URLError(.badURL)
        }

        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "include_adult", value: "false"),
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
            let response: SearchResponse = try JSONDecoder().decode(SearchResponse.self, from: data)
            return response
        } catch {
            throw error
        }
    }
}
