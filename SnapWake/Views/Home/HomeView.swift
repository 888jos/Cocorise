//
//  HomeView.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var streakManager = StreakManager.shared
    @StateObject private var alarmManager = AlarmManager.shared
    @StateObject private var xpManager = XPManager.shared
    @State private var showingEditTime = false
    @State private var showingSounds = false
    @State private var showingAddAlarm = false
    @State private var showingOnboarding = false
    @State private var showingOnboardingV2 = false
    @State private var onboardingComplete = false
    @State private var tempSound = "Default"
    @State private var showingMyReason = false
    @State private var showingGoalCommitted = false
    @State private var showingMissionIntro = false
    @StateObject private var commitmentManager = CommitmentManager.shared

    var nextAlarm: Alarm? {
        alarmManager.alarms.first { $0.isEnabled }
    }

    var bedtime: String {
        guard let alarm = nextAlarm else { return "No alarm set" }

        // Recommandation : 8h de sommeil
        let calendar = Calendar.current
        let bedtimeDate = calendar.date(byAdding: .hour, value: -8, to: alarm.time) ?? alarm.time

        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: bedtimeDate)
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header avec branding et streak
                    HStack {
                        HStack(spacing: 8) {
                            Image(systemName: "alarm.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.snapOrange)
                            Text("Cocorise")
                                .font(.faroBold(size: 28))
                                .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                        }

                        Spacer()

                        // Preview onboarding V1 button
                        Button(action: { showingOnboarding = true }) {
                            Image(systemName: "info.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.snapBlue)
                        }

                        // Preview onboarding V2 button
                        Button(action: { showingOnboardingV2 = true }) {
                            Image(systemName: "message.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.snapPurple)
                        }

                        // Test alarm button
                        Button(action: testAlarm) {
                            Image(systemName: "play.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.snapOrange)
                        }

                        // Streak badge
                        HStack(spacing: 4) {
                            Image(systemName: "flame.fill")
                                .foregroundColor(.snapOrange)
                            Text("\(streakManager.streakData.currentStreak)")
                                .font(.faroBold(size: 18))
                                .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.snapOrange.opacity(0.2))
                        .cornerRadius(20)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    // Calendrier hebdomadaire
                    WeekCalendarView()
                        .padding(.horizontal)

                    // XP Progress Bar
                    XPProgressView()
                        .padding(.horizontal)

                    // Section "Next Wake Up"
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Next Wake Up")
                            .font(.faroBold(size: 22))
                            .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                            .padding(.horizontal)

                        if let alarm = nextAlarm {
                            Button(action: { showingEditTime = true }) {
                                VStack(spacing: 12) {
                                    HStack {
                                        Text(alarm.daysDescription)
                                            .font(.faro(size: 16))
                                            .foregroundColor(Color.snapTextSecondary(for: colorScheme))

                                        Spacer()

                                        Image(systemName: "alarm")
                                            .foregroundColor(.snapBlue)
                                    }

                                    HStack(alignment: .lastTextBaseline) {
                                        Text(alarm.formattedTime)
                                            .font(.faroBold(size: 56))
                                            .foregroundColor(Color.snapTextPrimary(for: colorScheme))

                                        Spacer()

                                        Toggle("", isOn: Binding(
                                            get: { alarm.isEnabled },
                                            set: { _ in alarmManager.toggleAlarm(alarm) }
                                        ))
                                        .labelsHidden()
                                        .tint(.snapOrange)
                                    }

                                    HStack(spacing: 8) {
                                        Image(systemName: "moon.zzz.fill")
                                            .font(.system(size: 14))
                                            .foregroundColor(.snapPurple)
                                        Text("\(calculateTimeUntil(alarm.time)) until your next alarm")
                                            .font(.faro(size: 14))
                                            .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding()
                                .background(Color.snapCard(for: colorScheme))
                                .cornerRadius(16)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.horizontal)
                        } else {
                            // État vide - Créer une alarme
                            Button(action: { showingAddAlarm = true }) {
                                HStack(spacing: 12) {
                                    // Image à gauche (1.25x plus grande)
                                    Image("mascotte_alarm")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 112, height: 112)

                                    // Texte à droite - 3 lignes séparées
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("No alarm set")
                                            .font(.system(size: 20, weight: .bold, design: .rounded))
                                            .foregroundColor(Color.snapTextPrimary(for: colorScheme))

                                        Text("Tap to create your first alarm")
                                            .font(.system(size: 13, weight: .medium, design: .rounded))
                                            .foregroundColor(Color.snapTextSecondary(for: colorScheme))

                                        HStack(spacing: 6) {
                                            Image(systemName: "plus.circle.fill")
                                                .font(.system(size: 12))
                                            Text("Create Alarm")
                                                .font(.system(size: 13, weight: .bold, design: .rounded))
                                        }
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 7)
                                        .background(LinearGradient.snapSunrise)
                                        .cornerRadius(16)
                                    }

                                    Spacer()
                                }
                                .padding(16)
                                .frame(maxWidth: .infinity)
                                .background(Color.snapCard(for: colorScheme))
                                .cornerRadius(16)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.horizontal)
                        }
                    }

                    // Cards Mission et Sound
                    if let alarm = nextAlarm {
                        HStack(spacing: 16) {
                            MissionCard(alarm: alarm)

                            SoundCard(soundName: alarm.sound) {
                                showingSounds = true
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Stay Committed Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Stay Committed")
                            .font(.faroBold(size: 22))
                            .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                            .padding(.horizontal)

                        VStack(spacing: 12) {
                            // My Reason Card
                            Button(action: { showingMyReason = true }) {
                                HStack(spacing: 16) {
                                    ZStack {
                                        Circle()
                                            .fill(LinearGradient(colors: [.orange, .yellow], startPoint: .topLeading, endPoint: .bottomTrailing))
                                            .frame(width: 50, height: 50)

                                        Image(systemName: "pencil.line")
                                            .font(.system(size: 22))
                                            .foregroundColor(.white)
                                    }

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("My Reason")
                                            .font(.faroBold(size: 17))
                                            .foregroundColor(Color.snapTextPrimary(for: colorScheme))

                                        Text(commitmentManager.myReason.isEmpty ? "Your reason for waking up" : commitmentManager.myReason)
                                            .font(.faro(size: 14))
                                            .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                                            .lineLimit(1)
                                    }

                                    Spacer()

                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                                        .font(.system(size: 14))
                                }
                                .padding()
                                .background(Color.snapCard(for: colorScheme))
                                .cornerRadius(12)
                            }
                            .buttonStyle(PlainButtonStyle())

                            // Goal Committed Card
                            Button(action: { showingGoalCommitted = true }) {
                                HStack(spacing: 16) {
                                    ZStack {
                                        Circle()
                                            .fill(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                                            .frame(width: 50, height: 50)

                                        Image(systemName: "hand.raised.fill")
                                            .font(.system(size: 22))
                                            .foregroundColor(.white)
                                    }

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Goal Committed")
                                            .font(.faroBold(size: 17))
                                            .foregroundColor(Color.snapTextPrimary(for: colorScheme))

                                        if let commitTime = commitmentManager.goalCommittedTime {
                                            Text("Sealed at \(formatCommitTime(commitTime))")
                                                .font(.faro(size: 14))
                                                .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                                        } else {
                                            Text("Make your commitment")
                                                .font(.faro(size: 14))
                                                .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                                        }
                                    }

                                    Spacer()

                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                                        .font(.system(size: 14))
                                }
                                .padding()
                                .background(Color.snapCard(for: colorScheme))
                                .cornerRadius(12)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal)
                    }

                    // Test Missions section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Test Missions")
                            .font(.faroBold(size: 22))
                            .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                            .padding(.horizontal)

                        Text("Try out different mission types")
                            .font(.faro(size: 14))
                            .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                            .padding(.horizontal)

                        // Test Mission Intro button
                        Button(action: { showingMissionIntro = true }) {
                            HStack(spacing: 16) {
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [Color.snapOrange, Color.snapPink],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 50, height: 50)

                                    Image(systemName: "star.fill")
                                        .font(.system(size: 22))
                                        .foregroundColor(.white)
                                }

                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Mission Intro Screen")
                                        .font(.faroBold(size: 16))
                                        .foregroundColor(Color.snapTextPrimary(for: colorScheme))

                                    Text("Preview the Good Morning animation")
                                        .font(.faro(size: 13))
                                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                                    .font(.system(size: 14))
                            }
                            .padding()
                            .background(Color.snapCard(for: colorScheme))
                            .cornerRadius(12)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal)

                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            ForEach(MissionsLibrary.shared.missions.filter { !$0.isNoMission && $0.type != .random }) { mission in
                                Button(action: {
                                    testMission(mission)
                                }) {
                                    VStack(spacing: 12) {
                                        ZStack {
                                            Circle()
                                                .fill(
                                                    LinearGradient(
                                                        colors: mission.gradient,
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    )
                                                )
                                                .frame(width: 60, height: 60)

                                            Image(systemName: mission.icon)
                                                .font(.system(size: 28))
                                                .foregroundColor(.white)
                                        }

                                        Text(mission.name)
                                            .font(.faroBold(size: 14))
                                            .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                                            .lineLimit(1)

                                        Text("Tap to test")
                                            .font(.faro(size: 11))
                                            .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                                    }
                                    .padding(.vertical, 16)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.snapCard(for: colorScheme))
                                    .cornerRadius(16)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Wake Up History section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Wake Up History")
                            .font(.faroBold(size: 22))
                            .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                            .padding(.horizontal)

                        WakeUpHistoryCard()
                            .padding(.horizontal)
                    }

                    Spacer(minLength: 40)
                }
                .padding(.vertical)
            }
            .background(Color.snapBackground(for: colorScheme))
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingEditTime) {
            if let alarm = nextAlarm {
                EditAlarmView(alarm: alarm)
            }
        }
        .sheet(isPresented: $showingSounds) {
            if let alarm = nextAlarm {
                SoundsView(selectedSoundName: Binding(
                    get: { alarm.sound },
                    set: { newSound in
                        var updatedAlarm = alarm
                        updatedAlarm.sound = newSound
                        alarmManager.updateAlarm(updatedAlarm)
                    }
                ))
                .presentationDragIndicator(.hidden)
                .interactiveDismissDisabled()
            }
        }
        .sheet(isPresented: $showingAddAlarm) {
            EditAlarmView(alarm: nil)
        }
        .sheet(isPresented: $showingMyReason) {
            MyReasonView()
                .presentationDragIndicator(.hidden)
        }
        .sheet(isPresented: $showingGoalCommitted) {
            GoalCommittedView()
                .presentationDragIndicator(.hidden)
        }
        .fullScreenCover(isPresented: $showingMissionIntro) {
            if let mathMission = MissionsLibrary.shared.missions.first(where: { $0.type == .math }) {
                MissionIntroView(mission: mathMission) {
                    // Ne rien faire - juste fermer
                    showingMissionIntro = false
                }
            }
        }
        .fullScreenCover(isPresented: $showingOnboarding) {
            CompleteOnboardingView(isComplete: $onboardingComplete)
                .onChange(of: onboardingComplete) { newValue in
                    if newValue {
                        showingOnboarding = false
                    }
                }
        }
        .fullScreenCover(isPresented: $showingOnboardingV2) {
            OnboardingV2View(isComplete: $onboardingComplete)
                .onChange(of: onboardingComplete) { newValue in
                    if newValue {
                        showingOnboardingV2 = false
                    }
                }
        }
    }

    private func calculateTimeUntil(_ alarmTime: Date) -> String {
        guard let alarm = nextAlarm else { return "0 h 0 m" }

        let now = Date()
        let calendar = Calendar.current

        // Extraire l'heure et les minutes de l'alarme
        let alarmComponents = calendar.dateComponents([.hour, .minute], from: alarmTime)
        guard let alarmHour = alarmComponents.hour, let alarmMinute = alarmComponents.minute else {
            return "0 h 0 m"
        }

        // Jour actuel
        let currentWeekday = calendar.component(.weekday, from: now)

        // Trouver le prochain jour où l'alarme sonne
        var nextAlarmDate: Date?

        // Chercher dans les 7 prochains jours
        for daysAhead in 0..<7 {
            let futureDate = calendar.date(byAdding: .day, value: daysAhead, to: now)!
            let futureWeekday = calendar.component(.weekday, from: futureDate)

            // Convertir weekday (1=dimanche, 2=lundi...) en Weekday enum
            let weekdayEnum = Weekday(rawValue: futureWeekday)!

            // Vérifier si l'alarme sonne ce jour-là
            if alarm.selectedDays.contains(weekdayEnum) {
                // Créer la date avec l'heure de l'alarme
                var dateComponents = calendar.dateComponents([.year, .month, .day], from: futureDate)
                dateComponents.hour = alarmHour
                dateComponents.minute = alarmMinute
                dateComponents.second = 0

                if let candidateDate = calendar.date(from: dateComponents) {
                    // Si c'est aujourd'hui, vérifier que l'heure n'est pas passée
                    if daysAhead == 0 && candidateDate <= now {
                        continue
                    }
                    nextAlarmDate = candidateDate
                    break
                }
            }
        }

        guard let nextDate = nextAlarmDate else { return "0 h 0 m" }

        let timeInterval = nextDate.timeIntervalSince(now)
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60

        return "\(hours) h \(minutes) m"
    }

    private func formatCommitTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    private func testAlarm() {
        guard let alarm = nextAlarm else {
            // Create a test alarm if none exists
            let testAlarm = Alarm(
                name: "Test Alarm",
                time: Date(),
                isEnabled: true,
                selectedDays: [.monday, .tuesday],
                difficulty: .medium,
                sound: "Default",
                missionId: MissionsLibrary.shared.missions.first(where: { $0.type == .math })?.id
            )
            alarmManager.triggerAlarm(testAlarm)
            return
        }
        alarmManager.triggerAlarm(alarm)
    }

    private func testMission(_ mission: Mission) {
        // Create a test alarm with this specific mission
        let testAlarm = Alarm(
            name: "Test: \(mission.name)",
            time: Date(),
            isEnabled: true,
            selectedDays: [.monday, .tuesday, .wednesday, .thursday, .friday],
            difficulty: .medium,
            sound: "Default",
            missionId: mission.id
        )
        alarmManager.triggerAlarm(testAlarm)
    }
}

