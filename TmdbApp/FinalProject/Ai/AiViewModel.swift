//
//  AiViewModel.swift
//  FinalProject
//
//  Created by Neel Joshi on 12/13/25.
//

import Foundation
import Observation

@Observable
class AiViewModel {
    var description: String = ""
    var aiResults: AiSearchResponse? = nil
    private let service = AiService()
    var errorMessage: String? = nil
    
    func getAiSearch() async {
        if description.isEmpty {
            return
        }
        
        do {
            let response = try await service.getAiSearch(description: description)
            aiResults = response
            errorMessage = nil
        } catch {
            errorMessage = "Failed to make search: \(error)"
        }
    }
}
