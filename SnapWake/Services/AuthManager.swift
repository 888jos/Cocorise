//
//  AuthManager.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseAuth

@MainActor
class AuthManager: ObservableObject {
    static let shared = AuthManager()

    @Published var user: User?
    @Published var isAuthenticated = false

    struct User {
        let uid: String
        let email: String?
        let displayName: String?
    }

    private init() {
        checkAuthStatus()
    }

    // MARK: - Auth Status

    func checkAuthStatus() {
        // Check if Firebase is configured before accessing Auth
        guard FirebaseApp.app() != nil else {
            print("⚠️ Firebase not configured - skipping auth check")
            self.user = nil
            self.isAuthenticated = false
            return
        }

        if let firebaseUser = Auth.auth().currentUser {
            self.user = User(
                uid: firebaseUser.uid,
                email: firebaseUser.email,
                displayName: firebaseUser.displayName
            )
            self.isAuthenticated = true
        } else {
            self.user = nil
            self.isAuthenticated = false
        }
    }

    // MARK: - Sign In

    func signInWithEmail(email: String, password: String) async throws {
        guard FirebaseApp.app() != nil else {
            throw NSError(domain: "AuthManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Firebase not configured"])
        }

        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.user = User(
                uid: result.user.uid,
                email: result.user.email,
                displayName: result.user.displayName
            )
            self.isAuthenticated = true
        } catch let error as NSError {
            // Provide user-friendly error messages
            if error.code == 17009 { // wrong password
                throw NSError(domain: error.domain, code: error.code, userInfo: [NSLocalizedDescriptionKey: "Incorrect password. Please try again."])
            } else if error.code == 17011 { // user not found
                throw NSError(domain: error.domain, code: error.code, userInfo: [NSLocalizedDescriptionKey: "No account found with this email."])
            } else if error.code == 17020 { // network error
                throw NSError(domain: error.domain, code: error.code, userInfo: [NSLocalizedDescriptionKey: "Network error. Please check your connection."])
            } else {
                throw error
            }
        }
    }

    // MARK: - Sign Up

    func signUpWithEmail(email: String, password: String, name: String) async throws {
        guard FirebaseApp.app() != nil else {
            throw NSError(domain: "AuthManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Firebase not configured"])
        }

        do {
            print("🔵 AuthManager: Creating user with email: \(email)")
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            print("✅ AuthManager: User created with UID: \(result.user.uid)")

            // Update display name
            print("🔵 AuthManager: Setting display name: \(name)")
            let changeRequest = result.user.createProfileChangeRequest()
            changeRequest.displayName = name
            try await changeRequest.commitChanges()
            print("✅ AuthManager: Display name set")

            self.user = User(
                uid: result.user.uid,
                email: result.user.email,
                displayName: name
            )
            self.isAuthenticated = true
            print("✅ AuthManager: User authenticated")
        } catch let error as NSError {
            // Provide user-friendly error messages
            if error.code == 17007 { // email already in use
                throw NSError(domain: error.domain, code: error.code, userInfo: [NSLocalizedDescriptionKey: "This email is already registered."])
            } else if error.code == 17026 { // weak password
                throw NSError(domain: error.domain, code: error.code, userInfo: [NSLocalizedDescriptionKey: "Password should be at least 6 characters."])
            } else if error.code == 17008 { // invalid email
                throw NSError(domain: error.domain, code: error.code, userInfo: [NSLocalizedDescriptionKey: "Invalid email address format."])
            } else if error.code == 17020 { // network error
                throw NSError(domain: error.domain, code: error.code, userInfo: [NSLocalizedDescriptionKey: "Network error. Please check your connection."])
            } else {
                throw error
            }
        }
    }

    // MARK: - Sign Out

    func signOut() throws {
        guard FirebaseApp.app() != nil else {
            throw NSError(domain: "AuthManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Firebase not configured"])
        }

        try Auth.auth().signOut()
        self.user = nil
        self.isAuthenticated = false
    }

    // MARK: - Password Reset

    func resetPassword(email: String) async throws {
        guard FirebaseApp.app() != nil else {
            throw NSError(domain: "AuthManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Firebase not configured"])
        }

        try await Auth.auth().sendPasswordReset(withEmail: email)
    }

    // MARK: - Delete Account

    func deleteAccount() async throws {
        guard FirebaseApp.app() != nil else {
            throw NSError(domain: "AuthManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Firebase not configured"])
        }

        try await Auth.auth().currentUser?.delete()

        // Clear all local data
        clearAllLocalData()

        self.user = nil
        self.isAuthenticated = false
    }

    private func clearAllLocalData() {
        let defaults = UserDefaults.standard
        // Clear all app data
        defaults.removeObject(forKey: "savedAlarms")
        defaults.removeObject(forKey: "streakData")
        defaults.removeObject(forKey: "unlockedBadges")
        defaults.removeObject(forKey: "insightsData")
        defaults.synchronize()
    }
}
