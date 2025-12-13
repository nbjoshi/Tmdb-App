//
//  TrendingView.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/17/25.
//

import SwiftData
import SwiftUI

enum TrendingTab {
    case all
    case movie
    case tv
    
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
    @State private var trendingVM = TrendingViewModel()
    @State private var selectedTab: TrendingTab = .all
    @State private var selectedMedia: SelectedMedia? = nil
    @ObservedObject var profileVM: ProfileViewModel
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            VStack {
                HStack(spacing: 20) {
                    Button(action: { selectedTab = .all }) {
                        Text("All")
                            .fontWeight(.semibold)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 20)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(selectedTab == .all ? Color.accentColor.opacity(0.2) : Color.clear)
                            )
                    }
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
                        ForEach(trendingVM.trending) { trending in
                            TrendingCardView(trending: trending)
                                .onTapGesture {
                                    selectedMedia = SelectedMedia(id: trending.id, mediaType: trending.mediaType)
                                }
                            Divider()
                        }
                    }
                }
            }
            .task {
                await trendingVM.getTrending(type: selectedTab.pathValue)
            }
            .refreshable {
                await trendingVM.getTrending(type: selectedTab.pathValue)
            }
            .onChange(of: selectedTab) { oldTab, newTab in
                Task {
                    await trendingVM.getTrending(type: newTab.pathValue)
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
    }
}

// #Preview {
//    TrendingView()
// }
