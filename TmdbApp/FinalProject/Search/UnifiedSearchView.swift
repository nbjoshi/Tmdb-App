//
//  UnifiedSearchView.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/17/25.
//

import SwiftData
import SwiftUI

enum SearchMode {
    case regular
    case ai
}

struct UnifiedSearchView: View {
    // MARK: - Properties

    @State private var searchVM = SearchViewModel()
    @State private var aiVM = AiViewModel()
    @State private var searchQuery: String = ""
    @State private var selectedMedia: SelectedMedia?
    @State private var showAiDialog = false
    @State private var searchMode: SearchMode = .regular
    @FocusState private var isTextFieldFocused: Bool
    @ObservedObject var profileVM: ProfileViewModel
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \RecentSearch.timestamp, order: .reverse) private var recentSearches: [RecentSearch]

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.background.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Search Bar Section
                    searchBarSection

                    // Content Section
                    if searchQuery.isEmpty && searchVM.search.isEmpty && aiVM.aiResults == nil {
                        defaultContentView
                    } else if searchVM.isLoading || aiVM.isLoading {
                        LoadingView()
                    } else {
                        searchResultsView
                    }
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.large)
            .preferredColorScheme(.dark)
            .sheet(isPresented: $showAiDialog) {
                aiSearchDialog
            }
            .sheet(item: $selectedMedia) { media in
                mediaDetailView(for: media)
            }
        }
    }

    // MARK: - Search Bar Section

    private var searchBarSection: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            HStack(spacing: AppTheme.Spacing.md) {
                // Search Text Field
                HStack(spacing: AppTheme.Spacing.sm) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(AppTheme.Colors.textSecondary)

                    TextField("Search movies, TV shows, people...", text: $searchQuery)
                        .textFieldStyle(.plain)
                        .focused($isTextFieldFocused)
                        .foregroundColor(AppTheme.Colors.textPrimary)
                        .onSubmit {
                            performSearch()
                        }
                        .onChange(of: searchQuery) { _, newValue in
                            if newValue.isEmpty {
                                searchVM.clearSearch()
                                aiVM.clearAiResults()
                            }
                        }

                    if !searchQuery.isEmpty {
                        Button(action: {
                            searchQuery = ""
                            searchVM.query = ""
                            searchVM.clearSearch()
                            aiVM.clearAiResults()
                            hideKeyboard()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(AppTheme.Colors.textSecondary)
                        }
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.md)
                .padding(.vertical, AppTheme.Spacing.sm)
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                        .fill(AppTheme.Colors.surface)
                )

                // AI Search Button
                Button(action: {
                    showAiDialog = true
                }) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(AppTheme.Colors.textPrimary)
                        .frame(width: 44, height: 44)
                        .background(
                            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            AppTheme.Colors.primary,
                                            AppTheme.Colors.accent,
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                }
            }
            .padding(.horizontal, AppTheme.Spacing.md)
            .padding(.top, AppTheme.Spacing.sm)
        }
    }

    // MARK: - Default Content View

    private var defaultContentView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: AppTheme.Spacing.xl) {
                // AI Search Prompt
                VStack(spacing: AppTheme.Spacing.md) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 60))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    AppTheme.Colors.primary,
                                    AppTheme.Colors.accent,
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 100, height: 100)
                        .background(
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            AppTheme.Colors.primary.opacity(0.2),
                                            AppTheme.Colors.accent.opacity(0.1),
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )

                    Text("AI-Powered Search")
                        .font(AppTheme.Typography.title2)
                        .fontWeight(.bold)
                        .foregroundColor(AppTheme.Colors.textPrimary)

                    Text("Describe what you're looking for and let AI find it for you")
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, AppTheme.Spacing.xl)

                    Button(action: {
                        showAiDialog = true
                    }) {
                        HStack {
                            Image(systemName: "sparkles")
                            Text("Try AI Search")
                        }
                        .font(AppTheme.Typography.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(AppTheme.Colors.textPrimary)
                        .padding(.horizontal, AppTheme.Spacing.xl)
                        .padding(.vertical, AppTheme.Spacing.md)
                        .background(
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            AppTheme.Colors.primary,
                                            AppTheme.Colors.accent,
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                    }
                    .padding(.top, AppTheme.Spacing.sm)
                }
                .padding(.top, AppTheme.Spacing.xxl)

                // Recent Searches
                if !recentSearches.isEmpty {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                        Text("Recent Searches")
                            .font(AppTheme.Typography.title3)
                            .fontWeight(.bold)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                            .padding(.horizontal, AppTheme.Spacing.md)

                        ForEach(recentSearches.prefix(5)) { recent in
                            Button(action: {
                                searchQuery = recent.query
                                searchVM.query = recent.query
                                performSearch()
                            }) {
                                HStack(spacing: AppTheme.Spacing.md) {
                                    Image(systemName: "clock")
                                        .foregroundColor(AppTheme.Colors.textSecondary)
                                        .frame(width: 20)

                                    Text(recent.query)
                                        .font(AppTheme.Typography.body)
                                        .foregroundColor(AppTheme.Colors.textPrimary)

                                    Spacer()
                                }
                                .padding(.horizontal, AppTheme.Spacing.md)
                                .padding(.vertical, AppTheme.Spacing.sm)
                                .background(
                                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                                        .fill(AppTheme.Colors.surface)
                                )
                            }
                            .padding(.horizontal, AppTheme.Spacing.md)
                        }
                    }
                }

                // Quick Suggestions
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    Text("Trending Now")
                        .font(AppTheme.Typography.title3)
                        .fontWeight(.bold)
                        .foregroundColor(AppTheme.Colors.textPrimary)
                        .padding(.horizontal, AppTheme.Spacing.md)

                    Text("Search for popular movies and TV shows")
                        .font(AppTheme.Typography.subheadline)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                        .padding(.horizontal, AppTheme.Spacing.md)
                }
                .padding(.top, AppTheme.Spacing.lg)
            }
            .padding(.bottom, AppTheme.Spacing.xxl)
        }
    }

    // MARK: - Search Results View

    private var searchResultsView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: AppTheme.Spacing.md) {
                // AI Results
                if let aiResults = aiVM.aiResults {
                    aiResultsSection(aiResults)
                }

                // Regular Search Results
                if !searchVM.search.isEmpty {
                    regularSearchResultsSection
                } else if let errorMessage = searchVM.errorMessage {
                    errorView(message: errorMessage)
                }
            }
            .padding(.bottom, AppTheme.Spacing.xxl)
        }
    }

    // MARK: - AI Results Section

    private func aiResultsSection(_ results: AiSearchResponse) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            HStack {
                Image(systemName: "sparkles")
                    .foregroundColor(AppTheme.Colors.accent)
                Text("AI Search Results")
                    .font(AppTheme.Typography.title3)
                    .fontWeight(.bold)
                    .foregroundColor(AppTheme.Colors.textPrimary)
            }
            .padding(.horizontal, AppTheme.Spacing.md)

            if let summary = results.querySummary {
                Text(summary)
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.textSecondary)
                    .padding(.horizontal, AppTheme.Spacing.md)
            }

            if let candidates = results.candidates {
                ForEach(candidates) { candidate in
                    aiCandidateCard(candidate)
                }
            }
        }
        .padding(.top, AppTheme.Spacing.md)
    }

    private func aiCandidateCard(_ candidate: Candidate) -> some View {
        HStack(spacing: AppTheme.Spacing.md) {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                if let title = candidate.title {
                    Text(title)
                        .font(AppTheme.Typography.headline)
                        .foregroundColor(AppTheme.Colors.textPrimary)
                }

                if let type = candidate.type {
                    Text(type.capitalized)
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }

                if let rationale = candidate.rationale {
                    Text(rationale)
                        .font(AppTheme.Typography.footnote)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                        .lineLimit(2)
                }
            }

            Spacer()

            if let confidence = candidate.confidence {
                VStack {
                    Text("\(Int(confidence * 100))%")
                        .font(AppTheme.Typography.headline)
                        .fontWeight(.bold)
                        .foregroundColor(AppTheme.Colors.accent)
                    Text("Match")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
            }
        }
        .padding(AppTheme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                .fill(AppTheme.Colors.surface)
        )
        .padding(.horizontal, AppTheme.Spacing.md)
    }

    // MARK: - Regular Search Results Section

    private var regularSearchResultsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("Search Results")
                .font(AppTheme.Typography.title3)
                .fontWeight(.bold)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .padding(.horizontal, AppTheme.Spacing.md)

            LazyVStack(spacing: AppTheme.Spacing.md) {
                ForEach(searchVM.search) { result in
                    if result.mediaType == .movie || result.mediaType == .tv {
                        SearchCardView(search: result)
                            .onTapGesture {
                                selectedMedia = SelectedMedia(
                                    id: result.id,
                                    mediaType: result.mediaType.rawValue
                                )
                            }
                    } else {
                        SearchCardView(search: result)
                    }
                }
            }
            .padding(.horizontal, AppTheme.Spacing.md)
        }
    }

    // MARK: - AI Search Dialog

    private var aiSearchDialog: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.background.ignoresSafeArea()

                VStack(spacing: AppTheme.Spacing.xl) {
                    // Icon
                    Image(systemName: "sparkles")
                        .font(.system(size: 60))
                        .foregroundColor(AppTheme.Colors.accent)
                        .frame(width: 100, height: 100)
                        .background(
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            AppTheme.Colors.primary.opacity(0.2),
                                            AppTheme.Colors.accent.opacity(0.1),
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                        .padding(.top, AppTheme.Spacing.xxl)

                    // Title
                    Text("AI-Powered Search")
                        .font(AppTheme.Typography.title1)
                        .fontWeight(.bold)
                        .foregroundColor(AppTheme.Colors.textPrimary)

                    // Description
                    Text("Describe the movie, TV show, or person you're looking for in natural language")
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, AppTheme.Spacing.xl)

                    // Text Editor
                    TextEditor(text: $aiVM.description)
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.textPrimary)
                        .padding(AppTheme.Spacing.md)
                        .frame(height: 150)
                        .background(
                            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                                .fill(AppTheme.Colors.surface)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                                .stroke(AppTheme.Colors.primary.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.horizontal, AppTheme.Spacing.md)

                    // Search Button
                    Button(action: {
                        Task {
                            await aiVM.getAiSearch()
                            showAiDialog = false
                        }
                    }) {
                        HStack {
                            Image(systemName: "sparkles")
                            Text("Search with AI")
                        }
                        .font(AppTheme.Typography.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(AppTheme.Colors.textPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppTheme.Spacing.md)
                        .background(
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            AppTheme.Colors.primary,
                                            AppTheme.Colors.accent,
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                    }
                    .padding(.horizontal, AppTheme.Spacing.md)
                    .disabled(aiVM.description.isEmpty)
                    .opacity(aiVM.description.isEmpty ? 0.6 : 1.0)

                    Spacer()
                }
            }
            .navigationTitle("AI Search")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        showAiDialog = false
                        aiVM.description = ""
                    }
                }
            }
            .preferredColorScheme(.dark)
        }
    }

    // MARK: - Helper Views

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

    // MARK: - Error View

    private func errorView(message: String) -> some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 40))
                .foregroundColor(AppTheme.Colors.error)

            Text(message)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(AppTheme.Spacing.xl)
    }

    // MARK: - Methods

    private func performSearch() {
        guard !searchQuery.isEmpty else {
            searchVM.clearSearch()
            return
        }

        let recentSearch = RecentSearch(query: searchQuery)
        modelContext.insert(recentSearch)

        searchVM.query = searchQuery
        hideKeyboard()

        Task {
            await searchVM.getSearch()
        }
    }
}

// MARK: - Extensions

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

// MARK: - Preview

#Preview {
    UnifiedSearchView(profileVM: ProfileViewModel())
        .modelContainer(for: RecentSearch.self)
}
