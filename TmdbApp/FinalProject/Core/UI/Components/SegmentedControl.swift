//
//  SegmentedControl.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/17/25.
//

import SwiftUI

/// Modern segmented control component
struct SegmentedControl<T: Hashable & CaseIterable & RawRepresentable>: View where T.RawValue == String {
    @Binding var selection: T
    let options: [T]

    @Namespace private var animation

    var body: some View {
        HStack(spacing: 0) {
            ForEach(options, id: \.self) { option in
                Button(action: {
                    withAnimation(AppTheme.Animation.smooth) {
                        selection = option
                    }
                }) {
                    Text(option.rawValue.capitalized)
                        .font(AppTheme.Typography.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(selection == option ? AppTheme.Colors.textPrimary : AppTheme.Colors.textSecondary)
                        .padding(.horizontal, AppTheme.Spacing.lg)
                        .padding(.vertical, AppTheme.Spacing.sm)
                        .frame(maxWidth: .infinity)
                        .background(
                            ZStack {
                                if selection == option {
                                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    AppTheme.Colors.primary.opacity(0.3),
                                                    AppTheme.Colors.accent.opacity(0.2),
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .matchedGeometryEffect(id: "selectedTab", in: animation)
                                }
                            }
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                .fill(AppTheme.Colors.surface)
        )
    }
}

/// Simple tab picker for two options
struct TabPicker: View {
    @Binding var selection: Int
    let options: [String]

    @Namespace private var animation

    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            ForEach(Array(options.enumerated()), id: \.offset) { index, option in
                Button(action: {
                    withAnimation(AppTheme.Animation.smooth) {
                        selection = index
                    }
                }) {
                    Text(option)
                        .font(AppTheme.Typography.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(selection == index ? AppTheme.Colors.textPrimary : AppTheme.Colors.textSecondary)
                        .padding(.horizontal, AppTheme.Spacing.lg)
                        .padding(.vertical, AppTheme.Spacing.sm)
                        .background(
                            ZStack {
                                if selection == index {
                                    Capsule()
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    AppTheme.Colors.primary,
                                                    AppTheme.Colors.accent,
                                                ],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .matchedGeometryEffect(id: "selectedTab", in: animation)
                                }
                            }
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(4)
        .background(
            Capsule()
                .fill(AppTheme.Colors.surface)
        )
    }
}
