//
//  ContentView.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import SwiftUI
import StoreKit

struct ContentView: View {
    @StateObject private var alarmManager = AlarmManager.shared
    @StateObject private var authManager = AuthManager.shared
    @AppStorage("darkModeEnabled") private var darkModeEnabled = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @State private var selectedTab = 0
    @State private var onboardingComplete: Bool = false

    var body: some View {
        if !authManager.isAuthenticated {
            LoginView()
        } else if !hasCompletedOnboarding && !onboardingComplete {
            OnboardingV2View(isComplete: $onboardingComplete)
                .onChange(of: onboardingComplete) { newValue in
                    if newValue {
                        hasCompletedOnboarding = true
                    }
                }
        } else {
            mainContent
        }
    }

    private var mainContent: some View {
        ZStack {
            ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case 0:
                    HomeView()
                case 1:
                    AlarmsListView()
                case 2:
                    InsightsView()
                case 3:
                    SettingsView()
                default:
                    HomeView()
                }
            }
            .preferredColorScheme(darkModeEnabled ? .dark : .light)
            .safeAreaInset(edge: .bottom, spacing: 0) {
                Color.clear
                    .frame(height: 90)
            }

            // Custom floating tab bar with liquid glass
            HStack(spacing: 40) {
                TabBarButton(icon: "house.fill", label: "Home", isSelected: selectedTab == 0) {
                    selectedTab = 0
                }
                TabBarButton(icon: "alarm.fill", label: "Alarms", isSelected: selectedTab == 1) {
                    selectedTab = 1
                }
                TabBarButton(icon: "chart.bar.fill", label: "Insights", isSelected: selectedTab == 2) {
                    selectedTab = 2
                }
                TabBarButton(icon: "gearshape.fill", label: "Settings", isSelected: selectedTab == 3) {
                    selectedTab = 3
                }
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 16)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
            .shadow(color: .black.opacity(0.15), radius: 20, y: 10)
            }
            .ignoresSafeArea(edges: .bottom)

            // Badge unlock overlay
            BadgeUnlockedOverlay()
        }
        .fullScreenCover(item: $alarmManager.currentlyRingingAlarm) { alarm in
            ChallengeContainerView(alarm: alarm, mission: alarm.mission ?? MissionsLibrary.shared.missions.first(where: { $0.isNoMission })!) { success in
                alarmManager.dismissAlarm(success: success)
            }
            .interactiveDismissDisabled(true) // Force user to complete mission - no swipe down!
        }
        .task {
            _ = await alarmManager.requestNotificationPermission()
        }
    }
}

struct TabBarButton: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(label)
                    .font(.faro(size: 10))
            }
            .foregroundColor(isSelected ? .snapOrange : .gray)
            .frame(maxWidth: .infinity)
        }
    }
}

