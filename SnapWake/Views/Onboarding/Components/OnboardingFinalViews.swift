//
//  OnboardingFinalViews.swift
//  SnapWake
//
//  Final onboarding views including rating, notifications, and paywall (Steps 26-38)
//

import SwiftUI
import Lottie

extension CompleteOnboardingView {

    // MARK: - Rating with Social Proof (Step 26)
    var ratingWithSocialProofView: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 32) {
                Text("⭐️⭐️⭐️⭐️⭐️")
                    .font(.system(size: 50))

                Text("Join 50,000+ people who\ntransformed their mornings")
                    .font(.poppinsBold(size: 26))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)

                VStack(spacing: 16) {
                    ratingCard(
                        stars: 5,
                        text: "\"This app literally changed my life. I wake up at 6am now without struggle.\"",
                        author: "Sarah, 28"
                    )

                    ratingCard(
                        stars: 5,
                        text: "\"No more snoozing! The missions make it impossible to go back to bed.\"",
                        author: "Michael, 34"
                    )

                    ratingCard(
                        stars: 5,
                        text: "\"I've gained 2 hours every morning. Best decision ever.\"",
                        author: "Emma, 25"
                    )
                }
                .padding(.horizontal, 24)
            }

            Spacer()

            Button(action: {
                withAnimation {
                    currentStep += 1
                }
            }) {
                Text("Continue")
                    .font(.faroBold(size: 17))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color.snapOrange)
                    .cornerRadius(30)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
        .background(Color.snapLightBackground)
    }

    func ratingCard(stars: Int, text: String, author: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 4) {
                ForEach(0..<stars, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.snapOrange)
                }
            }

            Text(text)
                .font(.faro(size: 15))
                .foregroundColor(.black)

            Text(author)
                .font(.faro(size: 13))
                .foregroundColor(Color.snapTextTertiary(for: colorScheme))
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(16)
    }

    // MARK: - Stay on Track with Notifications (Step 27)
    var stayOnTrackNotificationView: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 32) {
                Text("🔔")
                    .font(.system(size: 80))

                VStack(spacing: 16) {
                    Text("Stay on track with reminders")
                        .font(.poppinsBold(size: 32))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)

                    Text("We'll send a gentle nudge so you never miss your wake-up time.")
                        .font(.faro(size: 17))
                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }

                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color.black)
                                .frame(width: 48, height: 48)
                            Image(systemName: "alarm.fill")
                                .font(.poppinsBold(size: 20))
                                .foregroundColor(.white)
                        }
                        Text("Wake-up time reminders")
                            .font(.faro(size: 17))
                            .foregroundColor(.black)
                        Spacer()
                    }

                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color.black)
                                .frame(width: 48, height: 48)
                            Image(systemName: "flame.fill")
                                .font(.poppinsBold(size: 20))
                                .foregroundColor(.white)
                        }
                        Text("Streak protection alerts")
                            .font(.faro(size: 17))
                            .foregroundColor(.black)
                        Spacer()
                    }

                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color.black)
                                .frame(width: 48, height: 48)
                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .font(.poppinsBold(size: 20))
                                .foregroundColor(.white)
                        }
                        Text("Weekly progress updates")
                            .font(.faro(size: 17))
                            .foregroundColor(.black)
                        Spacer()
                    }
                }
                .padding(.horizontal, 32)
            }

            Spacer()

            VStack(spacing: 16) {
                Button(action: {
                    // Request notification permission
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                        DispatchQueue.main.async {
                            withAnimation {
                                currentStep += 1
                            }
                        }
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "bell.fill")
                            .font(.faroBold(size: 16))
                        Text("Enable Reminders")
                            .font(.faroBold(size: 17))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color.black)
                    .cornerRadius(30)
                }
                .padding(.horizontal, 32)

                Button(action: {
                    withAnimation {
                        currentStep += 1
                    }
                }) {
                    Text("Not now")
                        .font(.faro(size: 17))
                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                }
                .padding(.bottom, 40)
            }
        }
        .background(Color.snapLightBackground)
    }

    // MARK: - Request Tracking (Step 28)
    var requestTrackingView: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 40) {
                Text("Allow tracking on\nthe next screen for:")
                    .font(.poppinsBold(size: 32))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                VStack(alignment: .leading, spacing: 24) {
                    HStack(alignment: .top, spacing: 16) {
                        Text("📊")
                            .font(.system(size: 40))
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Personalized wake-up insights tailored to you.")
                                .font(.faro(size: 17))
                                .foregroundColor(.black)
                        }
                    }

                    HStack(alignment: .top, spacing: 16) {
                        Text("🎯")
                            .font(.system(size: 40))
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Better recommendations to improve your mornings.")
                                .font(.faro(size: 17))
                                .foregroundColor(.black)
                        }
                    }

                    HStack(alignment: .top, spacing: 16) {
                        Text("⚙️")
                            .font(.system(size: 40))
                        VStack(alignment: .leading, spacing: 4) {
                            Text("You can change this anytime in Settings.")
                                .font(.faro(size: 17))
                                .foregroundColor(.black)
                        }
                    }
                }
                .padding(.horizontal, 32)
            }

            Spacer()

            Button(action: {
                // Request tracking permission (iOS 14.5+)
                withAnimation {
                    currentStep += 1
                }
            }) {
                Text("Next")
                    .font(.faroBold(size: 17))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color.black)
                    .cornerRadius(30)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
        .background(Color.snapLightBackground)
    }

    // MARK: - Heard About Us (Step 33)
    var heardAboutUsView: some View {
        questionView(
            title: "How did you hear\nabout Cocorise?",
            options: [
                "TikTok",
                "Instagram",
                "Friend recommendation",
                "App Store search",
                "YouTube",
                "Other"
            ],
            selection: $heardAboutUs
        )
    }

    // MARK: - Quote: Win the Morning (Step 34)
    var quoteWinTheMorningView: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 40) {
                Text("\"\"")
                    .font(.poppinsBold(size: 80))
                    .foregroundColor(Color.snapBorder(for: colorScheme))

                VStack(spacing: 8) {
                    Text("If you win")
                        .font(.poppinsBold(size: 42))
                        .foregroundColor(.black)

                    Text("the morning,")
                        .font(.poppinsBold(size: 42))
                        .foregroundColor(.black)

                    Text("you win the day.")
                        .font(.poppinsBold(size: 42))
                        .foregroundColor(.black)
                }
                .multilineTextAlignment(.center)

                Text("— Tim Ferriss")
                    .font(.faro(size: 18))
                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))
            }

            Spacer()

            Button(action: {
                withAnimation {
                    currentStep += 1
                }
            }) {
                Text("Continue")
                    .font(.faroBold(size: 17))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color.snapOrange)
                    .cornerRadius(30)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
        .background(Color.snapLightBackground)
    }

    // MARK: - Ready to Become a Morning Person (Step 35)
    var readyToBecomeView: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 32) {
                // Mascotte encouragement
                MascotView(.encouragement, size: .large)

                Text("Ready to become a\nmorning person?")
                    .font(.poppinsBold(size: 32))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)

                // Card avec icônes et infos
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Color.black)
                                .frame(width: 40, height: 40)

                            Image(systemName: "alarm.fill")
                                .font(.faroBold(size: 18))
                                .foregroundColor(.white)
                        }

                        Text("Wake up at")
                            .font(.faro(size: 18))
                            .foregroundColor(.black)

                        Spacer()

                        let formatter = DateFormatter()
                        let _ = formatter.dateFormat = "HH:mm"

                        Text(formatter.string(from: desiredWakeTime))
                            .font(.poppinsBold(size: 22))
                            .foregroundColor(.black)
                    }

                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Color.black)
                                .frame(width: 40, height: 40)

                            Image(systemName: "bed.double.fill")
                                .font(.faroBold(size: 18))
                                .foregroundColor(.white)
                        }

                        Text("Mission")
                            .font(.faro(size: 18))
                            .foregroundColor(.black)

                        Spacer()

                        Text(selectedMission.isEmpty ? "make your bed" : selectedMission)
                            .font(.faroBold(size: 18))
                            .foregroundColor(.black)
                    }
                }
                .padding(20)
                .background(Color.snapLightBackground)
                .cornerRadius(16)
                .padding(.horizontal, 32)
            }

            Spacer()

            // 2 boutons
            VStack(spacing: 16) {
                Button(action: {
                    withAnimation {
                        currentStep += 1
                    }
                }) {
                    Text("I'm all in")
                        .font(.faroBold(size: 17))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.black)
                        .cornerRadius(30)
                }

                Button(action: {
                    withAnimation {
                        currentStep += 1
                    }
                }) {
                    Text("I'll give it my best")
                        .font(.faroBold(size: 17))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.black, lineWidth: 2)
                        )
                        .cornerRadius(30)
                }
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
        .background(Color.snapLightBackground)
    }

    // MARK: - Plan Creation (Step 37)
    var planCreationView: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 24) {
                Text("\(Int(planCreationProgress))%")
                    .font(.poppinsBold(size: 72))
                    .foregroundColor(.black)

                Text("We're setting everything\nup for you")
                    .font(.poppinsBold(size: 28))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)

                // Progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.snapBorder(for: colorScheme))
                            .frame(height: 8)

                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.snapOrange,
                                        Color(hex: "FF6B9D"),
                                        Color(hex: "C44569"),
                                        Color(hex: "A55FCC")
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * (planCreationProgress / 100), height: 8)
                    }
                }
                .frame(height: 8)
                .padding(.horizontal, 32)

                Text("Finishing up...")
                    .font(.faro(size: 16))
                    .foregroundColor(Color.snapTextTertiary(for: colorScheme))

                // Checklist
                VStack(spacing: 16) {
                    planCreationItem("Configuring your goals", isComplete: planCreationProgress > 20)
                    planCreationItem("Setting your mission", isComplete: planCreationProgress > 40)
                    planCreationItem("Setting alarm tone", isComplete: planCreationProgress > 60)
                    planCreationItem("Scheduling your alarm", isComplete: planCreationProgress > 80)
                    planCreationItem("Setting up wake receipt", isComplete: planCreationProgress > 95)
                }
                .padding(24)
                .background(Color.white.opacity(0.5))
                .cornerRadius(20)
                .padding(.horizontal, 32)
            }

            Spacer()
        }
        .background(Color.snapLightBackground)
        .onAppear {
            animatePlanCreation()
        }
    }

    func planCreationItem(_ text: String, isComplete: Bool) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(isComplete ? Color(hex: "4CAF50") : Color(hex: "E0E0E0"))
                    .frame(width: 24, height: 24)

                if isComplete {
                    Image(systemName: "checkmark")
                        .font(.faroBold(size: 12))
                        .foregroundColor(.white)
                }
            }

            Text(text)
                .font(.faro(size: 16))
                .foregroundColor(.black)

            Spacer()
        }
    }

    func animatePlanCreation() {
        planCreationProgress = 0

        Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { timer in
            if planCreationProgress < 100 {
                planCreationProgress += 1
            } else {
                timer.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation {
                        currentStep += 1
                    }
                }
            }
        }
    }

    // MARK: - Finish View / Paywall (Step 38)
    var finishView: some View {
        VStack {
            Spacer()
            Text("All set! 🎉")
                .font(.poppinsBold(size: 40))
            Spacer()
        }
        .onAppear {
            finishOnboarding()
        }
    }

    // MARK: - Helper Functions
    func advanceToAnimation() {
        withAnimation {
            currentStep = 1
        }
    }

    func finishOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")

        // Save goal wake time from onboarding
        UserDefaults.standard.set(desiredWakeTime, forKey: "goalWakeTime")

        Task {
            await alarmManager.requestNotificationPermission()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation {
                isComplete = true
            }
        }
    }
}
