//
//  OptimizedSyncManager.swift
//  SnapWake
//
//  Gère la synchronisation optimisée avec Firebase
//  Minimise les writes en groupant les updates
//

import Foundation
import Combine

@MainActor
class OptimizedSyncManager: ObservableObject {
    static let shared = OptimizedSyncManager()

    private let firebaseService = OptimizedFirebaseService.shared
    private var cancellables = Set<AnyCancellable>()

    // Auto-sync scheduler
    private var autoSyncTimer: Timer?
    private var needsSync = false

    private init() {
        // Auto-sync toutes les 10 minutes si besoin
        startAutoSync()
    }

    // MARK: - 🔄 SYNC OPTIMISÉ

    /// Marque qu'un sync est nécessaire mais ne sync pas immédiatement
    func markNeedsSync() {
        needsSync = true
        print("📝 Marked for sync (will sync later)")
    }

    /// Force un sync immédiat (utilisé uniquement pour événements importants)
    func syncNow() async {
        let streakData = StreakManager.shared.streakData
        let insightsData = InsightsManager.shared.insightsData

        // Temporarily disabled until Firestore is added
        /*
        do {
            try await firebaseService.syncAllUserData(
                streakData: streakData,
                insightsData: insightsData
            )
            needsSync = false
            print("✅ Synced to Firebase (1 write)")
        } catch {
            print("❌ Sync error: \(error.localizedDescription)")
        }
        */
        needsSync = false
        print("⚠️ Sync skipped - Firestore not configured")
    }

    /// Sync avec debouncing (attend avant de sync)
    func syncDebounced() {
        let streakData = StreakManager.shared.streakData
        let insightsData = InsightsManager.shared.insightsData

        // Temporarily disabled until Firestore is added
        /*
        firebaseService.scheduleDebouncedSync(
            streakData: streakData,
            insightsData: insightsData
        )
        */
        print("⚠️ Debounced sync skipped - Firestore not configured")
    }

    // MARK: - 📥 FETCH FROM FIREBASE

    func fetchAllData() async {
        // Temporarily disabled until Firestore is added
        /*
        do {
            let (streak, insights) = try await firebaseService.fetchUserData()

            if let streak = streak {
                StreakManager.shared.streakData = streak
                StreakManager.shared.saveStreak()
                print("✅ Loaded streak from Firebase")
            }

            // Insights restent principalement en local (UserDefaults)
            // On ne sync que le summary vers Firebase

        } catch {
            print("❌ Fetch error: \(error.localizedDescription)")
        }
        */
        print("⚠️ Fetch skipped - Firestore not configured")
    }

    // MARK: - ⏰ AUTO-SYNC

    private func startAutoSync() {
        // Auto-sync toutes les 10 minutes si changements détectés
        autoSyncTimer = Timer.scheduledTimer(withTimeInterval: 600, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self = self, self.needsSync else { return }
                await self.syncNow()
            }
        }
    }

    // MARK: - 🧹 CLEANUP

    func stopAutoSync() {
        autoSyncTimer?.invalidate()
        autoSyncTimer = nil
    }

    // deinit - timer will be cleaned up automatically
}

// MARK: - Extensions pour intégration facile

extension StreakManager {
    func logWakeUpOptimized() {
        streakData.logWakeUp()
        saveStreak()

        // Marquer pour sync mais ne pas sync immédiatement
        OptimizedSyncManager.shared.markNeedsSync()

        // Badge checks...
        let badgeManager = BadgeManager.shared
        let insightsManager = InsightsManager.shared
        let perfectDays = insightsManager.insightsData.perfectWeekDays(alarms: AlarmManager.shared.alarms)

        badgeManager.checkAndUnlockBadges(
            streak: streakData.currentStreak,
            totalMissions: streakData.weeklyWakeUps.count,
            perfectWeekDays: perfectDays,
            impossibleCompleted: insightsManager.insightsData.impossibleMissionsCompleted
        )

        badgeManager.checkWeekendBadge(date: Date())

        // Sync après 5 secondes (debounced)
        OptimizedSyncManager.shared.syncDebounced()
    }
}

extension InsightsManager {
    func logWakeUpOptimized(
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

        // Marquer pour sync (sera fait en batch)
        OptimizedSyncManager.shared.markNeedsSync()
    }
}
