//
//  InsightsView.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import SwiftUI

struct InsightsView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var streakManager = StreakManager.shared
    @StateObject private var alarmManager = AlarmManager.shared
    @StateObject private var badgeManager = BadgeManager.shared
    @StateObject private var insightsManager = InsightsManager.shared
    @StateObject private var leagueManager = LeagueManager.shared
    @StateObject private var xpManager = XPManager.shared
    @State private var showingAllBadges = false
    @State private var selectedTab = 0 // 0 = Stats, 1 = Leagues

    var consistencyScore: Double {
        insightsManager.insightsData.consistencyScore
    }

    var consistencyColor: Color {
        if consistencyScore < 0 { return .gray } // Insufficient data
        switch consistencyScore {
        case 0..<30: return .red
        case 30..<50: return .orange
        case 50..<70: return .blue
        default: return .green
        }
    }

    var consistencyLabel: String {
        if consistencyScore < 0 { return "Need more data" }
        switch consistencyScore {
        case 0..<30: return "Variable"
        case 30..<50: return "Improving"
        case 50..<70: return "Regular"
        default: return "Consistent"
        }
    }

    var consistencyGradient: LinearGradient {
        if consistencyScore < 0 {
            return LinearGradient(colors: [.gray, .gray.opacity(0.7)], startPoint: .leading, endPoint: .trailing)
        }
        switch consistencyScore {
        case 0..<30: return LinearGradient(colors: [.red, .red.opacity(0.7)], startPoint: .leading, endPoint: .trailing)
        case 30..<50: return LinearGradient(colors: [.orange, .orange.opacity(0.7)], startPoint: .leading, endPoint: .trailing)
        case 50..<70: return LinearGradient(colors: [.blue, .blue.opacity(0.7)], startPoint: .leading, endPoint: .trailing)
        default: return LinearGradient(colors: [.green, .green.opacity(0.7)], startPoint: .leading, endPoint: .trailing)
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Custom Tab Bar
                HStack(spacing: 0) {
                    Button(action: { selectedTab = 0 }) {
                        VStack(spacing: 4) {
                            Text("Stats")
                                .font(.system(size: 16, weight: selectedTab == 0 ? .bold : .semibold, design: .rounded))
                                .foregroundColor(selectedTab == 0 ? Color.snapOrange : Color.snapTextSecondary(for: colorScheme))

                            if selectedTab == 0 {
                                Rectangle()
                                    .fill(Color.snapOrange)
                                    .frame(height: 3)
                                    .cornerRadius(1.5)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                    }
                    .buttonStyle(PlainButtonStyle())

                    Button(action: { selectedTab = 1 }) {
                        VStack(spacing: 4) {
                            Text("Leagues")
                                .font(.system(size: 16, weight: selectedTab == 1 ? .bold : .semibold, design: .rounded))
                                .foregroundColor(selectedTab == 1 ? Color.snapOrange : Color.snapTextSecondary(for: colorScheme))

                            if selectedTab == 1 {
                                Rectangle()
                                    .fill(Color.snapOrange)
                                    .frame(height: 3)
                                    .cornerRadius(1.5)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .background(Color.snapCard(for: colorScheme))
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.top, 8)

                // Tab Content
                if selectedTab == 0 {
                    statsView
                } else {
                    leaguesView
                }
            }
            .background(Color.snapBackground(for: colorScheme))
            .navigationTitle("Insights")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingAllBadges) {
                BadgesGridView()
            }
        }
    }

    var statsView: some View {
        ScrollView {
            VStack(spacing: 24) {
                    // Day Streak et Badges
                    HStack(spacing: 16) {
                        DayStreakCard(streak: streakManager.streakData.currentStreak)

                        BadgesEarnedCard(
                            badges: badgeManager.unlockedCount,
                            total: badgeManager.totalBadges
                        ) {
                            showingAllBadges = true
                        }
                    }
                    .padding(.horizontal)

                    // Stats section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Stats")
                            .font(.faroBold(size: 22))
                            .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                            .padding(.horizontal)

                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            InsightsStatCard(
                                icon: "figure.run",
                                title: "Avg Wake Time",
                                value: insightsManager.insightsData.averageWakeTime
                            )

                            InsightsStatCard(
                                icon: "timer",
                                title: "Avg Response",
                                value: insightsManager.insightsData.averageResponseTime
                            )

                            InsightsStatCard(
                                icon: "target",
                                title: "Favorite Mission",
                                value: insightsManager.insightsData.favoriteMission
                            )

                            InsightsStatCard(
                                icon: "music.note",
                                title: "Favorite Sound",
                                value: insightsManager.insightsData.favoriteSound
                            )
                        }
                        .padding(.horizontal)
                    }

                    // Consistency section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Consistency")
                                .font(.faroBold(size: 22))
                                .foregroundColor(Color.snapTextPrimary(for: colorScheme))

                            Spacer()

                            Button(action: {}) {
                                Image(systemName: "questionmark.circle")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                            }
                        }
                        .padding(.horizontal)

                        VStack(spacing: 16) {
                            HStack {
                                // Progress bar placeholder icon
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 30, height: 4)

                                Text("Need 3+ wake ups")
                                    .font(.faro(size: 15))
                                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))

                                Spacer()
                            }

                            // Multi-color progress bar
                            ZStack(alignment: .leading) {
                                // Background segments
                                HStack(spacing: 0) {
                                    Rectangle()
                                        .fill(Color.red.opacity(0.3))
                                        .frame(maxWidth: .infinity)
                                    Rectangle()
                                        .fill(Color.orange.opacity(0.3))
                                        .frame(maxWidth: .infinity)
                                    Rectangle()
                                        .fill(Color.blue.opacity(0.3))
                                        .frame(maxWidth: .infinity)
                                    Rectangle()
                                        .fill(Color.green.opacity(0.3))
                                        .frame(maxWidth: .infinity)
                                }
                                .frame(height: 8)
                            }
                            .cornerRadius(4)

                            // Scale labels
                            HStack {
                                Text("0")
                                    .font(.faro(size: 12))
                                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                                Spacer()
                                Text("30")
                                    .font(.faro(size: 12))
                                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                                Spacer()
                                Text("50")
                                    .font(.faro(size: 12))
                                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                                Spacer()
                                Text("70")
                                    .font(.faro(size: 12))
                                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                                Spacer()
                                Text("100")
                                    .font(.faro(size: 12))
                                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                            }

                            // Legend
                            HStack(spacing: 12) {
                                HStack(spacing: 4) {
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 8, height: 8)
                                    Text("Variable")
                                        .font(.faro(size: 12))
                                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                                }

                                HStack(spacing: 4) {
                                    Circle()
                                        .fill(Color.orange)
                                        .frame(width: 8, height: 8)
                                    Text("Improving")
                                        .font(.faro(size: 12))
                                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                                }

                                HStack(spacing: 4) {
                                    Circle()
                                        .fill(Color.blue)
                                        .frame(width: 8, height: 8)
                                    Text("Regular")
                                        .font(.faro(size: 12))
                                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                                }

                                HStack(spacing: 4) {
                                    Circle()
                                        .fill(Color.green)
                                        .frame(width: 8, height: 8)
                                    Text("Consistent")
                                        .font(.faro(size: 12))
                                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                                }
                            }
                        }
                        .padding(20)
                        .background(Color.snapCard(for: colorScheme))
                        .cornerRadius(16)
                        .padding(.horizontal)
                    }

                    Spacer(minLength: 40)
                }
                .padding(.vertical)
            }
        }
    }

    var leaguesView: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let league = leagueManager.currentLeague {
                    // League Info Card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text(league.name)
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                            Spacer()
                            Text("Week \(league.weekStartDate.formatted(.dateTime.day().month()))")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                        }

                        HStack(spacing: 8) {
                            Image(systemName: "person.3.fill")
                                .foregroundColor(.snapOrange)
                            Text("\(league.memberIDs.count)/8 members")
                                .font(.system(size: 14, weight: .semibold))
                            Spacer()
                            Text("Code: \(league.inviteCode)")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.snapOrange)
                        }
                    }
                    .padding(16)
                    .background(Color.snapCard(for: colorScheme))
                    .cornerRadius(16)
                    .padding(.horizontal)

                    // Leaderboard
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Weekly Leaderboard")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .padding(.horizontal)

                        ForEach(Array(leagueManager.leagueMembers.enumerated()), id: \.element.id) { index, member in
                            HStack(spacing: 12) {
                                // Rank
                                ZStack {
                                    if index == 0 {
                                        Circle()
                                            .fill(LinearGradient(
                                                colors: [Color.yellow, Color.orange],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            ))
                                            .frame(width: 36, height: 36)
                                        Image(systemName: "crown.fill")
                                            .foregroundColor(.white)
                                            .font(.system(size: 16, weight: .bold))
                                    } else {
                                        Circle()
                                            .fill(Color.gray.opacity(0.2))
                                            .frame(width: 36, height: 36)
                                        Text("\(index + 1)")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(.primary)
                                    }
                                }

                                // Avatar
                                Text(member.avatarEmoji)
                                    .font(.system(size: 32))

                                // Info
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(member.name)
                                        .font(.system(size: 16, weight: .semibold))
                                    HStack(spacing: 4) {
                                        Image(systemName: "flame.fill")
                                            .foregroundColor(.orange)
                                            .font(.system(size: 10))
                                        Text("\(member.currentStreak) day streak")
                                            .font(.system(size: 12))
                                            .foregroundColor(.secondary)
                                    }
                                }

                                Spacer()

                                // Weekly XP
                                VStack(alignment: .trailing, spacing: 2) {
                                    Text("\(member.weeklyXP)")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.snapOrange)
                                    Text("XP")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(12)
                            .background(Color.snapCard(for: colorScheme))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal)
                    }

                    // Leave League Button
                    Button(action: {
                        Task {
                            try? await leagueManager.leaveLeague()
                        }
                    }) {
                        Text("Leave League")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)

                } else {
                    // No League State
                    VStack(spacing: 24) {
                        Image(systemName: "trophy.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.snapOrange.opacity(0.5))
                            .padding(.top, 40)

                        VStack(spacing: 8) {
                            Text("Join a League!")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                            Text("Compete with friends in weekly XP challenges")
                                .font(.system(size: 15))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }

                        VStack(spacing: 12) {
                            // Create League Button
                            Button(action: {
                                Task {
                                    try? await leagueManager.createLeague(name: "My League")
                                }
                            }) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Create League")
                                        .font(.system(size: 16, weight: .bold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(LinearGradient(
                                    colors: [Color.snapOrange, Color.snapPink],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ))
                                .cornerRadius(12)
                            }

                            // Join with Code Button
                            Button(action: {
                                // TODO: Show join code input sheet
                            }) {
                                HStack {
                                    Image(systemName: "qrcode")
                                    Text("Join with Code")
                                        .font(.system(size: 16, weight: .semibold))
                                }
                                .foregroundColor(.snapOrange)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.snapOrange.opacity(0.1))
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    .frame(maxHeight: .infinity)
                }

                Spacer(minLength: 40)
            }
            .padding(.vertical)
        }
    }
}

