//
//  MissionCompletionView.swift
//  SnapWake
//
//  Mission completion screen with stats and XP
//

import SwiftUI

struct MissionCompletionView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var streakManager = StreakManager.shared
    @StateObject private var xpManager = XPManager.shared
    @StateObject private var badgeManager = BadgeManager.shared

    let mission: Mission
    let timeTaken: TimeInterval
    let onDismiss: () -> Void

    @State private var showStats = false
    @State private var sunScale: CGFloat = 0.5
    @State private var sunRotation: Double = -180

    var xpEarned: Int {
        switch mission.type {
        case .exercise:
            return MissionXP.pushups
        case .photo:
            return MissionXP.skyPhoto
        case .shake:
            return MissionXP.shake
        case .math:
            return MissionXP.math
        case .text:
            return MissionXP.affirmation
        default:
            return 10
        }
    }

    var body: some View {
        ZStack {
            Color.snapLightBackground
                .ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                // Animated Sun
                ZStack {
                    // Sun rays (outer glow)
                    ForEach(0..<12) { index in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                LinearGradient(
                                    colors: [Color.yellow.opacity(0.8), Color.orange.opacity(0.3)],
                                    startPoint: .center,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: 60, height: 8)
                            .offset(x: 70)
                            .rotationEffect(.degrees(Double(index) * 30))
                    }

                    // Main sun circle
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.yellow, Color.orange],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 140, height: 140)
                        .shadow(color: Color.orange.opacity(0.3), radius: 20)
                        .overlay(
                            // Happy face
                            VStack(spacing: 8) {
                                HStack(spacing: 20) {
                                    // Eyes
                                    Capsule()
                                        .fill(Color.black.opacity(0.7))
                                        .frame(width: 20, height: 8)
                                    Capsule()
                                        .fill(Color.black.opacity(0.7))
                                        .frame(width: 20, height: 8)
                                }
                                .offset(y: -10)

                                // Smile
                                Path { path in
                                    path.move(to: CGPoint(x: 45, y: 20))
                                    path.addQuadCurve(
                                        to: CGPoint(x: 95, y: 20),
                                        control: CGPoint(x: 70, y: 40)
                                    )
                                }
                                .stroke(Color.black.opacity(0.7), style: StrokeStyle(lineWidth: 4, lineCap: .round))
                                .frame(width: 140, height: 140)
                            }
                        )
                }
                .scaleEffect(sunScale)
                .rotationEffect(.degrees(sunRotation))

                // Title
                Text("Alarm turned off!")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .opacity(showStats ? 1 : 0)

                // Stats Cards
                HStack(spacing: 16) {
                    StatCard(
                        icon: "clock",
                        iconColor: .blue,
                        value: formatTime(timeTaken),
                        label: "Time Taken"
                    )

                    StatCard(
                        icon: "flame.fill",
                        iconColor: .orange,
                        value: "\(streakManager.streakData.currentStreak)",
                        label: "Day Streak"
                    )

                    StatCard(
                        icon: "star.fill",
                        iconColor: .yellow,
                        value: "+\(xpEarned)",
                        label: "XP Earned"
                    )
                }
                .padding(.horizontal, 16)
                .opacity(showStats ? 1 : 0)
                .offset(y: showStats ? 0 : 20)

                // Badge (if unlocked)
                if let lastBadge = badgeManager.badges.last(where: { $0.isUnlocked }) {
                    VStack(spacing: 8) {
                        ZStack {
                            // Hexagon shape
                            Image(systemName: "hexagon.fill")
                                .font(.system(size: 80))
                                .foregroundColor(Color.yellow)

                            Text(lastBadge.icon)
                                .font(.system(size: 40))
                        }

                        Text(lastBadge.name)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.secondary)
                    }
                    .opacity(showStats ? 1 : 0)
                }

                Spacer()

                // Start My Day Button
                Button(action: onDismiss) {
                    Text("Start My Day")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.black)
                        .cornerRadius(16)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
                .opacity(showStats ? 1 : 0)
            }
        }
        .onAppear {
            // Animate sun
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                sunScale = 1.0
                sunRotation = 0
            }

            // Show stats after sun animation
            withAnimation(.easeIn(duration: 0.4).delay(0.4)) {
                showStats = true
            }
        }
    }

    private func formatTime(_ seconds: TimeInterval) -> String {
        let minutes = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%dm %ds", minutes, secs)
    }
}

struct StatCard: View {
    @Environment(\.colorScheme) var colorScheme
    let icon: String
    let iconColor: Color
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(iconColor)

            Text(value)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(Color.snapTextPrimary(for: colorScheme))

            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, y: 4)
    }
}

#Preview {
    MissionCompletionView(
        mission: Mission(
            name: "Math Challenge",
            description: "Solve problems",
            icon: "number",
            gradient: [.blue, .purple],
            category: .mental,
            type: .math
        ),
        timeTaken: 87,
        onDismiss: {}
    )
}
