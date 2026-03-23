//
//  InsightsData.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import Foundation

struct WakeUpRecord: Codable, Identifiable {
    let id: UUID
    let date: Date
    let alarmTime: Date
    let wakeUpTime: Date
    let missionCompleted: Bool
    let missionType: String?
    let difficulty: String
    let soundUsed: String
    let responseTimeSeconds: Double // Temps entre alarme et complétion mission

    init(
        id: UUID = UUID(),
        date: Date = Date(),
        alarmTime: Date,
        wakeUpTime: Date,
        missionCompleted: Bool,
        missionType: String?,
        difficulty: String,
        soundUsed: String
    ) {
        self.id = id
        self.date = date
        self.alarmTime = alarmTime
        self.wakeUpTime = wakeUpTime
        self.missionCompleted = missionCompleted
        self.missionType = missionType
        self.difficulty = difficulty
        self.soundUsed = soundUsed
        self.responseTimeSeconds = wakeUpTime.timeIntervalSince(alarmTime)
    }
}

struct InsightsData: Codable {
    var wakeUpRecords: [WakeUpRecord]

    init() {
        self.wakeUpRecords = []
    }

    mutating func addWakeUpRecord(_ record: WakeUpRecord) {
        wakeUpRecords.append(record)

        // Garder seulement les 90 derniers jours
        let ninetyDaysAgo = Calendar.current.date(byAdding: .day, value: -90, to: Date()) ?? Date()
        wakeUpRecords = wakeUpRecords.filter { $0.date >= ninetyDaysAgo }
    }

    // MARK: - Calculs des insights

    var averageWakeTime: String {
        guard !wakeUpRecords.isEmpty else { return "--" }

        let calendar = Calendar.current
        let totalMinutes = wakeUpRecords.reduce(0) { total, record in
            let components = calendar.dateComponents([.hour, .minute], from: record.wakeUpTime)
            let minutes = (components.hour ?? 0) * 60 + (components.minute ?? 0)
            return total + minutes
        }

        let avgMinutes = totalMinutes / wakeUpRecords.count
        let hours = avgMinutes / 60
        let minutes = avgMinutes % 60

        return String(format: "%02d:%02d", hours, minutes)
    }

    var averageResponseTime: String {
        // Filter only completed missions
        let completedRecords = wakeUpRecords.filter { $0.missionCompleted }
        guard !completedRecords.isEmpty else { return "--" }

        let totalSeconds = completedRecords.reduce(0.0) { $0 + $1.responseTimeSeconds }
        let avgSeconds = totalSeconds / Double(completedRecords.count)

        if avgSeconds < 60 {
            return String(format: "%.0fs", avgSeconds)
        } else if avgSeconds < 3600 {
            let minutes = Int(avgSeconds / 60)
            let seconds = Int(avgSeconds.truncatingRemainder(dividingBy: 60))
            return "\(minutes)m \(seconds)s"
        } else {
            return "--"
        }
    }

    var favoriteMission: String {
        guard !wakeUpRecords.isEmpty else { return "--" }

        let missionCounts = Dictionary(grouping: wakeUpRecords.compactMap { $0.missionType }) { $0 }
            .mapValues { $0.count }

        guard let favorite = missionCounts.max(by: { $0.value < $1.value }) else {
            return "None"
        }

        return favorite.key
    }

    var favoriteSound: String {
        guard !wakeUpRecords.isEmpty else { return "--" }

        let soundCounts = Dictionary(grouping: wakeUpRecords.map { $0.soundUsed }) { $0 }
            .mapValues { $0.count }

        guard let favorite = soundCounts.max(by: { $0.value < $1.value }) else {
            return "Default"
        }

        return favorite.key
    }

    var consistencyScore: Double {
        // Need at least 3 records for meaningful calculation
        guard wakeUpRecords.count >= 3 else { return -1 } // -1 indicates insufficient data

        // Calculer la variance des heures de réveil
        let calendar = Calendar.current
        let wakeMinutes = wakeUpRecords.map { record -> Int in
            let components = calendar.dateComponents([.hour, .minute], from: record.wakeUpTime)
            return (components.hour ?? 0) * 60 + (components.minute ?? 0)
        }

        let mean = Double(wakeMinutes.reduce(0, +)) / Double(wakeMinutes.count)
        let variance = wakeMinutes.reduce(0.0) { sum, minutes in
            sum + pow(Double(minutes) - mean, 2)
        } / Double(wakeMinutes.count)

        let stdDev = sqrt(variance)

        // Convertir en score de 0-100
        // stdDev faible = score élevé
        // stdDev de 0 min = 100%, stdDev de 60+ min = 0%
        let score = max(0, min(100, 100 - (stdDev / 60 * 100)))

        return score
    }

