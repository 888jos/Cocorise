//
//  BadgeManager.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import Foundation
import SwiftUI
import UIKit

@MainActor
class BadgeManager: ObservableObject {
    static let shared = BadgeManager()

    @Published var unlockedBadges: Set<String> = []
    @Published var newlyUnlockedBadge: Badge?

    private let userDefaults = UserDefaults.standard
    private let badgesKey = "unlockedBadges"

    private init() {
        loadBadges()
    }

    // MARK: - Load/Save

    func loadBadges() {
        if let data = userDefaults.data(forKey: badgesKey),
           let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) {
            unlockedBadges = decoded
        }
    }

    func saveBadges() {
        if let encoded = try? JSONEncoder().encode(unlockedBadges) {
            userDefaults.set(encoded, forKey: badgesKey)
        }
    }

    // MARK: - Badge Management

    func unlockBadge(_ badgeId: String) {
        guard !unlockedBadges.contains(badgeId) else { return }

        unlockedBadges.insert(badgeId)
        saveBadges()

        // Trigger haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)

        // Trigger notification for newly unlocked badge
        if let badge = BadgesLibrary.shared.badge(withId: badgeId) {
            newlyUnlockedBadge = badge

            // Auto-dismiss after 4 seconds (increased from 3)
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                if self.newlyUnlockedBadge?.id == badgeId {
                    self.newlyUnlockedBadge = nil
                }
            }
        }
    }

    func isBadgeUnlocked(_ badgeId: String) -> Bool {
        unlockedBadges.contains(badgeId)
    }

    func getBadgesForCategory(_ category: BadgeCategory) -> [Badge] {
        BadgesLibrary.shared.allBadges
            .filter { $0.category == category }
            .map { badge in
                var updatedBadge = badge
                updatedBadge.isUnlocked = isBadgeUnlocked(badge.id)
                return updatedBadge
            }
    }

    func getAllBadges() -> [Badge] {
        BadgesLibrary.shared.allBadges.map { badge in
            var updatedBadge = badge
            updatedBadge.isUnlocked = isBadgeUnlocked(badge.id)
            return updatedBadge
        }
    }

    var unlockedCount: Int {
        unlockedBadges.count
    }

    var totalBadges: Int {
        BadgesLibrary.shared.allBadges.count
    }

    // MARK: - Check Badges

    func checkAndUnlockBadges(streak: Int, totalMissions: Int, perfectWeekDays: Int, impossibleCompleted: Int = 0) {
        // Streak badges
        if streak >= 3 { unlockBadge("streak_3") }
        if streak >= 7 { unlockBadge("streak_7") }
        if streak >= 14 { unlockBadge("streak_14") }
        if streak >= 30 { unlockBadge("streak_30") }
        if streak >= 100 { unlockBadge("streak_100") }

        // Mission badges
        if totalMissions >= 1 { unlockBadge("first_wake") }
        if totalMissions >= 10 { unlockBadge("missions_10") }
        if totalMissions >= 50 { unlockBadge("missions_50") }
        if totalMissions >= 100 { unlockBadge("missions_100") }

        // Perfect week
        if perfectWeekDays >= 7 { unlockBadge("perfect_week") }

        // Impossible master
        if impossibleCompleted >= 10 { unlockBadge("impossible_master") }
    }

    func checkWeekendBadge(date: Date) {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)

        // 1 = Sunday, 7 = Saturday
        if weekday == 1 || weekday == 7 {
            unlockBadge("weekend_warrior")
        }
    }
}
