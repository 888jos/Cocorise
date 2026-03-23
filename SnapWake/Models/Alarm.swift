//
//  Alarm.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import Foundation

struct Alarm: Codable, Identifiable {
    let id: UUID
    var name: String
    var time: Date
    var isEnabled: Bool
    var selectedDays: Set<Weekday>
    var difficulty: Difficulty
    var sound: String
    var missionId: UUID?
    var currentChallenge: ChallengeObject?

    init(
        id: UUID = UUID(),
        name: String = "First Alarm",
        time: Date = Date(),
        isEnabled: Bool = true,
        selectedDays: Set<Weekday> = [.monday, .tuesday, .wednesday, .thursday, .friday],
        difficulty: Difficulty = .easy,
        sound: String = "Default",
        missionId: UUID? = nil
    ) {
        self.id = id
        self.name = name
        self.time = time
        self.isEnabled = isEnabled
        self.selectedDays = selectedDays
        self.difficulty = difficulty
        self.sound = sound
        self.missionId = missionId
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
}

enum Weekday: Int, Codable, CaseIterable, Comparable {
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7

    var shortName: String {
        switch self {
        case .sunday: return "Sun"
        case .monday: return "Mon"
        case .tuesday: return "Tue"
        case .wednesday: return "Wed"
        case .thursday: return "Thu"
        case .friday: return "Fri"
        case .saturday: return "Sat"
        }
    }

    static func < (lhs: Weekday, rhs: Weekday) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
