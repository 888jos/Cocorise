//
//  AlarmSound.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import Foundation
import SwiftUI

struct AlarmSound: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let fileName: String
    let color: String
    let category: SoundCategory

    init(name: String, fileName: String, color: String, category: SoundCategory) {
        self.id = UUID()
        self.name = name
        self.fileName = fileName
        self.color = color
        self.category = category
    }

    var displayColor: Color {
        switch color {
        case "gray": return .gray
        case "darkGray": return Color(white: 0.3)
        case "green": return .green
        case "purple": return .purple
        case "teal": return .teal
        case "orange": return .orange
        case "red": return .red
        case "blue": return .blue
        case "yellow": return .yellow
        default: return .gray
        }
    }
}

enum SoundCategory: String, CaseIterable, Codable {
    case classic = "Classic"
    case viral = "Viral"
    case aggressive = "Aggressive"
    case peaceful = "Peaceful"

    var icon: String {
        switch self {
        case .classic: return "bell"
        case .viral: return "flame"
        case .aggressive: return "bolt"
        case .peaceful: return "figure.meditation"
        }
    }
}

class SoundsLibrary {
    static let shared = SoundsLibrary()

    let sounds: [AlarmSound] = [
        // Classic
        AlarmSound(name: "Default", fileName: "default", color: "gray", category: .classic),
        AlarmSound(name: "Alarm Clock", fileName: "alarm-clock", color: "darkGray", category: .classic),
        AlarmSound(name: "Reveille", fileName: "reveille", color: "green", category: .classic),
        AlarmSound(name: "Sparkles", fileName: "sparkles", color: "purple", category: .classic),

        // Viral
        AlarmSound(name: "Mindful Earth", fileName: "mindful-earth", color: "teal", category: .viral),
        AlarmSound(name: "Dialed", fileName: "dialed", color: "orange", category: .viral),
        AlarmSound(name: "Rise And Shine", fileName: "rise-and-shine", color: "yellow", category: .viral),

        // Aggressive
        AlarmSound(name: "Air Raid", fileName: "air-raid", color: "red", category: .aggressive),
        AlarmSound(name: "Rooster", fileName: "rooster", color: "orange", category: .aggressive),
        AlarmSound(name: "Pop Star", fileName: "pop-star", color: "blue", category: .aggressive),

        // Peaceful
        AlarmSound(name: "Sunray", fileName: "sunray", color: "yellow", category: .peaceful),
        AlarmSound(name: "Jolly Day", fileName: "jolly-day", color: "orange", category: .peaceful),
        AlarmSound(name: "London Town", fileName: "london-town", color: "purple", category: .peaceful)
    ]

    func sound(named: String) -> AlarmSound? {
        sounds.first { $0.name == named }
    }

    func sounds(for category: SoundCategory) -> [AlarmSound] {
        sounds.filter { $0.category == category }
    }
}
