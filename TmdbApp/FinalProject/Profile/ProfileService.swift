//
//  ProfileService.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/23/25.
//

import Foundation

class ProfileService {
    func createRequestToken() async throws -> RequestTokenResponse {
        guard let url = URL(string: "https://api.themoviedb.org/3/authentication/token/new") else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(Constants.access_token)",
        ]

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response: RequestTokenResponse = try JSONDecoder().decode(RequestTokenResponse.self, from: data)
            return response
        } catch {
            throw error
        }
    }

    func validateRequestToken(username: String, password: String, requestToken: String) async throws -> RequestTokenResponse {
        let parameters = [
            "username": username,
            "password": password,
            "request_token": requestToken,
        ] as [String: Any?]

        let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])

        guard let url = URL(string: "https://api.themoviedb.org/3/authentication/token/validate_with_login") else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
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
            let response: RequestTokenResponse = try JSONDecoder().decode(RequestTokenResponse.self, from: data)
            return response
        } catch {
            throw error
        }
    }

    func createSession(requestToken: String) async throws -> SessionIdResponse {
        let parameters = ["request_token": requestToken] as [String: Any?]
        let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])

        guard let url = URL(string: "https://api.themoviedb.org/3/authentication/session/new") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
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
            let response: SessionIdResponse = try JSONDecoder().decode(SessionIdResponse.self, from: data)
            return response
        } catch {
            throw error
        }
    }

    func deleteSession(sessionId: String) async throws -> DeleteSessionResponse {
        let parameters = ["session_id": sessionId] as [String: Any?]
        let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])

        guard let url = URL(string: "https://api.themoviedb.org/3/authentication/session") else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "content-type": "application/json",
            "Authorization": "Bearer \(Constants.access_token)",
        ]
        request.httpBody = postData

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response: DeleteSessionResponse = try JSONDecoder().decode(DeleteSessionResponse.self, from: data)
            return response
        } catch {
            throw error
        }
    }

    func getProfile(sessionId: String) async throws -> Profile {
        guard let url = URL(string: "https://api.themoviedb.org/3/account") else {
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
            let response: Profile = try JSONDecoder().decode(Profile.self, from: data)
            return response
        } catch {
            throw error
        }
    }
}
