//
//  OptimizedFirebaseService.swift
//  SnapWake
//
//  Optimized for minimal Firebase reads/writes
//  Strategy: Batch operations, local cache, debouncing
//

import Foundation
// import FirebaseFirestore  // Temporarily disabled - add FirebaseFirestore package to enable
import FirebaseAuth

@MainActor
class OptimizedFirebaseService: ObservableObject {
    static let shared = OptimizedFirebaseService()

    // private let db = Firestore.firestore()  // Temporarily disabled

    // Cache pour éviter des reads inutiles
    private var userDataCache: [String: Any]?
    private var lastSyncDate: Date?

    // Debouncing timer pour grouper les writes
    private var syncTimer: Timer?
    private var pendingUpdates: [String: Any] = [:]

    private init() {
        // Enable offline persistence
        // TODO: Uncomment when FirebaseFirestore is added
        /*
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        settings.cacheSizeBytes = FirestoreCacheSizeUnlimited
        db.settings = settings
        */
    }

    // MARK: - 💾 USER DATA (tout dans 1 seul document)

    /// Structure optimisée: 1 seul document par user
    // Temporarily disabled until Firestore is added
    /*
    private func getUserDocRef() throws -> DocumentReference {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "OptimizedFirebaseService", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        return db.collection("users").document(userId)
    }
    */

    // MARK: - 🔥 SYNC WITH BATCHING (1 seul write au lieu de 3)

    // Temporarily disabled until Firestore is added
    /*
    /// Sync TOUT en 1 seul write: streak + insights + leaderboard
    func syncAllUserData(
        streakData: StreakData,
        insightsData: InsightsData
    ) async throws {
        let docRef = try getUserDocRef()
        guard let displayName = Auth.auth().currentUser?.displayName else { return }

        // Préparer toutes les données en 1 seul objet
        let updates: [String: Any] = [
            // Streak data
            "streak": [
                "currentStreak": streakData.currentStreak,
                "longestStreak": streakData.longestStreak,
                "lastWakeUpDate": streakData.lastWakeUpDate ?? Date(),
                "weeklyWakeUpsCount": streakData.weeklyWakeUps.count
            ],

            // Insights summary (pas tout l'historique!)
            "insights": [
                "totalWakeUps": insightsData.totalWakeUps,
                "successRate": insightsData.successRate,
                "averageWakeTime": insightsData.averageWakeTime,
                "favoriteMission": insightsData.favoriteMission
            ],

            // Leaderboard data (pour affichage public)
            "leaderboard": [
                "displayName": displayName,
                "currentStreak": streakData.currentStreak,
                "longestStreak": streakData.longestStreak,
                "totalMissions": insightsData.totalWakeUps
            ],

            // Metadata
            "lastUpdated": Timestamp(date: Date()),
            "email": Auth.auth().currentUser?.email ?? ""
        ]

        // 1 SEUL WRITE au lieu de 3! 🎉
        try await docRef.setData(updates, merge: true)

        // Update cache
        userDataCache = updates
        lastSyncDate = Date()

        print("✅ Synced all data in 1 write")
    }
    */

    // MARK: - ⏱️ DEBOUNCED SYNC (éviter trop de writes)

    // Temporarily disabled until Firestore is added
    /*
    /// Sync avec debouncing: attend 5 secondes avant de sync
    /// Si plusieurs updates arrivent, on fait 1 seul write
    func scheduleDebouncedSync(
        streakData: StreakData,
        insightsData: InsightsData
    ) {
        // Cancel previous timer
        syncTimer?.invalidate()

        // Store pending updates
        pendingUpdates["streak"] = streakData
        pendingUpdates["insights"] = insightsData

        // Schedule new sync in 5 seconds
        syncTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [weak self] _ in
            Task { @MainActor in
                guard let self = self,
                      let streak = self.pendingUpdates["streak"] as? StreakData,
                      let insights = self.pendingUpdates["insights"] as? InsightsData else {
                    return
                }

                try? await self.syncAllUserData(streakData: streak, insightsData: insights)
                self.pendingUpdates.removeAll()
            }
        }
    }
    */

    // MARK: - 📥 FETCH USER DATA (avec cache)

