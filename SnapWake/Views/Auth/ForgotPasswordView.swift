//
//  ForgotPasswordView.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @StateObject private var authManager = AuthManager.shared

    @State private var email = ""
    @State private var errorMessage = ""
    @State private var successMessage = ""
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

                // Icon & Title
                VStack(spacing: 16) {
                    Image(systemName: "lock.rotation")
                        .font(.system(size: 60))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.snapOrange, Color.snapPink],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    Text("Reset Password")
                        .font(.faroBold(size: 32))
                        .foregroundColor(Color.snapTextPrimary(for: colorScheme))

                    Text("Enter your email to receive a password reset link")
                        .font(.faro(size: 16))
                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }

                // Form
                VStack(spacing: 16) {
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

                    // Error message
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .font(.faro(size: 14))
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }

                    // Success message
                    if !successMessage.isEmpty {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.snapGreen)
                            Text(successMessage)
                                .font(.faro(size: 14))
                                .foregroundColor(.snapGreen)
                        }
                        .multilineTextAlignment(.center)
                    }

                    // Send Link Button
                    Button(action: resetPassword) {
                        Group {
                            if isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Send Reset Link")
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
                    .disabled(isLoading || email.isEmpty)
                    .opacity((isLoading || email.isEmpty) ? 0.6 : 1.0)
                }
                .padding(.horizontal, 32)

                Spacer()

                // Back to Login
                Button(action: { dismiss() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.left")
                        Text("Back to Login")
                    }
                    .font(.faro(size: 14))
                    .foregroundColor(.snapOrange)
                }
                .padding(.bottom, 32)
            }
        }
    }

    private func resetPassword() {
        isLoading = true
        errorMessage = ""
        successMessage = ""

        Task {
            do {
                try await authManager.resetPassword(email: email)
                successMessage = "Password reset link sent! Check your email."
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}

#Preview {
    ForgotPasswordView()
}
