//
//  ShakeChallengeView.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import SwiftUI
import CoreMotion

struct ShakeChallengeView: View {
    @Environment(\.colorScheme) var colorScheme
    let difficulty: Difficulty
    let onComplete: (Bool) -> Void

    @State private var shakeCount = 0
    @State private var timeRemaining: TimeInterval
    @State private var timer: Timer?
    @State private var motionManager = CMMotionManager()

    private var targetShakes: Int {
        switch difficulty {
        case .easy: return 20
        case .medium: return 30
        case .hard: return 50
        case .impossible: return 80
        }
    }

    init(difficulty: Difficulty, onComplete: @escaping (Bool) -> Void) {
        self.difficulty = difficulty
        self.onComplete = onComplete
        _timeRemaining = State(initialValue: difficulty.timeLimit)
    }

    var body: some View {
        ZStack {
            Color.snapBackground(for: colorScheme)
                .ignoresSafeArea()

            VStack(spacing: 32) {
                // Header
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "iphone.radiowaves.left.and.right")
                            .font(.system(size: 32))
                            .foregroundColor(.snapOrange)

                        Spacer()

                        Text(formatTime(timeRemaining))
                            .font(.faroBold(size: 24))
                            .foregroundColor(timeRemaining < 30 ? .red : Color.snapTextPrimary(for: colorScheme))
                    }

                    Text("Shake Challenge")
                        .font(.faroBold(size: 28))
                        .foregroundColor(Color.snapTextPrimary(for: colorScheme))

                    Text("Shake your phone to turn off alarm")
                        .font(.faro(size: 14))
                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                }
                .padding()

                Spacer()

                // Shake counter
                VStack(spacing: 24) {
                    ZStack {
                        Circle()
                            .stroke(Color.snapCard(for: colorScheme), lineWidth: 20)
                            .frame(width: 250, height: 250)

                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(
                                LinearGradient(
                                    colors: [Color.snapOrange, Color.snapPink],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                style: StrokeStyle(lineWidth: 20, lineCap: .round)
                            )
                            .frame(width: 250, height: 250)
                            .rotationEffect(.degrees(-90))
                            .animation(.easeInOut(duration: 0.3), value: progress)

                        VStack(spacing: 8) {
                            Text("\(shakeCount)")
                                .font(.system(size: 72, weight: .bold))
                                .foregroundColor(Color.snapTextPrimary(for: colorScheme))

                            Text("/ \(targetShakes)")
                                .font(.faroBold(size: 24))
                                .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                        }
                    }

                    Text("Shake your phone!")
                        .font(.faroBold(size: 20))
                        .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                        .opacity(shakeCount == 0 ? 1 : 0)
                        .animation(.easeInOut(duration: 0.5), value: shakeCount)
                }

                Spacer()
            }
        }
        .onAppear {
            startTimer()
            startShakeDetection()
        }
        .onDisappear {
            timer?.invalidate()
            motionManager.stopAccelerometerUpdates()
        }
    }

    private var progress: CGFloat {
        CGFloat(shakeCount) / CGFloat(targetShakes)
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

    private func startShakeDetection() {
        guard motionManager.isAccelerometerAvailable else { return }

        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates(to: .main) { data, error in
            guard let data = data else { return }

            let acceleration = sqrt(
                pow(data.acceleration.x, 2) +
                pow(data.acceleration.y, 2) +
                pow(data.acceleration.z, 2)
            )

            // Detect shake (threshold for significant movement)
            if acceleration > 2.5 {
                incrementShake()
            }
        }
    }

    private func incrementShake() {
        guard shakeCount < targetShakes else { return }

        shakeCount += 1

        if shakeCount >= targetShakes {
            timer?.invalidate()
            motionManager.stopAccelerometerUpdates()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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
    ShakeChallengeView(difficulty: .medium) { _ in }
}