    // Temporarily disabled until Firestore is added
    /*
    func fetchUserData() async throws -> (streak: StreakData?, insights: InsightsData?) {
        // Check cache first (éviter des reads)
        if let cache = userDataCache,
           let lastSync = lastSyncDate,
           Date().timeIntervalSince(lastSync) < 300 { // Cache 5 minutes
            print("✅ Using cached data (no read)")
            return parseCachedData(cache)
        }

        let docRef = try getUserDocRef()
        let document = try await docRef.getDocument()

        guard document.exists, let data = document.data() else {
            return (nil, nil)
        }

        // Update cache
        userDataCache = data
        lastSyncDate = Date()

        return parseCachedData(data)
    }

    private func parseCachedData(_ data: [String: Any]) -> (streak: StreakData?, insights: InsightsData?) {
        var streakData: StreakData?
        var insightsData: InsightsData?

        // Parse streak
        if let streakDict = data["streak"] as? [String: Any] {
            var streak = StreakData()
            streak.currentStreak = streakDict["currentStreak"] as? Int ?? 0
            streak.longestStreak = streakDict["longestStreak"] as? Int ?? 0
            // Timestamp temporarily disabled
            // if let lastDate = streakDict["lastWakeUpDate"] as? Timestamp {
            //     streak.lastWakeUpDate = lastDate.dateValue()
            // }
            streakData = streak
        }

        // Note: Insights historique reste en local (UserDefaults)
        // On ne sync que le summary

        return (streakData, insightsData)
    }
    */

    // MARK: - 👥 FRIENDS (optimisé)

    // Temporarily disabled until Firestore is added
    /*
    /// Search user by email (1 read au lieu de scan)
    func findUserByEmail(_ email: String) async throws -> String? {
        // Use cached index if available
        let snapshot = try await db.collection("users")
            .whereField("email", isEqualTo: email)
            .limit(to: 1)
            .getDocument()

        return snapshot.documents.first?.documentID
    }

    func sendFriendRequest(toEmail: String) async throws {
        guard let currentUserId = Auth.auth().currentUser?.uid,
              let currentUserName = Auth.auth().currentUser?.displayName else {
            throw NSError(domain: "OptimizedFirebaseService", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }

        // Find target user (1 read)
        guard let targetUserId = try await findUserByEmail(toEmail) else {
            throw NSError(domain: "OptimizedFirebaseService", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found"])
        }

        let requestId = UUID().uuidString
        let data: [String: Any] = [
            "id": requestId,
            "fromUserId": currentUserId,
            "fromUserName": currentUserName,
            "toUserId": targetUserId,
            "sentDate": Timestamp(date: Date()),
            "status": "pending"
        ]

        // 1 write
        try await db.collection("friendRequests").document(requestId).setData(data)
    }

    func fetchFriendRequests() async throws -> [FriendRequest] {
        guard let userId = Auth.auth().currentUser?.uid else { return [] }

        // 1 read avec index
        let snapshot = try await db.collection("friendRequests")
            .whereField("toUserId", isEqualTo: userId)
            .whereField("status", isEqualTo: "pending")
            .getDocuments()

        return snapshot.documents.compactMap { doc in
            let data = doc.data()
            let id = UUID(uuidString: data["id"] as? String ?? "") ?? UUID()
            return FriendRequest(
                id: id,
                fromUserId: data["fromUserId"] as? String ?? "",
                fromUserName: data["fromUserName"] as? String ?? "",
                toUserId: data["toUserId"] as? String ?? "",
                sentDate: (data["sentDate"] as? Timestamp)?.dateValue() ?? Date(),
                status: .pending
            )
        }
    }

    func acceptFriendRequest(_ request: FriendRequest) async throws {
        // Batch write (compte comme 1 seul write pour < 500 operations)
        let batch = db.batch()

        // 1. Update request status
        let requestRef = db.collection("friendRequests").document(request.id.uuidString)
        batch.updateData(["status": "accepted"], forDocument: requestRef)

        // 2. Add to both users' friends
        let myRef = try getUserDocRef()
        batch.setData([
            "friends": FieldValue.arrayUnion([[
                "id": request.fromUserId,
                "displayName": request.fromUserName,
                "addedDate": Timestamp(date: Date())
            ]])
        ], forDocument: myRef, merge: true)

        let friendRef = db.collection("users").document(request.fromUserId)
        batch.setData([
            "friends": FieldValue.arrayUnion([[
                "id": request.toUserId,
                "displayName": Auth.auth().currentUser?.displayName ?? "Friend",
                "addedDate": Timestamp(date: Date())
            ]])
        ], forDocument: friendRef, merge: true)

        // Execute batch (compte comme 1 write!)
        try await batch.commit()
    }

    func fetchFriends() async throws -> [Friend] {
        let docRef = try getUserDocRef()
        let doc = try await docRef.getDocument()

        guard let data = doc.data(),
              let friendsArray = data["friends"] as? [[String: Any]] else {
            return []
        }

        return friendsArray.compactMap { friendData in
            Friend(
                id: friendData["id"] as? String ?? "",
                displayName: friendData["displayName"] as? String ?? "",
                currentStreak: 0,
                status: .accepted,
                addedDate: (friendData["addedDate"] as? Timestamp)?.dateValue() ?? Date()
            )
        }
    }
    */

