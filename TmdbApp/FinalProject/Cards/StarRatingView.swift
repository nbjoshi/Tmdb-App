//
//  StarRatingView.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/28/25.
//

import SwiftUI

struct StarRatingView: View {
    let rating: Double

    var body: some View {
        let starCount = Int(rating.rounded())

        HStack(spacing: 4) {
            ForEach(0 ..< 10) { index in
                Image(systemName: index < starCount ? "star.fill" : "star")
                    .foregroundColor(.yellow)
            }
        }
    }
}

// #Preview {
//    StarView()
// }
