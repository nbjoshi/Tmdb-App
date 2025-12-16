//
//  TrendingView.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/17/25.
//

import SwiftData
import SwiftUI

enum TrendingTab: String, CaseIterable {
    case all = "All"
    case movie = "Movies"
    case tv = "TV Shows"

    var pathValue: String {
        switch self {
        case .all:
            return "all"
        case .movie:
            return "movie"
        case .tv:
            return "tv"
        }
    }
}

struct SelectedMedia: Identifiable {
    var id: Int
    var mediaType: String
}

struct TrendingView: View {
    // MARK: - Properties

    @State private var viewModel = TrendingViewModel()
    @State private var selectedTab: TrendingTab = .all
    @State private var selectedMedia: SelectedMedia?
    @ObservedObject var profileVM: ProfileViewModel
    @Environment(\.modelContext) private var modelContext

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                AppTheme.Colors.background.ignoresSafeArea()

                if viewModel.isLoading && viewModel.trending.isEmpty {
                    LoadingView()
                } else if let errorMessage = viewModel.errorMessage, viewModel.trending.isEmpty {
                    errorView(message: errorMessage)
                } else {
                    contentView
                }
            }
            .navigationTitle("Trending")
            .navigationBarTitleDisplayMode(.large)
            .preferredColorScheme(.dark)
        }
        .task {
            await loadTrending()
        }
        .refreshable {
            await loadTrending()
        }
        .onChange(of: selectedTab) { _, newTab in
            Task {
                await viewModel.fetchTrending(type: newTab)
            }
        }
        .sheet(item: $selectedMedia) { media in
            mediaDetailView(for: media)
        }
    }

    // MARK: - Content Views

    private var contentView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: AppTheme.Spacing.xl) {
                // Tab Picker
                TabPicker(
                    selection: Binding(
                        get: { TrendingTab.allCases.firstIndex(of: selectedTab) ?? 0 },
                        set: { selectedTab = TrendingTab.allCases[$0] }
                    ),
                    options: TrendingTab.allCases.map { $0.rawValue }
                )
                .padding(.horizontal, AppTheme.Spacing.md)
                .padding(.top, AppTheme.Spacing.sm)

                // Featured Hero Card
                if let featured = viewModel.featuredMedia {
                    HeroCard(media: featured) {
                        selectedMedia = SelectedMedia(
                            id: featured.id,
                            mediaType: featured.mediaType.rawValue
                        )
                    }
                    .padding(.horizontal, AppTheme.Spacing.md)
                }

                // Content based on selected tab
                switch selectedTab {
                case .all:
                    allContent
                case .movie:
                    moviesContent
                case .tv:
                    tvShowsContent
                }
            }
            .padding(.bottom, AppTheme.Spacing.xxl)
        }
    }

    private var allContent: some View {
        VStack(spacing: AppTheme.Spacing.xl) {
            if !viewModel.movies.isEmpty {
                HorizontalMediaRow(
                    title: "Trending Movies",
                    mediaItems: viewModel.movies
                ) { media in
                    selectedMedia = SelectedMedia(
                        id: media.id,
                        mediaType: media.mediaType.rawValue
                    )
                }
            }

            if !viewModel.tvShows.isEmpty {
                HorizontalMediaRow(
                    title: "Trending TV Shows",
                    mediaItems: viewModel.tvShows
                ) { media in
                    selectedMedia = SelectedMedia(
                        id: media.id,
                        mediaType: media.mediaType.rawValue
                    )
                }
            }
        }
    }

    private var moviesContent: some View {
        MediaGrid(
            mediaItems: viewModel.movies,
            onMediaTap: { media in
                selectedMedia = SelectedMedia(
                    id: media.id,
                    mediaType: media.mediaType.rawValue
                )
            }
        )
    }

    private var tvShowsContent: some View {
        MediaGrid(
            mediaItems: viewModel.tvShows,
            onMediaTap: { media in
                selectedMedia = SelectedMedia(
                    id: media.id,
                    mediaType: media.mediaType.rawValue
                )
            }
        )
    }

    // MARK: - Helper Views

    private func errorView(message: String) -> some View {
        EmptyStateView(
            icon: "exclamationmark.triangle",
            title: "Oops!",
            message: message,
            actionTitle: "Try Again"
        ) {
            Task {
                await loadTrending()
            }
        }
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

    // MARK: - Methods

    @MainActor
    private func loadTrending() async {
        await viewModel.fetchTrending(type: selectedTab)
    }
}

// MARK: - Preview

#Preview {
    TrendingView(profileVM: ProfileViewModel())
        .modelContainer(for: RecentSearch.self)
}
