//
//  OnboardingUserInfo.swift
//  SnapWake
//
//  User information collection views (Steps 0-1)
//

import SwiftUI

extension CompleteOnboardingView {

    // MARK: - Step 0: Name Question
    var nameQuestionView: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 40) {
                MascotView(.bienvenue, size: .large)

                VStack(spacing: 16) {
                    Text("What's your\nfirst name?")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)

                    TextField("Enter your name", text: $userName)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.05), radius: 8, y: 4)
                        .padding(.horizontal, 32)
                }
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
                    .background(!userName.isEmpty ? Color.snapOrange : Color.gray.opacity(0.3))
                    .cornerRadius(30)
            }
            .disabled(userName.isEmpty)
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
        .background(Color.snapLightBackground)
    }

    // MARK: - Step 1: Age Question
    var ageQuestionView: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 20)

            Text("How old are you,\n\(userName)?")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
                .lineSpacing(2)
                .padding(.horizontal, 32)
                .padding(.top, 24)
                .padding(.bottom, 24)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 16) {
                ForEach(Array(["Under 18", "18-24", "25-34", "35-44", "45-54", "55+"].enumerated()), id: \.element) { index, option in
                    optionButton(option, number: index + 1, isSelected: userAge == option) {
                        userAge = option
                    }
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
                    .background(!userAge.isEmpty ? Color.snapOrange : Color.gray.opacity(0.3))
                    .cornerRadius(30)
            }
            .disabled(userAge.isEmpty)
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
        .background(Color.snapLightBackground)
    }
}