struct WeekCalendarView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var streakManager = StreakManager.shared

    var weekDays: [Date] {
        let calendar = Calendar.current
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)

        // Dimanche = 1, donc on calcule le dimanche de cette semaine
        let sundayOffset = -(weekday - 1)
        let sunday = calendar.date(byAdding: .day, value: sundayOffset, to: today) ?? today

        return (0..<7).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: sunday)
        }
    }

    var body: some View {
        HStack(spacing: 12) {
            ForEach(weekDays, id: \.self) { date in
                VStack(spacing: 8) {
                    // Indicateur de wake up
                    let hasWakeUp = streakManager.streakData.hasWakeUp(on: date)

                    Circle()
                        .fill(hasWakeUp ? Color.green : Color.gray.opacity(0.3))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: hasWakeUp ? "checkmark" : "minus")
                                .foregroundColor(hasWakeUp ? .white : .gray)
                                .font(.system(size: 16, weight: .bold))
                        )

                    // Lettre du jour
                    Text(dayLetter(for: date))
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                }
            }
        }
    }

    private func dayLetter(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEEE" // Premier caractère du jour
        return formatter.string(from: date).uppercased()
    }
}

// Mission Card
struct MissionCard: View {
    @Environment(\.colorScheme) var colorScheme
    let alarm: Alarm

