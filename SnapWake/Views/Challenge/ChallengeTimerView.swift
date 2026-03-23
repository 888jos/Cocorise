//
//  ChallengeTimerView.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import SwiftUI

struct ChallengeTimerView: View {
    @Environment(\.colorScheme) var colorScheme
    let difficulty: Difficulty
    let startTime: Date
    @State private var timeRemaining: TimeInterval
    @State private var timer: Timer?
    let onTimeout: () -> Void

    init(difficulty: Difficulty, onTimeout: @escaping () -> Void) {
        self.difficulty = difficulty
        self.startTime = Date()
        self._timeRemaining = State(initialValue: difficulty.timeLimit)
        self.onTimeout = onTimeout
    }

    var minutes: Int {
        Int(timeRemaining) / 60
    }

    var seconds: Int {
        Int(timeRemaining) % 60
    }

    var progress: Double {
        timeRemaining / difficulty.timeLimit
    }

    var timerColor: Color {
        if progress > 0.5 { return .green }
        else if progress > 0.25 { return .orange }
        else { return .red }
    }

    var body: some View {
        HStack(spacing: 12) {
            // Circular progress indicator
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 4)
                    .frame(width: 50, height: 50)

                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(timerColor, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .frame(width: 50, height: 50)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 0.5), value: progress)

                Image(systemName: "clock.fill")
                    .font(.system(size: 18))
                    .foregroundColor(timerColor)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text("Time Remaining")
                    .font(.faro(size: 12))
                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))

                Text(String(format: "%d:%02d", minutes, seconds))
                    .font(.faroBold(size: 20))
                    .foregroundColor(timerColor)
            }

            Spacer()
        }
        .padding()
        .background(Color.snapCard(for: colorScheme))
        .cornerRadius(12)
        .onAppear {
            startTimer()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            let elapsed = Date().timeIntervalSince(startTime)
            timeRemaining = max(0, difficulty.timeLimit - elapsed)

            if timeRemaining <= 0 {
                timer?.invalidate()
                onTimeout()
            }
        }
    }
}

#Preview {
    ChallengeTimerView(difficulty: .medium) {
        print("Timeout!")
    }
}
