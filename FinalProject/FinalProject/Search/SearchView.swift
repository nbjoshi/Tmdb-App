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
                                .onChange(of: isTextFieldFocused) { oldValue, newValue in
                                    hasCancel = newValue
                                }
                                .onSubmit {
                                    if searchQuery.isEmpty {
                                        searchVM.search = []
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
                            searchVM.search = []
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
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            modelContext.delete(recent)
                                        }) {
                                            Image(systemName: "x.circle")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 20, height: 20)
                                        }
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
                            if let mediaType = result.mediaType {
                                SearchCardView(search: result)
                                    .onTapGesture { selectedMedia = SelectedMedia(id: result.id, mediaType: mediaType)
                                    }
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
    
    private func deleteAllItemsInSwiftData() {
        let fetchDescriptor = FetchDescriptor<RecentSearch>()
        do {
            let searches = try modelContext.fetch(fetchDescriptor)
            for search in searches {
                modelContext.delete(search)
            }
            print("✅ Deleted all WidgetModel entries.")
        } catch {
            print("Failed to delete WidgetModel items: \(error)")
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
