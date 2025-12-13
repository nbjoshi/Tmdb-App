//
//  WatchlistView.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/29/25.
//

import SwiftUI

enum WatchlistTab {
    case movie
    case tv
}

struct WatchlistView: View {
    @ObservedObject var profileVM: ProfileViewModel
    @State private var watchlistVM = WatchlistViewModel()
    @State private var selectedTab: WatchlistTab = .movie
    @State private var selectedMedia: SelectedMedia? = nil

    var body: some View {
        if profileVM.isLoggedIn {
            NavigationStack {
                VStack {
                    HStack(spacing: 20) {
                        Button(action: { selectedTab = .movie }) {
                            Text("Movies")
                                .fontWeight(.semibold)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 20)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(selectedTab == .movie ? Color.accentColor.opacity(0.2) : Color.clear)
                                )
                        }
                        Button(action: { selectedTab = .tv }) {
                            Text("TV Shows")
                                .fontWeight(.semibold)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 20)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(selectedTab == .tv ? Color.accentColor.opacity(0.2) : Color.clear)
                                )
                        }
                    }
                    .padding()
                    .animation(.easeInOut(duration: 0.2), value: selectedTab)

                    ScrollView(.vertical) {
                        LazyVStack {
                            if selectedTab == .movie {
                                ForEach(watchlistVM.watchlistMovies) { movie in
                                    WatchlistCardView(title: movie.title, posterPath: movie.posterPath)
                                        .onTapGesture {
                                            selectedMedia = SelectedMedia(id: movie.id, mediaType: "movie")
                                        }
                                    Divider()
                                }
                            } else {
                                ForEach(watchlistVM.watchlistShows) { show in
                                    WatchlistCardView(title: show.name, posterPath: show.posterPath)
                                        .onTapGesture {
                                            selectedMedia = SelectedMedia(id: show.id, mediaType: "tv")
                                        }
                                    Divider()
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .overlay {
                        if selectedTab == .movie && watchlistVM.watchlistMovies.isEmpty {
                            VStack {
                                Image(systemName: "eye.slash.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.secondary)
                                    .frame(width: 80, height: 80)
                                Text("No movies in your watchlist yet.")
                                    .font(.headline)
                                Text("Begin adding movies to your watchlist by searching for them or exploring the trending page")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .padding()
                        } else if selectedTab == .tv && watchlistVM.watchlistShows.isEmpty {
                            VStack {
                                Image(systemName: "eye.slash.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.secondary)
                                    .frame(width: 80, height: 80)
                                Text("No shows in your watchlist yet.")
                                    .font(.headline)
                                Text("Begin adding shows to your watchlist by searching for them or exploring the trending page")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .padding()
                        }
                    }
                }
            }
            .task {
                if selectedTab == .movie {
                    await watchlistVM.getWatchlistMovies(accountId: profileVM.profile?.id ?? 0, sessionId: profileVM.session ?? "")
                } else {
                    await watchlistVM.getWatchlistShows(accountId: profileVM.profile?.id ?? 0, sessionId: profileVM.session ?? "")
                }
            }
            .onAppear {
                Task {
                    if selectedTab == .movie {
                        await watchlistVM.getWatchlistMovies(accountId: profileVM.profile?.id ?? 0, sessionId: profileVM.session ?? "")
                    } else {
                        await watchlistVM.getWatchlistShows(accountId: profileVM.profile?.id ?? 0, sessionId: profileVM.session ?? "")
                    }
                }
            }
            .refreshable {
                if selectedTab == .movie {
                    await watchlistVM.getWatchlistMovies(accountId: profileVM.profile?.id ?? 0, sessionId: profileVM.session ?? "")
                } else {
                    await watchlistVM.getWatchlistShows(accountId: profileVM.profile?.id ?? 0, sessionId: profileVM.session ?? "")
                }
            }
            .onChange(of: selectedTab) { oldTab, newTab in
                Task {
                    if newTab == .movie {
                        await watchlistVM.getWatchlistMovies(accountId: profileVM.profile?.id ?? 0, sessionId: profileVM.session ?? "")
                    } else {
                        await watchlistVM.getWatchlistShows(accountId: profileVM.profile?.id ?? 0, sessionId: profileVM.session ?? "")
                    }
                }
            }
            .sheet(item: $selectedMedia) { media in
                if media.mediaType == "movie" {
                    MovieDetailCard(
                        trendingId: media.id,
                        sessionId: profileVM.session ?? "",
                        accountId: profileVM.profile?.id ?? 0,
                        isLoggedIn: profileVM.isLoggedIn,
                    )
                }
                else if media.mediaType == "tv" {
                    ShowDetailCard(
                        trendingId: media.id,
                        sessionId: profileVM.session ?? "",
                        accountId: profileVM.profile?.id ?? 0,
                        isLoggedIn: profileVM.isLoggedIn,
                    )
                }
            }
        }
        else {
            VStack(spacing: 24) {
                Spacer()
                
                Image(systemName: "heart.slash.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.secondary)
                
                Text("No Favorites Yet")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Log in to save your favorite movies and TV shows, and view them here anytime.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

// #Preview {
//    WatchlistView()
// }
