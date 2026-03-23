//
//  DetailedStatsView.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import SwiftUI
import Charts

struct DetailedStatsView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var insightsManager = InsightsManager.shared
    @StateObject private var streakManager = StreakManager.shared

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Summary Cards
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    SummaryCard(
                        icon: "calendar.badge.checkmark",
                        title: "Total Wake Ups",
                        value: "\(insightsManager.insightsData.totalWakeUps)",
                        color: .snapBlue
                    )

                    SummaryCard(
                        icon: "percent",
                        title: "Success Rate",
                        value: String(format: "%.0f%%", insightsManager.insightsData.successRate),
                        color: .snapGreen
                    )

                    SummaryCard(
                        icon: "flame.fill",
                        title: "Longest Streak",
                        value: "\(streakManager.streakData.longestStreak)",
                        color: .snapOrange
                    )

                    SummaryCard(
                        icon: "star.fill",
                        title: "This Week",
                        value: "\(insightsManager.insightsData.weeklyWakeUps.count)/7",
                        color: .snapYellow
                    )
                }
                .padding(.horizontal)

                // Weekly Activity Chart
                VStack(alignment: .leading, spacing: 16) {
                    Text("Weekly Activity")
                        .font(.faroBold(size: 22))
                        .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                        .padding(.horizontal)

                    WeeklyActivityChart()
                        .padding()
                        .background(Color.snapCard(for: colorScheme))
                        .cornerRadius(16)
                        .padding(.horizontal)
                }

                // Wake Time Distribution
                VStack(alignment: .leading, spacing: 16) {
                    Text("Wake Time Distribution")
                        .font(.faroBold(size: 22))
                        .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                        .padding(.horizontal)

                    WakeTimeDistributionChart()
                        .padding()
                        .background(Color.snapCard(for: colorScheme))
                        .cornerRadius(16)
                        .padding(.horizontal)
                }

                // Mission Performance
                VStack(alignment: .leading, spacing: 16) {
                    Text("Mission Performance")
                        .font(.faroBold(size: 22))
                        .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                        .padding(.horizontal)

                    MissionPerformanceView()
                }

                // Response Time Stats
                VStack(alignment: .leading, spacing: 16) {
                    Text("Response Time Analysis")
                        .font(.faroBold(size: 22))
                        .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                        .padding(.horizontal)

                    ResponseTimeStatsView()
                        .padding()
                        .background(Color.snapCard(for: colorScheme))
                        .cornerRadius(16)
                        .padding(.horizontal)
                }

                Spacer(minLength: 40)
            }
            .padding(.vertical)
        }
        .background(Color.snapBackground(for: colorScheme))
        .navigationTitle("Detailed Stats")
    }
}

struct SummaryCard: View {
    @Environment(\.colorScheme) var colorScheme
    let icon: String
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(color)

            Text(value)
                .font(.faroBold(size: 28))
                .foregroundColor(Color.snapTextPrimary(for: colorScheme))

            Text(title)
                .font(.faro(size: 13))
                .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.snapCard(for: colorScheme))
        .cornerRadius(16)
    }
}

struct WeeklyActivityChart: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var insightsManager = InsightsManager.shared

    struct DayData: Identifiable {
        let id = UUID()
        let day: String
        let count: Int
    }

    var weekData: [DayData] {
        let calendar = Calendar.current
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)
        let sundayOffset = -(weekday - 1)
        let sunday = calendar.date(byAdding: .day, value: sundayOffset, to: today) ?? today

        return (0..<7).map { offset in
            let date = calendar.date(byAdding: .day, value: offset, to: sunday) ?? today
            let dayName = dayFormatter.string(from: date).prefix(1).uppercased()
            let count = insightsManager.insightsData.wakeUpRecords.filter { record in
                calendar.isDate(record.date, inSameDayAs: date)
            }.count

            return DayData(day: String(dayName), count: count)
        }
    }

    private let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                ForEach(weekData) { data in
                    VStack(spacing: 8) {
                        // Bar
                        VStack {
                            Spacer()
                            RoundedRectangle(cornerRadius: 4)
                                .fill(data.count > 0 ? LinearGradient.snapSuccess : LinearGradient(colors: [Color.gray.opacity(0.3)], startPoint: .top, endPoint: .bottom))
                                .frame(height: CGFloat(max(data.count * 40, 20)))
                        }
                        .frame(height: 120)

                        // Day letter
                        Text(data.day)
                            .font(.faro(size: 12))
                            .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

struct WakeTimeDistributionChart: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var insightsManager = InsightsManager.shared

    var hourDistribution: [Int: Int] {
        var distribution: [Int: Int] = [:]

        for record in insightsManager.insightsData.wakeUpRecords {
            let hour = Calendar.current.component(.hour, from: record.wakeUpTime)
            distribution[hour, default: 0] += 1
        }

        return distribution
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if insightsManager.insightsData.wakeUpRecords.isEmpty {
                Text("No wake up data yet")
                    .font(.faro(size: 14))
                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                ForEach(Array(hourDistribution.sorted(by: { $0.key < $1.key })), id: \.key) { hour, count in
                    HStack {
                        Text(String(format: "%02d:00", hour))
                            .font(.faro(size: 14))
                            .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                            .frame(width: 60, alignment: .leading)

                        GeometryReader { geometry in
                            RoundedRectangle(cornerRadius: 4)
                                .fill(LinearGradient.snapSunrise)
                                .frame(width: geometry.size.width * CGFloat(count) / CGFloat(hourDistribution.values.max() ?? 1))
                        }
                        .frame(height: 20)

                        Text("\(count)")
                            .font(.faroBold(size: 14))
                            .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                            .frame(width: 30, alignment: .trailing)
                    }
                }
            }
        }
    }
}