// Day Streak Card
struct DayStreakCard: View {
    @Environment(\.colorScheme) var colorScheme
    let streak: Int

    var body: some View {
        VStack(spacing: 10) {
            // Flame icon - geometric shape with overlaid number
            ZStack(alignment: .center) {
                // Outer flame shape with gradient (orange to red)
                FlameShape()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 1.0, green: 0.65, blue: 0.3),  // #FFA54D - Orange clair
                                Color(red: 0.95, green: 0.4, blue: 0.3)   // #F26650 - Rouge-orange
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 55, height: 42)
                    .shadow(color: Color.orange.opacity(0.2), radius: 6, x: 0, y: 3)

                // Inner flame (yellow center)
                FlameShape()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 1.0, green: 0.95, blue: 0.6),  // #FFF299 - Jaune clair
                                Color(red: 1.0, green: 0.85, blue: 0.4)   // #FFD966 - Jaune-orange
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 28, height: 24)
                    .offset(y: 3)

                // Number overlaying the flame - noir avec stroke blanc
                ZStack {
                    // White stroke outline
                    Text("\(streak)")
                        .font(.faroBold(size: 40))
                        .foregroundColor(.white)
                        .offset(x: -1, y: -1)
                    Text("\(streak)")
                        .font(.faroBold(size: 40))
                        .foregroundColor(.white)
                        .offset(x: 1, y: -1)
                    Text("\(streak)")
                        .font(.faroBold(size: 40))
                        .foregroundColor(.white)
                        .offset(x: -1, y: 1)
                    Text("\(streak)")
                        .font(.faroBold(size: 40))
                        .foregroundColor(.white)
                        .offset(x: 1, y: 1)

                    // Main black number
                    Text("\(streak)")
                        .font(.faroBold(size: 40))
                        .foregroundColor(.black)
                }
                .offset(y: 5) // Centré dans la flamme
            }
            .padding(.top, 12)

            Text("Day Streak")
                .font(.faroBold(size: 15))
                .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                .padding(.top, 4)

            // Week dots
            HStack(spacing: 4) {
                ForEach(["S", "M", "T", "W", "T", "F", "S"], id: \.self) { day in
                    VStack(spacing: 2) {
                        Text(day)
                            .font(.faro(size: 10))
                            .foregroundColor(Color.snapTextSecondary(for: colorScheme))

                        Circle()
                            .fill(day == "S" ? Color(red: 1.0, green: 0.65, blue: 0.3) : Color.gray.opacity(0.3))
                            .frame(width: 16, height: 16)
                            .overlay(
                                day == "S" ?
                                Circle()
                                    .stroke(Color(red: 1.0, green: 0.65, blue: 0.3), lineWidth: 2)
                                    .frame(width: 20, height: 20)
                                : nil
                            )
                    }
                }
            }
            .padding(.bottom, 12)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .frame(height: 180)
        .background(Color.snapCard(for: colorScheme))
        .cornerRadius(16)
    }
}

