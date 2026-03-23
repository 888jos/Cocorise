//
//  LoginView.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var authManager = AuthManager.shared

    @State private var email = ""
    @State private var password = ""
    @State private var showingSignUp = false
    @State private var showingForgotPassword = false
    @State private var errorMessage = ""
    @State private var isLoading = false

    var body: some View {
        ZStack {
            Color.snapBackground(for: colorScheme)
                .ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                // Logo & Title
                VStack(spacing: 16) {
                    Image(systemName: "alarm.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.snapOrange, Color.snapPink],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    Text("Cocorise")
                        .font(.faroBold(size: 40))
                        .foregroundColor(Color.snapTextPrimary(for: colorScheme))

                    Text("Wake up with purpose")
                        .font(.faro(size: 16))
                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))
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

                    // Password
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.faro(size: 14))
                            .foregroundColor(Color.snapTextSecondary(for: colorScheme))

                        SecureField("••••••••", text: $password)
                            .textContentType(.password)
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

                    // Forgot Password
                    Button(action: { showingForgotPassword = true }) {
                        Text("Forgot password?")
                            .font(.faro(size: 14))
                            .foregroundColor(.snapOrange)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)

                    // Login Button
                    Button(action: login) {
                        Group {
                            if isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Log In")
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
                    .disabled(isLoading || email.isEmpty || password.isEmpty)
                    .opacity((isLoading || email.isEmpty || password.isEmpty) ? 0.6 : 1.0)
                }
                .padding(.horizontal, 32)

                Spacer()

                // Sign Up
                HStack(spacing: 4) {
                    Text("Don't have an account?")
                        .font(.faro(size: 14))
                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))

                    Button(action: { showingSignUp = true }) {
                        Text("Sign Up")
                            .font(.faroBold(size: 14))
                            .foregroundColor(.snapOrange)
                    }
                }
                .padding(.bottom, 32)
            }
        }
        .sheet(isPresented: $showingSignUp) {
            SignUpView()
        }
        .sheet(isPresented: $showingForgotPassword) {
            ForgotPasswordView()
        }
    }

    private func login() {
        isLoading = true
        errorMessage = ""

        Task {
            do {
                try await authManager.signInWithEmail(email: email, password: password)
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}

#Preview {
    LoginView()
}
