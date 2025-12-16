//
//  FavoritesView.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/17/25.
//

import SwiftUI

enum FavoritesTab: String, CaseIterable {
    case movie = "Movies"
    case tv = "TV Shows"
}

struct FavoritesView: View {
    // MARK: - Properties

    @ObservedObject var profileVM: ProfileViewModel
    @State private var viewModel = FavoritesViewModel()
    @State private var selectedTab: FavoritesTab = .movie
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
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.large)
        }
        .task {
            await loadFavorites()
        }
        .refreshable {
            await loadFavorites()
        }
        .onChange(of: selectedTab) { _, _ in
            Task {
                await loadFavorites()
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
                        get: { FavoritesTab.allCases.firstIndex(of: selectedTab) ?? 0 },
                        set: { selectedTab = FavoritesTab.allCases[$0] }
                    ),
                    options: FavoritesTab.allCases.map { $0.rawValue }
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
            icon: "star.fill",
            title: "No Favorites Yet",
            message: "Log in to save your favorite movies and TV shows, and view them here anytime."
        )
    }

    // MARK: - Helper Views

    private var emptyStateView: some View {
        EmptyStateView(
            icon: "star.slash.fill",
            title: selectedTab == .movie ? "No Favorite Movies" : "No Favorite Shows",
            message: "Begin adding \(selectedTab.rawValue.lowercased()) to your favorites by searching for them or exploring the trending page."
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

    private var currentItems: [FavoriteMedia] {
        selectedTab == .movie ? viewModel.favoriteMovies : viewModel.favoriteShows
    }

    private var currentMediaItems: [Media] {
        currentItems.map { favorite in
            Media(
                id: favorite.id,
                mediaType: favorite.mediaType,
                posterPath: favorite.posterPath,
                profilePath: nil,
                title: favorite.title,
                name: favorite.name
            )
        }
    }

    // MARK: - Methods

    @MainActor
    private func loadFavorites() async {
        guard let accountId = profileVM.profile?.id,
              let sessionId = profileVM.session else { return }

        switch selectedTab {
        case .movie:
            await viewModel.fetchFavoriteMovies(accountId: accountId, sessionId: sessionId)
        case .tv:
            await viewModel.fetchFavoriteShows(accountId: accountId, sessionId: sessionId)
        }
    }
}

// MARK: - Preview

#Preview {
    FavoritesView(profileVM: ProfileViewModel())
}
