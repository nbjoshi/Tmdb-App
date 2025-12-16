//
//  SearchViewModel.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/17/25.
//

import Foundation
import Observation

@Observable
final class SearchViewModel {
    private(set) var search: [Media] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    var query: String = ""

    private let service: SearchService

    init(service: SearchService = SearchService()) {
        self.service = service
    }

    var isQueryValid: Bool { !query.isEmpty }

    @MainActor
    func getSearch() async {
        guard isQueryValid else {
            search = []
            return
        }

        isLoading = true
        errorMessage = nil

        defer { isLoading = false }

        do {
            let response = try await service.getSearch(query: query)
            search = response.results
        } catch {
            errorMessage = "Failed to make search: \(error.localizedDescription)"
            search = []
        }
    }

    func clearSearch() {
        search = []
        errorMessage = nil
    }
}
