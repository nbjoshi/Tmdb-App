//
//  MediaCard.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/17/25.
//

import SwiftUI

/// Reusable media card component with modern design
struct MediaCard: View {
    let media: Media
    let imageSize: CGSize
    let showTitle: Bool
    let cornerRadius: CGFloat

    @State private var isPressed = false

    init(
        media: Media,
        imageSize: CGSize = CGSize(width: 200, height: 300),
        showTitle: Bool = true,
        cornerRadius: CGFloat = AppTheme.CornerRadius.medium
    ) {
        self.media = media
        self.imageSize = imageSize
        self.showTitle = showTitle
        self.cornerRadius = cornerRadius
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            // Poster Image
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    placeholderView
                case let .success(image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: imageSize.width, height: imageSize.height)
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                        .overlay(
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            AppTheme.Colors.primary.opacity(0.3),
                                            AppTheme.Colors.accent.opacity(0.1),
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                case .failure:
                    placeholderView
                @unknown default:
                    placeholderView
                }
            }
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(AppTheme.Animation.quick, value: isPressed)

            // Title
            if showTitle, let title = media.displayName {
                Text(title)
                    .font(AppTheme.Typography.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
        }
        .frame(width: imageSize.width)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }

    private var imageURL: URL? {
        guard let path = media.imagePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }

    private var placeholderView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(
                    LinearGradient(
                        colors: [
                            AppTheme.Colors.surface,
                            AppTheme.Colors.surfaceElevated,
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: imageSize.width, height: imageSize.height)

            Image(systemName: "photo")
                .font(.system(size: 40))
                .foregroundColor(AppTheme.Colors.textTertiary)
        }
    }
}

/// Compact media card for horizontal scrolling
struct CompactMediaCard: View {
    let media: Media
    let size: CGSize

    @State private var isPressed = false

    init(media: Media, size: CGSize = CGSize(width: 120, height: 180)) {
        self.media = media
        self.size = size
    }

    var body: some View {
        AsyncImage(url: imageURL) { phase in
            switch phase {
            case .empty:
                placeholderView
            case let .success(image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.small))
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.small)
                            .stroke(AppTheme.Colors.primary.opacity(0.2), lineWidth: 1)
                    )
            case .failure:
                placeholderView
            @unknown default:
                placeholderView
            }
        }
        .scaleEffect(isPressed ? 0.92 : 1.0)
        .animation(AppTheme.Animation.quick, value: isPressed)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }

    private var imageURL: URL? {
        guard let path = media.imagePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }

    private var placeholderView: some View {
        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.small)
            .fill(AppTheme.Colors.surface)
            .frame(width: size.width, height: size.height)
            .overlay(
                Image(systemName: "photo")
                    .font(.system(size: 24))
                    .foregroundColor(AppTheme.Colors.textTertiary)
            )
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        AppTheme.Colors.background.ignoresSafeArea()

        ScrollView {
            VStack(spacing: 20) {
                MediaCard(media: Media(
                    id: 1,
                    mediaType: .movie,
                    posterPath: nil,
                    profilePath: nil,
                    title: "Sample Movie",
                    name: nil
                ))

                CompactMediaCard(media: Media(
                    id: 2,
                    mediaType: .tv,
                    posterPath: nil,
                    profilePath: nil,
                    title: nil,
                    name: "Sample Show"
                ))
            }
            .padding()
        }
    }
}