struct SettingsView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var authManager = AuthManager.shared
    @StateObject private var leagueManager = LeagueManager.shared
    @StateObject private var xpManager = XPManager.shared
    @AppStorage("alarmVolume") private var alarmVolume: Double = 100
    @AppStorage("vibrationEnabled") private var vibrationEnabled = true
    @AppStorage("strictModeEnabled") private var strictModeEnabled = false
    @State private var showingDeleteConfirmation = false
    @State private var showingShareSheet = false
    @State private var showingReferralSheet = false
    @State private var showingTroubleshoot = false
    @State private var showingSupport = false
    @State private var showingFeatureRequest = false
    @AppStorage("darkModeEnabled") private var darkModeEnabled = false
    @State private var refreshTrigger = false

    var goalWakeTimeText: String {
        _ = refreshTrigger // Force refresh
        if let goalWakeTime = UserDefaults.standard.object(forKey: "goalWakeTime") as? Date {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: goalWakeTime)
        }
        return "Not set"
    }

    var body: some View {
        NavigationView {
            List {
                // Notifications Section
                Section {
                    Toggle(isOn: $darkModeEnabled) {
                        HStack {
                            Image(systemName: "sun.max.fill")
                                .foregroundColor(.orange)
                            Text("Dark Mode")
                                .font(.faro(size: 16))
                                .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                        }
                    }
                    .tint(.snapOrange)
                    .listRowBackground(Color.snapCard(for: colorScheme))
                } header: {
                    Text("Notifications")
                        .font(.faro(size: 12))
                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                }

                // Customize Section
                Section {
                    NavigationLink(destination: GoalWakeTimeView()) {
                        HStack {
                            Image(systemName: "alarm")
                                .foregroundColor(.snapBlue)
                            VStack(alignment: .leading) {
                                Text("Goal wake time")
                                    .font(.faro(size: 16))
                                    .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                                Text(goalWakeTimeText)
                                    .font(.faro(size: 13))
                                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                            }
                        }
                    }
                    .listRowBackground(Color.snapCard(for: colorScheme))

                    NavigationLink(destination: ReceiptStyleView()) {
                        HStack {
                            Image(systemName: "moon.stars.fill")
                                .foregroundColor(.snapPurple)
                            VStack(alignment: .leading) {
                                Text("Receipt style")
                                    .font(.faro(size: 16))
                                    .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                                Text(UserDefaults.standard.string(forKey: "selectedReceiptStyle") ?? "Default")
                                    .font(.faro(size: 13))
                                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                            }
                        }
                    }
                    .listRowBackground(Color.snapCard(for: colorScheme))
                } header: {
                    Text("Customize")
                        .font(.faro(size: 12))
                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                }

                // Alarm Section
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "speaker.wave.2.fill")
                                .foregroundColor(.snapGreen)
                            Text("Alarm Volume")
                                .font(.faro(size: 16))
                                .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                        }

                        Slider(value: $alarmVolume, in: 0...100)
                            .tint(.snapOrange)

                        Text("\(Int(alarmVolume))%")
                            .font(.faro(size: 14))
                            .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                    }
                    .listRowBackground(Color.snapCard(for: colorScheme))

                    Toggle(isOn: $vibrationEnabled) {
                        HStack {
                            Image(systemName: "iphone.radiowaves.left.and.right")
                                .foregroundColor(.snapPurple)
                            Text("Vibration")
                                .font(.faro(size: 16))
                                .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                        }
                    }
                    .tint(.snapOrange)
                    .listRowBackground(Color.snapCard(for: colorScheme))

                    Toggle(isOn: $strictModeEnabled) {
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.red)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Strict Mode")
                                    .font(.faro(size: 16))
                                    .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                                Text(strictModeEnabled ? "Must complete missions - no skip" : "Can skip after 30s")
                                    .font(.faro(size: 12))
                                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                            }
                        }
                    }
                    .tint(.snapOrange)
                    .listRowBackground(Color.snapCard(for: colorScheme))

                    Button(action: { showingTroubleshoot = true }) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.snapOrange)
                            VStack(alignment: .leading) {
                                Text("Alarm not working?")
                                    .font(.faro(size: 16))
                                    .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                                Text("Troubleshoot & fix common issues")
                                    .font(.faro(size: 13))
                                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                            }
                        }
                    }
                    .listRowBackground(Color.snapCard(for: colorScheme))
                } header: {
                    Text("Alarm")
                        .font(.faro(size: 12))
                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                }

                // Earn Section
                Section {
                    Button(action: { showingReferralSheet = true }) {
                        HStack {
                            Image(systemName: "gift.fill")
                                .foregroundColor(.snapPink)
                            VStack(alignment: .leading) {
                                Text("Refer a friend, earn +500 XP")
                                    .font(.faro(size: 16))
                                    .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                                Text("Share your code: \(leagueManager.userProfile?.referralCode ?? "...")")
                                    .font(.faro(size: 12))
                                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                            }
                            Spacer()
                            if let profile = leagueManager.userProfile, profile.referralCount > 0 {
                                Text("\(profile.referralCount)")
                                    .font(.faroBold(size: 14))
                                    .foregroundColor(.snapOrange)
                            }
                        }
                    }
                    .listRowBackground(Color.snapCard(for: colorScheme))
                } header: {
                    Text("Earn")
                        .font(.faro(size: 12))
                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                }

                // Invite Friends Section
                Section {
                    Button(action: { showingShareSheet = true }) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.snapBlue)
                            VStack(alignment: .leading) {
                                Text("Share Cocorise with friends")
                                    .font(.faro(size: 16))
                                    .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                                Text("Know someone who needs to wake up earlier or keeps snoozing their alarm?")
                                    .font(.faro(size: 12))
                                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                            }
                        }
                    }
                    .listRowBackground(Color.snapCard(for: colorScheme))
                } header: {
                    Text("Invite Friends")
                        .font(.faro(size: 12))
                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                }

                // Resources Section
                Section {
                    Button(action: { showingFeatureRequest = true }) {
                        HStack {
                            Image(systemName: "lightbulb.fill")
                                .foregroundColor(.snapYellow)
                            Text("Request a Feature")
                                .font(.faro(size: 16))
                                .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                        }
                    }
                    .listRowBackground(Color.snapCard(for: colorScheme))

                    Button(action: { showingSupport = true }) {
                        HStack {
                            Image(systemName: "questionmark.circle.fill")
                                .foregroundColor(.snapBlue)
                            Text("Support")
                                .font(.faro(size: 16))
                                .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                        }
                    }
                    .listRowBackground(Color.snapCard(for: colorScheme))

                    Button(action: openAppStoreReview) {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.snapOrange)
                            Text("Leave a Review")
                                .font(.faro(size: 16))
                                .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                        }
                    }
                    .listRowBackground(Color.snapCard(for: colorScheme))

                    Button(action: {
                        if let url = URL(string: "https://discord.gg/snapwake") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "bubble.left.and.bubble.right.fill")
                                .foregroundColor(.snapPurple)
                            Text("Join our Discord")
                                .font(.faro(size: 16))
                                .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                        }
                    }
                    .listRowBackground(Color.snapCard(for: colorScheme))

                    Button(action: {
                        if let url = URL(string: "https://snapwake.app/privacy") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "lock.shield.fill")
                                .foregroundColor(.snapGreen)
                            Text("Privacy Policy")
                                .font(.faro(size: 16))
                                .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                        }
                    }
                    .listRowBackground(Color.snapCard(for: colorScheme))

                    Button(action: {
                        if let url = URL(string: "https://snapwake.app/terms") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "doc.text.fill")
                                .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                            Text("Terms of Service")
                                .font(.faro(size: 16))
                                .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                        }
                    }
                    .listRowBackground(Color.snapCard(for: colorScheme))

                    HStack {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.snapBlue)
                        Text("About")
                            .font(.faro(size: 16))
                            .foregroundColor(Color.snapTextPrimary(for: colorScheme))

                        Spacer()

                        Text("v1.0.0 (1)")
                            .font(.faro(size: 14))
                            .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                    }
                    .listRowBackground(Color.snapCard(for: colorScheme))
                } header: {
                    Text("Resources")
                        .font(.faro(size: 12))
                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                }

                // Account Section
                Section {
                    Button(action: {
                        try? authManager.signOut()
                    }) {
                        HStack {
                            Image(systemName: "arrow.right.square.fill")
                                .foregroundColor(.red)
                            Text("Log Out")
                                .font(.faro(size: 16))
                                .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                        }
                    }
                    .listRowBackground(Color.snapCard(for: colorScheme))

                    NavigationLink(destination: ManageSubscriptionView()) {
                        HStack {
                            Image(systemName: "creditcard.fill")
                                .foregroundColor(.snapGreen)
                            Text("Manage Subscription")
                                .font(.faro(size: 16))
                                .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                        }
                    }
                    .listRowBackground(Color.snapCard(for: colorScheme))

                    Button(action: { restorePurchases() }) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(.snapBlue)
                            Text("Restore Purchases")
                                .font(.faro(size: 16))
                                .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                            Spacer()
                        }
                    }
                    .listRowBackground(Color.snapCard(for: colorScheme))

                    Button(action: {
                        showingDeleteConfirmation = true
                    }) {
                        HStack {
                            Image(systemName: "trash.fill")
                                .foregroundColor(.red)
                            Text("Delete Account")
                                .font(.faro(size: 16))
                                .foregroundColor(.red)
                        }
                    }
                    .listRowBackground(Color.snapCard(for: colorScheme))
                } header: {
                    Text("Account")
                        .font(.faro(size: 12))
                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.snapBackground(for: colorScheme))
            .listStyle(.insetGrouped)
            .navigationTitle("Settings")
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("goalWakeTimeChanged"))) { _ in
                refreshTrigger.toggle()
            }
            .alert("Delete Account", isPresented: $showingDeleteConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    Task {
                        try? await authManager.deleteAccount()
                    }
                }
            } message: {
                Text("Are you sure you want to permanently delete your account? This action cannot be undone.")
            }
            .sheet(isPresented: $showingShareSheet) {
                ShareSheet(items: ["Check out Cocorise - the best alarm app to wake up with purpose! 🌅⏰"])
            }
            .sheet(isPresented: $showingTroubleshoot) {
                SimpleInfoView(
                    title: "Troubleshooting",
                    icon: "exclamationmark.triangle.fill",
                    iconColor: .orange,
                    content: "If your alarm isn't working, make sure:\n\n• Notifications are enabled for Cocorise\n• App has critical alerts permission\n• Your device isn't in silent mode\n• The alarm toggle is ON\n• Battery saver mode is disabled\n\nStill having issues? Contact support!"
                )
            }
            .sheet(isPresented: $showingSupport) {
                SimpleInfoView(
                    title: "Support",
                    icon: "questionmark.circle.fill",
                    iconColor: .blue,
                    content: "Need help? We're here for you!\n\nEmail: support@cocorise.app\n\nWe typically respond within 24 hours.\n\nYou can also check our FAQ and troubleshooting guides."
                )
            }
            .sheet(isPresented: $showingFeatureRequest) {
                SimpleInfoView(
                    title: "Request a Feature",
                    icon: "lightbulb.fill",
                    iconColor: Color(hex: "#FFD700"),
                    content: "Have an idea to make Cocorise better?\n\nWe'd love to hear from you!\n\nEmail your suggestions to:\nfeatures@cocorise.app\n\nOr join our Discord community to discuss with other users!"
                )
            }
            .sheet(isPresented: $showingReferralSheet) {
                ReferralView(userProfile: leagueManager.userProfile)
            }
        }
    }

    private func restorePurchases() {
        Task {
            do {
                try await AppStore.sync()
                // Show success alert
            } catch {
                // Show error alert
                print("Failed to restore purchases: \(error)")
            }
        }
    }

    private func openAppStoreReview() {
        if let url = URL(string: "https://apps.apple.com/app/id123456789?action=write-review") {
            UIApplication.shared.open(url)
        }
    }
}

