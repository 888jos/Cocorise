//
//  ShakeMissionView.swift
//  SnapWake
//
//  Vue de détection de secousse pour missions shake
//

import SwiftUI
import CoreMotion

struct ShakeMissionView: View {
    let mission: Mission
    let onComplete: (Bool) -> Void

    @StateObject private var motionManager = MotionManager()
    @State private var shakesCompleted = 0
    @State private var targetShakes = 30
    @State private var isActive = false
    @State private var feedback = "Get ready to shake!"

    var body: some View {
        ZStack {
            // Clean background
            Color.snapLightBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Top instruction
                VStack(spacing: 12) {
                    HStack {
                        ForEach(0..<3, id: \.self) { index in
                            Circle()
                                .fill(shakesCompleted >= (index + 1) * 10 ? Color.snapOrange : Color.gray.opacity(0.3))
                                .frame(width: 10, height: 10)
                        }
                    }
                    .padding(.top, 60)

                    Text("Shake \(targetShakes) times")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color.gray)
                }

                Spacer()

                // Shake counter with animation
                VStack(spacing: 40) {
                    // Phone icon that shakes
                    Image(systemName: "iphone.gen3")
                        .font(.system(size: 120))
                        .foregroundColor(.black)
                        .rotationEffect(.degrees(motionManager.isShaking ? 15 : 0))
                        .animation(.spring(response: 0.3, dampingFraction: 0.3), value: motionManager.isShaking)

                    // Big counter
                    Text("\(shakesCompleted)")
                        .font(.system(size: 96, weight: .bold))
                        .foregroundColor(.black)

                    // Feedback message
                    if !feedback.isEmpty && feedback != "Get ready to shake!" {
                        Text(feedback)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.gray)
                    }
                }

                Spacer()

                // Start button
                if !isActive {
                    Button(action: startShaking) {
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
            if shakesCompleted >= targetShakes {
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
                    motionManager.stopDetection()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        onComplete(true)
                    }
                }
            }
        }
        .onAppear {
            motionManager.onShakeDetected = {
                handleShake()
            }
        }
        .onDisappear {
            motionManager.stopDetection()
        }
    }

    private func startShaking() {
        isActive = true
        feedback = "Shake it! 🔥"
        motionManager.startDetection()
    }

    private func handleShake() {
        guard isActive, shakesCompleted < targetShakes else { return }

        shakesCompleted += 1

        if shakesCompleted >= targetShakes {
            feedback = "Complete! 🎉"
        } else if shakesCompleted >= targetShakes - 5 {
            feedback = "Almost there! 💪"
        } else if shakesCompleted % 10 == 0 {
            feedback = "Keep going! 🔥"
        }
    }
}

// MARK: - Motion Manager
@MainActor
class MotionManager: ObservableObject {
    private let motionManager = CMMotionManager()
    @Published var isShaking = false

    var onShakeDetected: (() -> Void)?

    private var shakeThreshold: Double = 2.5
    private var lastShakeTime: Date = Date()
    private let shakeDebounceInterval: TimeInterval = 0.3

    func startDetection() {
        guard motionManager.isAccelerometerAvailable else { return }

        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, error in
            guard let self = self, let data = data else { return }

            let acceleration = data.acceleration
            let magnitude = sqrt(pow(acceleration.x, 2) + pow(acceleration.y, 2) + pow(acceleration.z, 2))

            // Detect shake
            if magnitude > self.shakeThreshold {
                let now = Date()
                if now.timeIntervalSince(self.lastShakeTime) > self.shakeDebounceInterval {
                    self.isShaking = true
                    self.lastShakeTime = now
                    self.onShakeDetected?()

                    // Reset shake animation
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.isShaking = false
                    }
                }
            }
        }
    }

    func stopDetection() {
        motionManager.stopAccelerometerUpdates()
    }
}
