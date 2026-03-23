//
//  League.swift
//  SnapWake
//
//  League and leaderboard system
//

import Foundation

// MARK: - League Model

struct League: Identifiable, Codable {
    var id: String?
    var name: String
    var inviteCode: String
    var createdBy: String // User ID
    var createdAt: Date
    var memberIDs: [String]
    var weekStartDate: Date

    init(name: String, inviteCode: String, createdBy: String, memberIDs: [String] = []) {
        self.name = name
        self.inviteCode = inviteCode
        self.createdBy = createdBy
        self.createdAt = Date()
        self.memberIDs = memberIDs
        self.weekStartDate = Date().startOfWeek()
    }

    var isFull: Bool {
        return memberIDs.count >= 8
    }

    var canAddMember: Bool {
        return memberIDs.count < 8
    }
}

// MARK: - League Member

struct LeagueMember: Identifiable, Codable {
    var id: String // User ID
    var name: String
    var weeklyXP: Int
    var currentStreak: Int
    var avatarEmoji: String

    init(id: String, name: String, weeklyXP: Int = 0, currentStreak: Int = 0, avatarEmoji: String = "👤") {
        self.id = id
        self.name = name
        self.weeklyXP = weeklyXP
        self.currentStreak = currentStreak
        self.avatarEmoji = avatarEmoji
    }
}

// MARK: - User Profile

struct UserProfile: Identifiable, Codable {
    var id: String?
    var name: String
    var email: String?
    var totalXP: Int
    var weeklyXP: Int
    var currentStreak: Int
    var avatarEmoji: String
    var referralCode: String
    var referredBy: String?
    var referralCount: Int
    var leagueID: String?
    var createdAt: Date

    init(name: String, email: String? = nil, referralCode: String, referredBy: String? = nil) {
        self.name = name
        self.email = email
        self.totalXP = 0
        self.weeklyXP = 0
        self.currentStreak = 0
        self.avatarEmoji = ["🐔", "🦅", "🦉", "🐓", "🦆"].randomElement() ?? "🐔"
        self.referralCode = referralCode
        self.referredBy = referredBy
        self.referralCount = 0
        self.leagueID = nil
        self.createdAt = Date()
    }
}

// MARK: - Date Extension

extension Date {
    func startOfWeek() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components) ?? self
    }

    func isInCurrentWeek() -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }
}

// MARK: - Invite Code Generator

struct InviteCodeGenerator {
    static func generate() -> String {
        let characters = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789" // Avoid confusing characters
        return String((0..<6).compactMap{ _ in characters.randomElement() })
    }
}
