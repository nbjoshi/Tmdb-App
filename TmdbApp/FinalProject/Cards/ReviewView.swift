//
//  ReviewView.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/29/25.
//

import SwiftUI

struct ReviewView: View {
    let review: Review
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .center, spacing: 12) {
                if let avatarPath = review.authorDetails.avatarPath,
                   let url = URL(string: avatarURL(from: avatarPath))
                {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                    } placeholder: {
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 60, height: 60)
                    }
                } else {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 60, height: 60)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(review.author)
                        .font(.headline)
                    Text(formatDate(review.createdAt))
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }

            VStack(alignment: .leading, spacing: 12) {
                Text(review.content)
                    .font(.subheadline)
            }
            Divider()
        }
        .padding()
    }

    private func avatarURL(from path: String) -> String {
        if path.starts(with: "/https") {
            return String(path.dropFirst(1))
        } else {
            return "https://image.tmdb.org/t/p/w500\(path)"
        }
    }
    
    // Used AI to help me format the date
    private func formatDate(_ dateString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        if let date = isoFormatter.date(from: dateString) {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            return formatter.string(from: date)
        } else {
            return dateString
        }
    }
}

// #Preview {
//    ReviewView()
// }