// Goal Wake Time Editor
struct GoalWakeTimeView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var goalWakeTime: Date = {
        if let savedTime = UserDefaults.standard.object(forKey: "goalWakeTime") as? Date {
            return savedTime
        }
        // Default to 7:30 AM
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.hour = 7
        components.minute = 30
        return Calendar.current.date(from: components) ?? Date()
    }()

    var body: some View {
        ZStack {
            Color.snapBackground(for: colorScheme)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Content
                VStack(spacing: 32) {
                    VStack(spacing: 16) {
                        Text("What time do you want to wake up?")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                            .multilineTextAlignment(.center)

                        Text("Set your ideal wake-up time")
                            .font(.faro(size: 16))
                            .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 40)

                    // Time Picker
                    DatePicker("", selection: $goalWakeTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 32)

                    Spacer()
                }

                // Save button
                Button(action: {
                    UserDefaults.standard.set(goalWakeTime, forKey: "goalWakeTime")
                    // Force notification to update UI
                    NotificationCenter.default.post(name: NSNotification.Name("goalWakeTimeChanged"), object: nil)
                    dismiss()
                }) {
                    Text("Save Goal")
                        .font(.faroBold(size: 18))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.snapOrange)
                        .cornerRadius(30)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 120) // Plus de padding pour éviter la tab bar
            }
        }
        .navigationTitle("Goal Wake Time")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Share Sheet wrapper
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// Referral View
struct ReferralView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    let userProfile: UserProfile?
    @State private var showingShareSheet = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.snapBackground(for: colorScheme)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 32) {
                        // Header
                        VStack(spacing: 16) {
                            Image(systemName: "gift.circle.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.snapPink)

                            Text("Refer & Earn")
                                .font(.system(size: 32, weight: .bold, design: .rounded))

                            Text("Get +500 XP for every friend who joins with your code!")
                                .font(.system(size: 16))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .padding(.top, 24)

                        // Referral Code Card
                        VStack(spacing: 16) {
                            Text("Your Referral Code")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.secondary)

                            Text(userProfile?.referralCode ?? "LOADING")
                                .font(.system(size: 42, weight: .bold, design: .rounded))
                                .tracking(4)
                                .foregroundColor(.snapOrange)
                                .padding(.vertical, 20)
                                .frame(maxWidth: .infinity)
                                .background(Color.snapCard(for: colorScheme))
                                .cornerRadius(16)

                            Button(action: {
                                if let code = userProfile?.referralCode {
                                    UIPasteboard.general.string = code
                                }
                            }) {
                                HStack {
                                    Image(systemName: "doc.on.doc")
                                    Text("Copy Code")
                                }
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.snapOrange)
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity)
                                .background(Color.snapOrange.opacity(0.1))
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal, 24)

                        // Stats
                        VStack(spacing: 12) {
                            HStack {
                                VStack(spacing: 8) {
                                    Text("\(userProfile?.referralCount ?? 0)")
                                        .font(.system(size: 36, weight: .bold))
                                        .foregroundColor(.snapOrange)
                                    Text("Friends Referred")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .background(Color.snapCard(for: colorScheme))
                                .cornerRadius(16)

                                VStack(spacing: 8) {
                                    Text("+\((userProfile?.referralCount ?? 0) * 500)")
                                        .font(.system(size: 36, weight: .bold))
                                        .foregroundColor(.snapOrange)
                                    Text("XP Earned")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .background(Color.snapCard(for: colorScheme))
                                .cornerRadius(16)
                            }
                        }
                        .padding(.horizontal, 24)

                        // How it works
                        VStack(alignment: .leading, spacing: 16) {
                            Text("How it works")
                                .font(.system(size: 20, weight: .bold))
                                .padding(.horizontal, 24)

                            VStack(alignment: .leading, spacing: 16) {
                                HStack(alignment: .top, spacing: 12) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.snapOrange.opacity(0.2))
                                            .frame(width: 32, height: 32)
                                        Text("1")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(.snapOrange)
                                    }
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Share your code")
                                            .font(.system(size: 16, weight: .semibold))
                                        Text("Send your referral code to friends")
                                            .font(.system(size: 14))
                                            .foregroundColor(.secondary)
                                    }
                                }

                                HStack(alignment: .top, spacing: 12) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.snapOrange.opacity(0.2))
                                            .frame(width: 32, height: 32)
                                        Text("2")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(.snapOrange)
                                    }
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("They sign up")
                                            .font(.system(size: 16, weight: .semibold))
                                        Text("Your friend creates an account with your code")
                                            .font(.system(size: 14))
                                            .foregroundColor(.secondary)
                                    }
                                }

                                HStack(alignment: .top, spacing: 12) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.snapOrange.opacity(0.2))
                                            .frame(width: 32, height: 32)
                                        Text("3")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(.snapOrange)
                                    }
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("You both get rewards!")
                                            .font(.system(size: 16, weight: .semibold))
                                        Text("You get +500 XP, they start at Level 3")
                                            .font(.system(size: 14))
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            .padding(.horizontal, 24)
                        }

                        // Share Button
                        Button(action: {
                            showingShareSheet = true
                        }) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                Text("Share with Friends")
                                    .font(.system(size: 16, weight: .bold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(LinearGradient(
                                colors: [Color.snapOrange, Color.snapPink],
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationTitle("Referrals")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .sheet(isPresented: $showingShareSheet) {
                if let code = userProfile?.referralCode {
                    ShareSheet(items: [
                        "Join me on SnapWake and level up your morning routine! 🌅\n\nUse my referral code: \(code)\n\nYou'll start at Level 3 and we'll both earn rewards! 🎁"
                    ])
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
