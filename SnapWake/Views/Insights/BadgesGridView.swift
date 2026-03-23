//
//  BadgesGridView.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import SwiftUI

struct BadgesGridView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var badgeManager = BadgeManager.shared

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header stats
                    HStack(spacing: 20) {
                        VStack(spacing: 4) {
                            Text("\(badgeManager.unlockedCount)")
                                .font(.faroBold(size: 36))
                                .foregroundColor(Color.snapTextPrimary(for: colorScheme))

                            Text("Unlocked")
                                .font(.faro(size: 14))
                                .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                        }

                        Divider()
                            .frame(height: 40)

                        VStack(spacing: 4) {
                            Text("\(badgeManager.totalBadges)")
                                .font(.faroBold(size: 36))
                                .foregroundColor(Color.snapTextPrimary(for: colorScheme))

                            Text("Total")
                                .font(.faro(size: 14))
                                .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                        }

                        Divider()
                            .frame(height: 40)

                        VStack(spacing: 4) {
                            Text("\(Int(Double(badgeManager.unlockedCount) / Double(badgeManager.totalBadges) * 100))%")
                                .font(.faroBold(size: 36))
                                .foregroundColor(Color.snapTextPrimary(for: colorScheme))

                            Text("Complete")
                                .font(.faro(size: 14))
                                .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                        }
                    }
                    .padding()
                    .background(Color.snapCard(for: colorScheme))
                    .cornerRadius(16)
                    .padding(.horizontal)

                    // Badges par catégorie
                    ForEach(BadgeCategory.allCases, id: \.self) { category in
                        BadgeCategorySection(category: category)
                    }

                    Spacer(minLength: 40)
                }
                .padding(.vertical)
            }
            .background(Color.snapBackground(for: colorScheme))
            .navigationTitle("Badges")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}


struct BadgeCategorySection: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var badgeManager = BadgeManager.shared
    let category: BadgeCategory

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var badges: [Badge] {
        badgeManager.getBadgesForCategory(category)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(category.rawValue)
                .font(.faroBold(size: 22))
                .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                .padding(.horizontal)

            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(badges) { badge in
                    BadgeCardView(badge: badge)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct BadgeCardView: View {
    @Environment(\.colorScheme) var colorScheme
    let badge: Badge
    @State private var showingDetail = false

    var body: some View {
        Button(action: { showingDetail = true }) {
            VStack(spacing: 12) {
                // Badge icon - hexagonal geometric shape
                ZStack {
                    if badge.isUnlocked {
                        // Unlocked badge: gradient border with dark background
                        HexagonShape()
                            .stroke(
                                LinearGradient(
                                    colors: badge.gradientColors,
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 3
                            )
                            .frame(width: 70, height: 70)

                        HexagonShape()
                            .fill(Color(hex: "3C3C3E"))
                            .frame(width: 64, height: 64)

                        // Badge content (number or icon representation)
                        badgeContentView(for: badge)

                        // 3 stars at bottom for unlocked badges
                        HStack(spacing: 2) {
                            ForEach(0..<3) { _ in
                                StarShape()
                                    .fill(Color(hex: "F4C430"))
                                    .frame(width: 6, height: 6)
                            }
                        }
                        .offset(y: 24)
                    } else {
                        // Locked badge: gray hexagon with lock
                        HexagonShape()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 70, height: 70)

                        Image(systemName: "lock.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.gray.opacity(0.5))
                    }
                }
                .frame(height: 80)

                Text(badge.name)
                    .font(.faroBold(size: 12))
                    .foregroundColor(
                        badge.isUnlocked ?
                        Color.snapTextPrimary(for: colorScheme) :
                        Color.snapTextSecondary(for: colorScheme)
                    )
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(Color.snapCard(for: colorScheme))
            .cornerRadius(16)
            .opacity(badge.isUnlocked ? 1.0 : 0.6)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingDetail) {
            BadgeDetailView(badge: badge)
        }
    }

    @ViewBuilder
    private func badgeContentView(for badge: Badge) -> some View {
        // Create geometric representations based on badge type
        if badge.category == .streak {
            // For streak badges, show the number
            Text("\(badge.requirement)")
                .font(.faroBold(size: 24))
                .foregroundColor(Color(hex: "F4C430"))
        } else {
            // For achievement badges, create geometric icons
            GeometricBadgeIcon(iconType: badge.icon)
                .fill(Color(hex: "F4C430"))
                .frame(width: 32, height: 32)
        }
    }
}

struct BadgeDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    let badge: Badge

    var body: some View {
        ZStack {
            // Gradient background (cream to dark)
            LinearGradient(
                colors: badge.isUnlocked ?
                    [Color(hex: "F5E6D3"), Color(hex: "2C2C2E")] :
                    [Color.snapBackground(for: colorScheme), Color.snapBackground(for: colorScheme)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 32) {
                // Close button
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 20))
                            .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                    }
                }
                .padding(.horizontal, 32)

                Spacer()

                // Large hexagonal badge
                ZStack {
                    if badge.isUnlocked {
                        // Unlocked: gradient border hexagon
                        HexagonShape()
                            .stroke(
                                LinearGradient(
                                    colors: badge.gradientColors,
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 5
                            )
                            .frame(width: 180, height: 180)

                        HexagonShape()
                            .fill(Color(hex: "3C3C3E"))
                            .frame(width: 170, height: 170)

                        // Badge content
                        if badge.category == .streak {
                            Text("\(badge.requirement)")
                                .font(.faroBold(size: 60))
                                .foregroundColor(Color(hex: "F4C430"))
                        } else {
                            GeometricBadgeIcon(iconType: badge.icon)
                                .fill(Color(hex: "F4C430"))
                                .frame(width: 80, height: 80)
                        }

                        // 3 stars at bottom
                        HStack(spacing: 4) {
                            ForEach(0..<3) { _ in
                                StarShape()
                                    .fill(Color(hex: "F4C430"))
                                    .frame(width: 12, height: 12)
                            }
                        }
                        .offset(y: 70)
                    } else {
                        // Locked: gray hexagon
                        HexagonShape()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 180, height: 180)

                        Image(systemName: "lock.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.gray.opacity(0.5))
                    }
                }

                VStack(spacing: 16) {
                    if badge.isUnlocked {
                        Text("BADGE UNLOCKED")
                            .font(.faroBold(size: 14))
                            .foregroundColor(.snapOrange)
                            .tracking(2)
                    }

                    Text(badge.name)
                        .font(.faroBold(size: 36))
                        .foregroundColor(.white)

                    if badge.isUnlocked, let unlockedDate = badge.unlockedDate {
                        Text("Unlocked on \(formattedDate(unlockedDate))")
                            .font(.faro(size: 15))
                            .foregroundColor(Color.white.opacity(0.7))
                    }

                    Text(badge.description)
                        .font(.faro(size: 16))
                        .foregroundColor(Color.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .padding(.top, 8)
                }

                Spacer()
            }
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    BadgesGridView()
}
