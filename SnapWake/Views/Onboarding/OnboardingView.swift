//
//  OnboardingView.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var alarmManager = AlarmManager.shared
    @State private var currentPage = 0
    @Binding var isComplete: Bool

    let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "alarm.fill",
            gradient: [Color.snapOrange, Color.snapPink],
            title: "Welcome to Cocorise",
            description: "Wake up with purpose! Complete fun missions to start your day right."
        ),
        OnboardingPage(
            icon: "camera.fill",
            gradient: [Color.cyan, Color.blue],
            title: "Interactive Missions",
            description: "Take photos, solve math problems, do exercises, and more to dismiss your alarm."
        ),
        OnboardingPage(
            icon: "flame.fill",
            gradient: [Color.orange, Color.red],
            title: "Build Your Streak",
            description: "Wake up consistently to build streaks and unlock exclusive badges."
        ),
        OnboardingPage(
            icon: "bell.badge.fill",
            gradient: [Color.purple, Color.pink],
            title: "Enable Notifications",
            description: "Allow critical alerts so your alarms work even in silent mode."
        )
    ]

    var body: some View {
        ZStack {
            Color.snapBackground(for: colorScheme)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Pages
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                // Page indicator
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? Color.snapOrange : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .animation(.spring(), value: currentPage)
                    }
                }
                .padding(.bottom, 24)

                // Button
                if currentPage == pages.count - 1 {
                    Button(action: {
                        requestPermissionsAndFinish()
                    }) {
                        Text("Get Started")
                            .font(.faroBold(size: 18))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(LinearGradient.snapSunrise)
                            .cornerRadius(16)
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 40)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                } else {
                    Button(action: {
                        withAnimation {
                            currentPage += 1
                        }
                    }) {
                        Text("Next")
                            .font(.faroBold(size: 18))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(LinearGradient.snapSunrise)
                            .cornerRadius(16)
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 40)
                }
            }
        }
    }

    private func requestPermissionsAndFinish() {
        Task {
            let granted = await alarmManager.requestNotificationPermission()
            if granted {
                print("✅ Notification permission granted")
            }

            // Mark onboarding as complete
            UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
            isComplete = true
        }
    }
}

struct OnboardingPage {
    let icon: String
    let gradient: [Color]
    let title: String
    let description: String
}

struct OnboardingPageView: View {
    @Environment(\.colorScheme) var colorScheme
    let page: OnboardingPage

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            // Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: page.gradient,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 140, height: 140)
                    .shadow(color: page.gradient[0].opacity(0.4), radius: 20, y: 10)

                Image(systemName: page.icon)
                    .font(.system(size: 70))
                    .foregroundColor(.white)
            }

            VStack(spacing: 16) {
                Text(page.title)
                    .font(.poppinsBold(size: 32))
                    .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                    .multilineTextAlignment(.center)

                Text(page.description)
                    .font(.faro(size: 18))
                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }

            Spacer()
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(isComplete: .constant(false))
}