struct MissionPerformanceView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var insightsManager = InsightsManager.shared

    var missionStats: [(mission: String, completed: Int, failed: Int)] {
        let records = insightsManager.insightsData.wakeUpRecords
        let grouped = Dictionary(grouping: records) { $0.missionType ?? "None" }

        return grouped.map { mission, records in
            let completed = records.filter { $0.missionCompleted }.count
            let failed = records.count - completed
            return (mission, completed, failed)
        }.sorted { $0.completed > $1.completed }
    }

    var body: some View {
        VStack(spacing: 12) {
            ForEach(missionStats, id: \.mission) { stat in
                MissionStatRow(
                    missionName: stat.mission,
                    completed: stat.completed,
                    failed: stat.failed
                )
            }
        }
        .padding(.horizontal)
    }
}

struct MissionStatRow: View {
    @Environment(\.colorScheme) var colorScheme
    let missionName: String
    let completed: Int
    let failed: Int

    var total: Int {
        completed + failed
    }

    var successRate: Double {
        total > 0 ? Double(completed) / Double(total) * 100 : 0
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(missionName)
                    .font(.faroBold(size: 16))
                    .foregroundColor(Color.snapTextPrimary(for: colorScheme))

                Spacer()

                Text(String(format: "%.0f%%", successRate))
                    .font(.faroBold(size: 16))
                    .foregroundColor(successRate >= 80 ? .snapGreen : (successRate >= 50 ? .snapOrange : .red))
            }

            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.red.opacity(0.3))
                        .frame(height: 8)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(LinearGradient.snapSuccess)
                        .frame(width: geometry.size.width * CGFloat(completed) / CGFloat(total), height: 8)
                }
            }
            .frame(height: 8)

            HStack {
                Text("✅ \(completed) completed")
                    .font(.faro(size: 12))
                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))

                Spacer()

                Text("❌ \(failed) failed")
                    .font(.faro(size: 12))
                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))
            }
        }
        .padding()
        .background(Color.snapCard(for: colorScheme))
        .cornerRadius(12)
    }
}

struct ResponseTimeStatsView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var insightsManager = InsightsManager.shared

    var responseTimes: [Double] {
        insightsManager.insightsData.wakeUpRecords.map { $0.responseTimeSeconds }
    }

    var avgResponseTime: String {
        guard !responseTimes.isEmpty else { return "--" }
        let avg = responseTimes.reduce(0, +) / Double(responseTimes.count)
        return formatTime(avg)
    }

    var fastestResponseTime: String {
        guard !responseTimes.isEmpty else { return "--" }
        let fastest = responseTimes.min() ?? 0
        return formatTime(fastest)
    }

    var slowestResponseTime: String {
        guard !responseTimes.isEmpty else { return "--" }
        let slowest = responseTimes.max() ?? 0
        return formatTime(slowest)
    }

    func formatTime(_ seconds: Double) -> String {
        if seconds < 60 {
            return String(format: "%.0fs", seconds)
        } else if seconds < 3600 {
            let minutes = Int(seconds / 60)
            let secs = Int(seconds.truncatingRemainder(dividingBy: 60))
            return "\(minutes)m \(secs)s"
        } else {
            return "--"
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                VStack(spacing: 4) {
                    Text("Average")
                        .font(.faro(size: 13))
                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))

                    Text(avgResponseTime)
                        .font(.faroBold(size: 20))
                        .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                }
                .frame(maxWidth: .infinity)

                Divider()

                VStack(spacing: 4) {
                    Text("Fastest")
                        .font(.faro(size: 13))
                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))

                    Text(fastestResponseTime)
                        .font(.faroBold(size: 20))
                        .foregroundColor(.snapGreen)
                }
                .frame(maxWidth: .infinity)

                Divider()

                VStack(spacing: 4) {
                    Text("Slowest")
                        .font(.faro(size: 13))
                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))

                    Text(slowestResponseTime)
                        .font(.faroBold(size: 20))
                        .foregroundColor(.snapOrange)
                }
                .frame(maxWidth: .infinity)
            }
            .frame(height: 60)
        }
    }
}

#Preview {
    NavigationView {
        DetailedStatsView()
    }
}
