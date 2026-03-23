//
//  Badge.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import SwiftUI

enum BadgeCategory: String, Codable, CaseIterable {
    case streak = "Streak"
    case missions = "Missions"
    case consistency = "Consistency"
    case special = "Special"
}

struct Badge: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let description: String
    let icon: String
    let category: BadgeCategory
    let requirement: Int
    let gradient: [String] // Couleurs en hex pour le gradient

    var isUnlocked: Bool = false
    var unlockedDate: Date?

    var gradientColors: [Color] {
        gradient.compactMap { hex in
            // Convertir manuellement pour éviter conflit avec extension existante
            var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

            var rgb: UInt64 = 0
            guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

            let r = Double((rgb & 0xFF0000) >> 16) / 255.0
            let g = Double((rgb & 0x00FF00) >> 8) / 255.0
            let b = Double(rgb & 0x0000FF) / 255.0

            return Color(red: r, green: g, blue: b)
        }
    }
}

// Bibliothèque de badges
class BadgesLibrary {
    static let shared = BadgesLibrary()

    let allBadges: [Badge] = [
        // Streak Badges
        Badge(
            id: "streak_3",
            name: "Getting Started",
            description: "Complete a 3-day streak",
            icon: "flame",
            category: .streak,
            requirement: 3,
            gradient: ["#FF6B35", "#F7931E"]
        ),
        Badge(
            id: "streak_7",
            name: "Week Warrior",
            description: "Complete a 7-day streak",
            icon: "flame.fill",
            category: .streak,
            requirement: 7,
            gradient: ["#FF6B35", "#FF4500"]
        ),
        Badge(
            id: "streak_14",
            name: "Fortnight Fighter",
            description: "Complete a 14-day streak",
            icon: "flame.circle.fill",
            category: .streak,
            requirement: 14,
            gradient: ["#FF4500", "#DC143C"]
        ),
        Badge(
            id: "streak_30",
            name: "Monthly Master",
            description: "Complete a 30-day streak",
            icon: "crown.fill",
            category: .streak,
            requirement: 30,
            gradient: ["#FFD700", "#FFA500"]
        ),
        Badge(
            id: "streak_100",
            name: "Century Club",
            description: "Complete a 100-day streak",
            icon: "trophy.fill",
            category: .streak,
            requirement: 100,
            gradient: ["#FFD700", "#FF8C00"]
        ),

        // Mission Badges
        Badge(
            id: "missions_10",
            name: "Mission Rookie",
            description: "Complete 10 missions",
            icon: "star",
            category: .missions,
            requirement: 10,
            gradient: ["#4ECDC4", "#44A08D"]
        ),
        Badge(
            id: "missions_50",
            name: "Mission Expert",
            description: "Complete 50 missions",
            icon: "star.fill",
            category: .missions,
            requirement: 50,
            gradient: ["#4ECDC4", "#2E8B57"]
        ),
        Badge(
            id: "missions_100",
            name: "Mission Legend",
            description: "Complete 100 missions",
            icon: "star.circle.fill",
            category: .missions,
            requirement: 100,
            gradient: ["#00CED1", "#008B8B"]
        ),

        // Consistency Badges
        Badge(
            id: "consistency_5",
            name: "Early Bird",
            description: "Wake up at the same time 5 days in a row",
            icon: "sunrise.fill",
            category: .consistency,
            requirement: 5,
            gradient: ["#FF9A56", "#FF6B6B"]
        ),
        Badge(
            id: "consistency_14",
            name: "Time Master",
            description: "Wake up within 15 minutes for 14 days",
            icon: "clock.fill",
            category: .consistency,
            requirement: 14,
            gradient: ["#667EEA", "#764BA2"]
        ),

        // Special Badges
        Badge(
            id: "first_wake",
            name: "First Steps",
            description: "Complete your first wake up",
            icon: "sunrise",
            category: .special,
            requirement: 1,
            gradient: ["#FDB99B", "#CF8BF3"]
        ),
        Badge(
            id: "weekend_warrior",
            name: "Weekend Warrior",
            description: "Wake up on time on a Saturday or Sunday",
            icon: "moon.stars.fill",
            category: .special,
            requirement: 1,
            gradient: ["#667EEA", "#764BA2"]
        ),
        Badge(
            id: "perfect_week",
            name: "Perfect Week",
            description: "Complete all alarms for 7 consecutive days",
            icon: "checkmark.seal.fill",
            category: .special,
            requirement: 7,
            gradient: ["#56CCF2", "#2F80ED"]
        ),
        Badge(
            id: "impossible_master",
            name: "Impossible Master",
            description: "Complete 10 impossible difficulty missions",
            icon: "bolt.fill",
            category: .special,
            requirement: 10,
            gradient: ["#F093FB", "#F5576C"]
        )
    ]

    func badge(withId id: String) -> Badge? {
        allBadges.first { $0.id == id }
    }
}
