//
//  StreakData.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import Foundation

struct StreakData: Codable {
    var currentStreak: Int
    var longestStreak: Int
    var lastWakeUpDate: Date?
    var weeklyWakeUps: [Date] // Les 7 derniers jours

    init() {
        self.currentStreak = 0
        self.longestStreak = 0
        self.lastWakeUpDate = nil
        self.weeklyWakeUps = []
    }

    mutating func logWakeUp(on date: Date = Date()) {
        // Vérifier si c'est un nouveau jour
        let calendar = Calendar.current

        if let lastDate = lastWakeUpDate {
            let daysBetween = calendar.dateComponents([.day], from: lastDate, to: date).day ?? 0

            if daysBetween == 1 {
                // Jour consécutif
                currentStreak += 1
            } else if daysBetween > 1 {
                // Streak cassé
                currentStreak = 1
            }
            // Si daysBetween == 0, c'est le même jour, on ne change rien
        } else {
            // Premier wake up
            currentStreak = 1
        }

        // Mettre à jour le longest streak
        if currentStreak > longestStreak {
            longestStreak = currentStreak
        }

        lastWakeUpDate = date

        // Ajouter à l'historique hebdomadaire
        weeklyWakeUps.append(date)

        // Garder seulement les 30 derniers jours
        let thirtyDaysAgo = calendar.date(byAdding: .day, value: -30, to: Date()) ?? Date()
        weeklyWakeUps = weeklyWakeUps.filter { $0 >= thirtyDaysAgo }
    }

    func hasWakeUp(on date: Date) -> Bool {
        let calendar = Calendar.current
        return weeklyWakeUps.contains { wakeUp in
            calendar.isDate(wakeUp, inSameDayAs: date)
        }
    }
}

@MainActor
class StreakManager: ObservableObject {
    static let shared = StreakManager()

    @Published var streakData: StreakData

    private let userDefaults = UserDefaults.standard
    private let streakKey = "streakData"

    init() {
        if let data = userDefaults.data(forKey: streakKey),
           let decoded = try? JSONDecoder().decode(StreakData.self, from: data) {
            streakData = decoded
        } else {
            streakData = StreakData()
        }
    }

    func saveStreak() {
        if let encoded = try? JSONEncoder().encode(streakData) {
            userDefaults.set(encoded, forKey: streakKey)
        }
    }

    func logWakeUp() {
        let wasFirstWakeUp = streakData.currentStreak == 0
        let previousStreak = streakData.currentStreak

        streakData.logWakeUp()
        saveStreak()

        // Sync to Firebase (disabled until Firestore is added)
        // Task {
        //     try? await OptimizedFirebaseService.shared.syncAllUserData(streakData: streakData, insightsData: InsightsData())
        //     try? await OptimizedFirebaseService.shared.updateLeaderboard()
        // }

        // Check and unlock badges
        let badgeManager = BadgeManager.shared
        let insightsManager = InsightsManager.shared

        // Calculate perfect week days
        let perfectDays = insightsManager.insightsData.perfectWeekDays(alarms: AlarmManager.shared.alarms)

        badgeManager.checkAndUnlockBadges(
            streak: streakData.currentStreak,
            totalMissions: streakData.weeklyWakeUps.count,
            perfectWeekDays: perfectDays,
            impossibleCompleted: insightsManager.insightsData.impossibleMissionsCompleted
        )

        // Check weekend badge
        badgeManager.checkWeekendBadge(date: Date())
    }

    func syncFromFirebase() async {
        // Disabled until Firestore is added
        print("⚠️ Firebase sync disabled - add FirebaseFirestore to enable")
        // do {
        //     if let (firebaseStreak, _) = try await OptimizedFirebaseService.shared.fetchUserData(),
        //        let streak = firebaseStreak {
        //         streakData = streak
        //         saveStreak()
        //     }
        // } catch {
        //     print("Error syncing streak from Firebase: \(error.localizedDescription)")
        // }
    }
}
