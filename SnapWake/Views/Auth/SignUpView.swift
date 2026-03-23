//
//  SignUpView.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @StateObject private var authManager = AuthManager.shared

    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""
    @State private var isLoading = false

    var body: some View {
        ZStack {
            Color.snapBackground(for: colorScheme)
                .ignoresSafeArea()

            VStack(spacing: 32) {
                // Close button
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 20))
                            .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                    }
                    Spacer()
                }
                .padding(.horizontal, 32)

                Spacer()

                // Logo & Title
                VStack(spacing: 16) {
                    Image(systemName: "person.badge.plus")
                        .font(.system(size: 60))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.snapOrange, Color.snapPink],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    Text("Create Account")
                        .font(.faroBold(size: 32))
                        .foregroundColor(Color.snapTextPrimary(for: colorScheme))

                    Text("Join Cocorise today")
                        .font(.faro(size: 16))
                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                }

                // Form
                VStack(spacing: 16) {
                    // Name
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Full Name")
                            .font(.faro(size: 14))
                            .foregroundColor(Color.snapTextSecondary(for: colorScheme))

                        TextField("John Doe", text: $name)
                            .textContentType(.name)
                            .autocapitalization(.words)
                            .font(.faro(size: 16))
                            .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                            .padding()
                            .background(Color.snapCard(for: colorScheme))
                            .cornerRadius(12)
                    }

                    // Email
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .font(.faro(size: 14))
                            .foregroundColor(Color.snapTextSecondary(for: colorScheme))

                        TextField("you@example.com", text: $email)
                            .textContentType(.emailAddress)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .font(.faro(size: 16))
                            .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                            .padding()
                            .background(Color.snapCard(for: colorScheme))
                            .cornerRadius(12)
                    }

                    // Password
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.faro(size: 14))
                            .foregroundColor(Color.snapTextSecondary(for: colorScheme))

                        SecureField("••••••••", text: $password)
                            .textContentType(.newPassword)
                            .font(.faro(size: 16))
                            .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                            .padding()
                            .background(Color.snapCard(for: colorScheme))
                            .cornerRadius(12)
                    }

                    // Confirm Password
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Confirm Password")
                            .font(.faro(size: 14))
                            .foregroundColor(Color.snapTextSecondary(for: colorScheme))

                        SecureField("••••••••", text: $confirmPassword)
                            .textContentType(.newPassword)
                            .font(.faro(size: 16))
                            .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                            .padding()
                            .background(Color.snapCard(for: colorScheme))
                            .cornerRadius(12)
                    }

                    // Error message
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .font(.faro(size: 14))
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }

                    // Sign Up Button
                    Button(action: signUp) {
                        Group {
                            if isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Sign Up")
                                    .font(.faroBold(size: 18))
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [Color.snapOrange, Color.snapPink],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                    }
                    .disabled(isLoading || !isFormValid)
                    .opacity((isLoading || !isFormValid) ? 0.6 : 1.0)
                }
                .padding(.horizontal, 32)

                Spacer()

                // Terms
                Text("By signing up, you agree to our Terms of Service and Privacy Policy")
                    .font(.faro(size: 12))
                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 32)
            }
        }
    }

    private var isFormValid: Bool {
        !name.isEmpty &&
        !email.isEmpty &&
        !password.isEmpty &&
        password.count >= 6 &&
        password == confirmPassword
    }

    private func signUp() {
        guard password == confirmPassword else {
            errorMessage = "Passwords don't match"
            return
        }

        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters"
            return
        }

        isLoading = true
        errorMessage = ""

        Task {
            do {
                print("🔵 Starting sign up for: \(email)")
                try await authManager.signUpWithEmail(email: email, password: password, name: name)
                print("✅ Sign up successful!")
                dismiss()
            } catch {
                print("❌ Sign up error: \(error.localizedDescription)")
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}

#Preview {
    SignUpView()
}
