//
//  MovieDetailCard.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/17/25.
//

import SwiftUI

enum MovieTab {
    case similar
    case reviews
}

struct MovieDetailCard: View {
    @Environment(\.dismiss) private var dismiss
    let trendingId: Int
    let sessionId: String
    let accountId: Int
    let isLoggedIn: Bool
    @State private var cardDetailVM = CardDetailViewModel()
    @State private var selectedMedia: SelectedMedia? = nil
    @State private var movieTab: MovieTab = .similar
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if let movie = cardDetailVM.movieDetails {
                        AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Color.gray
                                .frame(height: 400)
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text(movie.title)
                                .font(.title)
                                .bold()
                            
                            Text(movie.overview)
                                .font(.body)
                            
                            Text("\(movie.releaseDate.prefix(4)) · \(movie.genres.map { $0.name }.joined(separator: ", ")) · Movie")
                                .font(.callout)
                                .foregroundColor(.secondary)
                            
                            StarRatingView(rating: movie.voteAverage)
                            
                            if isLoggedIn {
                                HStack {
                                    Button {
                                        Task {
                                            withAnimation {
                                                cardDetailVM.isFavorited.toggle()
                                            }
                                            await cardDetailVM.markAsFavorite(accountId: accountId, sessionId: sessionId, mediaType: "movie", mediaId: trendingId, favorite: cardDetailVM.isFavorited)
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
                                            await cardDetailVM.markAsWatchlist(accountId: accountId, sessionId: sessionId, mediaType: "movie", mediaId: trendingId, watchlist: cardDetailVM.isWatchlisted)
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
                            
                            HStack(spacing: 10) {
                                Button(action: { movieTab = .similar }) {
                                    Text("Similar")
                                        .fontWeight(.semibold)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(movieTab == .similar ? Color.accentColor.opacity(0.2) : Color.clear)
                                        )
                                }
                                Button(action: { movieTab = .reviews }) {
                                    Text("Reviews")
                                        .fontWeight(.semibold)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(movieTab == .reviews ? Color.accentColor.opacity(0.2) : Color.clear)
                                        )
                                }
                            }
                            .padding(.vertical)
                            
                            if movieTab == .similar {
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                    ForEach(cardDetailVM.similarMovies) { movie in
                                        VStack {
                                            if let posterPath = movie.posterPath {
                                                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")) { image in
                                                    image
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(height: 180)
                                                        .cornerRadius(12)
                                                } placeholder: {
                                                    Color.gray
                                                        .frame(height: 180)
                                                        .cornerRadius(12)
                                                }
                                            } else {
                                                Color.gray
                                                    .frame(height: 180)
                                                    .cornerRadius(12)
                                            }
                                            
                                            Text(movie.title)
                                                .font(.callout)
                                                .fontWeight(.bold)
                                                .multilineTextAlignment(.center)
                                                .lineLimit(1)
                                        }
                                        .padding()
                                        .onTapGesture {
                                            selectedMedia = SelectedMedia(id: movie.id, mediaType: "movie")
                                        }
                                    }
                                }
                            }
                            
                            if movieTab == .reviews {
                                LazyVStack(alignment: .leading) {
                                    ForEach(cardDetailVM.movieReviews) { review in
                                        ReviewView(review: review)
                                    }
                                }
                            }
                        }
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
            await cardDetailVM.getMovieDetails(movieId: trendingId)
            await cardDetailVM.getSimilarMovies(movieId: trendingId)
            await cardDetailVM.getMovieState(movieId: trendingId, sessionId: sessionId)
            await cardDetailVM.getMovieReviews(movieId: trendingId)
        }
        .refreshable {
            await cardDetailVM.getMovieDetails(movieId: trendingId)
            await cardDetailVM.getSimilarMovies(movieId: trendingId)
            await cardDetailVM.getMovieState(movieId: trendingId, sessionId: sessionId)
        }
        .sheet(item: $selectedMedia) { media in
            if media.mediaType == "movie" {
                MovieDetailCard(trendingId: media.id, sessionId: sessionId, accountId: accountId, isLoggedIn: isLoggedIn)
            }
            else if media.mediaType == "tv" {
                ShowDetailCard(trendingId: media.id, sessionId: sessionId, accountId: accountId, isLoggedIn: isLoggedIn)
            }
        }
    }
}

// #Preview {
//    MovieDetailCard()
// }
