//
//  LocalStorageService.swift
//  SnapWake
//
//  Local persistence service - Easy to migrate to Firestore later
//  Architecture: Codable models + UserDefaults for now, can swap to Firestore seamlessly
//

import Foundation
import Combine

@MainActor
class LocalStorageService: ObservableObject {
    static let shared = LocalStorageService()

    private let defaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    // MARK: - Keys
    private enum Keys {
        static let alarms = "saved_alarms"
        static let goalWakeTime = "goalWakeTime"
        static let userName = "user_name"
        static let userAge = "user_age"
        static let selectedMission = "selected_mission"
        static let selectedSound = "selected_alarm_sound"
        static let selectedDays = "selected_days"
        static let onboardingData = "onboarding_data"
        static let streakData = "streak_data"
        static let insightsData = "insights_data"
        static let lastBackupDate = "last_backup_date"
    }

    private init() {
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
    }

    // MARK: - Alarms Persistence

    func saveAlarms(_ alarms: [Alarm]) {
        do {
            let data = try encoder.encode(alarms)
            defaults.set(data, forKey: Keys.alarms)
            print("✅ Saved \(alarms.count) alarms locally")
        } catch {
            print("❌ Failed to save alarms: \(error)")
        }
    }

    func loadAlarms() -> [Alarm] {
        guard let data = defaults.data(forKey: Keys.alarms) else {
            return []
        }

        do {
            let alarms = try decoder.decode([Alarm].self, from: data)
            print("✅ Loaded \(alarms.count) alarms from local storage")
            return alarms
        } catch {
            print("❌ Failed to load alarms: \(error)")
            return []
        }
    }

    // MARK: - User Data

    func saveUserData(name: String?, age: String?) {
        defaults.set(name, forKey: Keys.userName)
        defaults.set(age, forKey: Keys.userAge)
    }

    func getUserName() -> String? {
        defaults.string(forKey: Keys.userName)
    }

    func getUserAge() -> String? {
        defaults.string(forKey: Keys.userAge)
    }

    // MARK: - Goal Wake Time

    func saveGoalWakeTime(_ time: Date) {
        defaults.set(time, forKey: Keys.goalWakeTime)
        NotificationCenter.default.post(name: NSNotification.Name("goalWakeTimeChanged"), object: nil)
    }

    func getGoalWakeTime() -> Date? {
        defaults.object(forKey: Keys.goalWakeTime) as? Date
    }

    // MARK: - Mission & Sound Preferences

    func saveMissionPreference(_ mission: String) {
        defaults.set(mission, forKey: Keys.selectedMission)
    }

    func getMissionPreference() -> String? {
        defaults.string(forKey: Keys.selectedMission)
    }

    func saveSoundPreference(_ sound: String) {
        defaults.set(sound, forKey: Keys.selectedSound)
    }

    func getSoundPreference() -> String? {
        defaults.string(forKey: Keys.selectedSound)
    }

    func saveSelectedDays(_ days: Set<String>) {
        let daysArray = Array(days)
        defaults.set(daysArray, forKey: Keys.selectedDays)
    }

    func getSelectedDays() -> Set<String> {
        guard let daysArray = defaults.array(forKey: Keys.selectedDays) as? [String] else {
            return []
        }
        return Set(daysArray)
    }

    // MARK: - Onboarding Data (for analytics/personalization)

    struct OnboardingData: Codable {
        let userName: String?
        let userAge: String?
        let snoozeTime: String?
        let dreamActivity: String?
        let biggestDream: String?
        let currentWakeTime: Date?
        let desiredWakeTime: Date?
        let selectedMission: String?
        let completedDate: Date
    }

    func saveOnboardingData(_ data: OnboardingData) {
        do {
            let encoded = try encoder.encode(data)
            defaults.set(encoded, forKey: Keys.onboardingData)
            print("✅ Saved onboarding data")
        } catch {
            print("❌ Failed to save onboarding data: \(error)")
        }
    }

    func getOnboardingData() -> OnboardingData? {
        guard let data = defaults.data(forKey: Keys.onboardingData) else {
            return nil
        }

        return try? decoder.decode(OnboardingData.self, from: data)
    }

    // MARK: - Streak Data Backup

    func saveStreakData(_ streakData: StreakData) {
        do {
            let data = try encoder.encode(streakData)
            defaults.set(data, forKey: Keys.streakData)
            print("✅ Saved streak data (current: \(streakData.currentStreak), longest: \(streakData.longestStreak))")
        } catch {
            print("❌ Failed to save streak data: \(error)")
        }
    }

    func loadStreakData() -> StreakData? {
        guard let data = defaults.data(forKey: Keys.streakData) else {
            return nil
        }

        return try? decoder.decode(StreakData.self, from: data)
    }

    // MARK: - Insights Data Backup

    func saveInsightsData(_ insightsData: InsightsData) {
        do {
            let data = try encoder.encode(insightsData)
            defaults.set(data, forKey: Keys.insightsData)
            print("✅ Saved insights data")
        } catch {
            print("❌ Failed to save insights data: \(error)")
        }
    }

    func loadInsightsData() -> InsightsData? {
        guard let data = defaults.data(forKey: Keys.insightsData) else {
            return nil
        }

        return try? decoder.decode(InsightsData.self, from: data)
    }

    // MARK: - Backup All Data

    /// Backup tout en une seule fois (utile pour migration Firestore plus tard)
    func backupAllData() {
        let backupData: [String: Any] = [
            "alarms": loadAlarms().map { alarm in
                [
                    "id": alarm.id.uuidString,
                    "name": alarm.name,
                    "time": alarm.time,
                    "isEnabled": alarm.isEnabled,
                    "selectedDays": Array(alarm.selectedDays),
                    "sound": alarm.sound,
                    "missionId": alarm.missionId?.uuidString ?? ""
                ]
            },
            "goalWakeTime": getGoalWakeTime() ?? Date(),
            "userName": getUserName() ?? "",
            "userAge": getUserAge() ?? "",
            "selectedMission": getMissionPreference() ?? "",
            "selectedSound": getSoundPreference() ?? "",
            "onboardingData": getOnboardingData() ?? [:],
            "streakData": loadStreakData() ?? [:],
            "insightsData": loadInsightsData() ?? [:],
            "backupDate": Date()
        ]

        defaults.set(Date(), forKey: Keys.lastBackupDate)
        print("✅ Full backup completed")

        // TODO: Future - Send to Firestore
        // await FirebaseService.shared.backupUserData(backupData)
    }

    func getLastBackupDate() -> Date? {
        defaults.object(forKey: Keys.lastBackupDate) as? Date
    }

    // MARK: - Clear All Data (for testing)

    func clearAllData() {
        let domain = Bundle.main.bundleIdentifier!
        defaults.removePersistentDomain(forName: domain)
        defaults.synchronize()
        print("🗑️ Cleared all local data")
    }
}
