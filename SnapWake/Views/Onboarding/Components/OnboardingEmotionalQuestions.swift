//
//  OnboardingEmotionalQuestions.swift
//  SnapWake
//
//  Emotional trigger questions and user reflection views (Steps 2-21)
//

import SwiftUI

extension CompleteOnboardingView {

    // MARK: - Step 2: Snooze Question
    var snoozeQuestionView: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 20)

            Text("How long do you spend\nsnoozing each morning?")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
                .lineSpacing(2)
                .padding(.horizontal, 32)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 20)
                .opacity(1.0)
                .animation(.easeOut(duration: 0.5), value: currentStep)

            VStack(spacing: 16) {
                ForEach(Array(["Under 10 minutes", "10-20 minutes", "20-30 minutes", "30-45 minutes", "45-60 minutes", "Over an hour"].enumerated()), id: \.element) { index, option in
                    optionButton(option, number: index + 1, isSelected: snoozeTime == option) {
                        snoozeTime = option
                    }
                    .transition(.opacity.combined(with: .offset(y: 20)))
                    .animation(.easeOut(duration: 0.3).delay(Double(index) * 0.08), value: currentStep)
                }
            }
            .padding(.horizontal, 32)

            Spacer()

            Button(action: {
                withAnimation {
                    currentStep += 1
                }
            }) {
                Text("Continue")
                    .font(.faroBold(size: 17))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(!snoozeTime.isEmpty ? Color.snapOrange : Color.gray.opacity(0.3))
                    .cornerRadius(30)
            }
            .disabled(snoozeTime.isEmpty)
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
        .background(Color.snapLightBackground)
    }

    // MARK: - Q2: Guilty Feeling
    var guiltyFeelingView: some View {
        questionView(
            title: "Do you often feel guilty\nabout not waking up\nat the first alarm?",
            options: ["Yes, every day", "Several times", "Sometimes", "Rarely"],
            selection: $guiltyFeeling
        )
    }

    // MARK: - Current Wake Time
    var currentWakeTimeView: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 32) {
                VStack(spacing: 12) {
                    Text("What time do you\nactually wake up right now?")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)

                    Text("Be honest, we're here to help you")
                        .font(.faro(size: 16))
                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 32)

                DatePicker("", selection: $currentWakeTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 32)
            }

            Spacer()

            Button(action: {
                withAnimation {
                    currentStep += 1
                }
            }) {
                Text("Continue")
                    .font(.faroBold(size: 17))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color.snapOrange)
                    .cornerRadius(30)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
        .background(Color.snapLightBackground)
    }

    // MARK: - Q3: Panic Feeling
    var panicFeelingView: some View {
        questionView(
            title: "How do you feel when\nyou wake up in panic\nand late?",
            options: ["Stressed", "Angry", "Discouraged", "It ruins my day"],
            selection: $panicFeeling
        )
    }

    // MARK: - Q4: Dream Activity
    var dreamActivityView: some View {
        VStack(spacing: 0) {
            Text("What could you accomplish with 30 more minutes every morning?")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
                .lineSpacing(2)
                .padding(.horizontal, 32)
                .padding(.top, 24)
                .padding(.bottom, 24)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 16) {
                dreamOption("Exercise", number: 1)
                dreamOption("Have a real breakfast", number: 2)
                dreamOption("Meditate or practice yoga", number: 3)
                dreamOption("Work on my projects", number: 4)
                dreamOption("Spend time with loved ones", number: 5)
            }
            .padding(.horizontal, 32)

            Spacer()

            Button(action: {
                withAnimation {
                    currentStep += 1
                }
            }) {
                Text("Continue")
                    .font(.faroBold(size: 17))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(!dreamActivity.isEmpty ? Color.snapOrange : Color.gray.opacity(0.3))
                    .cornerRadius(30)
            }
            .disabled(dreamActivity.isEmpty)
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
        .background(Color.snapLightBackground)
    }

    func dreamOption(_ text: String, number: Int) -> some View {
        Button(action: {
            dreamActivity = text
        }) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.snapOrange)
                        .frame(width: 32, height: 32)

                    Text("\(number)")
                        .font(.faroBold(size: 15))
                        .foregroundColor(.white)
                }

                Text(text)
                    .font(.faro(size: 17))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
            .background(Color.white)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(dreamActivity == text ? Color.snapOrange : Color.clear, lineWidth: 2)
            )
        }
    }

    // MARK: - Q5: Alarms Count
    var alarmsCountView: some View {
        questionView(
            title: "How many alarms do you\nhave currently set?",
            options: ["Only one", "2-3", "4-6", "More than 7", "I don't know anymore"],
            selection: $alarmsCount
        )
    }

    // MARK: - Q6: Forget Turn Off
    var forgetTurnOffView: some View {
        questionView(
            title: "Do you ever turn off\nthe alarm and fall back asleep\nwithout remembering?",
            options: ["Yes, often", "Sometimes", "Rarely", "Never"],
            selection: $forgetTurnOff
        )
    }

    // MARK: - Q7: Life Difference
    var lifeDifferenceView: some View {
        VStack(spacing: 0) {
            Text("If you woke up on time every morning, how would your life be different in 3 months?")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
                .lineSpacing(2)
                .padding(.horizontal, 32)
                .padding(.top, 24)
                .padding(.bottom, 24)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 16) {
                lifeDifferenceOption("More productive at work", number: 1)
                lifeDifferenceOption("Better physical health", number: 2)
                lifeDifferenceOption("Less daily stress", number: 3)
                lifeDifferenceOption("More time for myself", number: 4)
                lifeDifferenceOption("Improved relationships", number: 5)
            }
            .padding(.horizontal, 32)

            Spacer()

            Button(action: {
                withAnimation {
                    currentStep += 1
                }
            }) {
                Text("Continue")
                    .font(.faroBold(size: 17))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(!lifeDifference.isEmpty ? Color.snapOrange : Color.gray.opacity(0.3))
                    .cornerRadius(30)
            }
            .disabled(lifeDifference.isEmpty)
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
        .background(Color.snapLightBackground)
    }

    func lifeDifferenceOption(_ text: String, number: Int) -> some View {
        Button(action: {
            lifeDifference = text
        }) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.snapOrange)
                        .frame(width: 32, height: 32)

                    Text("\(number)")
                        .font(.faroBold(size: 15))
                        .foregroundColor(.white)
                }

                Text(text)
                    .font(.faro(size: 17))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
            .background(Color.white)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(lifeDifference == text ? Color.snapOrange : Color.clear, lineWidth: 2)
            )
        }
    }

    // MARK: - Q8: Self Thought
    var selfThoughtView: some View {
        questionView(
            title: "What do you think about yourself\nwhen you miss your wake-up?",
            options: ["I lack discipline", "I'm weak", "I disappoint others", "I can't count on myself"],
            selection: $selfThought
        )
    }

    // MARK: - Q9: Tries Count
    var triesCountView: some View {
        questionView(
            title: "How many times have you tried\nto change your wake-up habits\nwithout success?",
            options: ["Never", "1-2 times", "3-5 times", "Too many times", "I've tried everything"],
            selection: $triesCount
        )
    }

    // MARK: - Q10: Biggest Dream
    var biggestDreamView: some View {
        VStack(spacing: 24) {
            Spacer().frame(height: 16)

            VStack(alignment: .leading, spacing: 6) {
                Text("What is your biggest dream that you could achieve if you mastered your mornings?")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.black)

                Text("Dis-nous ce qui te fait vibrer")
                    .font(.faro(size: 15))
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 32)

            Spacer()

            TextField("Write your dream here...", text: $biggestDream, axis: .vertical)
                .font(.faro(size: 17))
                .multilineTextAlignment(.center)
                .textFieldStyle(.plain)
                .lineLimit(3...6)
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .padding(.horizontal, 32)

            Spacer()

            Button(action: {
                withAnimation {
                    currentStep += 1
                }
            }) {
                Text("Skip")
                    .font(.faro(size: 15))
                    .foregroundColor(Color.snapTextTertiary(for: colorScheme))
            }
            .padding(.bottom, 12)

            Button(action: {
                guard !biggestDream.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                    return
                }
                withAnimation {
                    currentStep += 1
                }
            }) {
                Text("Continue")
                    .font(.faroBold(size: 17))
                    .foregroundColor(biggestDream.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .white.opacity(0.5) : .white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(biggestDream.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.gray.opacity(0.3) : Color.snapOrange)
                    .cornerRadius(30)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
        .background(Color.snapLightBackground)
    }

    // MARK: - Q12: Future Feeling
    var futureFeelingView: some View {
        questionView(
            title: "Imagine yourself in 6 months, waking up consistently on time.\nHow would you feel?",
            options: ["Proud of myself", "Confident", "Energized", "In control", "Accomplished"],
            selection: $futureFeeling
        )
    }
}
