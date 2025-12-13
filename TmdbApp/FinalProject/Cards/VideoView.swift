//
//  VideoView.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/30/25.
//

import SwiftUI

struct VideoView: View {
    let video: Video

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Source: https://stackoverflow.com/questions/78540337/how-to-show-thumbnail-video-url-in-image-in-swiftui
            if video.site.lowercased() == "youtube" {
                Link(destination: URL(string: "https://www.youtube.com/watch?v=\(video.key)")!) {
                    ZStack {
                        AsyncImage(url: URL(string: "https://img.youtube.com/vi/\(video.key)/maxresdefault.jpg")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Color.gray
                        }
                        .frame(width: 200, height: 200)
                        .clipped()
                        .cornerRadius(8)

                        Image(systemName: "play.circle.fill")
                            .resizable()
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                            .frame(width: 50, height: 50)
                    }
                }
            }

            Text(video.name)
                .font(.headline)
                .lineLimit(2)
                .minimumScaleFactor(0.8)

            Text(video.type)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .cornerRadius(12)
    }
}

// #Preview {
//    VideoView()
// }
