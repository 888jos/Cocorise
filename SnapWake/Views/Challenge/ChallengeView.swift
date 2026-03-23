//
//  ChallengeView.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import SwiftUI

struct ChallengeView: View {
    let alarm: Alarm
    @Environment(\.dismiss) private var dismiss
    @StateObject private var cameraService = CameraService()
    @StateObject private var alarmManager = AlarmManager.shared

    @State private var startTime = Date()
    @State private var isProcessing = false
    @State private var resultMessage = ""
    @State private var showResult = false
    @State private var challengeCompleted = false

    var elapsedTime: TimeInterval {
        Date().timeIntervalSince(startTime)
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                VStack(spacing: 8) {
                    Text("Find and photograph:")
                        .font(.headline)
                        .foregroundColor(.white)

                    if let challenge = alarm.currentChallenge {
                        Text(challenge.name.uppercased())
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.orange)
                            .multilineTextAlignment(.center)

                        Text(challenge.difficulty.rawValue)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }

                    // Timer
                    Text(formatTime(elapsedTime))
                        .font(.system(size: 20, weight: .semibold, design: .monospaced))
                        .foregroundColor(.white)
                        .padding(.top, 4)
                }
                .padding()
                .background(Color.black.opacity(0.7))

                // Camera Preview
                if cameraService.isAuthorized {
                    CameraView(cameraService: cameraService)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    VStack(spacing: 16) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.white)
                        Text("Camera access required")
                            .font(.title3)
                            .foregroundColor(.white)
                        Button("Enable Camera") {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }

                // Capture Button
                VStack(spacing: 16) {
                    if isProcessing {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.5)
                    } else {
                        Button(action: capturePhoto) {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 70, height: 70)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.5), lineWidth: 4)
                                        .frame(width: 85, height: 85)
                                )
                        }
                    }
                }
                .frame(height: 120)
                .frame(maxWidth: .infinity)
                .background(Color.black)
            }
        }
        .alert("Result", isPresented: $showResult) {
            if challengeCompleted {
                Button("Done") {
                    alarmManager.completeChallenge(for: alarm)
                    dismiss()
                }
            } else {
                Button("Try Again") {
                    resultMessage = ""
                }
            }
        } message: {
            Text(resultMessage)
        }
        .onAppear {
            startTime = Date()
        }
        .onDisappear {
            cameraService.stopCamera()
        }
    }

    private func capturePhoto() {
        isProcessing = true
        cameraService.capturePhoto()

        // Attendre que la photo soit capturée
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let image = cameraService.capturedImage,
               let challenge = alarm.currentChallenge {
                recognizeImage(image, for: challenge)
            } else {
                isProcessing = false
                resultMessage = "Failed to capture photo"
                showResult = true
            }
        }
    }

    private func recognizeImage(_ image: UIImage, for challenge: ChallengeObject) {
        ImageRecognitionService.shared.recognizeObject(in: image, keywords: challenge.keywords) { success, message in
            DispatchQueue.main.async {
                isProcessing = false
                let timeElapsed = Int(elapsedTime)

                if success {
                    challengeCompleted = true
                    resultMessage = """
                    ✅ Challenge completed!

                    Time: \(formatTime(TimeInterval(timeElapsed)))
                    \(getSarcasticComment(timeElapsed))
                    """
                } else {
                    challengeCompleted = false
                    resultMessage = """
                    ❌ Not quite right

                    \(message)

                    Looking for: \(challenge.name)
                    """
                }

                showResult = true
            }
        }
    }

    private func formatTime(_ interval: TimeInterval) -> String {
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    private func getSarcasticComment(_ seconds: Int) -> String {
        switch seconds {
        case 0..<30:
            return "Impressive! Did you sleep next to it?"
        case 30..<60:
            return "Not bad! You're actually functional."
        case 60..<120:
            return "2 minutes for that? Really?"
        case 120..<300:
            return "At least you're awake now... probably."
        default:
            return "Wow. Just... wow. Were you lost?"
        }
    }
}

#Preview {
    let alarm = Alarm(difficulty: .easy)
    var previewAlarm = alarm
    previewAlarm.currentChallenge = ChallengeDatabase.shared.randomObject(for: .easy)

    return ChallengeView(alarm: previewAlarm)
}
