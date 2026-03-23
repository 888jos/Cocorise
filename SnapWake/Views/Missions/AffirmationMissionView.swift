//
//  AffirmationMissionView.swift
//  SnapWake
//
//  Mission d'affirmation avec enregistrement vocal
//

import SwiftUI
import AVFoundation

struct AffirmationMissionView: View {
    let mission: Mission
    let onComplete: (Bool) -> Void

    @StateObject private var audioRecorder = AudioRecorderService()
    @State private var selectedAffirmation: String = ""
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

                    Text("Say your affirmation")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.gray)
                }

                Spacer()

                // Affirmation card
                VStack(spacing: 24) {
                    Image(systemName: "quote.bubble.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.snapOrange)

                    Text(selectedAffirmation)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .lineSpacing(8)
                        .padding(.horizontal, 40)

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
            selectedAffirmation = Affirmations.affirmations.randomElement() ?? Affirmations.affirmations[0]
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

        isVerifying = true
        verificationResult = nil

        AIVerificationService.shared.verifyAudio(
            audioURL: recordingURL,
            expectedText: selectedAffirmation
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

// MARK: - Audio Recorder Service
@MainActor
class AudioRecorderService: NSObject, ObservableObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    @Published var hasPermission = false

    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    var recordingURL: URL?
    private var playbackCompletion: ((Bool) -> Void)?

    override init() {
        super.init()
        setupAudioSession()
    }

    func requestPermission() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
                self.hasPermission = granted
            }
        }
    }

    private func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }

    func startRecording() {
        // Create unique file URL
        let tempDir = FileManager.default.temporaryDirectory
        recordingURL = tempDir.appendingPathComponent("affirmation_\(UUID().uuidString).m4a")

        guard let url = recordingURL else { return }

        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
        } catch {
            print("Failed to start recording: \(error)")
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
    }

    func playRecording(completion: @escaping (Bool) -> Void) {
        guard let url = recordingURL else {
            completion(false)
            return
        }

        playbackCompletion = completion

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.play()
        } catch {
            print("Failed to play recording: \(error)")
            completion(false)
        }
    }

    func stopPlaying() {
        audioPlayer?.stop()
        playbackCompletion?(false)
        playbackCompletion = nil
    }

    // MARK: - AVAudioPlayerDelegate
    nonisolated func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        Task { @MainActor in
            playbackCompletion?(flag)
            playbackCompletion = nil
        }
    }
}

#Preview {
    AffirmationMissionView(
        mission: Mission(
            name: "Affirmation",
            description: "Say your affirmation out loud",
            icon: "quote.bubble.fill",
            gradient: [.pink, .red],
            category: .easy,
            type: .text
        )
    ) { _ in }
}
