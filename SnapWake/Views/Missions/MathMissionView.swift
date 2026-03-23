//
//  MathMissionView.swift
//  SnapWake
//
//  Vue pour missions mathématiques
//

import SwiftUI

struct MathMissionView: View {
    let mission: Mission
    let onComplete: (Bool) -> Void

    @State private var problems: [MathProblem] = []
    @State private var currentProblemIndex = 0
    @State private var userAnswer = ""
    @State private var problemsSolved = 0
    @State private var totalProblems = 5
    @State private var feedback = ""
    @State private var showingFeedback = false
    @State private var isCorrect = false

    var currentProblem: MathProblem? {
        problems.indices.contains(currentProblemIndex) ? problems[currentProblemIndex] : nil
    }

    var body: some View {
        ZStack {
            // Clean background
            Color.snapLightBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Clean header
                VStack(spacing: 12) {
                    HStack {
                        ForEach(0..<totalProblems, id: \.self) { index in
                            Circle()
                                .fill(index < problemsSolved ? Color.snapOrange : Color.gray.opacity(0.3))
                                .frame(width: 10, height: 10)
                        }
                    }
                    .padding(.top, 60)

                    Text("Problem \(problemsSolved + 1)/\(totalProblems)")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color.gray)
                }

                Spacer()

                // Math problem - clean design
                if let problem = currentProblem {
                    VStack(spacing: 40) {
                        // Question - big and clean
                        Text(problem.question)
                            .font(.system(size: 64, weight: .bold))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)

                        // Answer input - minimal
                        VStack(spacing: 16) {
                            TextField("?", text: $userAnswer)
                                .font(.system(size: 56, weight: .semibold))
                                .multilineTextAlignment(.center)
                                .keyboardType(.numberPad)
                                .foregroundColor(.black)
                                .padding(.vertical, 20)
                                .background(Color.white)
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(showingFeedback ? (isCorrect ? Color.green : Color.red) : Color.gray.opacity(0.2), lineWidth: 2)
                                )
                                .padding(.horizontal, 40)

                            // Feedback - clean
                            if showingFeedback {
                                HStack(spacing: 12) {
                                    Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(isCorrect ? .green : .red)

                                    Text(feedback)
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(isCorrect ? .green : .red)
                                }
                                .transition(.scale.combined(with: .opacity))
                            }
                        }
                    }
                }

                Spacer()

                // Branding
                MissionBrandingView()
                    .padding(.bottom, 16)

                // Submit button - clean
                Button(action: checkAnswer) {
                    Text("Submit")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(userAnswer.isEmpty || showingFeedback ? Color.gray.opacity(0.3) : Color.black)
                        .cornerRadius(30)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
                .disabled(userAnswer.isEmpty || showingFeedback)
            }

            // Success overlay - clean
            if problemsSolved >= totalProblems {
                ZStack {
                    Color.black.opacity(0.7)
                        .ignoresSafeArea()

                    VStack(spacing: 24) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.green)

                        Text("All done!")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)

                        Text("Brain = activated 🧠")
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
        .onAppear {
            generateProblems()
        }
    }

    private func generateProblems() {
        problems = (0..<totalProblems).map { _ in
            MathProblem.random()
        }
    }

    private func checkAnswer() {
        guard let problem = currentProblem,
              let answer = Int(userAnswer) else { return }

        isCorrect = answer == problem.answer

        withAnimation {
            showingFeedback = true
            feedback = isCorrect ? "Correct! 🎉" : "Wrong! Answer was \(problem.answer)"
        }

        if isCorrect {
            problemsSolved += 1

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    showingFeedback = false
                    userAnswer = ""

                    if problemsSolved < totalProblems {
                        currentProblemIndex += 1
                    }
                }
            }
        } else {
            // Give time to see the correct answer, then reset
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showingFeedback = false
                    userAnswer = ""
                }
            }
        }
    }
}