    // MARK: - 💣 REVENGE ALARMS

    // Temporarily disabled until Firestore is added
    /*
    func sendRevengeAlarm(_ revengeAlarm: RevengeAlarm) async throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let jsonData = try encoder.encode(revengeAlarm)
        let json = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] ?? [:]

        try await db.collection("revengeAlarms").document(revengeAlarm.id.uuidString).setData(json)
    }

    func fetchRevengeAlarms() async throws -> [RevengeAlarm] {
        guard let userId = Auth.auth().currentUser?.uid else { return [] }

        let snapshot = try await db.collection("revengeAlarms")
            .whereField("targetUserId", isEqualTo: userId)
            .whereField("isCompleted", isEqualTo: false)
            .getDocuments()

        return try snapshot.documents.compactMap { doc -> RevengeAlarm? in
            let jsonData = try JSONSerialization.data(withJSONObject: doc.data())
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try? decoder.decode(RevengeAlarm.self, from: jsonData)
        }
    }
    */

    // MARK: - 🤝 DUO ALARMS

    // Temporarily disabled until Firestore is added
    /*
    func createDuoAlarm(_ duoAlarm: DuoAlarm) async throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let jsonData = try encoder.encode(duoAlarm)
        let json = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] ?? [:]

        try await db.collection("duoAlarms").document(duoAlarm.id.uuidString).setData(json)
    }

    func fetchDuoAlarms() async throws -> [DuoAlarm] {
        guard let userId = Auth.auth().currentUser?.uid else { return [] }

        // Fetch both queries in parallel (optimisé!)
        async let hostSnapshot = db.collection("duoAlarms")
            .whereField("hostUserId", isEqualTo: userId)
            .getDocuments()

        async let partnerSnapshot = db.collection("duoAlarms")
            .whereField("partnerUserId", isEqualTo: userId)
            .getDocuments()

        let (host, partner) = try await (hostSnapshot, partnerSnapshot)
        let allDocs = host.documents + partner.documents

        return try allDocs.compactMap { doc -> DuoAlarm? in
            let jsonData = try JSONSerialization.data(withJSONObject: doc.data())
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try? decoder.decode(DuoAlarm.self, from: jsonData)
        }
    }
    */

    // MARK: - 🏆 LEADERBOARD (optimisé avec pagination)

    // Temporarily disabled until Firestore is added
    /*
    func fetchLeaderboard(limit: Int = 50) async throws -> [LeaderboardEntry] {
        // Les données leaderboard sont déjà dans users/{userId}.leaderboard
        // On utilise un index composite pour performance
        let snapshot = try await db.collection("users")
            .order(by: "leaderboard.currentStreak", descending: true)
            .limit(to: limit)
            .getDocuments()

        return snapshot.documents.compactMap { doc -> LeaderboardEntry? in
            let data = doc.data()
            guard let leaderboardData = data["leaderboard"] as? [String: Any] else {
                return nil
            }

            return LeaderboardEntry(
                id: doc.documentID,
                displayName: leaderboardData["displayName"] as? String ?? "",
                currentStreak: leaderboardData["currentStreak"] as? Int ?? 0,
                longestStreak: leaderboardData["longestStreak"] as? Int ?? 0,
                totalMissions: leaderboardData["totalMissions"] as? Int ?? 0,
                lastUpdated: (data["lastUpdated"] as? Timestamp)?.dateValue() ?? Date()
            )
        }
    }
    */

    // MARK: - 🧹 CLEANUP

    func clearCache() {
        userDataCache = nil
        lastSyncDate = nil
    }
}
