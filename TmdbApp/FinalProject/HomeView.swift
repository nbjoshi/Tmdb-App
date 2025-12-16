//
//  HomeView.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/17/25.
//

import SwiftData
import SwiftUI

struct HomeView: View {
    // MARK: - Properties

    @State private var selectedTab = 0
    @ObservedObject var profileVM: ProfileViewModel

    // MARK: - Body

    var body: some View {
        TabView(selection: $selectedTab) {
            // Home/Trending
            TrendingView(profileVM: profileVM)
                .tabItem {
                    Label("Home", systemImage: selectedTab == 0 ? "play.house.fill" : "play.house")
                }
                .tag(0)

            // Unified Search (combines regular and AI search)
            UnifiedSearchView(profileVM: profileVM)
                .tabItem {
                    Label("Search", systemImage: selectedTab == 1 ? "magnifyingglass.circle.fill" : "magnifyingglass.circle")
                }
                .tag(1)

            // Profile (includes Favorites and Watchlist)
            ProfileView(profileVM: profileVM)
                .tabItem {
                    Label("Profile", systemImage: selectedTab == 2 ? "person.crop.circle.fill" : "person.crop.circle")
                }
                .tag(2)
        }
        .preferredColorScheme(.dark)
        .tint(AppTheme.Colors.accent)
        .task {
            await initializeProfile()
        }
    }

    // MARK: - Methods

    @MainActor
    private func initializeProfile() async {
        profileVM.loadSession()
        if let savedSessionId = profileVM.session {
            await profileVM.getProfile(sessionId: savedSessionId)
        }
    }
}
