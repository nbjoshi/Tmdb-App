//
//  WatchlistView.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/29/25.
//

import SwiftUI

enum WatchlistTab: String, CaseIterable {
    case movie = "Movies"
    case tv = "TV Shows"
}

struct WatchlistView: View {
    // MARK: - Properties

    @ObservedObject var profileVM: ProfileViewModel
    @State private var viewModel = WatchlistViewModel()
    @State private var selectedTab: WatchlistTab = .movie
    @State private var selectedMedia: SelectedMedia?

    // MARK: - Body

    var body: some View {
        Group {
            if profileVM.isLoggedIn {
                loggedInView
            } else {
                loggedOutView
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Logged In View

    private var loggedInView: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.background.ignoresSafeArea()

                if viewModel.isLoading && currentItems.isEmpty {
                    LoadingView()
                } else {
                    contentView
                }
            }
            .navigationTitle("Watchlist")
            .navigationBarTitleDisplayMode(.large)
        }
        .task {
            await loadWatchlist()
        }
        .refreshable {
            await loadWatchlist()
        }
        .onChange(of: selectedTab) { _, _ in
            Task {
                await loadWatchlist()
            }
        }
        .sheet(item: $selectedMedia) { media in
            mediaDetailView(for: media)
        }
    }

    // MARK: - Content View

    private var contentView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: AppTheme.Spacing.xl) {
                // Tab Picker
                TabPicker(
                    selection: Binding(
                        get: { WatchlistTab.allCases.firstIndex(of: selectedTab) ?? 0 },
                        set: { selectedTab = WatchlistTab.allCases[$0] }
                    ),
                    options: WatchlistTab.allCases.map { $0.rawValue }
                )
                .padding(.horizontal, AppTheme.Spacing.md)
                .padding(.top, AppTheme.Spacing.sm)

                // Content Grid
                if currentItems.isEmpty {
                    emptyStateView
                } else {
                    MediaGrid(
                        mediaItems: currentMediaItems,
                        onMediaTap: { media in
                            selectedMedia = SelectedMedia(
                                id: media.id,
                                mediaType: media.mediaType.rawValue
                            )
                        }
                    )
                }
            }
            .padding(.bottom, AppTheme.Spacing.xxl)
        }
    }

    // MARK: - Logged Out View

    private var loggedOutView: some View {
        EmptyStateView(
            icon: "tv.fill",
            title: "No Watchlist Yet",
            message: "Log in to save movies and TV shows to your watchlist, and view them here anytime."
        )
    }

    // MARK: - Helper Views

    private var emptyStateView: some View {
        EmptyStateView(
            icon: "tv.slash.fill",
            title: selectedTab == .movie ? "No Movies in Watchlist" : "No Shows in Watchlist",
            message: "Begin adding \(selectedTab.rawValue.lowercased()) to your watchlist by searching for them or exploring the trending page."
        )
        .padding(.top, AppTheme.Spacing.xxl)
    }

    @ViewBuilder
    private func mediaDetailView(for media: SelectedMedia) -> some View {
        if media.mediaType == MediaType.movie.rawValue {
            MovieDetailCard(
                trendingId: media.id,
                sessionId: profileVM.session ?? "",
                accountId: profileVM.profile?.id ?? 0,
                isLoggedIn: profileVM.isLoggedIn
            )
        } else if media.mediaType == MediaType.tv.rawValue {
            ShowDetailCard(
                trendingId: media.id,
                sessionId: profileVM.session ?? "",
                accountId: profileVM.profile?.id ?? 0,
                isLoggedIn: profileVM.isLoggedIn
            )
        }
    }

    // MARK: - Computed Properties

    private var currentItems: [WatchlistMedia] {
        selectedTab == .movie ? viewModel.watchlistMovies : viewModel.watchlistShows
    }

    private var currentMediaItems: [Media] {
        currentItems.map { watchlist in
            Media(
                id: watchlist.id,
                mediaType: watchlist.mediaType,
                posterPath: watchlist.posterPath,
                profilePath: nil,
                title: watchlist.title,
                name: watchlist.name
            )
        }
    }

    // MARK: - Methods

    @MainActor
    private func loadWatchlist() async {
        guard let accountId = profileVM.profile?.id,
              let sessionId = profileVM.session else { return }

        switch selectedTab {
        case .movie:
            await viewModel.fetchWatchlistMovies(accountId: accountId, sessionId: sessionId)
        case .tv:
            await viewModel.fetchWatchlistShows(accountId: accountId, sessionId: sessionId)
        }
    }
}

// MARK: - Preview

#Preview {
    WatchlistView(profileVM: ProfileViewModel())
}
