//
//  ProfileView.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/23/25.
//

import SwiftUI

enum ProfileSection: String, CaseIterable {
    case favorites = "Favorites"
    case watchlist = "Watchlist"
}

struct ProfileView: View {
    // MARK: - Properties

    @ObservedObject var profileVM: ProfileViewModel
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var selectedSection: ProfileSection? = nil
    @State private var favoritesVM = FavoritesViewModel()
    @State private var watchlistVM = WatchlistViewModel()
    @State private var selectedMedia: SelectedMedia?

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.background.ignoresSafeArea()

                if let profile = profileVM.profile {
                    loggedInView(profile: profile)
                } else {
                    loggedOutView
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .preferredColorScheme(.dark)
            .sheet(item: $selectedMedia) { media in
                mediaDetailView(for: media)
            }
        }
    }

    // MARK: - Logged In View

    private func loggedInView(profile: Profile) -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: AppTheme.Spacing.xl) {
                // Profile Header
                profileHeader(profile: profile)

                // Quick Actions
                quickActionsSection

                // Favorites Section
                favoritesSection

                // Watchlist Section
                watchlistSection

                // Logout Button
                logoutButton
            }
            .padding(.bottom, AppTheme.Spacing.xxl)
        }
    }

    // MARK: - Profile Header

    private func profileHeader(profile: Profile) -> some View {
        VStack(spacing: AppTheme.Spacing.md) {
            // Avatar
            Group {
                if let avatarPath = profile.avatar.tmdb.avatarPath,
                   let url = URL(string: "https://image.tmdb.org/t/p/w200\(avatarPath)")
                {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            placeholderAvatar
                        case let .success(image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        case .failure:
                            placeholderAvatar
                        @unknown default:
                            placeholderAvatar
                        }
                    }
                } else {
                    placeholderAvatar
                }
            }
            .frame(width: 120, height: 120)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [
                                AppTheme.Colors.primary,
                                AppTheme.Colors.accent,
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 4
                    )
            )
            .shadow(color: AppTheme.Colors.primary.opacity(0.3), radius: 20, x: 0, y: 10)

            // Name and Username
            VStack(spacing: AppTheme.Spacing.xs) {
                Text("Welcome, \(profile.name)!")
                    .font(AppTheme.Typography.title2)
                    .fontWeight(.bold)
                    .foregroundColor(AppTheme.Colors.textPrimary)

                Text("@\(profile.username)")
                    .font(AppTheme.Typography.subheadline)
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
        }
        .padding(.top, AppTheme.Spacing.lg)
    }

    private var placeholderAvatar: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            AppTheme.Colors.primary.opacity(0.3),
                            AppTheme.Colors.accent.opacity(0.2),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Image(systemName: "person.fill")
                .font(.system(size: 50))
                .foregroundColor(AppTheme.Colors.textSecondary)
        }
    }

    // MARK: - Quick Actions Section

    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("Quick Actions")
                .font(AppTheme.Typography.title3)
                .fontWeight(.bold)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .padding(.horizontal, AppTheme.Spacing.md)

            HStack(spacing: AppTheme.Spacing.md) {
                actionButton(
                    icon: "star.fill",
                    title: "Favorites",
                    color: AppTheme.Colors.accent
                ) {
                    selectedSection = .favorites
                }

                actionButton(
                    icon: "tv.fill",
                    title: "Watchlist",
                    color: AppTheme.Colors.primary
                ) {
                    selectedSection = .watchlist
                }
            }
            .padding(.horizontal, AppTheme.Spacing.md)
        }
    }

    private func actionButton(
        icon: String,
        title: String,
        color: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(spacing: AppTheme.Spacing.sm) {
                Image(systemName: icon)
                    .font(.system(size: 30))
                    .foregroundColor(color)
                    .frame(width: 60, height: 60)
                    .background(
                        Circle()
                            .fill(color.opacity(0.2))
                    )

                Text(title)
                    .font(AppTheme.Typography.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(AppTheme.Colors.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppTheme.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                    .fill(AppTheme.Colors.surface)
            )
        }
    }

    // MARK: - Favorites Section

    private var favoritesSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            HStack {
                Text("My Favorites")
                    .font(AppTheme.Typography.title3)
                    .fontWeight(.bold)
                    .foregroundColor(AppTheme.Colors.textPrimary)

                Spacer()

                NavigationLink(destination: favoritesDetailView) {
                    Text("See All")
                        .font(AppTheme.Typography.subheadline)
                        .foregroundColor(AppTheme.Colors.primary)
                }
            }
            .padding(.horizontal, AppTheme.Spacing.md)

            if favoritesVM.favoriteMovies.isEmpty && favoritesVM.favoriteShows.isEmpty {
                emptyFavoritesView
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AppTheme.Spacing.md) {
                        ForEach(Array(favoritesVM.favoriteMovies.prefix(5))) { favorite in
                            favoriteCard(favorite)
                        }
                        ForEach(Array(favoritesVM.favoriteShows.prefix(5))) { favorite in
                            favoriteCard(favorite)
                        }
                    }
                    .padding(.horizontal, AppTheme.Spacing.md)
                }
            }
        }
        .task {
            await loadFavorites()
        }
    }

    private func favoriteCard(_ favorite: FavoriteMedia) -> some View {
        CompactMediaCard(media: Media(
            id: favorite.id,
            mediaType: favorite.mediaType,
            posterPath: favorite.posterPath,
            profilePath: nil,
            title: favorite.title,
            name: favorite.name
        ))
        .onTapGesture {
            selectedMedia = SelectedMedia(
                id: favorite.id,
                mediaType: favorite.mediaType.rawValue
            )
        }
    }

    private var emptyFavoritesView: some View {
        EmptyStateView(
            icon: "star.slash.fill",
            title: "No Favorites",
            message: "Start adding movies and TV shows to your favorites"
        )
        .frame(height: 200)
        .padding(.horizontal, AppTheme.Spacing.md)
    }

    private var favoritesDetailView: some View {
        FavoritesView(profileVM: profileVM)
    }

    // MARK: - Watchlist Section

    private var watchlistSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            HStack {
                Text("My Watchlist")
                    .font(AppTheme.Typography.title3)
                    .fontWeight(.bold)
                    .foregroundColor(AppTheme.Colors.textPrimary)

                Spacer()

                NavigationLink(destination: watchlistDetailView) {
                    Text("See All")
                        .font(AppTheme.Typography.subheadline)
                        .foregroundColor(AppTheme.Colors.primary)
                }
            }
            .padding(.horizontal, AppTheme.Spacing.md)

            if watchlistVM.watchlistMovies.isEmpty && watchlistVM.watchlistShows.isEmpty {
                emptyWatchlistView
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AppTheme.Spacing.md) {
                        ForEach(Array(watchlistVM.watchlistMovies.prefix(5))) { watchlist in
                            watchlistCard(watchlist)
                        }
                        ForEach(Array(watchlistVM.watchlistShows.prefix(5))) { watchlist in
                            watchlistCard(watchlist)
                        }
                    }
                    .padding(.horizontal, AppTheme.Spacing.md)
                }
            }
        }
        .task {
            await loadWatchlist()
        }
    }

    private func watchlistCard(_ watchlist: WatchlistMedia) -> some View {
        CompactMediaCard(media: Media(
            id: watchlist.id,
            mediaType: watchlist.mediaType,
            posterPath: watchlist.posterPath,
            profilePath: nil,
            title: watchlist.title,
            name: watchlist.name
        ))
        .onTapGesture {
            selectedMedia = SelectedMedia(
                id: watchlist.id,
                mediaType: watchlist.mediaType.rawValue
            )
        }
    }

    private var emptyWatchlistView: some View {
        EmptyStateView(
            icon: "tv.slash.fill",
            title: "No Watchlist",
            message: "Start adding movies and TV shows to your watchlist"
        )
        .frame(height: 200)
        .padding(.horizontal, AppTheme.Spacing.md)
    }

    private var watchlistDetailView: some View {
        WatchlistView(profileVM: profileVM)
    }

    // MARK: - Logout Button

    private var logoutButton: some View {
        Button(action: {
            Task {
                username = ""
                password = ""
                await profileVM.logout()
            }
        }) {
            HStack {
                Image(systemName: "arrow.right.square")
                Text("Log Out")
            }
            .font(AppTheme.Typography.headline)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppTheme.Spacing.md)
            .background(
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.red.opacity(0.8),
                                Color.red,
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            )
        }
        .padding(.horizontal, AppTheme.Spacing.md)
    }

    // MARK: - Logged Out View

    private var loggedOutView: some View {
        VStack(spacing: AppTheme.Spacing.xl) {
            Spacer()

            // Icon
            Image(systemName: "person.crop.circle.badge.plus")
                .font(.system(size: 80))
                .foregroundColor(AppTheme.Colors.primary)

            // Title
            Text("Welcome to TMDB")
                .font(AppTheme.Typography.title1)
                .fontWeight(.bold)
                .foregroundColor(AppTheme.Colors.textPrimary)

            // Description
            Text("Log in to access your favorites, watchlist, and personalized recommendations")
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppTheme.Spacing.xl)

            // Login Form
            VStack(spacing: AppTheme.Spacing.md) {
                TextField("Username", text: $username)
                    .textFieldStyle(.plain)
                    .autocapitalization(.none)
                    .padding(AppTheme.Spacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                            .fill(AppTheme.Colors.surface)
                    )
                    .foregroundColor(AppTheme.Colors.textPrimary)

                SecureField("Password", text: $password)
                    .textFieldStyle(.plain)
                    .padding(AppTheme.Spacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                            .fill(AppTheme.Colors.surface)
                    )
                    .foregroundColor(AppTheme.Colors.textPrimary)

                Button(action: {
                    Task {
                        await performLogin()
                    }
                }) {
                    Text("Log In")
                        .font(AppTheme.Typography.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
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
                .disabled(username.isEmpty || password.isEmpty)
                .opacity(username.isEmpty || password.isEmpty ? 0.6 : 1.0)
            }
            .padding(.horizontal, AppTheme.Spacing.md)

            Spacer()
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

    // MARK: - Methods

    @MainActor
    private func performLogin() async {
        await profileVM.createRequestToken()

        if let token = profileVM.token {
            await profileVM.validateRequestToken(
                username: username,
                password: password,
                requestToken: token
            )
        }

        if let validatedToken = profileVM.validatedToken {
            await profileVM.createSession(requestToken: validatedToken)
        }

        if let sessionId = profileVM.session {
            await profileVM.getProfile(sessionId: sessionId)
        }

        if let sessionId = profileVM.session, profileVM.profile != nil {
            profileVM.saveSession(username: username, sessionId: sessionId)
            username = ""
            password = ""
        }
    }

    @MainActor
    private func loadFavorites() async {
        guard let accountId = profileVM.profile?.id,
              let sessionId = profileVM.session else { return }

        await favoritesVM.fetchFavoriteMovies(accountId: accountId, sessionId: sessionId)
        await favoritesVM.fetchFavoriteShows(accountId: accountId, sessionId: sessionId)
    }

    @MainActor
    private func loadWatchlist() async {
        guard let accountId = profileVM.profile?.id,
              let sessionId = profileVM.session else { return }

        await watchlistVM.fetchWatchlistMovies(accountId: accountId, sessionId: sessionId)
        await watchlistVM.fetchWatchlistShows(accountId: accountId, sessionId: sessionId)
    }
}

// MARK: - Preview

#Preview {
    ProfileView(profileVM: ProfileViewModel())
}
