//
//  ColorTheme.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import SwiftUI

extension Color {
    // MARK: - Light Theme (Sunrise - Lever du soleil) - PREMIUM UPDATE
    static let snapLightBackground = Color(hex: "FAFAF8") // Off-white premium (was FFF5E6)
    static let snapLightCard = Color(hex: "FFFFFF") // Pure white cards (was FFE8CC)
    static let snapLightCardSecondary = Color(hex: "F5F5F0") // Very light warm gray (was FFD9A6)

    // MARK: - Dark Theme (Night - Coucher de nuit)
    static let snapDarkBackground = Color(hex: "0B0E1F") // Bleu nuit très profond
    static let snapDarkCard = Color(hex: "1A1F3A") // Bleu nuit profond
    static let snapDarkCardSecondary = Color(hex: "252B4A") // Bleu nuit moyen

    // MARK: - Adaptive Backgrounds (s'adaptent au thème)
    static func snapBackground(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? snapDarkBackground : snapLightBackground
    }

    static func snapCard(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? snapDarkCard : snapLightCard
    }

    static func snapCardSecondary(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? snapDarkCardSecondary : snapLightCardSecondary
    }

    // MARK: - Primary Colors (identiques pour les deux thèmes)
    static let snapOrange = Color(hex: "FF7043") // Orange lever de soleil
    static let snapPeach = Color(hex: "FFAB91") // Pêche douce
    static let snapCoral = Color(hex: "FF8A65") // Corail

    // MARK: - Accent Colors
    static let snapPurple = Color(hex: "7E57C2") // Violet crépuscule
    static let snapBlue = Color(hex: "42A5F5") // Bleu ciel
    static let snapPink = Color(hex: "FF6B9D") // Rose doux
    static let snapYellow = Color(hex: "FFC857") // Jaune soleil
    static let snapGreen = Color(hex: "66BB6A") // Vert nature

    // MARK: - Adaptive Text Colors
    static func snapTextPrimary(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color.white : Color(hex: "1A1A1A")
    }

    static func snapTextSecondary(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color(hex: "A0A5C8") : Color(hex: "666666")
    }

    static func snapTextTertiary(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color(hex: "6B7099") : Color(hex: "999999")
    }

    // MARK: - Adaptive Border/Divider Colors
    static func snapBorder(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color(hex: "3A3F5A") : Color(hex: "E0E0E0")
    }

    static func snapDivider(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color(hex: "2A2F4A") : Color(hex: "D0D0D0")
    }

    // Helper pour créer des couleurs depuis hex
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Gradient Presets
extension LinearGradient {
    static let snapSunrise = LinearGradient(
        colors: [Color.snapOrange, Color.snapPink],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let snapSunset = LinearGradient(
        colors: [Color.snapPeach, Color.snapCoral, Color.snapOrange],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let snapNight = LinearGradient(
        colors: [Color.snapPurple, Color.snapBlue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let snapDawn = LinearGradient(
        colors: [Color.snapYellow, Color.snapPeach],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let snapSuccess = LinearGradient(
        colors: [Color.snapGreen, Color.snapBlue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let snapEnergy = LinearGradient(
        colors: [Color.snapYellow, Color.snapOrange],
        startPoint: .leading,
        endPoint: .trailing
    )
}
