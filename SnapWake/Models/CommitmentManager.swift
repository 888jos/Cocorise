//
//  CommitmentManager.swift
//  SnapWake
//
//  Created by Josselin Biot on 08/03/2026.
//

import Foundation

class CommitmentManager: ObservableObject {
    static let shared = CommitmentManager()

    @Published var myReason: String {
        didSet {
            UserDefaults.standard.set(myReason, forKey: "myReason")
        }
    }

    @Published var goalCommittedTime: Date? {
        didSet {
            if let time = goalCommittedTime {
                UserDefaults.standard.set(time, forKey: "goalCommittedTime")
            } else {
                UserDefaults.standard.removeObject(forKey: "goalCommittedTime")
            }
        }
    }

    @Published var isAppLockEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isAppLockEnabled, forKey: "isAppLockEnabled")
        }
    }

    @Published var appLockStartTime: Date {
        didSet {
            UserDefaults.standard.set(appLockStartTime, forKey: "appLockStartTime")
        }
    }

    @Published var appLockEndTime: Date {
        didSet {
            UserDefaults.standard.set(appLockEndTime, forKey: "appLockEndTime")
        }
    }

    private init() {
        self.myReason = UserDefaults.standard.string(forKey: "myReason") ?? ""
        self.goalCommittedTime = UserDefaults.standard.object(forKey: "goalCommittedTime") as? Date
        self.isAppLockEnabled = UserDefaults.standard.bool(forKey: "isAppLockEnabled")
        self.appLockStartTime = UserDefaults.standard.object(forKey: "appLockStartTime") as? Date ?? Calendar.current.date(from: DateComponents(hour: 22, minute: 0)) ?? Date()
        self.appLockEndTime = UserDefaults.standard.object(forKey: "appLockEndTime") as? Date ?? Calendar.current.date(from: DateComponents(hour: 7, minute: 0)) ?? Date()
    }
}
