//
//  HorizontalMediaRow.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/17/25.
//

import SwiftUI

/// Horizontal scrolling row of media items
struct HorizontalMediaRow: View {
    let title: String
    let mediaItems: [Media]
    let onMediaTap: (Media) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            // Section Title
            Text(title)
                .font(AppTheme.Typography.title3)
                .fontWeight(.bold)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .padding(.horizontal, AppTheme.Spacing.md)

            // Horizontal Scroll
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppTheme.Spacing.md) {
                    ForEach(mediaItems) { media in
                        CompactMediaCard(media: media)
                            .onTapGesture {
                                withAnimation(AppTheme.Animation.quick) {
                                    onMediaTap(media)
                                }
                            }
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.md)
            }
        }
    }
}

/// Grid layout for media items
struct MediaGrid: View {
    let mediaItems: [Media]
    let columns: [GridItem]
    let onMediaTap: (Media) -> Void

    init(
        mediaItems: [Media],
        columns: [GridItem] = [
            GridItem(.flexible(), spacing: AppTheme.Spacing.md),
            GridItem(.flexible(), spacing: AppTheme.Spacing.md),
        ],
        onMediaTap: @escaping (Media) -> Void
    ) {
        self.mediaItems = mediaItems
        self.columns = columns
        self.onMediaTap = onMediaTap
    }

    var body: some View {
        LazyVGrid(columns: columns, spacing: AppTheme.Spacing.lg) {
            ForEach(mediaItems) { media in
                MediaCard(media: media)
                    .onTapGesture {
                        withAnimation(AppTheme.Animation.quick) {
                            onMediaTap(media)
                        }
                    }
            }
        }
        .padding(.horizontal, AppTheme.Spacing.md)
    }
}
