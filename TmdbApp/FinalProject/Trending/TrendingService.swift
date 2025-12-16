//
//  TrendingService.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/15/25.
//

import Foundation

class TrendingService {
    func getTrending(type: String) async throws -> TrendingResponse {
        guard let url = URL(string: "https://api.themoviedb.org/3/trending/\(type)/day") else {
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
            let response: TrendingResponse = try JSONDecoder().decode(TrendingResponse.self, from: data)
            return response
        } catch {
            throw error
        }
    }
}
