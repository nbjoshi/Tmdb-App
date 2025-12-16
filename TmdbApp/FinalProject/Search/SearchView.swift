//
//  SearchView.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/17/25.
//

import SwiftData
import SwiftUI

struct SearchView: View {
    @State private var searchVM = SearchViewModel()
    @State private var searchQuery: String = ""
    @State private var hasCancel: Bool = false
    @FocusState private var isTextFieldFocused: Bool
    @State private var selectedMedia: SelectedMedia? = nil
    @ObservedObject var profileVM: ProfileViewModel
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \RecentSearch.timestamp, order: .reverse) private var recentSearches: [RecentSearch]

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .frame(height: 40)
                            .cornerRadius(12)
                            .foregroundStyle(.ultraThinMaterial)
                        HStack {
                            Spacer()
                            Image(systemName: "magnifyingglass")
                            TextField("Search", text: $searchQuery)
                                .frame(height: 50)
                                .textFieldStyle(.plain)
                                .focused($isTextFieldFocused)
                                .cornerRadius(12)
                                .onChange(of: isTextFieldFocused) { _, newValue in
                                    hasCancel = newValue
                                }
                                .onSubmit {
                                    if searchQuery.isEmpty {
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
                        .cornerRadius(12)
                    }

                    if hasCancel && !searchQuery.isEmpty {
                        Button(action: {
                            searchQuery = ""
                            searchVM.query = searchQuery
                            searchVM.clearSearch()
                            hideKeyboard()
                            isTextFieldFocused = false
                        }) {
                            Text("Cancel")
                                .foregroundStyle(Color.red)
                        }
                        .padding(.trailing, 8)
                    }
                }
                .padding()

                if searchQuery.isEmpty && searchVM.search.isEmpty {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 12) {
                            Text("Recent Searches")
                                .font(.headline)

                            ForEach(recentSearches.prefix(5)) { recent in
                                Button(action: {
                                    searchQuery = recent.query
                                    Task {
                                        searchVM.query = searchQuery
                                        await searchVM.getSearch()
                                        hideKeyboard()
                                    }
                                }) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "clock")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)

                                        Text(recent.query)
                                    }
                                    .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                ScrollView(.vertical) {
                    LazyVStack {
                        ForEach(searchVM.search) { result in
                            if result.mediaType == .movie || result.mediaType == .tv {
                                SearchCardView(search: result)
                                    .onTapGesture {
                                        selectedMedia = SelectedMedia(id: result.id, mediaType: result.mediaType.rawValue)
                                    }
                            } else {
                                SearchCardView(search: result)
                            }
                            Divider()
                        }
                    }
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
            .sheet(item: $selectedMedia) { media in
                if media.mediaType == "movie" {
                    MovieDetailCard(
                        trendingId: media.id,
                        sessionId: profileVM.session ?? "",
                        accountId: profileVM.profile?.id ?? 0,
                        isLoggedIn: profileVM.isLoggedIn,
                    )
                } else if media.mediaType == "tv" {
                    ShowDetailCard(
                        trendingId: media.id,
                        sessionId: profileVM.session ?? "",
                        accountId: profileVM.profile?.id ?? 0,
                        isLoggedIn: profileVM.isLoggedIn,
                    )
                }
            }
        }
        .task {
            print("Recent Searches on Launch: \(recentSearches.map(\.query))")
            printAllItemsInSwiftData()
        }
    }

    private func printAllItemsInSwiftData() {
        let fetchDescriptor = FetchDescriptor<RecentSearch>()
        do {
            let searches = try modelContext.fetch(fetchDescriptor)
            print("=== SwiftData Items ===")
            for search in searches {
                print(search.query)
            }
            print("=======================")
        } catch {
            print("Failed to fetch SwiftData items: \(error)")
        }
    }

    private func deleteAllItemsInSwiftData() {
        let fetchDescriptor = FetchDescriptor<RecentSearch>()
        do {
            let searches = try modelContext.fetch(fetchDescriptor)
            for search in searches {
                modelContext.delete(search)
            }
            print("Deleted all SwiftData entries.")
        } catch {
            print("Failed to delete SwiftData items: \(error)")
        }
    }
}

//
// #Preview {
//     SearchView(profileVM: ProfileViewModel())
//         .modelContainer(for: RecentSearch.self, inMemory: true)
// }
