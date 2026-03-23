//
//  SocialManager.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import Foundation
import FirebaseAuth

@MainActor
class SocialManager: ObservableObject {
    static let shared = SocialManager()

    @Published var friends: [Friend] = []
    @Published var friendRequests: [FriendRequest] = []
    @Published var revengeAlarms: [RevengeAlarm] = []
    @Published var duoAlarms: [DuoAlarm] = []
    @Published var leaderboard: [LeaderboardEntry] = []

    private let firebaseService = OptimizedFirebaseService.shared

    private init() {
        Task {
            await loadSocialData()
        }
    }

    // MARK: - Load Data

    func loadSocialData() async {
        // Temporarily disabled until Firestore is added
        /*
        do {
            friends = try await firebaseService.fetchFriends()
            friendRequests = try await firebaseService.fetchFriendRequests()
            revengeAlarms = try await firebaseService.fetchRevengeAlarms()
            duoAlarms = try await firebaseService.fetchDuoAlarms()
            leaderboard = try await firebaseService.fetchLeaderboard()
        } catch {
            print("Error loading social data: \(error.localizedDescription)")
        }
        */
    }

    // MARK: - Friends

    func sendFriendRequest(toEmail: String) async throws {
        // Temporarily disabled until Firestore is added
        // try await firebaseService.sendFriendRequest(toEmail: toEmail)
        // await loadSocialData()
    }

    func acceptFriendRequest(_ request: FriendRequest) async throws {
        // Temporarily disabled until Firestore is added
        // try await firebaseService.acceptFriendRequest(request)
        // await loadSocialData()
    }

    func rejectFriendRequest(_ request: FriendRequest) async throws {
        // Update in Firebase (you can implement this similarly to accept)
        await loadSocialData()
    }

    // MARK: - Revenge Alarms

    func sendRevengeAlarm(to friend: Friend, time: Date, difficulty: Difficulty, missionId: UUID?) async throws {
        guard let currentUserId = Auth.auth().currentUser?.uid,
              let currentUserName = Auth.auth().currentUser?.displayName else {
            throw NSError(domain: "SocialManager", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }

        let revengeAlarm = RevengeAlarm(
            senderId: currentUserId,
            senderName: currentUserName,
            targetUserId: friend.id,
            time: time,
            message: "⏰ Wake up! \(currentUserName) sent you a revenge alarm!",
            difficulty: difficulty,
            missionId: missionId
        )

        // Temporarily disabled until Firestore is added
        // try await firebaseService.sendRevengeAlarm(revengeAlarm)
        // await loadSocialData()
    }

    func completeRevengeAlarm(_ alarm: RevengeAlarm) async throws {
        // Temporarily disabled until Firestore is added
        // Method completeRevengeAlarm needs to be implemented in OptimizedFirebaseService
        // await loadSocialData()
    }

    // MARK: - Duo Alarms

    func createDuoAlarm(
        with friend: Friend,
        time: Date,
        selectedDays: Set<Weekday>,
        difficulty: Difficulty,
        sound: String,
        missionId: UUID?
    ) async throws {
        guard let currentUserId = Auth.auth().currentUser?.uid,
              let currentUserName = Auth.auth().currentUser?.displayName else {
            throw NSError(domain: "SocialManager", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }

        let duoAlarm = DuoAlarm(
            hostUserId: currentUserId,
            hostName: currentUserName,
            partnerUserId: friend.id,
            partnerName: friend.displayName,
            time: time,
            selectedDays: selectedDays,
            difficulty: difficulty,
            sound: sound,
            missionId: missionId
        )

        // Temporarily disabled until Firestore is added
        // try await firebaseService.createDuoAlarm(duoAlarm)
        // await loadSocialData()
    }

    func completeDuoAlarm(_ alarm: DuoAlarm) async throws {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        // Temporarily disabled until Firestore is added
        // Method updateDuoAlarmCompletion needs to be implemented in OptimizedFirebaseService
        // await loadSocialData()
    }

    func toggleDuoAlarm(_ alarm: DuoAlarm) {
        // Update local state and sync to Firebase
        // Implementation similar to AlarmManager.toggleAlarm
    }

    // MARK: - Leaderboard

    func updateLeaderboard() async throws {
        // Temporarily disabled until Firestore is added
        // Method updateLeaderboard needs to be implemented in OptimizedFirebaseService
        // leaderboard = try await firebaseService.fetchLeaderboard()
    }

    func refreshLeaderboard() async {
        // Temporarily disabled until Firestore is added
        /*
        do {
            leaderboard = try await firebaseService.fetchLeaderboard()
        } catch {
            print("Error refreshing leaderboard: \(error.localizedDescription)")
        }
        */
    }
}
