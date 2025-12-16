//
//  AppTheme.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/17/25.
//

import SwiftUI

/// Design system for the app following streaming service aesthetics
enum AppTheme {
    // MARK: - Colors

    enum Colors {
        // Primary colors
        static let primary = Color(red: 0.0, green: 0.48, blue: 1.0) // Netflix red-ish blue
        static let secondary = Color(red: 0.95, green: 0.95, blue: 0.97)
        static let accent = Color(red: 1.0, green: 0.27, blue: 0.23) // Netflix red

        // Background colors
        static let background = Color.black
        static let surface = Color(red: 0.11, green: 0.11, blue: 0.12)
        static let surfaceElevated = Color(red: 0.15, green: 0.15, blue: 0.16)
        static let cardBackground = Color(red: 0.18, green: 0.18, blue: 0.20)

        // Text colors
        static let textPrimary = Color.white
        static let textSecondary = Color(red: 0.7, green: 0.7, blue: 0.7)
        static let textTertiary = Color(red: 0.5, green: 0.5, blue: 0.5)

        // Status colors
        static let success = Color.green
        static let warning = Color.orange
        static let error = Color.red

        // Gradient colors
        static let gradientStart = Color.black.opacity(0.0)
        static let gradientEnd = Color.black.opacity(0.8)
    }

    // MARK: - Typography

    enum Typography {
        static let largeTitle = Font.system(size: 34, weight: .bold, design: .default)
        static let title1 = Font.system(size: 28, weight: .bold, design: .default)
        static let title2 = Font.system(size: 22, weight: .bold, design: .default)
        static let title3 = Font.system(size: 20, weight: .semibold, design: .default)
        static let headline = Font.system(size: 17, weight: .semibold, design: .default)
        static let body = Font.system(size: 17, weight: .regular, design: .default)
        static let callout = Font.system(size: 16, weight: .regular, design: .default)
        static let subheadline = Font.system(size: 15, weight: .regular, design: .default)
        static let footnote = Font.system(size: 13, weight: .regular, design: .default)
        static let caption = Font.system(size: 12, weight: .regular, design: .default)
    }

    // MARK: - Spacing

    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }

    // MARK: - Corner Radius

    enum CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let xlarge: CGFloat = 24
    }

    // MARK: - Shadows

    enum Shadows {
        static let small = Shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
        static let medium = Shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
        static let large = Shadow(color: .black.opacity(0.4), radius: 16, x: 0, y: 8)
    }

    // MARK: - Animation

    enum Animation {
        static let quick = SwiftUI.Animation.easeInOut(duration: 0.2)
        static let standard = SwiftUI.Animation.easeInOut(duration: 0.3)
        static let smooth = SwiftUI.Animation.spring(response: 0.4, dampingFraction: 0.8)
        static let bouncy = SwiftUI.Animation.spring(response: 0.5, dampingFraction: 0.6)
    }
}

struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - View Extensions

extension View {
    func appShadow(_ shadow: Shadow) -> some View {
        self.shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
    }

    func cardStyle() -> some View {
        background(AppTheme.Colors.cardBackground)
            .cornerRadius(AppTheme.CornerRadius.medium)
            .appShadow(AppTheme.Shadows.medium)
    }
}
