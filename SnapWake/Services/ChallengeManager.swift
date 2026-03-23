//
//  ChallengeManager.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import Foundation
import Combine

class ChallengeManager: ObservableObject {
    static let shared = ChallengeManager()

    @Published var isShowingChallenge = false
    @Published var currentMission: Mission?
    @Published var currentDifficulty: Difficulty = .easy
    @Published var challengeCompleted = false

    private var completionHandler: ((Bool) -> Void)?

    private init() {}

    func startChallenge(mission: Mission, difficulty: Difficulty, completion: @escaping (Bool) -> Void) {
        self.currentMission = mission
        self.currentDifficulty = difficulty
        self.completionHandler = completion
        self.challengeCompleted = false
        self.isShowingChallenge = true
    }

    func completeChallenge(success: Bool) {
        challengeCompleted = success
        isShowingChallenge = false
        completionHandler?(success)
        completionHandler = nil
    }

    func cancelChallenge() {
        isShowingChallenge = false
        completionHandler?(false)
        completionHandler = nil
    }

    func getRandomMission(excluding: Mission? = nil) -> Mission {
        var availableMissions = MissionsLibrary.shared.missions.filter { !$0.isNoMission && $0.type != .random }
        if let excluding = excluding {
            availableMissions = availableMissions.filter { $0.id != excluding.id }
        }
        return availableMissions.randomElement() ?? availableMissions[0]
    }
}
