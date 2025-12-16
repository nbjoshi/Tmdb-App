//
//  AiViewModel.swift
//  FinalProject
//
//  Created by Neel Joshi on 12/13/25.
//

import Foundation
import Observation

@Observable
final class AiViewModel {
    var description: String = ""
    private(set) var aiResults: AiSearchResponse?
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    private let service: AiService

    init(service: AiService = AiService()) {
        self.service = service
    }

    @MainActor
    func getAiSearch() async {
        guard !description.isEmpty else {
            aiResults = nil
            return
        }

        isLoading = true
        errorMessage = nil

        defer { isLoading = false }

        do {
            let response = try await service.getAiSearch(description: description)
            aiResults = response
        } catch {
            errorMessage = "Failed to make AI search: \(error.localizedDescription)"
            aiResults = nil
        }
    }

    func clearAiResults() {
        aiResults = nil
        errorMessage = nil
    }
}
