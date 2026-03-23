//
//  BadgeUnlockedView.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import SwiftUI

struct BadgeUnlockedOverlay: View {
    @StateObject private var badgeManager = BadgeManager.shared

    var body: some View {
        Group {
            if let badge = badgeManager.newlyUnlockedBadge {
                ZStack {
                    // Semi-transparent background
                    Color.black.opacity(0.7)
                        .ignoresSafeArea()
                        .transition(.opacity)

                    // Badge card
                    VStack(spacing: 24) {
                        MascotView(.victoire, size: .medium)

                        Text("Badge Unlocked!")
                            .font(.faroBold(size: 28))
                            .foregroundColor(.white)

                        // Badge icon
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: badge.gradientColors,
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 120, height: 120)

                            Image(systemName: badge.icon)
                                .font(.system(size: 55))
                                .foregroundColor(.white)
                        }
                        .shadow(color: badge.gradientColors.first?.opacity(0.5) ?? .clear, radius: 20)

                        VStack(spacing: 8) {
                            Text(badge.name)
                                .font(.faroBold(size: 24))
                                .foregroundColor(.white)

                            Text(badge.description)
                                .font(.faro(size: 16))
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                        }

                        Button(action: {
                            withAnimation {
                                badgeManager.newlyUnlockedBadge = nil
                            }
                        }) {
                            Text("Continue")
                                .font(.faroBold(size: 18))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    LinearGradient(
                                        colors: badge.gradientColors,
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(16)
                        }
                        .padding(.horizontal, 40)
                    }
                    .padding(32)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.black.opacity(0.9))
                    )
                    .padding(.horizontal, 32)
                    .transition(.scale.combined(with: .opacity))
                }
                .transition(.opacity)
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: badgeManager.newlyUnlockedBadge != nil)
    }
}

#Preview {
    BadgeUnlockedOverlay()
}
