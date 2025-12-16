//
//  ShowDetailCard.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/17/25.
//

import SwiftUI

enum ShowTab {
    case episodes
    case similar
    case reviews
    case extras
}

struct ShowDetailCard: View {
    @Environment(\.dismiss) private var dismiss
    let trendingId: Int
    let sessionId: String
    let accountId: Int
    let isLoggedIn: Bool
    @State private var cardDetailVM = CardDetailViewModel()
    @State private var selectedMedia: SelectedMedia? = nil
    @State private var showTab: ShowTab = .episodes
    @State private var selectedSeason: Season? = nil

    var body: some View {
        ZStack(alignment: .topLeading) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if let show = cardDetailVM.mediaDetails {
                        AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(show.posterPath)")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Color.gray
                                .frame(height: 400)
                        }

                        VStack(alignment: .leading, spacing: 16) {
                            Text(show.displayName)
                                .font(.title)
                                .bold()

                            Text(show.overview)
                                .font(.body)

                            Text("\((show.dateString ?? "").prefix(4)) · \(show.genres.map { $0.name }.joined(separator: ", ")) · \(show.mediaType.displayName)")
                                .font(.footnote)
                                .foregroundColor(.secondary)

                            StarRatingView(rating: show.voteAverage)

                            if isLoggedIn {
                                HStack {
                                    Button {
                                        Task {
                                            withAnimation {
                                                cardDetailVM.isFavorited.toggle()
                                            }
                                            await cardDetailVM.markAsFavorite(accountId: accountId, sessionId: sessionId, mediaType: .tv, mediaId: trendingId, favorite: cardDetailVM.isFavorited)
                                        }
                                    } label: {
                                        VStack {
                                            Image(systemName: cardDetailVM.isFavorited ? "star.fill" : "star")
                                            Text(cardDetailVM.isFavorited ? "Unfavorite" : "Favorite")
                                        }
                                    }
                                    Spacer()
                                    Button {
                                        Task {
                                            withAnimation {
                                                cardDetailVM.isWatchlisted.toggle()
                                            }
                                            await cardDetailVM.markAsWatchlist(accountId: accountId, sessionId: sessionId, mediaType: .tv, mediaId: trendingId, watchlist: cardDetailVM.isWatchlisted)
                                        }
                                    } label: {
                                        VStack {
                                            Image(systemName: cardDetailVM.isWatchlisted ? "tv.and.mediabox.fill" : "tv.and.mediabox")
                                            Text(cardDetailVM.isWatchlisted ? "Remove from Watchlist" : "Add to Watchlist")
                                        }
                                    }
                                }
                                .padding(.vertical)
                            }
                            Divider()

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    Button(action: { showTab = .episodes }) {
                                        Text("Episodes")
                                            .fontWeight(.semibold)
                                            .padding(.vertical, 8)
                                            .padding(.horizontal, 12)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(showTab == .episodes ? Color.accentColor.opacity(0.2) : Color.clear)
                                            )
                                    }
                                    Button(action: { showTab = .similar }) {
                                        Text("Similar")
                                            .fontWeight(.semibold)
                                            .padding(.vertical, 8)
                                            .padding(.horizontal, 12)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(showTab == .similar ? Color.accentColor.opacity(0.2) : Color.clear)
                                            )
                                    }
                                    Button(action: { showTab = .reviews }) {
                                        Text("Reviews")
                                            .fontWeight(.semibold)
                                            .padding(.vertical, 8)
                                            .padding(.horizontal, 12)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(showTab == .reviews ? Color.accentColor.opacity(0.2) : Color.clear)
                                            )
                                    }
                                    Button(action: { showTab = .extras }) {
                                        Text("Extras")
                                            .fontWeight(.semibold)
                                            .padding(.vertical, 8)
                                            .padding(.horizontal, 12)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(showTab == .extras ? Color.accentColor.opacity(0.2) : Color.clear)
                                            )
                                    }
                                }
                            }
                            .padding(.vertical)
                            .animation(.easeInOut(duration: 0.2), value: showTab)

                            if showTab == .episodes {
                                Menu {
                                    ForEach(show.seasons ?? []) { season in
                                        Button(action: {
                                            selectedSeason = season
                                            Task {
                                                await cardDetailVM.getSeasonDetails(showId: show.id, seasonNumber: season.seasonNumber)
                                            }
                                        }) {
                                            Text("Season \(season.seasonNumber) — \(season.episodeCount) Episodes")
                                        }
                                    }
                                } label: {
                                    HStack {
                                        if let season = selectedSeason {
                                            Text("Season \(season.seasonNumber)")
                                                .font(.body)
                                        }
                                        Image(systemName: "chevron.down")
                                            .font(.body)
                                    }
                                    .background(Color.clear)
                                }

                                if let episodes = cardDetailVM.seasonEpisodes {
                                    LazyVStack(alignment: .leading, spacing: 40) {
                                        ForEach(episodes) { episode in
                                            VStack(alignment: .leading, spacing: 20) {
                                                HStack(alignment: .center, spacing: 12) {
                                                    if let stillPath = episode.stillPath {
                                                        AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(stillPath)")) { image in
                                                            image
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fill)
                                                                .frame(width: 120, height: 80)
                                                                .cornerRadius(8)
                                                        } placeholder: {
                                                            Color.gray
                                                                .frame(width: 120, height: 80)
                                                                .cornerRadius(8)
                                                        }
                                                    } else {
                                                        Color.gray
                                                            .frame(width: 120, height: 80)
                                                            .cornerRadius(8)
                                                    }

                                                    Text("S\(episode.seasonNumber) E\(episode.episodeNumber) - \(episode.name)")
                                                        .font(.headline)
                                                        .multilineTextAlignment(.leading)
                                                }

                                                VStack(alignment: .leading, spacing: 12) {
                                                    Text(episode.overview)
                                                        .font(.subheadline)
                                                    Text("\(episode.runtime) min · Air Date: \(episode.airDate)")
                                                        .font(.footnote)
                                                        .foregroundColor(.secondary)
                                                }
                                            }
                                            Divider()
                                        }
                                    }
                                }
                            }

                            if showTab == .similar {
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                    ForEach(cardDetailVM.similarMedia) { media in
                                        VStack {
                                            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(media.posterPath ?? "")")) { image in
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(height: 180)
                                                    .cornerRadius(12)
                                                    .clipped()
                                            } placeholder: {
                                                Color.gray
                                                    .frame(height: 180)
                                                    .cornerRadius(12)
                                                    .clipped()
                                            }

                                            Text(media.displayName)
                                                .font(.caption)
                                                .multilineTextAlignment(.center)
                                                .lineLimit(2)
                                        }
                                        .padding()
                                        .cornerRadius(12)
                                        .onTapGesture {
                                            selectedMedia = SelectedMedia(id: media.id, mediaType: media.mediaType.rawValue)
                                        }
                                    }
                                }
                            }

                            if showTab == .reviews {
                                LazyVStack(alignment: .leading) {
                                    ForEach(cardDetailVM.reviews) { review in
                                        ReviewView(review: review)
                                    }
                                }
                            }

                            if showTab == .extras {
                                LazyVStack(alignment: .leading) {
                                    ForEach(cardDetailVM.videos) { video in
                                        VideoView(video: video)
                                        Divider()
                                    }
                                }
                            }
                        }
                        .padding()

                    } else if let errorMessage = cardDetailVM.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }
                }
            }

            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.white)
            }
            .padding()
        }
        .ignoresSafeArea()
        .task {
            await cardDetailVM.getShowDetails(showId: trendingId)
            await cardDetailVM.getSimilarShows(showId: trendingId)
            await cardDetailVM.getShowState(showId: trendingId, sessionId: sessionId)
            await cardDetailVM.getShowReviews(showId: trendingId)
            await cardDetailVM.getVideos(mediaId: trendingId, mediaType: .tv)
            if let firstSeason = cardDetailVM.mediaDetails?.seasons?.first {
                selectedSeason = firstSeason
                await cardDetailVM.getSeasonDetails(showId: trendingId, seasonNumber: firstSeason.seasonNumber)
            }
        }
        .refreshable {
            await cardDetailVM.getMovieDetails(movieId: trendingId)
            await cardDetailVM.getSimilarMovies(movieId: trendingId)
            await cardDetailVM.getMovieState(movieId: trendingId, sessionId: sessionId)
        }
        .sheet(item: $selectedMedia) { media in
            if media.mediaType == "movie" {
                MovieDetailCard(trendingId: media.id, sessionId: sessionId, accountId: accountId, isLoggedIn: isLoggedIn)
            } else if media.mediaType == "tv" {
                ShowDetailCard(trendingId: media.id, sessionId: sessionId, accountId: accountId, isLoggedIn: isLoggedIn)
            }
        }
    }
}

// #Preview {
//    ShowDetailCard()
// }
