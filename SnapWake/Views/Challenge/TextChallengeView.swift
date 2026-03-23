//
//  TextChallengeView.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import SwiftUI

struct TextChallengeView: View {
    @Environment(\.colorScheme) var colorScheme
    let mission: Mission
    let difficulty: Difficulty
    let onComplete: (Bool) -> Void

    @State private var currentText: String = ""
    @State private var isRecording = false
    @State private var hasRead = false
    @State private var timeRemaining: TimeInterval
    @State private var timer: Timer?

    private let affirmations = [
        "Today is going to be a great day",
        "I am capable of achieving my goals",
        "I choose to be positive and productive",
        "I am grateful for this new day",
        "I have the power to create change"
    ]

    private let verses = [
        "This is the day that the Lord has made; let us rejoice and be glad in it. - Psalm 118:24",
        "I can do all things through Christ who strengthens me. - Philippians 4:13",
        "The Lord is my strength and my shield. - Psalm 28:7",
        "Be strong and courageous. Do not be afraid. - Joshua 1:9",
        "For I know the plans I have for you, declares the Lord. - Jeremiah 29:11"
    ]

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

                    Text("Read the text below out loud")
                        .font(.faro(size: 14))
                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                }
                .padding()

                Spacer()

                // Text to read
                VStack(spacing: 24) {
                    ScrollView {
                        Text(currentText)
                            .font(.faroBold(size: 20))
                            .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                            .multilineTextAlignment(.center)
                            .padding(24)
                            .background(Color.snapCard(for: colorScheme))
                            .cornerRadius(16)
                            .padding(.horizontal)
                    }
                    .frame(maxHeight: 300)

                    if !hasRead {
                        VStack(spacing: 16) {
                            Image(systemName: isRecording ? "waveform.circle.fill" : "mic.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(isRecording ? .red : .snapOrange)
                                .symbolEffect(.pulse, isActive: isRecording)

                            Text(isRecording ? "Listening..." : "Tap to read aloud")
                                .font(.faro(size: 16))
                                .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                        }
                    }
                }

                Spacer()

                // Action button
                if !hasRead {
                    Button(action: startReading) {
                        Text(isRecording ? "I've Read It" : "Start Reading")
                            .font(.faroBold(size: 18))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    colors: isRecording ? [.snapGreen, .green] : [Color.snapOrange, Color.snapPink],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 32)
                } else {
                    VStack(spacing: 16) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.snapGreen)

                        Text("Great job! Alarm dismissed")
                            .font(.faroBold(size: 18))
                            .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                    }
                    .padding(.bottom, 32)
                }
            }
        }
        .onAppear {
            startTimer()
            loadText()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }

    private func loadText() {
        if mission.name == "Bible Verse" {
            currentText = verses.randomElement() ?? verses[0]
        } else {
            currentText = affirmations.randomElement() ?? affirmations[0]
        }
    }

    private func startReading() {
        if !isRecording {
            isRecording = true
        } else {
            // User claims they've read it
            hasRead = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                timer?.invalidate()
                onComplete(true)
            }
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

    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

#Preview {
    TextChallengeView(
        mission: MissionsLibrary.shared.missions.first(where: { $0.name == "Affirmation" })!,
        difficulty: .easy
    ) { _ in }
}
