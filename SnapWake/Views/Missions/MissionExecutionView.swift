//
//  MissionExecutionView.swift
//  SnapWake
//
//  Écran principal d'exécution des missions
//

import SwiftUI
import AVFoundation
import Lottie

struct MissionExecutionView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var alarmManager = AlarmManager.shared
    @StateObject private var xpManager = XPManager.shared
    @StateObject private var leagueManager = LeagueManager.shared
    @AppStorage("strictModeEnabled") private var strictModeEnabled = false

    let alarm: Alarm
    let mission: Mission

    @State private var isCompleted = false
    @State private var showingSuccess = false
    @State private var showingCompletion = false
    @State private var selectedHuntObject: HuntObject?
    @State private var showingObjectPicker = true
    @State private var startTime = Date()
    @State private var completionTime: TimeInterval = 0

    init(alarm: Alarm) {
        self.alarm = alarm
        self.mission = alarm.mission ?? MissionsLibrary.shared.missions[0]

        // For Object Hunt, we'll show the gambling animation first
        _showingObjectPicker = State(initialValue: mission.type == .photo && mission.name == "Object Hunt")
    }

    var body: some View {
        ZStack {
            Color.snapLightBackground.ignoresSafeArea()

            // Show gambling animation for Object Hunt first
            if mission.type == .photo && mission.name == "Object Hunt" && showingObjectPicker {
                ObjectHuntPickerView(
                    availableObjects: getAvailableObjects(),
                    onObjectSelected: { selectedObject in
                        selectedHuntObject = selectedObject
                        showingObjectPicker = false
                    }
                )
            } else {
                // Mission-specific view
                Group {
                    switch mission.type {
                    case .photo:
                        PhotoMissionView(
                            mission: mission,
                            huntObject: selectedHuntObject,
                            onComplete: handleCompletion
                        )
                    case .exercise:
                        ExerciseMissionView(
                            mission: mission,
                            onComplete: handleCompletion
                        )
                    case .shake:
                        ShakeMissionView(
                            mission: mission,
                            onComplete: handleCompletion
                        )
                    case .math:
                        MathMissionView(
                            mission: mission,
                            onComplete: handleCompletion
                        )
                    case .text:
                        if mission.name == "Affirmation" {
                            AffirmationMissionView(
                                mission: mission,
                                onComplete: handleCompletion
                            )
                        } else if mission.name == "Bible Verse" {
                            BibleVerseMissionView(
                                mission: mission,
                                onComplete: handleCompletion
                            )
                        } else {
                            TextMissionView(
                                mission: mission,
                                onComplete: handleCompletion
                            )
                        }
                    default:
                        NoMissionView(onComplete: handleCompletion)
                    }
                }
            }

            // Success overlay
            if showingSuccess {
                MissionSuccessOverlay()
                    .transition(.scale.combined(with: .opacity))
            }

            // Completion screen with stats and XP
            if showingCompletion {
                MissionCompletionView(
                    mission: mission,
                    timeTaken: completionTime,
                    onDismiss: {
                        alarmManager.dismissAlarm(success: true)
                    }
                )
                .transition(.opacity)
            }

            // Discrete skip button (bottom left corner, always visible if strict mode OFF)
            VStack {
                Spacer()

                HStack {
                    if !strictModeEnabled {
                        Button(action: skipMission) {
                            Text("Skip")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.white.opacity(0.6))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(15)
                        }
                        .padding(.leading, 20)
                        .padding(.bottom, 140)
                    }

                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private func getAvailableObjects() -> [HuntObject] {
        // Get objects from mission config, or use all objects if none specified
        if let selectedItems = mission.config?.selectedItems, !selectedItems.isEmpty {
            return HuntObjects.allObjects.filter { selectedItems.contains($0.name) }
        }
        return HuntObjects.allObjects
    }

    private func handleCompletion(success: Bool) {
        // ⚠️ CRITICAL: Missions should NEVER call onComplete(false)
        // If user fails, mission view keeps them until they succeed
        // This guard is just a safety net - alarm keeps ringing if somehow success == false
        guard success else {
            print("⚠️ WARNING: Mission called onComplete(false) - this should never happen!")
            print("⚠️ Alarm will keep ringing until mission is completed")
            // DO NOT dismiss - user must complete mission!
            return
        }

        // Calculate completion time
        completionTime = Date().timeIntervalSince(startTime)

        // Award XP for mission completion
        xpManager.awardXP(for: mission.type)

        // Update league weekly XP if user is in a league
        if let profile = leagueManager.userProfile {
            let newTotalXP = xpManager.xpData.totalXP
            let newWeeklyXP = xpManager.xpData.weeklyXP
            leagueManager.updateUserXP(newTotalXP, weeklyXP: newWeeklyXP)
        }

        // Show success animation
        withAnimation(.spring()) {
            showingSuccess = true
        }

        // After 2 seconds, show completion screen with stats
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showingSuccess = false
                showingCompletion = true
            }
        }
    }

    private func skipMission() {
        // Don't call dismiss() - the fullScreenCover will auto-dismiss when currentlyRingingAlarm becomes nil
        alarmManager.dismissAlarm(success: false)
    }
}

// MARK: - Success Overlay
struct MissionSuccessOverlay: View {
    @State private var scale: CGFloat = 0.5
    @State private var rotation: Double = -180
    @State private var textOpacity: Double = 0
    @State private var showConfetti = false

    var body: some View {
        ZStack {
            // Bright energetic background
            Color.snapLightBackground
                .ignoresSafeArea()

            // Lottie Confetti Animation (fullscreen)
            if showConfetti {
                LottieView(
                    animationName: "confetti on transparent background",
                    loopMode: .playOnce,
                    contentMode: .scaleAspectFill,
                    animationSpeed: 1.0
                )
                .ignoresSafeArea()
                .allowsHitTesting(false)
            }

            // Main content
            VStack(spacing: 30) {
                Spacer()

                // Big checkmark with bounce
                ZStack {
                    Circle()
                        .fill(Color.snapOrange)
                        .frame(width: 140, height: 140)
                        .shadow(color: Color.snapOrange.opacity(0.4), radius: 20)

                    Image(systemName: "checkmark")
                        .font(.system(size: 70, weight: .bold))
                        .foregroundColor(.white)
                }
                .scaleEffect(scale)
                .rotationEffect(.degrees(rotation))

                // Success text
                VStack(spacing: 12) {
                    Text("Mission Complete!")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.black)

                    Text("You're unstoppable! 🔥")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.gray)
                }
                .opacity(textOpacity)

                // Motivational message
                Text("Great start to your day!")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.snapOrange)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 12)
                    .background(Color.snapOrange.opacity(0.1))
                    .cornerRadius(25)
                    .opacity(textOpacity)

                Spacer()
            }
        }
        .onAppear {
            // Bounce animation for checkmark
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                scale = 1.0
                rotation = 0
            }

            // Fade in text
            withAnimation(.easeIn(duration: 0.4).delay(0.3)) {
                textOpacity = 1.0
            }

            // Show confetti immediately
            showConfetti = true
        }
    }
}

#Preview {
    MissionExecutionView(alarm: Alarm())
}
