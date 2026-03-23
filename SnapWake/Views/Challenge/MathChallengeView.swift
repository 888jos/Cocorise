//
//  MathChallengeView.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import SwiftUI

struct MathChallengeView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var challengeManager = ChallengeManager.shared
    let difficulty: Difficulty
    let onComplete: (Bool) -> Void

    @State private var currentProblem: MathProblem
    @State private var userAnswer = ""
    @State private var problemsCompleted = 0
    @State private var showError = false
    @State private var timeRemaining: TimeInterval
    @State private var timer: Timer?

    private var totalProblems: Int {
        switch difficulty {
        case .easy: return 3
        case .medium: return 5
        case .hard: return 7
        case .impossible: return 10
        }
    }

    init(difficulty: Difficulty, onComplete: @escaping (Bool) -> Void) {
        self.difficulty = difficulty
        self.onComplete = onComplete
        _currentProblem = State(initialValue: MathChallengeView.generateProblem(for: difficulty))
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
                        Image(systemName: "function")
                            .font(.system(size: 32))
                            .foregroundColor(.snapOrange)

                        Spacer()

                        Text(formatTime(timeRemaining))
                            .font(.faroBold(size: 24))
                            .foregroundColor(timeRemaining < 30 ? .red : Color.snapTextPrimary(for: colorScheme))
                    }

                    Text("Math Challenge")
                        .font(.faroBold(size: 28))
                        .foregroundColor(Color.snapTextPrimary(for: colorScheme))

                    Text("Solve \(totalProblems) problems to turn off alarm")
                        .font(.faro(size: 14))
                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))

                    // Progress
                    HStack(spacing: 8) {
                        ForEach(0..<totalProblems, id: \.self) { index in
                            Circle()
                                .fill(index < problemsCompleted ? Color.snapGreen : Color.snapCard(for: colorScheme))
                                .frame(width: 12, height: 12)
                        }
                    }
                    .padding(.top, 8)
                }
                .padding()

                Spacer()

                // Problem
                VStack(spacing: 32) {
                    Text(currentProblem.question)
                        .font(.faroBold(size: 48))
                        .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                        .multilineTextAlignment(.center)

                    VStack(spacing: 16) {
                        TextField("Your answer", text: $userAnswer)
                            .font(.faroBold(size: 32))
                            .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                            .multilineTextAlignment(.center)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color.snapCard(for: colorScheme))
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(showError ? Color.red : Color.clear, lineWidth: 2)
                            )
                            .animation(.easeInOut(duration: 0.3), value: showError)

                        if showError {
                            Text("Incorrect! Try again")
                                .font(.faro(size: 14))
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.horizontal, 32)
                }

                Spacer()

                // Submit button
                Button(action: checkAnswer) {
                    Text("Submit")
                        .font(.faroBold(size: 18))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [Color.snapOrange, Color.snapPink],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                }
                .disabled(userAnswer.isEmpty)
                .opacity(userAnswer.isEmpty ? 0.5 : 1.0)
                .padding(.horizontal, 32)
                .padding(.bottom, 32)
            }
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            timer?.invalidate()
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

    private func checkAnswer() {
        guard let answer = Int(userAnswer) else {
            showError = true
            return
        }

        if answer == currentProblem.answer {
            problemsCompleted += 1
            showError = false
            userAnswer = ""

            if problemsCompleted >= totalProblems {
                timer?.invalidate()
                onComplete(true)
            } else {
                currentProblem = MathChallengeView.generateProblem(for: difficulty)
            }
        } else {
            showError = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                showError = false
            }
        }
    }

    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    static func generateProblem(for difficulty: Difficulty) -> MathProblem {
        switch difficulty {
        case .easy:
            let a = Int.random(in: 1...20)
            let b = Int.random(in: 1...20)
            let operation = Bool.random()
            if operation {
                return MathProblem(question: "\(a) + \(b)", answer: a + b)
            } else {
                let max = Swift.max(a, b)
                let min = Swift.min(a, b)
                return MathProblem(question: "\(max) - \(min)", answer: max - min)
            }

        case .medium:
            let operations = ["+", "-", "×"]
            let op = operations.randomElement()!
            let a = Int.random(in: 5...30)
            let b = Int.random(in: 5...30)

            switch op {
            case "+":
                return MathProblem(question: "\(a) + \(b)", answer: a + b)
            case "-":
                let max = Swift.max(a, b)
                let min = Swift.min(a, b)
                return MathProblem(question: "\(max) - \(min)", answer: max - min)
            default: // ×
                let a = Int.random(in: 2...12)
                let b = Int.random(in: 2...12)
                return MathProblem(question: "\(a) × \(b)", answer: a * b)
            }

        case .hard:
            let operations = ["+", "-", "×"]
            let op = operations.randomElement()!

            if op == "×" {
                let a = Int.random(in: 5...20)
                let b = Int.random(in: 5...15)
                return MathProblem(question: "\(a) × \(b)", answer: a * b)
            } else {
                let a = Int.random(in: 10...100)
                let b = Int.random(in: 10...100)
                if op == "+" {
                    return MathProblem(question: "\(a) + \(b)", answer: a + b)
                } else {
                    let max = Swift.max(a, b)
                    let min = Swift.min(a, b)
                    return MathProblem(question: "\(max) - \(min)", answer: max - min)
                }
            }

        case .impossible:
            // Multi-step problems
            let a = Int.random(in: 5...20)
            let b = Int.random(in: 5...20)
            let c = Int.random(in: 2...10)
            let choice = Int.random(in: 0...2)

            switch choice {
            case 0:
                let answer = (a + b) * c
                return MathProblem(question: "(\(a) + \(b)) × \(c)", answer: answer)
            case 1:
                let answer = a * b + c
                return MathProblem(question: "\(a) × \(b) + \(c)", answer: answer)
            default:
                let answer = a * b - c
                return MathProblem(question: "\(a) × \(b) - \(c)", answer: answer)
            }
        }
    }
}

#Preview {
    MathChallengeView(difficulty: .medium) { _ in }
}
