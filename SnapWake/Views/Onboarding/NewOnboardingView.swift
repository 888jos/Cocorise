//
//  NewOnboardingView.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import SwiftUI

struct NewOnboardingView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var alarmManager = AlarmManager.shared
    @Binding var isComplete: Bool
    @State private var currentStep = 0
    @State private var userName = ""
    @State private var selectedSnoozeTime = ""
    @State private var showText1 = false
    @State private var showText2 = false
    @State private var showText3 = false
    @State private var sunPosition: CGFloat = 0.8
    @State private var backgroundColor = Color.black
    @State private var showStars = true

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 2.0), value: backgroundColor)

            if currentStep == 0 {
                snoozeQuestionView
            } else if currentStep == 1 {
                sunriseAnimationView
            } else if currentStep == 2 {
                becomeTextView
            } else if currentStep == 3 {
                morningPersonView
            } else if currentStep == 4 {
                mainMessageView
            } else if currentStep == 5 {
                nameInputView
            }
        }
        .onAppear {
            if currentStep == 1 {
                startSunriseAnimation()
            }
        }
    }

    // MARK: - Step 0: Snooze Question
    var snoozeQuestionView: some View {
        VStack(spacing: 0) {
            // Back button and progress bar on same row
            HStack(alignment: .center, spacing: 12) {
                Button(action: { isComplete = true }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.primary)
                }

                // Progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 4)

                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.black)
                            .frame(width: geometry.size.width * 0.15, height: 4)
                    }
                }
                .frame(height: 4)
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .padding(.bottom, 30)

            Text("How long do you spend snoozing each morning?")
                .font(.poppinsBold(size: 34))
                .foregroundColor(.primary)
                .padding(.horizontal, 32)
                .padding(.bottom, 40)

            VStack(spacing: 16) {
                ForEach(["Under 10 minutes", "10-20 minutes", "20-30 minutes", "30-45 minutes", "45-60 minutes", "Over an hour"], id: \.self) { option in
                    Button(action: {
                        selectedSnoozeTime = option
                        withAnimation {
                            currentStep = 1
                            backgroundColor = Color.black
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            startSunriseAnimation()
                        }
                    }) {
                        Text(option)
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 20)
                            .padding(.horizontal, 24)
                            .background(Color(.systemGray6))
                            .cornerRadius(16)
                    }
                }
            }
            .padding(.horizontal, 32)

            Spacer()

            Button(action: {
                withAnimation {
                    currentStep = 1
                    backgroundColor = Color.black
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    startSunriseAnimation()
                }
            }) {
                Text("Continue")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white.opacity(0.5))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(30)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
    }

    // MARK: - Step 1: Sunrise Animation
    var sunriseAnimationView: some View {
        ZStack {
            // Back button and progress bar
            VStack {
                HStack(alignment: .center, spacing: 12) {
                    Button(action: {
                        withAnimation {
                            currentStep = 0
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                    }

                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white.opacity(0.3))
                                .frame(height: 4)

                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .frame(width: geometry.size.width * 0.3, height: 4)
                        }
                    }
                    .frame(height: 4)
                }
                .padding(.horizontal)
                .padding(.vertical, 12)

                Spacer()
            }

            // Stars
            if showStars {
                ForEach(0..<50, id: \.self) { _ in
                    Circle()
                        .fill(Color.white.opacity(Double.random(in: 0.3...0.9)))
                        .frame(width: CGFloat.random(in: 1...3))
                        .position(
                            x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                            y: CGFloat.random(in: 0...UIScreen.main.bounds.height * 0.6)
                        )
                }
                .opacity(showStars ? 1 : 0)
                .animation(.easeOut(duration: 2.0), value: showStars)
            }

            // Sun
            VStack {
                Spacer()
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color(hex: "FFA500"), Color(hex: "FF8C00")],
                            center: .center,
                            startRadius: 0,
                            endRadius: 80
                        )
                    )
                    .frame(width: 120, height: 120)
                    .shadow(color: Color.orange.opacity(0.6), radius: 40)
                    .offset(y: sunPosition * UIScreen.main.bounds.height * 0.3)
                Spacer()
            }
        }
        .onAppear {
            startSunriseAnimation()
        }
    }

    // MARK: - Step 2: "Become" text
    var becomeTextView: some View {
        ZStack {
            VStack {
                HStack(alignment: .center, spacing: 12) {
                    Button(action: {
                        withAnimation {
                            currentStep = 1
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                    }

                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white.opacity(0.3))
                                .frame(height: 4)

                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .frame(width: geometry.size.width * 0.45, height: 4)
                        }
                    }
                    .frame(height: 4)
                }
                .padding(.horizontal)
                .padding(.vertical, 12)

                Spacer()
            }

            VStack {
                Spacer()
                Text("Become")
                    .font(.poppinsBold(size: 56))
                    .foregroundColor(.white.opacity(0.9))
                    .opacity(showText1 ? 1 : 0)
                    .offset(y: showText1 ? 0 : 20)
                Spacer()
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                showText1 = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    currentStep = 3
                    backgroundColor = Color(hex: "F5F5F0")
                }
            }
        }
    }

    // MARK: - Step 3: "Become a morning person"
    var morningPersonView: some View {
        ZStack {
            VStack {
                HStack(alignment: .center, spacing: 12) {
                    Button(action: {
                        withAnimation {
                            currentStep = 2
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.black)
                    }

                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 4)

                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.black)
                                .frame(width: geometry.size.width * 0.6, height: 4)
                        }
                    }
                    .frame(height: 4)
                }
                .padding(.horizontal)
                .padding(.vertical, 12)

                Spacer()
            }

            VStack {
                Spacer()

                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color(hex: "FFA500"), Color(hex: "FF8C00")],
                            center: .center,
                            startRadius: 0,
                            endRadius: 80
                        )
                    )
                    .frame(width: 120, height: 120)
                    .shadow(color: Color.orange.opacity(0.3), radius: 40)
                    .padding(.bottom, 60)

                Text("Become a morning person")
                    .font(.poppinsBold(size: 56))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .opacity(showText2 ? 1 : 0)
                    .offset(y: showText2 ? 0 : 20)

                Spacer()
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6).delay(0.2)) {
                showText2 = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    currentStep = 4
                }
            }
        }
    }

    // MARK: - Step 4: Main Message
    var mainMessageView: some View {
        VStack(spacing: 40) {
            HStack(alignment: .center, spacing: 12) {
                Button(action: {
                    withAnimation {
                        currentStep = 3
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.black)
                }

                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 4)

                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.black)
                            .frame(width: geometry.size.width * 0.75, height: 4)
                    }
                }
                .frame(height: 4)
            }
            .padding(.horizontal)
            .padding(.vertical, 12)

            Spacer()

            VStack(spacing: 24) {
                Text("Stop hitting snooze. Start winning mornings.")
                    .font(.poppinsBold(size: 38))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 32)

                Text("One alarm. One mission. You're up.")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 32)

                // Laurel wreath with stars
                HStack(spacing: 4) {
                    Text("🌿")
                    ForEach(0..<5, id: \.self) { _ in
                        Text("⭐️")
                    }
                    Text("🌿")
                }
                .font(.system(size: 32))
                .padding(.top, 20)
            }

            Spacer()

            VStack(spacing: 16) {
                Button(action: {
                    withAnimation {
                        currentStep = 5
                    }
                }) {
                    HStack {
                        Text("Build my plan")
                            .font(.system(size: 17, weight: .semibold))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color.snapOrange)
                    .cornerRadius(30)
                }

                HStack {
                    Text("Join thousands waking up on purpose")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }

                HStack(spacing: 4) {
                    Text("Already have an account?")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                    Button(action: {
                        // Sign in action
                    }) {
                        Text("Sign in")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.black)
                    }
                }
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
        .background(Color(hex: "F5F5F0"))
    }

    // MARK: - Step 5: Name Input
    var nameInputView: some View {
        VStack(spacing: 40) {
            // Back button and progress bar on same row
            HStack(alignment: .center, spacing: 12) {
                Button(action: {
                    withAnimation {
                        currentStep = 4
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.primary)
                }

                // Progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 4)

                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.black)
                            .frame(width: geometry.size.width * 0.3, height: 4)
                    }
                }
                .frame(height: 4)
            }
            .padding(.horizontal)
            .padding(.vertical, 12)

            Spacer()

            VStack(spacing: 32) {
                Text("👋")
                    .font(.system(size: 80))

                Text("What should we call you?")
                    .font(.poppinsBold(size: 28))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)

                TextField("Your first name", text: $userName)
                    .font(.system(size: 17))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 8)
                    .overlay(
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 1),
                        alignment: .bottom
                    )
                    .padding(.horizontal, 60)
            }

            Spacer()

            Button(action: {
                finishOnboarding()
            }) {
                Text("Continue")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white.opacity(userName.isEmpty ? 0.5 : 1))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(userName.isEmpty ? Color.gray.opacity(0.3) : Color.gray.opacity(0.6))
                    .cornerRadius(30)
            }
            .disabled(userName.isEmpty)
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
        .background(Color(hex: "F5F5F0"))
    }

    // MARK: - Animations
    private func startSunriseAnimation() {
        // Animate sun rising
        withAnimation(.easeInOut(duration: 3.0)) {
            sunPosition = 0.3
        }

        // Fade out stars
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeOut(duration: 2.0)) {
                showStars = false
            }
        }

        // Change background to sunrise colors
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeInOut(duration: 2.0)) {
                backgroundColor = Color(hex: "E8998D") // Purple-pink sunrise
            }
        }

        // Transition to next step
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            withAnimation {
                currentStep = 2
                backgroundColor = Color(hex: "F0A070") // Orange sunrise
            }
        }
    }

    private func finishOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        UserDefaults.standard.set(userName, forKey: "userName")

        Task {
            await alarmManager.requestNotificationPermission()
        }

        withAnimation {
            isComplete = true
        }
    }
}

#Preview {
    NewOnboardingView(isComplete: .constant(false))
}
