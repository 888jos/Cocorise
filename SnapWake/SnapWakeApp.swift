//
//  SnapWakeApp.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import SwiftUI
import UserNotifications
import FirebaseCore
import RevenueCat

@main
struct SnapWakeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var revenueCatManager = RevenueCatManager.shared

    init() {
        // Initialize Firebase
        FirebaseApp.configure()

        // Initialize RevenueCat
        RevenueCatManager.shared.configure()

        // Charger les polices custom au démarrage
        FontLoader.loadCustomFonts()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Required for UIApplicationDelegate conformance
    }

    // Called when notification is received while app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Don't show banner - just trigger the alarm directly with full screen
        completionHandler([.sound])

        // Trigger alarm immediately
        if let alarmId = notification.request.content.userInfo["alarmId"] as? String {
            Task { @MainActor in
                AlarmManager.shared.handleNotificationResponse(alarmId: alarmId)
            }
        }
    }

    // Called when user taps on notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let alarmId = response.notification.request.content.userInfo["alarmId"] as? String {
            Task { @MainActor in
                AlarmManager.shared.handleNotificationResponse(alarmId: alarmId)
            }
        }
        completionHandler()
    }
}
