//
//  LeagueManager.swift
//  SnapWake
//
//  Manager for leagues (Local storage for now, Firebase integration TODO)
//

import Foundation
import Combine

class LeagueManager: ObservableObject {
    static let shared = LeagueManager()

    @Published var currentLeague: League?
    @Published var leagueMembers: [LeagueMember] = []
    @Published var userProfile: UserProfile?

    private let defaults = UserDefaults.standard
    private let profilesKey = "userProfiles"
    private let leaguesKey = "leagues"

    private init() {
        loadUserProfile()
    }

    // MARK: - User Profile

    func loadUserProfile() {
        guard let userId = getCurrentUserId() else { return }

        if let profile = getProfile(userId) {
            DispatchQueue.main.async {
                self.userProfile = profile
                if let leagueID = profile.leagueID {
                    self.loadLeague(leagueID)
                }
            }
        }
    }

    func createUserProfile(name: String, email: String?, referredBy: String? = nil) {
        guard let userId = getCurrentUserId() else { return }

        let referralCode = InviteCodeGenerator.generate()
        var profile = UserProfile(name: name, email: email, referralCode: referralCode, referredBy: referredBy)

        // If referred, give bonus XP and start at level 3
        if referredBy != nil {
            profile.totalXP = 300 // Level 3
        }

        saveProfile(profile, for: userId)

        // Award referrer bonus
        if let referrerId = referredBy {
            awardReferralBonus(to: referrerId)
        }

        DispatchQueue.main.async {
            self.userProfile = profile
        }
    }

    func updateUserXP(_ xp: Int, weeklyXP: Int) {
        guard let userId = getCurrentUserId() else { return }

        if var profile = getProfile(userId) {
            profile.totalXP = xp
            profile.weeklyXP = weeklyXP
            saveProfile(profile, for: userId)

            DispatchQueue.main.async {
                self.userProfile = profile
            }
        }
    }

    private func awardReferralBonus(to userId: String) {
        if var profile = getProfile(userId) {
            profile.totalXP += 500
            profile.referralCount += 1
            saveProfile(profile, for: userId)
        }
    }

    // MARK: - League Operations

    func createLeague(name: String) async throws -> League {
        guard let userId = getCurrentUserId() else {
            throw NSError(domain: "LeagueManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user ID"])
        }

        let inviteCode = InviteCodeGenerator.generate()
        var league = League(name: name, inviteCode: inviteCode, createdBy: userId, memberIDs: [userId])
        let leagueId = UUID().uuidString
        league.id = leagueId

        // Save league
        saveLeague(league)

        // Update user's leagueID
        if var profile = getProfile(userId) {
            profile.leagueID = leagueId
            saveProfile(profile, for: userId)
        }

        DispatchQueue.main.async {
            self.currentLeague = league
            self.loadLeagueMembers(league.memberIDs)
        }

