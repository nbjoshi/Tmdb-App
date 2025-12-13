//
//  FavoritesCardView.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/26/25.
//

import SwiftUI

struct FavoritesCardView: View {
    let title: String
    let posterPath: String

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 300, height: 400)
                        .cornerRadius(12)
                } else {
                    Color.gray
                        .frame(width: 300, height: 400)
                        .cornerRadius(12)
                }
            }
            Text(title)
                .font(.headline)
        }
        .padding()
    }
}
