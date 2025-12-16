//
//  HeroCard.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/17/25.
//

import SwiftUI

/// Large hero card for featured content
struct HeroCard: View {
    let media: Media
    let onTap: () -> Void

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomLeading) {
                // Background Image
                AsyncImage(url: heroImageURL) { phase in
                    switch phase {
                    case .empty:
                        placeholderView
                    case let .success(image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                    case .failure:
                        placeholderView
                    @unknown default:
                        placeholderView
                    }
                }

                // Gradient Overlay
                LinearGradient(
                    colors: [
                        AppTheme.Colors.gradientStart,
                        AppTheme.Colors.gradientEnd,
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: geometry.size.height)

                // Content
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    if let title = media.displayName {
                        Text(title)
                            .font(AppTheme.Typography.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                            .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)
                    }
                }
                .padding(AppTheme.Spacing.lg)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large))
        }
        .frame(height: 500)
        .onTapGesture(perform: onTap)
    }

    private var heroImageURL: URL? {
        guard let path = media.imagePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w1280\(path)")
    }

    private var placeholderView: some View {
        ZStack {
            AppTheme.Colors.surface
            Image(systemName: "photo")
                .font(.system(size: 60))
                .foregroundColor(AppTheme.Colors.textTertiary)
        }
    }
}
