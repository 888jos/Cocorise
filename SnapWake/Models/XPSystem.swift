//
//  XPSystem.swift
//  SnapWake
//
//  XP and Level progression system
//

import Foundation
import SwiftUI

// MARK: - XP Configuration

enum MissionXP {
    static let pushups = 25
    static let squats = 20
    static let skyPhoto = 15
    static let makeBed = 15
    static let shake = 10
    static let math = 20
    static let objectHunt = 15
    static let bibleVerse = 15
    static let affirmation = 10
}

// MARK: - Level System

struct Level {
    let number: Int
    let name: String
    let xpRequired: Int

    static let levels: [Level] = [
        Level(number: 1, name: "Sleeper", xpRequired: 0),
        Level(number: 2, name: "Waker", xpRequired: 100),
        Level(number: 3, name: "Early Riser", xpRequired: 300),
        Level(number: 4, name: "Dawn Warrior", xpRequired: 600),
        Level(number: 5, name: "Morning Legend", xpRequired: 1000),
        Level(number: 6, name: "Sunrise Champion", xpRequired: 1500),
        Level(number: 7, name: "Day Conqueror", xpRequired: 2200),
        Level(number: 8, name: "Elite Riser", xpRequired: 3000),
        Level(number: 9, name: "Master of Dawn", xpRequired: 4000),
        Level(number: 10, name: "Legendary", xpRequired: 5500)
    ]

    static func level(for xp: Int) -> Level {
        return levels.last(where: { xp >= $0.xpRequired }) ?? levels[0]
    }

    static func nextLevel(for currentLevel: Level) -> Level? {
        guard let index = levels.firstIndex(where: { $0.number == currentLevel.number }),
              index + 1 < levels.count else {
            return nil
        }
        return levels[index + 1]
    }

    static func progress(for xp: Int) -> (current: Int, needed: Int, percentage: Double) {
        let currentLevel = level(for: xp)

        guard let nextLevel = nextLevel(for: currentLevel) else {
            // Max level reached
            return (xp, xp, 1.0)
        }

        let xpInCurrentLevel = xp - currentLevel.xpRequired
        let xpNeededForNext = nextLevel.xpRequired - currentLevel.xpRequired
        let percentage = Double(xpInCurrentLevel) / Double(xpNeededForNext)

        return (xpInCurrentLevel, xpNeededForNext, percentage)
    }
}

// MARK: - User XP Data

struct UserXPData: Codable {
    var totalXP: Int
    var weeklyXP: Int
    var lastResetDate: Date

    init(totalXP: Int = 0, weeklyXP: Int = 0, lastResetDate: Date = Date()) {
        self.totalXP = totalXP
        self.weeklyXP = weeklyXP
        self.lastResetDate = lastResetDate
    }

    var currentLevel: Level {
        Level.level(for: totalXP)
    }

    mutating func addXP(_ amount: Int) {
        totalXP += amount
        weeklyXP += amount
    }

    mutating func resetWeeklyXP() {
        weeklyXP = 0
        lastResetDate = Date()
    }

    func shouldResetWeekly() -> Bool {
        let calendar = Calendar.current
        let now = Date()

        // Check if it's Monday and we haven't reset this week
        guard calendar.component(.weekday, from: now) == 2 else { // 2 = Monday
            return false
        }

        // Check if last reset was before this Monday
        let startOfWeek = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)
        let thisMonday = calendar.date(from: startOfWeek) ?? now

        return lastResetDate < thisMonday
    }
}

// MARK: - XP Manager

class XPManager: ObservableObject {
    static let shared = XPManager()

    @Published var xpData: UserXPData {
        didSet {
            saveXPData()
        }
    }

    private init() {
        if let data = UserDefaults.standard.data(forKey: "userXPData"),
           let decoded = try? JSONDecoder().decode(UserXPData.self, from: data) {
            self.xpData = decoded
        } else {
            self.xpData = UserXPData()
        }

        // Check if we need to reset weekly XP
        checkWeeklyReset()
    }

    private func saveXPData() {
        if let encoded = try? JSONEncoder().encode(xpData) {
            UserDefaults.standard.set(encoded, forKey: "userXPData")
        }
    }

    func checkWeeklyReset() {
        if xpData.shouldResetWeekly() {
            xpData.resetWeeklyXP()
        }
    }

    func awardXP(for missionType: MissionType) {
        let xp: Int
        switch missionType {
        case .exercise:
            xp = MissionXP.pushups // Could differentiate push-ups vs squats
        case .photo:
            xp = MissionXP.skyPhoto
        case .shake:
            xp = MissionXP.shake
        case .math:
            xp = MissionXP.math
        case .text:
            xp = MissionXP.affirmation // Generic for text missions
        case .none, .random:
            xp = 0
        }

        if xp > 0 {
            xpData.addXP(xp)
        }
    }

    func awardBonusXP(_ amount: Int, reason: String) {
        xpData.addXP(amount)
        // Could log the reason for analytics
    }
}