// Badges Earned Card
struct BadgesEarnedCard: View {
    @Environment(\.colorScheme) var colorScheme
    let badges: Int
    let total: Int
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                // Hexagon badge - geometric shape
                ZStack {
                    // Outer gold border
                    HexagonShape()
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.96, green: 0.77, blue: 0.19),  // #F5C430 - Or clair
                                    Color(red: 0.85, green: 0.65, blue: 0.13)   // #D9A521 - Or foncé
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 4
                        )
                        .frame(width: 65, height: 65)

                    // Dark background
                    HexagonShape()
                        .fill(Color(red: 0.24, green: 0.24, blue: 0.25))  // #3C3C40 - Gris foncé
                        .frame(width: 60, height: 60)

                    // Badge number - doré
                    Text("\(badges)")
                        .font(.faroBold(size: 36))
                        .foregroundColor(Color(red: 0.96, green: 0.77, blue: 0.19))  // #F5C430 - Or
                }
                .padding(.top, 12)

                Text("Badges Earned")
                    .font(.faroBold(size: 15))
                    .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                    .padding(.top, 4)

                Text("Complete wake ups to earn")
                    .font(.faro(size: 11))
                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding(.horizontal, 8)
                    .padding(.bottom, 12)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .frame(height: 180)
            .background(Color.snapCard(for: colorScheme))
            .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Insights Stat Card
struct InsightsStatCard: View {
    @Environment(\.colorScheme) var colorScheme
    let icon: String
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                Spacer()
            }
            .padding(.bottom, 32)

            Text(title)
                .font(.faro(size: 15))
                .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                .padding(.bottom, 8)

            Text(value.isEmpty ? "—" : value)
                .font(.faroBold(size: 22))
                .foregroundColor(Color.snapTextPrimary(for: colorScheme))
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 120, alignment: .topLeading)
        .background(Color.snapCard(for: colorScheme))
        .cornerRadius(16)
    }
}

#Preview {
    InsightsView()
}