    var mission: Mission? {
        alarm.mission
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Titre de la mission en haut à gauche
            VStack(alignment: .leading, spacing: 4) {
                Text(mission?.name ?? "No Mission")
                    .font(.faroBold(size: 16))
                    .foregroundColor(Color.snapTextPrimary(for: colorScheme))

                Text("Mission")
                    .font(.faro(size: 13))
                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))
            }

            Spacer()

            // Icone en bas à droite
            HStack {
                Spacer()

                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: mission?.gradient ?? [.gray],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)

                    Image(systemName: mission?.icon ?? "questionmark")
                        .font(.system(size: 22))
                        .foregroundColor(.white)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 120)
        .background(Color.snapCard(for: colorScheme))
        .cornerRadius(16)
    }
}

// Sound Card
struct SoundCard: View {
    @Environment(\.colorScheme) var colorScheme
    let soundName: String
    let action: () -> Void

    var sound: AlarmSound {
        SoundsLibrary.shared.sound(named: soundName) ?? SoundsLibrary.shared.sounds[0]
    }

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 0) {
                // Nom du son en haut à gauche
                VStack(alignment: .leading, spacing: 4) {
                    Text(sound.name)
                        .font(.faroBold(size: 16))
                        .foregroundColor(Color.snapTextPrimary(for: colorScheme))

                    Text("Alarm Sound")
                        .font(.faro(size: 13))
                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                }

                Spacer()

                // Icone en bas à droite
                HStack {
                    Spacer()

                    ZStack {
                        Circle()
                            .fill(LinearGradient.snapNight)
                            .frame(width: 50, height: 50)

                        Image(systemName: "speaker.wave.2.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 120)
            .background(Color.snapCard(for: colorScheme))
            .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Wake Up History Card
struct WakeUpHistoryCard: View {
    @StateObject private var streakManager = StreakManager.shared
    @StateObject private var insightsManager = InsightsManager.shared

    var lastWakeUpTime: String {
        guard let lastWakeUp = insightsManager.insightsData.wakeUpRecords.last else {
            return "--:--"
        }
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: lastWakeUp.wakeUpTime)
    }

    var body: some View {
        VStack(spacing: 16) {
            // Image de fond étoilé
            ZStack {
                LinearGradient.snapNight
                .overlay(
                    GeometryReader { geometry in
                        ForEach(0..<30, id: \.self) { _ in
                            Circle()
                                .fill(Color.white.opacity(0.8))
                                .frame(width: CGFloat.random(in: 1...3))
                                .position(
                                    x: CGFloat.random(in: 0...geometry.size.width),
                                    y: CGFloat.random(in: 0...geometry.size.height)
                                )
                        }
                    }
                )

                VStack(spacing: 12) {
                    HStack {
                        HStack(spacing: 4) {
                            Image(systemName: "flame.fill")
                                .foregroundColor(.white)
                            Text("\(streakManager.streakData.currentStreak)")
                                .font(.faroBold(size: 16))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(16)

                        Spacer()

                        Text("TODAY")
                            .font(.faroBold(size: 12))
                            .foregroundColor(.white.opacity(0.8))
                    }

                    Spacer()

                    Text("WAKE UP TIME")
                        .font(.faroBold(size: 12))
                        .foregroundColor(.white.opacity(0.9))
                        .tracking(2)

                    // Last wake up time
                    Text(lastWakeUpTime)
                        .font(.faroBold(size: 36))
                        .foregroundColor(.white)

                    Spacer()

                    Text("Wake #\(streakManager.streakData.weeklyWakeUps.count)")
                        .font(.faro(size: 14))
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding()
            }
            .frame(height: 280)
            .cornerRadius(20)
        }
    }
}

// MARK: - XP Progress View

struct XPProgressView: View {
    @StateObject private var xpManager = XPManager.shared
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationLink(destination: InsightsView()) {
            VStack(alignment: .leading, spacing: 12) {
                // Level and name
                HStack {
                    Text("Level \(xpManager.xpData.currentLevel.number)")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(Color.snapTextPrimary(for: colorScheme))

                    Text("— \(xpManager.xpData.currentLevel.name)")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                }

                // Progress bar
                let progress = Level.progress(for: xpManager.xpData.totalXP)

                VStack(alignment: .leading, spacing: 4) {
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            // Background
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.15))

                            // Progress fill
                            RoundedRectangle(cornerRadius: 8)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.snapOrange, Color.snapPink],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: geometry.size.width * CGFloat(progress.percentage))
                        }
                    }
                    .frame(height: 12)

                    // XP text
                    Text("\(progress.current) / \(progress.needed) XP")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                }
            }
            .padding(16)
            .background(Color.snapCard(for: colorScheme))
            .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    HomeView()
}
