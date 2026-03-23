//
//  Difficulty.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import Foundation

enum Difficulty: String, Codable, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    case impossible = "Impossible"

    var timeLimit: TimeInterval {
        switch self {
        case .easy: return 300 // 5 minutes
        case .medium: return 180 // 3 minutes
        case .hard: return 120 // 2 minutes
        case .impossible: return 60 // 1 minute
        }
    }

    var icon: String {
        switch self {
        case .easy: return "😴"
        case .medium: return "🌅"
        case .hard: return "🔥"
        case .impossible: return "💀"
        }
    }
}
