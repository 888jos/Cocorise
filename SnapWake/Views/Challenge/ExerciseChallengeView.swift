//
//  ExerciseChallengeView.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import SwiftUI
import AVFoundation

struct ExerciseChallengeView: View {
    @Environment(\.colorScheme) var colorScheme
    let mission: Mission
    let difficulty: Difficulty
    let onComplete: (Bool) -> Void

    @State private var showCamera = false
    @State private var isRecording = false
    @State private var recordingComplete = false
    @State private var timeRemaining: TimeInterval
    @State private var timer: Timer?
    @State private var recordingDuration = 0.0
    @State private var recordingTimer: Timer?

    private var requiredDuration: Double {
        switch difficulty {
        case .easy: return 10.0
        case .medium: return 15.0
        case .hard: return 20.0
        case .impossible: return 30.0
        }
    }

    private var repsRequired: Int {
        switch difficulty {
        case .easy: return 5
        case .medium: return 10
        case .hard: return 15
        case .impossible: return 20
        }
    }

    init(mission: Mission, difficulty: Difficulty, onComplete: @escaping (Bool) -> Void) {
        self.mission = mission
        self.difficulty = difficulty
        self.onComplete = onComplete
        _timeRemaining = State(initialValue: difficulty.timeLimit)
    }

    var body: some View {
        ZStack {
            Color.snapBackground(for: colorScheme)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: mission.icon)
                            .font(.system(size: 32))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: mission.gradient,
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )

                        Spacer()

                        Text(formatTime(timeRemaining))
                            .font(.faroBold(size: 24))
                            .foregroundColor(timeRemaining < 30 ? .red : Color.snapTextPrimary(for: colorScheme))
                    }

                    Text(mission.name)
                        .font(.faroBold(size: 28))
                        .foregroundColor(Color.snapTextPrimary(for: colorScheme))

                    Text("Do \(repsRequired) \(mission.name.lowercased()) while recording")
                        .font(.faro(size: 14))
                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                }
                .padding()

                Spacer()

                if recordingComplete {
                    VStack(spacing: 24) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 100))
                            .foregroundColor(.snapGreen)

                        Text("Exercise Complete!")
                            .font(.faroBold(size: 28))
                            .foregroundColor(Color.snapTextPrimary(for: colorScheme))

                        Text("Great job! You did it 💪")
                            .font(.faro(size: 16))
                            .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                    }
                } else if isRecording {
                    VStack(spacing: 32) {
                        ZStack {
                            Circle()
                                .stroke(Color.snapCard(for: colorScheme), lineWidth: 15)
                                .frame(width: 200, height: 200)

                            Circle()
                                .trim(from: 0, to: recordingDuration / requiredDuration)
                                .stroke(
                                    LinearGradient(
                                        colors: [Color.red, Color.orange],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ),
                                    style: StrokeStyle(lineWidth: 15, lineCap: .round)
                                )
                                .frame(width: 200, height: 200)
                                .rotationEffect(.degrees(-90))

                            VStack(spacing: 8) {
                                Image(systemName: "record.circle.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.red)
                                    .symbolEffect(.pulse)

                                Text(String(format: "%.1fs", recordingDuration))
                                    .font(.faroBold(size: 24))
                                    .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                            }
                        }

                        Text("Keep going! Record for \(Int(requiredDuration)) seconds")
                            .font(.faroBold(size: 18))
                            .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                            .multilineTextAlignment(.center)

                        Button(action: stopRecording) {
                            Text("Stop Recording")
                                .font(.faroBold(size: 16))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.red)
                                .cornerRadius(16)
                        }
                        .padding(.horizontal, 32)
                    }
                } else {
                    VStack(spacing: 32) {
                        VStack(spacing: 16) {
                            Image(systemName: "video.fill")
                                .font(.system(size: 80))
                                .foregroundColor(Color.snapTextSecondary(for: colorScheme))

                            VStack(spacing: 8) {
                                Text("Instructions:")
                                    .font(.faroBold(size: 18))
                                    .foregroundColor(Color.snapTextPrimary(for: colorScheme))

                                VStack(alignment: .leading, spacing: 8) {
                                    HStack(alignment: .top, spacing: 12) {
                                        Text("1.")
                                            .font(.faro(size: 16))
                                        Text("Start recording video")
                                            .font(.faro(size: 16))
                                    }
                                    HStack(alignment: .top, spacing: 12) {
                                        Text("2.")
                                            .font(.faro(size: 16))
                                        Text("Do \(repsRequired) \(mission.name.lowercased())")
                                            .font(.faro(size: 16))
                                    }
                                    HStack(alignment: .top, spacing: 12) {
                                        Text("3.")
                                            .font(.faro(size: 16))
                                        Text("Record for at least \(Int(requiredDuration)) seconds")
                                            .font(.faro(size: 16))
                                    }
                                }
                                .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                                .padding()
                                .background(Color.snapCard(for: colorScheme))
                                .cornerRadius(12)
                            }
                        }

                        Button(action: startRecording) {
                            HStack(spacing: 12) {
                                Image(systemName: "video.circle.fill")
                                    .font(.system(size: 24))
                                Text("Start Recording")
                                    .font(.faroBold(size: 18))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    colors: [Color.red, Color.orange],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                        }
                        .padding(.horizontal, 32)
                    }
                }

                Spacer()
            }
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            timer?.invalidate()
            recordingTimer?.invalidate()
        }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
                onComplete(false)
            }
        }
    }

    private func startRecording() {
        isRecording = true
        recordingDuration = 0

        recordingTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            recordingDuration += 0.1

            if recordingDuration >= requiredDuration {
                stopRecording()
            }
        }
    }

    private func stopRecording() {
        recordingTimer?.invalidate()
        isRecording = false

        if recordingDuration >= requiredDuration {
            recordingComplete = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                timer?.invalidate()
                onComplete(true)
            }
        }
    }

    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

#Preview {
    ExerciseChallengeView(
        mission: MissionsLibrary.shared.missions.first(where: { $0.name == "Push Ups" })!,
        difficulty: .medium
    ) { _ in }
}
