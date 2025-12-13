//
//  ProfileViewModel.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/23/25.
//

import Foundation
import Observation

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var token: String? = nil
    @Published var validatedToken: String? = nil
    @Published var session: String? = nil
    let service = ProfileService()
    @Published var errorMessage: String? = nil
    @Published var profile: Profile? = nil
    @Published var isLoggedIn: Bool = false
        
    func createRequestToken() async {
        do {
            let response = try await service.createRequestToken()
            if response.success {
                token = response.requestToken
                errorMessage = nil
            } else {
                errorMessage = "Failed to create request token: Unknown error"
            }
        } catch {
            errorMessage = "Failed to create request token: \(error)"
        }
    }
    
    func validateRequestToken(username: String, password: String, requestToken: String) async {
        do {
            let response = try await service.validateRequestToken(username: username, password: password, requestToken: requestToken)
            if response.success {
                validatedToken = response.requestToken
                errorMessage = nil
            } else {
                errorMessage = "Failed to validate request token: Unknown error"
            }
        } catch {
            errorMessage = "Failed to validate request token: \(error)"
        }
    }
    
    func createSession(requestToken: String) async {
        do {
            let response = try await service.createSession(requestToken: requestToken)
            if response.success {
                session = response.sessionId
                errorMessage = nil
            } else {
                errorMessage = "Failed to create session: Unknown error"
            }
        } catch {
            errorMessage = "Failed to create session: \(error)"
        }
    }
    
    func deleteSession(sessionId: String) async {
        do {
            let response = try await service.deleteSession(sessionId: sessionId)
            if response.success {
                errorMessage = nil
            } else {
                errorMessage = "Failed to delete session: Unknown error"
            }
        } catch {
            errorMessage = "Failed to delete session: \(error)"
        }
    }
    
    func getProfile(sessionId: String) async {
        do {
            let response = try await service.getProfile(sessionId: sessionId)
            profile = response
            isLoggedIn = true
            errorMessage = nil
        } catch {
            errorMessage = "Failed to get profile: \(error)"
        }
    }
    
    // Source: https://medium.com/@ranga.c222/how-to-save-sensitive-data-in-keychain-in-ios-using-swift-c839d0e98f9d
    func saveSession(username: String, sessionId: String) {
        let sessionData = sessionId.data(using: .utf8)!
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "tmdb_session_id",
            kSecValueData as String: sessionData,
        ]
        
        SecItemDelete(query as CFDictionary)

        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            errorMessage = "Failed to save session: Unknown error"
        } else {
            errorMessage = nil
        }
    }
    
    func loadSession() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "tmdb_session_id",
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        if status == errSecSuccess, let data = item as? Data {
            if let sessionId = String(data: data, encoding: .utf8) {
                session = sessionId
            }
        } else {
            errorMessage = "Failed to load session: \(status)"
        }
    }
    
    func removeSession() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "tmdb_session_id",
        ]
        
        let status = SecItemDelete(query as CFDictionary)
                
        if status == errSecSuccess {
            print("Successfully deleted sessionId from Keychain")
            errorMessage = nil
        } else if status == errSecItemNotFound {
            print("No sessionId found in Keychain to delete")
            errorMessage = "Failed to delete session from Keychain: \(status)"
        } else {
            print("Failed to delete sessionId from Keychain with status: \(status)")
            errorMessage = "Failed to delete session from Keychain: \(status)"
        }
    }
    
    func logout() async {
        if let sessionId = session {
            await deleteSession(sessionId: sessionId)
        }
        removeSession()
        profile = nil
        isLoggedIn = false
    }
}
