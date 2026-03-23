//
//  AlarmManager.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import Foundation
import UserNotifications
import UIKit

@MainActor
class AlarmManager: ObservableObject {
    static let shared = AlarmManager()

    @Published var alarms: [Alarm] = []
    @Published var currentlyRingingAlarm: Alarm?
    @Published var snoozedUntil: Date?

    private let localStorage = LocalStorageService.shared

    init() {
        loadAlarms()
    }

    func loadAlarms() {
        let loaded = localStorage.loadAlarms()
        if loaded.isEmpty {
            // Créer une alarme par défaut
            let defaultAlarm = Alarm()
            alarms = [defaultAlarm]
            saveAlarms()
        } else {
            alarms = loaded
        }
    }

    func saveAlarms() {
        localStorage.saveAlarms(alarms)
    }

    func addAlarm(_ alarm: Alarm) {
        alarms.append(alarm)
        saveAlarms()
        scheduleNotification(for: alarm)
    }

    func updateAlarm(_ alarm: Alarm) {
        if let index = alarms.firstIndex(where: { $0.id == alarm.id }) {
            alarms[index] = alarm
            saveAlarms()
            scheduleNotification(for: alarm)
        }
    }

    func deleteAlarm(_ alarm: Alarm) {
        alarms.removeAll { $0.id == alarm.id }
        saveAlarms()
        cancelNotification(for: alarm)
    }

    func toggleAlarm(_ alarm: Alarm) {
        var updatedAlarm = alarm
        updatedAlarm.isEnabled.toggle()
        updateAlarm(updatedAlarm)
    }

    // MARK: - Notifications

    func requestNotificationPermission() async -> Bool {
        do {
            // Request critical alerts permission for alarm sounds that bypass silent mode
            let granted = try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound, .badge, .criticalAlert])

            if granted {
                // Register notification categories with actions
                let dismissAction = UNNotificationAction(
                    identifier: "DISMISS_ACTION",
                    title: "Dismiss",
                    options: .foreground
                )

                let snoozeAction = UNNotificationAction(
                    identifier: "SNOOZE_ACTION",
                    title: "Snooze 5 min",
                    options: []
                )

                let category = UNNotificationCategory(
                    identifier: "ALARM_CATEGORY",
                    actions: [dismissAction, snoozeAction],
                    intentIdentifiers: [],
                    options: .customDismissAction
                )

                UNUserNotificationCenter.current().setNotificationCategories([category])
            }

            return granted
        } catch {
            print("Error requesting notification permission: \(error)")
            return false
        }
    }

    private func scheduleNotification(for alarm: Alarm) {
        let center = UNUserNotificationCenter.current()

        // Annuler l'ancienne notification
        cancelNotification(for: alarm)

        guard alarm.isEnabled else { return }

        // Check notification permission before scheduling
        center.getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else {
                print("⚠️ Notification permission not granted")
                return
            }
        }

        // Get mission description
        let missionText = alarm.mission?.name ?? "No Mission"

        // Créer une notification pour chaque jour sélectionné
        for day in alarm.selectedDays {
            let content = UNMutableNotificationContent()
            content.title = "⏰ \(alarm.name)"
            content.body = "Time to wake up! Mission: \(missionText)"
            content.sound = .defaultCritical // Critical sound plays even in silent mode
            content.categoryIdentifier = "ALARM_CATEGORY"
            content.userInfo = ["alarmId": alarm.id.uuidString]
            content.interruptionLevel = .critical

            var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: alarm.time)
            dateComponents.weekday = day.rawValue

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(
                identifier: "\(alarm.id.uuidString)-\(day.rawValue)",
                content: content,
                trigger: trigger
            )

            center.add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error)")
                }
            }
        }
    }

    private func cancelNotification(for alarm: Alarm) {
        let center = UNUserNotificationCenter.current()
        let identifiers = alarm.selectedDays.map { "\(alarm.id.uuidString)-\($0.rawValue)" }
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
    }

    func startChallenge(for alarm: Alarm) {
        var updatedAlarm = alarm
        updatedAlarm.currentChallenge = ChallengeDatabase.shared.randomObject(for: alarm.difficulty)
        updateAlarm(updatedAlarm)
    }

    func completeChallenge(for alarm: Alarm) {
        var updatedAlarm = alarm
        updatedAlarm.currentChallenge = nil
        updateAlarm(updatedAlarm)
    }

    func triggerAlarm(_ alarm: Alarm) {
        currentlyRingingAlarm = alarm

        // Get volume from UserDefaults
        let volume = UserDefaults.standard.float(forKey: "alarmVolume")
        let actualVolume = volume > 0 ? volume : 1.0

        // Trigger haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)

        // Play alarm sound with volume
        AudioPlayerService.shared.playAlarmSound(alarm.sound, loop: true, volume: actualVolume)
    }

    func snoozeAlarm(minutes: Int = 5) {
        guard let alarm = currentlyRingingAlarm else { return }

        AudioPlayerService.shared.stopSound()

        // Schedule to retrigger alarm after snooze period
        snoozedUntil = Date().addingTimeInterval(TimeInterval(minutes * 60))

        Task {
            try? await Task.sleep(nanoseconds: UInt64(minutes * 60 * 1_000_000_000))
            if let snoozedUntil = snoozedUntil, Date() >= snoozedUntil {
                triggerAlarm(alarm)
                self.snoozedUntil = nil
            }
        }

        currentlyRingingAlarm = nil
    }

    func dismissAlarm(success: Bool) {
        guard let alarm = currentlyRingingAlarm else { return }

        // Stop sound immediately
        AudioPlayerService.shared.stopSound()
        snoozedUntil = nil

        // Clear the alarm FIRST to dismiss the view immediately
        currentlyRingingAlarm = nil

        // Then do logging in background to avoid freezing
        Task {
            if success {
                // Log insights
                InsightsManager.shared.logWakeUp(
                    alarm: alarm,
                    wakeUpTime: Date(),
                    missionCompleted: true
                )

                // Update streak
                StreakManager.shared.logWakeUp()

                // Haptic feedback for success
                await MainActor.run {
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                }
            } else {
                // Mission failed - still log it
                InsightsManager.shared.logWakeUp(
                    alarm: alarm,
                    wakeUpTime: Date(),
                    missionCompleted: false
                )
            }
        }
    }
}

extension AlarmManager {
    func handleNotificationResponse(alarmId: String) {
        guard let alarm = alarms.first(where: { $0.id.uuidString == alarmId }) else { return }
        triggerAlarm(alarm)
    }
}