        return league
    }

    func joinLeague(inviteCode: String) async throws {
        guard let userId = getCurrentUserId() else {
            throw NSError(domain: "LeagueManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user ID"])
        }

        // Find league by invite code
        guard var league = findLeague(byInviteCode: inviteCode) else {
            throw NSError(domain: "LeagueManager", code: -2, userInfo: [NSLocalizedDescriptionKey: "League not found"])
        }

        guard league.canAddMember else {
            throw NSError(domain: "LeagueManager", code: -3, userInfo: [NSLocalizedDescriptionKey: "League is full"])
        }

        guard !league.memberIDs.contains(userId) else {
            throw NSError(domain: "LeagueManager", code: -4, userInfo: [NSLocalizedDescriptionKey: "Already in league"])
        }

        // Add user to league
        league.memberIDs.append(userId)
        saveLeague(league)

        // Update user's leagueID
        if var profile = getProfile(userId) {
            profile.leagueID = league.id
            saveProfile(profile, for: userId)
        }

        DispatchQueue.main.async {
            self.currentLeague = league
            self.loadLeagueMembers(league.memberIDs)
        }
    }

    func leaveLeague() async throws {
        guard let userId = getCurrentUserId(),
              let leagueId = currentLeague?.id,
              var league = getLeague(leagueId) else { return }

        // Remove user from league members
        league.memberIDs.removeAll { $0 == userId }
        saveLeague(league)

        // Clear user's leagueID
        if var profile = getProfile(userId) {
            profile.leagueID = nil
            saveProfile(profile, for: userId)
        }

        DispatchQueue.main.async {
            self.currentLeague = nil
            self.leagueMembers = []
        }
    }

    private func loadLeague(_ leagueId: String) {
        guard let league = getLeague(leagueId) else { return }

        DispatchQueue.main.async {
            self.currentLeague = league
            self.loadLeagueMembers(league.memberIDs)
        }
    }

    private func loadLeagueMembers(_ memberIDs: [String]) {
        guard !memberIDs.isEmpty else {
            self.leagueMembers = []
            return
        }

        // Fetch member profiles
        let members = memberIDs.compactMap { userId -> LeagueMember? in
            guard let profile = getProfile(userId) else { return nil }
            return LeagueMember(
                id: userId,
                name: profile.name,
                weeklyXP: profile.weeklyXP,
                currentStreak: profile.currentStreak,
                avatarEmoji: profile.avatarEmoji
            )
        }.sorted { $0.weeklyXP > $1.weeklyXP }

        DispatchQueue.main.async {
            self.leagueMembers = members
        }
    }

    // MARK: - Weekly Reset

    func checkWeeklyReset() {
        guard let league = currentLeague,
              !league.weekStartDate.isInCurrentWeek() else { return }

        // Reset weekly XP for all league members
        for memberId in league.memberIDs {
            if var profile = getProfile(memberId) {
                profile.weeklyXP = 0
                saveProfile(profile, for: memberId)
            }
        }

        // Update league week start date
        if var updatedLeague = currentLeague {
            updatedLeague.weekStartDate = Date().startOfWeek()
            saveLeague(updatedLeague)

            DispatchQueue.main.async {
                self.currentLeague = updatedLeague
            }
        }
    }

    // MARK: - Local Storage Helpers

    private func getProfile(_ userId: String) -> UserProfile? {
        guard let data = defaults.data(forKey: "\(profilesKey)_\(userId)"),
              let profile = try? JSONDecoder().decode(UserProfile.self, from: data) else {
            return nil
        }
        return profile
    }

    private func saveProfile(_ profile: UserProfile, for userId: String) {
        if let encoded = try? JSONEncoder().encode(profile) {
            defaults.set(encoded, forKey: "\(profilesKey)_\(userId)")
        }
    }

    private func getLeague(_ leagueId: String) -> League? {
        guard let data = defaults.data(forKey: "\(leaguesKey)_\(leagueId)"),
              let league = try? JSONDecoder().decode(League.self, from: data) else {
            return nil
        }
        return league
    }

    private func saveLeague(_ league: League) {
        guard let leagueId = league.id else { return }
        if let encoded = try? JSONEncoder().encode(league) {
            defaults.set(encoded, forKey: "\(leaguesKey)_\(leagueId)")
        }
    }

    private func findLeague(byInviteCode code: String) -> League? {
        // Get all league keys
        let allKeys = defaults.dictionaryRepresentation().keys
        let leagueKeys = allKeys.filter { $0.hasPrefix(leaguesKey) }

        for key in leagueKeys {
            if let data = defaults.data(forKey: key),
               let league = try? JSONDecoder().decode(League.self, from: data),
               league.inviteCode == code {
                return league
            }
        }
        return nil
    }

    // MARK: - Helpers

    private func getCurrentUserId() -> String? {
        // For now, use UserDefaults. In production, use Firebase Auth
        return defaults.string(forKey: "userId") ?? {
            let newId = UUID().uuidString
            defaults.set(newId, forKey: "userId")
            return newId
        }()
    }

    func cleanup() {
        // No listeners to remove with local storage
    }
}
