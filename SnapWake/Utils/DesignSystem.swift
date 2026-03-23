//
//  DesignSystem.swift
//  SnapWake
//
//  Created by Josselin Biot on 08/03/2026.
//

import SwiftUI

// MARK: - Design Constants
struct DesignSystem {

    // MARK: - Corner Radius
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let extraLarge: CGFloat = 20
        static let pill: CGFloat = 30
    }

    // MARK: - Spacing
    struct Spacing {
        static let tiny: CGFloat = 4
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let extraLarge: CGFloat = 20
        static let xxLarge: CGFloat = 24
        static let xxxLarge: CGFloat = 32
    }

    // MARK: - Icon Sizes
    struct IconSize {
        static let small: CGFloat = 14
        static let medium: CGFloat = 20
        static let large: CGFloat = 24
        static let extraLarge: CGFloat = 28
        static let huge: CGFloat = 50
    }

    // MARK: - Font Sizes
    struct FontSize {
        static let caption: CGFloat = 13
        static let body: CGFloat = 15
        static let bodyLarge: CGFloat = 17
        static let title3: CGFloat = 20
        static let title2: CGFloat = 22
        static let title1: CGFloat = 24
        static let largeTitle: CGFloat = 28
        static let display: CGFloat = 48
        static let displayLarge: CGFloat = 56
        static let displayHuge: CGFloat = 60
    }

    // MARK: - Button Heights
    struct ButtonHeight {
        static let small: CGFloat = 40
        static let medium: CGFloat = 48
        static let large: CGFloat = 56
    }
}

// MARK: - Primary Button Style
struct SnapPrimaryButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme
    var isEnabled: Bool = true

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.faroSemiBold(size: DesignSystem.FontSize.bodyLarge))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: DesignSystem.ButtonHeight.medium)
            .background(
                isEnabled
                    ? (configuration.isPressed ? Color.snapOrange.opacity(0.8) : Color.snapOrange)
                    : Color.gray.opacity(0.5)
            )
            .cornerRadius(DesignSystem.CornerRadius.large)
    }
}

// MARK: - Secondary Button Style
struct SnapSecondaryButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.faroSemiBold(size: DesignSystem.FontSize.bodyLarge))
            .foregroundColor(Color.snapTextPrimary(for: colorScheme))
            .frame(maxWidth: .infinity)
            .frame(height: DesignSystem.ButtonHeight.medium)
            .background(
                configuration.isPressed
                    ? Color.snapCard(for: colorScheme).opacity(0.8)
                    : Color.snapCard(for: colorScheme)
            )
            .cornerRadius(DesignSystem.CornerRadius.large)
    }
}

// MARK: - Card Container
struct SnapCard<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme
    let content: Content
    var cornerRadius: CGFloat = DesignSystem.CornerRadius.medium
    var padding: CGFloat = DesignSystem.Spacing.large

    init(cornerRadius: CGFloat = DesignSystem.CornerRadius.medium,
         padding: CGFloat = DesignSystem.Spacing.large,
         @ViewBuilder content: () -> Content) {
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.content = content()
    }

    var body: some View {
        content
            .padding(padding)
            .background(Color.snapCard(for: colorScheme))
            .cornerRadius(cornerRadius)
    }
}

// MARK: - Section Header
struct SnapSectionHeader: View {
    @Environment(\.colorScheme) var colorScheme
    let title: String
    var action: (() -> Void)? = nil
    var actionTitle: String? = nil

    var body: some View {
        HStack {
            Text(title)
                .font(.faroBold(size: DesignSystem.FontSize.title2))
                .foregroundColor(Color.snapTextPrimary(for: colorScheme))

            Spacer()

            if let action = action, let actionTitle = actionTitle {
                Button(action: action) {
                    Text(actionTitle)
                        .font(.faroSemiBold(size: DesignSystem.FontSize.body))
                        .foregroundColor(.snapOrange)
                }
            }
        }
    }
}

// MARK: - Icon Badge
struct SnapIconBadge: View {
    let icon: String
    let color: Color
    let size: CGFloat

    init(icon: String, color: Color = .snapOrange, size: CGFloat = DesignSystem.IconSize.large) {
        self.icon = icon
        self.color = color
        self.size = size
    }

    var body: some View {
        Image(systemName: icon)
            .font(.system(size: size))
            .foregroundColor(color)
    }
}

// MARK: - Gradient Background
struct SnapGradientBackground: View {
    let colors: [Color]
    let startPoint: UnitPoint
    let endPoint: UnitPoint

    init(colors: [Color] = [.snapOrange, .snapPink],
         startPoint: UnitPoint = .topLeading,
         endPoint: UnitPoint = .bottomTrailing) {
        self.colors = colors
        self.startPoint = startPoint
        self.endPoint = endPoint
    }

    var body: some View {
        LinearGradient(
            colors: colors,
            startPoint: startPoint,
            endPoint: endPoint
        )
    }
}

// MARK: - Extensions for easy access
extension View {
    func snapPrimaryButton(isEnabled: Bool = true) -> some View {
        self.buttonStyle(SnapPrimaryButtonStyle(isEnabled: isEnabled))
    }

    func snapSecondaryButton() -> some View {
        self.buttonStyle(SnapSecondaryButtonStyle())
    }
}
