//
//  OnboardingInteractiveViews.swift
//  SnapWake
//
//  Interactive views including camera demo, signature, and customization (Steps 24-36)
//

import SwiftUI

extension CompleteOnboardingView {

    // MARK: - Let's Try It Now View (Step 24)
    var letsTryItNowView: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 32) {
                // Mission icon with gradient circle
                getMissionIcon(for: selectedMission)
                    .shadow(color: Color.black.opacity(0.15), radius: 20, y: 10)

                VStack(spacing: 16) {
                    Text("Let's try it right now")
                        .font(.poppinsBold(size: 28))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)

                    Text("Complete your \(selectedMission.lowercased()) mission\nto see how Wayk wakes you up")
                        .font(.faro(size: 17))
                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                .padding(.horizontal, 32)
            }

            Spacer()

            Button(action: {
                withAnimation {
                    currentStep += 1
                }
            }) {
                HStack(spacing: 12) {
                    Text("Start Mission")
                        .font(.faroBold(size: 18))
                        .foregroundColor(.white)

                    Image(systemName: "arrow.right")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(Color.snapOrange)
                .cornerRadius(30)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
        .background(Color.snapLightBackground)
    }

    // MARK: - Mission Camera View (Step 25)
    var missionCameraView: some View {
        ZStack {
            // Use the actual mission execution view
            if let mission = getMissionForDemo(selectedMission) {
                MissionExecutionView(
                    alarm: Alarm(
                        name: "Demo Alarm",
                        time: Date(),
                        isEnabled: true,
                        selectedDays: [.monday],
                        difficulty: .medium,
                        sound: "Default",
                        missionId: mission.id
                    )
                )
                .ignoresSafeArea()
            }

            // DEMO badge overlay in top right
            VStack {
                HStack {
                    Spacer()

                    Button(action: {
                        withAnimation {
                            currentStep += 1
                        }
                    }) {
                        HStack(spacing: 6) {
                            Text("DEMO")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.black)
                            Image(systemName: "xmark")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.black)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.white)
                        .cornerRadius(24)
                        .shadow(color: Color.black.opacity(0.15), radius: 8, y: 2)
                    }
                    .padding(.top, 60)
                    .padding(.trailing, 20)
                }

                Spacer()
            }
        }
    }

    // MARK: - Wake History Card View (Step 32)
    var wakeHistoryCardView: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 20)

            VStack(alignment: .leading, spacing: 8) {
                Text("Choose your wake\nhistory card")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.black)

                Text("This becomes your proof after every successful wake up.")
                    .font(.faro(size: 17))
                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 32)
            .padding(.bottom, 32)

            // Horizontal scroll with paging
            TabView(selection: $selectedCardIndex) {
                ForEach(0..<cardOptions.count, id: \.self) { index in
                    wakeHistoryCardOption(cardOptions[index].name, streak: 14, date: "Sat, Mar 7", wakeTime: "7:30", wakeNumber: 42)
                        .padding(.horizontal, 32)
                        .tag(index)
                        .onTapGesture {
                            wakeHistoryCard = cardOptions[index].name
                        }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 300)
            .onChange(of: selectedCardIndex) { newIndex in
                wakeHistoryCard = cardOptions[newIndex].name
            }

            // Custom page indicator
            HStack(spacing: 8) {
                ForEach(0..<cardOptions.count, id: \.self) { index in
                    Circle()
                        .fill(index == selectedCardIndex ? Color.snapOrange : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .scaleEffect(index == selectedCardIndex ? 1.2 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedCardIndex)
                }
            }
            .padding(.vertical, 20)

            Text(wakeHistoryCard.isEmpty ? "Swipe to explore" : wakeHistoryCard)
                .font(.faro(size: 17))
                .foregroundColor(wakeHistoryCard.isEmpty ? Color.gray : Color(hex: "666666"))
                .padding(.bottom, 16)
                .animation(.easeInOut, value: wakeHistoryCard)

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
                    .background(!wakeHistoryCard.isEmpty ? Color.snapOrange : Color.gray.opacity(0.3))
                    .cornerRadius(30)
            }
            .disabled(wakeHistoryCard.isEmpty)
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
        .background(Color.snapLightBackground)
    }

    // MARK: - Signature Commitment View (Step 36)
    var signatureCommitmentView: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 20)

            VStack(alignment: .leading, spacing: 8) {
                Text("Make the commitment")
                    .font(.poppinsBold(size: 24))
                    .foregroundColor(.black)

                let formatter = DateFormatter()
                let _ = formatter.dateFormat = "HH:mm"

                Text("Sign to commit to waking up at \(formatter.string(from: desiredWakeTime)) every day.")
                    .font(.faro(size: 17))
                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 32)
            .padding(.bottom, 24)

            // Real signature canvas
            OnboardingSignatureCanvas(signature: $userSignature)
                .frame(height: 280)
                .padding(.horizontal, 32)

            // Clear button
            if !userSignature.isEmpty {
                Button(action: {
                    userSignature = ""
                }) {
                    Text("Clear")
                        .font(.faro(size: 15))
                        .foregroundColor(Color.snapOrange)
                }
                .padding(.top, 12)
            }

            Spacer()

            Button(action: {
                withAnimation {
                    currentStep += 1
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark")
                        .font(.faroBold(size: 16))

                    Text("I Commit")
                        .font(.faroBold(size: 17))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(userSignature.isEmpty ? Color.gray.opacity(0.3) : Color.black)
                .cornerRadius(30)
            }
            .disabled(userSignature.isEmpty)
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
        .background(Color.snapLightBackground)
    }

    // MARK: - Helper Functions

    // Helper to get the mission for demo
    func getMissionForDemo(_ missionName: String) -> Mission? {
        return MissionsLibrary.shared.missions.first { $0.name == missionName }
    }

    // Helper function for framing instructions
    func getFramingInstruction(for mission: String) -> String {
        switch mission {
        case "Make Your Bed":
            return "Frame your made bed"
        case "Sky Photo":
            return "Frame the sky"
        case "Push-ups":
            return "Frame yourself"
        case "Math Problem":
            return "Ready to solve"
        case "Affirmation":
            return "Ready to read"
        case "Object Hunt":
            return "Frame the object"
        case "Bible Verse":
            return "Ready to recite"
        case "Walk":
            return "Start walking"
        default:
            return "Frame your target"
        }
    }

    func getMissionIconName(for mission: String) -> String {
        switch mission {
        case "Push-ups":
            return "figure.strengthtraining.traditional"
        case "Sky Photo":
            return "camera.fill"
        case "Make Your Bed":
            return "bed.double.fill"
        case "Bible Verse":
            return "book.fill"
        case "Affirmation":
            return "sparkles"
        case "Object Hunt":
            return "magnifyingglass"
        case "Walk":
            return "figure.walk"
        case "Math Problem":
            return "brain.head.profile"
        default:
            return "star.fill"
        }
    }

    func getMissionIconInfo(for mission: String) -> (String, [Color]) {
        switch mission {
        case "Push-ups":
            return ("figure.strengthtraining.traditional", [Color(hex: "FF6B6B"), Color(hex: "FF4757")])
        case "Sky Photo":
            return ("camera.fill", [Color(hex: "4A90E2"), Color(hex: "357ABD")])
        case "Make Your Bed":
            return ("bed.double.fill", [Color(hex: "9B59B6"), Color(hex: "8E44AD")])
        case "Bible Verse":
            return ("book.fill", [Color(hex: "F39C12"), Color(hex: "E67E22")])
        case "Affirmation":
            return ("sparkles", [Color(hex: "FFD700"), Color(hex: "FFA500")])
        case "Object Hunt":
            return ("magnifyingglass", [Color(hex: "00A86B"), Color(hex: "00D084")])
        case "Walk":
            return ("figure.walk", [Color.snapOrange, Color(hex: "FF8C00")])
        case "Math Problem":
            return ("brain.head.profile", [Color(hex: "3498DB"), Color(hex: "2980B9")])
        default:
            return ("star.fill", [Color.snapOrange, Color(hex: "FF8C00")])
        }
    }

    func getMissionInstruction(for mission: String) -> String {
        switch mission {
        case "Push-ups":
            return "Do 15 seconds of push-ups"
        case "Sky Photo":
            return "Take a photo of the sky"
        case "Make Your Bed":
            return "Show a made bed"
        case "Bible Verse":
            return "Say a short verse"
        case "Affirmation":
            return "Read an affirmation"
        case "Object Hunt":
            return "Find an object"
        case "Walk":
            return "Take a few steps"
        case "Math Problem":
            return "Solve a calculation"
        default:
            return "Complete your mission"
        }
    }

    // Card options array
    private var cardOptions: [(name: String, gradient: [Color])] {
        [
            ("Default", [Color(hex: "667EEA"), Color(hex: "764BA2")]),
            ("Morning Glory", [Color(hex: "F093FB"), Color(hex: "F5576C")]),
            ("Night Owl", [Color(hex: "4A00E0"), Color(hex: "8E2DE2")]),
            ("Fresh Start", [Color(hex: "00D2FF"), Color(hex: "3A7BD5")]),
            ("Fire", [Color(hex: "FA8BFF"), Color(hex: "2BFF88"), Color(hex: "F04A4A")]),
            ("Ocean", [Color(hex: "2E3192"), Color(hex: "1BFFFF")])
        ]
    }

    func wakeHistoryCardOption(_ title: String, streak: Int, date: String, wakeTime: String, wakeNumber: Int) -> some View {
        Button(action: {
            wakeHistoryCard = title
        }) {
            VStack(spacing: 0) {
                // Header avec streak et date
                HStack {
                    HStack(spacing: 4) {
                        Text("🔥")
                            .font(.system(size: 16))
                        Text("\(streak)")
                            .font(.faroBold(size: 16))
                            .foregroundColor(.black)
                    }

                    Spacer()

                    Text(date)
                        .font(.faro(size: 14))
                        .foregroundColor(Color.snapTextTertiary(for: colorScheme))
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 40)

                // Wake up time - grand
                VStack(spacing: 8) {
                    Text("WAKE UP TIME")
                        .font(.faroBold(size: 12))
                        .foregroundColor(Color.snapTextTertiary(for: colorScheme))
                        .tracking(1)

                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text(wakeTime)
                            .font(.poppinsBold(size: 72))
                            .foregroundColor(.black)
                        Text("am")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(Color.snapTextTertiary(for: colorScheme))
                    }
                }
                .padding(.bottom, 50)

                // Wake number
                Text("Wake #\(wakeNumber)")
                    .font(.faro(size: 16))
                    .foregroundColor(Color.snapTextTertiary(for: colorScheme))
                    .padding(.bottom, 20)
            }
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(wakeHistoryCard == title ? Color.snapOrange : Color.clear, lineWidth: 3)
            )
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.06), radius: 8, y: 4)
        }
    }
}