    var consistencyScoreFormatted: String {
        let score = consistencyScore
        if score < 0 {
            return "--" // Not enough data
        }
        return String(format: "%.0f%%", score)
    }

    var totalWakeUps: Int {
        wakeUpRecords.count
    }

    var successRate: Double {
        guard !wakeUpRecords.isEmpty else { return 0 }
        let successful = wakeUpRecords.filter { $0.missionCompleted }.count
        return Double(successful) / Double(wakeUpRecords.count) * 100
    }

    // Derniers 7 jours
    var weeklyWakeUps: [WakeUpRecord] {
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return wakeUpRecords.filter { $0.date >= sevenDaysAgo }
    }

    var weeklySuccessRate: Double {
        guard !weeklyWakeUps.isEmpty else { return 0 }
        let successful = weeklyWakeUps.filter { $0.missionCompleted }.count
        return Double(successful) / Double(weeklyWakeUps.count) * 100
    }

    // Difficulty-specific stats
    var impossibleMissionsCompleted: Int {
        wakeUpRecords.filter { $0.difficulty == "Impossible" && $0.missionCompleted }.count
    }

    // Perfect week calculation - improved version
    func perfectWeekDays(alarms: [Alarm]) -> Int {
        let calendar = Calendar.current
        let sevenDaysAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        let recentWakeUps = wakeUpRecords.filter { $0.date >= sevenDaysAgo }

        // Count days where user woke up on time AND completed mission
        var perfectDays = 0
        for wakeUp in recentWakeUps {
            // Get the day of week for this wake up
            let weekday = calendar.component(.weekday, from: wakeUp.date)

            // Check if any alarm was scheduled for this day
            let wasScheduled = alarms.contains { alarm in
                alarm.isEnabled && alarm.selectedDays.contains(where: { $0.rawValue == weekday })
            }

            // Only count if alarm was scheduled, wake up was on time, and mission completed
            if wasScheduled && wakeUp.missionCompleted {
                let timeDiff = abs(wakeUp.wakeUpTime.timeIntervalSince(wakeUp.alarmTime))
                if timeDiff <= 15 * 60 { // 15 minutes tolerance
                    perfectDays += 1
                }
            }
        }
        return perfectDays
    }

    // Calculate total scheduled days in the past week
    func scheduledDaysInWeek(alarms: [Alarm]) -> Int {
        let calendar = Calendar.current
        var scheduledCount = 0

        // Check each of the last 7 days
        for dayOffset in 0..<7 {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: Date()) else { continue }
            let weekday = calendar.component(.weekday, from: date)

            // Check if any enabled alarm was scheduled for this day
            let wasScheduled = alarms.contains { alarm in
                alarm.isEnabled && alarm.selectedDays.contains(where: { $0.rawValue == weekday })
            }

            if wasScheduled {
                scheduledCount += 1
            }
        }
        return scheduledCount
    }

    // Perfect week percentage
    func perfectWeekPercentage(alarms: [Alarm]) -> Double {
        let scheduled = scheduledDaysInWeek(alarms: alarms)
        guard scheduled > 0 else { return 0 }

        let perfect = perfectWeekDays(alarms: alarms)
        return Double(perfect) / Double(scheduled) * 100
    }
}

@MainActor
class InsightsManager: ObservableObject {
    static let shared = InsightsManager()

    @Published var insightsData: InsightsData

    private let userDefaults = UserDefaults.standard
    private let insightsKey = "insightsData"

    init() {
        if let data = userDefaults.data(forKey: insightsKey),
           let decoded = try? JSONDecoder().decode(InsightsData.self, from: data) {
            insightsData = decoded
        } else {
            insightsData = InsightsData()
        }
    }

    func saveInsights() {
        if let encoded = try? JSONEncoder().encode(insightsData) {
            userDefaults.set(encoded, forKey: insightsKey)
        }
    }

    func logWakeUp(
        alarm: Alarm,
        wakeUpTime: Date,
        missionCompleted: Bool
    ) {
        let record = WakeUpRecord(
            alarmTime: alarm.time,
            wakeUpTime: wakeUpTime,
            missionCompleted: missionCompleted,
            missionType: alarm.mission?.name,
            difficulty: alarm.difficulty.rawValue,
            soundUsed: alarm.sound
        )

        insightsData.addWakeUpRecord(record)
        saveInsights()
    }
}
