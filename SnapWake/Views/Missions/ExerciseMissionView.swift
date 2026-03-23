//
//  ExerciseMissionView.swift
//  SnapWake
//
//  Vue vidéo pour missions exercices avec IA de reconnaissance de mouvements
//

import SwiftUI
import AVFoundation

struct ExerciseMissionView: View {
    let mission: Mission
    let onComplete: (Bool) -> Void

    @StateObject private var cameraManager = CameraManager()
    @StateObject private var poseDetector = PoseDetectionService()

    @State private var repsCompleted = 0
    @State private var targetReps = 10
    @State private var isRecording = false
    @State private var feedback = "Get ready..."

    var body: some View {
        ZStack {
            // Camera Preview (front camera for exercises)
            CameraPreviewView(cameraManager: cameraManager)
                .ignoresSafeArea()
                .onAppear {
                    cameraManager.startSession(cameraType: .front)
                    startExerciseDetection()

                    // Connect camera frames to pose detector
                    cameraManager.frameCallback = { sampleBuffer in
                        poseDetector.processFrame(sampleBuffer)
                    }
                }
                .onDisappear {
                    cameraManager.stopSession()
                    poseDetector.stopDetection()
                    cameraManager.frameCallback = nil
                }

            VStack(spacing: 0) {
                // Top instruction - clean and simple
                Text("Do \(targetReps) \(mission.name.lowercased())")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 4)
                    .padding(.top, 70)

                Spacer()

                // Frame corners (like photo missions)
                ZStack {
                    VStack {
                        HStack {
                            FrameCorner(corners: [.topLeft])
                            Spacer()
                            FrameCorner(corners: [.topRight])
                        }
                        Spacer()
                        HStack {
                            FrameCorner(corners: [.bottomLeft])
                            Spacer()
                            FrameCorner(corners: [.bottomRight])
                        }
                    }
                    .padding(40)
                    .frame(height: 450)

                    // Discrete counter in center (only when recording)
                    if isRecording {
                        VStack(spacing: 8) {
                            Text("\(repsCompleted)/\(targetReps)")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.5), radius: 10)

                            if !feedback.isEmpty && feedback != "Get ready..." {
                                Text(feedback)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(Color.black.opacity(0.6))
                                    .cornerRadius(20)
                            }
                        }
                    }
                }

                Spacer()

                // Bottom hint
                Text(isRecording ? "Position yourself in frame" : "Tap start when ready")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 14)
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(25)
                    .shadow(color: .black.opacity(0.2), radius: 8)
                    .padding(.bottom, 12)

                // Branding
                MissionBrandingView()
                    .padding(.bottom, 20)

                // Start button
                if !isRecording {
                    Button(action: startRecording) {
                        Text("Start")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Color.black)
                            .cornerRadius(30)
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 50)
                }
            }

            // Success overlay
            if repsCompleted >= targetReps {
                ZStack {
                    Color.black.opacity(0.7)
                        .ignoresSafeArea()

                    VStack(spacing: 24) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.green)

                        Text("Mission Complete!")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)

                        Text("Great job! 🔥")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        onComplete(true)
                    }
                }
            }
        }
    }

    private func startRecording() {
        isRecording = true
        feedback = "Start your \(mission.name.lowercased())!"
    }

    private func startExerciseDetection() {
        poseDetector.startDetection(exerciseType: mission.name, targetReps: targetReps) { rep, feedbackMessage in
            DispatchQueue.main.async {
                repsCompleted = rep
                feedback = feedbackMessage

                if repsCompleted >= targetReps {
                    poseDetector.stopDetection()
                    onComplete(true)
                }
            }
        }
    }
}

// MARK: - Old simulation code removed - now using PoseDetectionService with real Vision AI
