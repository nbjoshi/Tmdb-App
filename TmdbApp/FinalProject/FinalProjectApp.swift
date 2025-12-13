//
//  FinalProjectApp.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/14/25.
//

import SwiftData
import SwiftUI

@main
struct FinalProjectApp: App {
    @StateObject private var profileVM = ProfileViewModel()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            WidgetModel.self,
            RecentSearch.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            HomeView(profileVM: profileVM)
        }
        .modelContainer(sharedModelContainer)
    }
}
