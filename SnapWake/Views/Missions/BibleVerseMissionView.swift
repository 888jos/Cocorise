//
//  BibleVerseMissionView.swift
//  SnapWake
//
//  Mission Bible Verse avec enregistrement vocal
//

import SwiftUI
import AVFoundation

struct BibleVerseMissionView: View {
    let mission: Mission
    let onComplete: (Bool) -> Void

    @StateObject private var audioRecorder = AudioRecorderService()
    @State private var selectedVerse: BibleVerse?
    @State private var isRecording = false
    @State private var hasRecorded = false
    @State private var isPlaying = false
    @State private var recordingDuration: TimeInterval = 0
    @State private var timer: Timer?
    @State private var isVerifying = false
    @State private var verificationResult: String?

    var body: some View {
        ZStack {
            Color.snapLightBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                VStack(spacing: 12) {
                    HStack {
                        ForEach(0..<3, id: \.self) { index in
                            Circle()
                                .fill(getStepColor(index))
                                .frame(width: 10, height: 10)
                        }
                    }
                    .padding(.top, 60)

                    Text("Read the verse out loud")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.gray)
                }

                Spacer()

                // Bible verse card
                if let verse = selectedVerse {
                    VStack(spacing: 24) {
                        Image(systemName: "book.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.snapOrange)

                        VStack(spacing: 16) {
                            Text(verse.text)
                                .font(.system(size: 22, weight: .medium))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .lineSpacing(8)
                                .padding(.horizontal, 30)

                            Text("— \(verse.reference)")
                                .font(.system(size: 16, weight: .semibold, design: .serif))
                                .foregroundColor(.snapOrange)
                        }

                        Text("Read it out loud and record yourself")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 40)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.05), radius: 10)
                    .padding(.horizontal, 20)
                }

                Spacer()

                // Recording controls
                VStack(spacing: 20) {
                    // Recording indicator
                    if isRecording {
                        HStack(spacing: 12) {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 12, height: 12)
                                .opacity(isRecording ? 1 : 0)
                                .animation(.easeInOut(duration: 1).repeatForever(), value: isRecording)

                            Text(formatTime(recordingDuration))
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.black)
                                .monospacedDigit()
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.white)
                        .cornerRadius(25)
                    }

                    // Main action button
                    if !hasRecorded {
                        // Record button
                        Button(action: toggleRecording) {
                            ZStack {
                                Circle()
                                    .fill(isRecording ? Color.red : Color.snapOrange)
                                    .frame(width: 80, height: 80)
                                    .shadow(color: Color.black.opacity(0.2), radius: 10)

                                if isRecording {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.white)
                                        .frame(width: 30, height: 30)
                                } else {
                                    Image(systemName: "mic.fill")
                                        .font(.system(size: 32))
                                        .foregroundColor(.white)
                                }
                            }
                        }

                        Text(isRecording ? "Tap to stop" : "Tap to record")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                    } else {
                        // Playback and submit controls
                        HStack(spacing: 20) {
                            // Play button
                            Button(action: playRecording) {
                                HStack(spacing: 10) {
                                    Image(systemName: isPlaying ? "stop.fill" : "play.fill")
                                        .font(.system(size: 18))
                                    Text(isPlaying ? "Stop" : "Listen")
                                        .font(.system(size: 16, weight: .semibold))
                                }
                                .foregroundColor(.black)
                                .frame(width: 140)
                                .padding(.vertical, 18)
                                .background(Color.white)
                                .cornerRadius(30)
                                .shadow(color: Color.black.opacity(0.05), radius: 5)
                            }

                            // Re-record button
                            Button(action: {
                                hasRecorded = false
                                recordingDuration = 0
                            }) {
                                Image(systemName: "arrow.clockwise")
                                    .font(.system(size: 20))
                                    .foregroundColor(.gray)
                                    .frame(width: 50, height: 50)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .shadow(color: Color.black.opacity(0.05), radius: 5)
                            }
                        }

                        // Verification result
                        if let result = verificationResult {
                            HStack(spacing: 12) {
                                Image(systemName: result.contains("Great") ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(result.contains("Great") ? .green : .red)

                                Text(result)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.black)
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 14)
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.05), radius: 5)
                            .padding(.top, 10)
                        }

                        // Complete button
                        Button(action: verifyAndComplete) {
                            HStack(spacing: 12) {
                                if isVerifying {
                                    ProgressView()
                                        .tint(.white)
                                    Text("Verifying...")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.white)
                                } else {
                                    Text("Complete")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Color.black)
                            .cornerRadius(30)
                        }
                        .padding(.horizontal, 32)
                        .padding(.top, 10)
                    }
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            // Select random verse
            selectedVerse = BibleVerses.allVerses.randomElement()
            audioRecorder.requestPermission()
        }
        .onDisappear {
            stopTimer()
            audioRecorder.stopRecording()
            audioRecorder.stopPlaying()
        }
    }

    private func getStepColor(_ index: Int) -> Color {
        if index == 0 && !isRecording && !hasRecorded {
            return .snapOrange
        } else if index == 1 && isRecording {
            return .snapOrange
        } else if index == 2 && hasRecorded {
            return .snapOrange
        }
        return Color.gray.opacity(0.3)
    }

    private func toggleRecording() {
        if isRecording {
            // Stop recording
            audioRecorder.stopRecording()
            stopTimer()
            isRecording = false
            hasRecorded = true
        } else {
            // Start recording
            audioRecorder.startRecording()
            isRecording = true
            recordingDuration = 0
            startTimer()
        }
    }

    private func playRecording() {
        if isPlaying {
            audioRecorder.stopPlaying()
            isPlaying = false
        } else {
            audioRecorder.playRecording { finished in
                if finished {
                    isPlaying = false
                }
            }
            isPlaying = true
        }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            recordingDuration += 0.1
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        let milliseconds = Int((time.truncatingRemainder(dividingBy: 1)) * 10)
        return String(format: "%02d:%02d.%01d", minutes, seconds, milliseconds)
    }

    private func verifyAndComplete() {
        guard let recordingURL = audioRecorder.recordingURL else {
            verificationResult = "No recording found"
            return
        }

        guard let verse = selectedVerse else {
            verificationResult = "No verse selected"
            return
        }

        isVerifying = true
        verificationResult = nil

        AIVerificationService.shared.verifyAudio(
            audioURL: recordingURL,
            expectedText: verse.text
        ) { success, message in
            isVerifying = false
            verificationResult = message

            if success {
                // Wait 1.5 seconds then complete
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    onComplete(true)
                }
            }
        }
    }
}

#Preview {
    BibleVerseMissionView(
        mission: Mission(
            name: "Bible Verse",
            description: "Read a Bible verse out loud",
            icon: "book.fill",
            gradient: [.purple, .orange],
            category: .medium,
            type: .text
        )
    ) { _ in }
}
