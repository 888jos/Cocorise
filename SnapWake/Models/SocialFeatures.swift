//
//  SocialFeatures.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import Foundation
// import FirebaseFirestore  // Temporarily disabled - add FirebaseFirestore package to enable

// MARK: - Friend System

struct Friend: Codable, Identifiable {
    let id: String // User ID
    var displayName: String
    var email: String?
    var currentStreak: Int
    var status: FriendStatus
    var addedDate: Date

    enum FriendStatus: String, Codable {
        case pending
        case accepted
        case blocked
    }
}

struct FriendRequest: Codable, Identifiable {
    let id: UUID
    let fromUserId: String
    let fromUserName: String
    let toUserId: String
    let sentDate: Date
    var status: RequestStatus

    enum RequestStatus: String, Codable {
        case pending
        case accepted
        case rejected
    }
}

// MARK: - Revenge Alarm

struct RevengeAlarm: Codable, Identifiable {
    let id: UUID
    let senderId: String
    let senderName: String
    let targetUserId: String
    let time: Date
    let message: String
    let difficulty: Difficulty
    let missionId: UUID?
    let createdDate: Date
    var isCompleted: Bool
    var completedDate: Date?

    init(
        id: UUID = UUID(),
        senderId: String,
        senderName: String,
        targetUserId: String,
        time: Date,
        message: String = "Wake up! Your friend sent you a revenge alarm!",
        difficulty: Difficulty = .hard,
        missionId: UUID? = nil
    ) {
        self.id = id
        self.senderId = senderId
        self.senderName = senderName
        self.targetUserId = targetUserId
        self.time = time
        self.message = message
        self.difficulty = difficulty
        self.missionId = missionId
        self.createdDate = Date()
        self.isCompleted = false
    }

    var mission: Mission? {
        guard let missionId = missionId else { return nil }
        return MissionsLibrary.shared.missions.first { $0.id == missionId }
    }
}

// MARK: - Duo Alarm

struct DuoAlarm: Codable, Identifiable {
    let id: UUID
    var hostUserId: String
    var hostName: String
    var partnerUserId: String
    var partnerName: String
    var time: Date
    var selectedDays: Set<Weekday>
    var difficulty: Difficulty
    var sound: String
    var missionId: UUID?
    var isEnabled: Bool
    var hostCompleted: Bool
    var partnerCompleted: Bool
    var createdDate: Date

    init(
        id: UUID = UUID(),
        hostUserId: String,
        hostName: String,
        partnerUserId: String,
        partnerName: String,
        time: Date,
        selectedDays: Set<Weekday> = [.monday, .tuesday, .wednesday, .thursday, .friday],
        difficulty: Difficulty = .medium,
        sound: String = "Default",
        missionId: UUID? = nil
    ) {
        self.id = id
        self.hostUserId = hostUserId
        self.hostName = hostName
        self.partnerUserId = partnerUserId
        self.partnerName = partnerName
        self.time = time
        self.selectedDays = selectedDays
        self.difficulty = difficulty
        self.sound = sound
        self.missionId = missionId
        self.isEnabled = true
        self.hostCompleted = false
        self.partnerCompleted = false
        self.createdDate = Date()
    }

    var mission: Mission? {
        guard let missionId = missionId else { return nil }
        return MissionsLibrary.shared.missions.first { $0.id == missionId }
    }

    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: time)
    }

    var daysDescription: String {
        if selectedDays.count == 7 {
            return "Every day"
        } else if selectedDays == [.monday, .tuesday, .wednesday, .thursday, .friday] {
            return "Weekdays"
        } else if selectedDays == [.saturday, .sunday] {
            return "Weekends"
        } else {
            return selectedDays.sorted().map { $0.shortName }.joined(separator: ", ")
        }
    }

    func isUserHost(_ userId: String) -> Bool {
        return hostUserId == userId
    }

    func partnerFor(_ userId: String) -> String {
        return userId == hostUserId ? partnerName : hostName
    }

    mutating func completeFor(userId: String) {
        if userId == hostUserId {
            hostCompleted = true
        } else if userId == partnerUserId {
            partnerCompleted = true
        }
    }

    mutating func resetCompletion() {
        hostCompleted = false
        partnerCompleted = false
    }

    var bothCompleted: Bool {
        return hostCompleted && partnerCompleted
    }
}

// MARK: - Leaderboard Entry

struct LeaderboardEntry: Codable, Identifiable {
    let id: String // User ID
    let displayName: String
    let currentStreak: Int
    let longestStreak: Int
    let totalMissions: Int
    let lastUpdated: Date
}
