//
//  AiService.swift
//  FinalProject
//
//  Created by Neel Joshi on 12/13/25.
//
import Foundation

class AiService {
    func getAiSearch(description: String) async throws -> AiSearchResponse {
        let parameters = [
            "description": description,
        ] as [String: Any?]
        
        let postBody = try JSONSerialization.data(withJSONObject: parameters, options: [])

        guard let url = URL(string: "http://192.168.1.245:3000/tmdbcompanion/ai") else {
            throw URLError(.badURL)
        }
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)!

        var request = URLRequest(url: components.url!)
        request.httpMethod = "POST"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "content-type": "application/json"
        ]
        request.httpBody = postBody

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response: AiSearchResponse = try JSONDecoder().decode(AiSearchResponse.self, from: data)
            return response
        } catch {
            throw error
        }
    }
}
