//
//  SwiftUIView.swift
//  FinalProject
//
//  Created by Neel Joshi on 12/13/25.
//

import SwiftUI

struct AiView: View {
    @State var description: String = ""
    @State var aiVM = AiViewModel()
    
    var body: some View {
        VStack {
            TextField("description", text: $description)
                .textFieldStyle(.roundedBorder)
                .submitLabel(.search)
                .onSubmit {
                    if description.isEmpty {
                        aiVM.description = ""
                        return
                    }
                    aiVM.description = description
                    Task {
                        await aiVM.getAiSearch()
                    }
                }
            Spacer()
            if let results = aiVM.aiResults {
                VStack {
                    Text(results.querySummary ?? "")
                    if let candidates = results.candidates {
                        ForEach(candidates) { candidate in
                            HStack {
                                Text(candidate.title ?? "Unknown")
                                Spacer()
                                Text(candidate.confidence.map { "\(Int($0 * 100))%" } ?? "")
                            }
                        }
                    }
                }
                .padding(.horizontal)
            } else if let msg = aiVM.errorMessage {
                Text(msg)
                    .foregroundStyle(.red)
                    .padding(.horizontal)
            }
        }
        .padding()
    }
}

//#Preview {
//    SwiftUIView()
//}
