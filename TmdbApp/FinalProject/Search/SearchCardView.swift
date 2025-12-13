//
//  SearchCardView.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/17/25.
//

import SwiftUI

struct SearchCardView: View {
    let search: Search

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(search.imagePath ?? "")")) { phase in
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
            Text(search.displayName ?? "")
                .font(.headline)
        }
        .padding()
    }
}

// #Preview {
//    SearchCardView()
// }
