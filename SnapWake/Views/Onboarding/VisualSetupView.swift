//
//  VisualSetupView.swift
//  SnapWake
//
//  Visual setup after chat onboarding
//

import SwiftUI

struct VisualSetupView: View {
    @Binding var setupStep: Int
    @Binding var selectedMission: String
    @Binding var desiredWakeTime: Date
    @Binding var selectedSound: String
    @Binding var selectedDays: Set<String>
    let userName: String
    let onComplete: () -> Void

    var body: some View {
        ZStack {
            Color.snapLightBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Progress bar
                ProgressView(value: Double(setupStep + 1), total: 4)
                    .tint(Color.snapOrange)
                    .padding()

                ScrollView {
                    VStack(spacing: 32) {
                        // Mascot
                        Image("mascot_guide")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)

                        switch setupStep {
                        case 0:
                            missionSelectionView
                        case 1:
                            wakeTimeSelectionView
                        case 2:
                            soundSelectionView
                        case 3:
                            daysSelectionView
                        default:
                            EmptyView()
                        }
                    }
                    .padding()
                }

                // Continue button
                Button(action: {
                    if setupStep < 3 {
                        withAnimation {
                            setupStep += 1
                        }
                    } else {
                        onComplete()
                    }
                }) {
                    Text(setupStep < 3 ? "Continue" : "Start My Journey 🚀")
                        .font(.faroBold(size: 18))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(canContinue ? Color.snapOrange : Color.gray.opacity(0.3))
                        .cornerRadius(16)
                }
                .disabled(!canContinue)
                .padding()
            }
        }
    }

    var canContinue: Bool {
        switch setupStep {
        case 0: return !selectedMission.isEmpty
        case 3: return !selectedDays.isEmpty
        default: return true
        }
    }

    // MARK: - Mission Selection
    var missionSelectionView: some View {
        VStack(spacing: 24) {
            Text("Choose Your Wake-Up Mission")
                .font(.poppinsBold(size: 32))
                .multilineTextAlignment(.center)

            Text("You'll need to complete this to turn off your alarm")
                .font(.faro(size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                OnboardingMissionCard(
                    icon: "figure.strengthtraining.traditional",
                    title: "Push-ups",
                    subtitle: "15 seconds",
                    isSelected: selectedMission == "Push-ups",
                    gradient: [Color(hex: "FF6B6B"), Color(hex: "FF4757")]
                ) {
                    selectedMission = "Push-ups"
                }

                OnboardingMissionCard(
                    icon: "camera.fill",
                    title: "Sky Photo",
                    subtitle: "Take a photo",
                    isSelected: selectedMission == "Sky Photo",
                    gradient: [Color(hex: "4A90E2"), Color(hex: "357ABD")]
                ) {
                    selectedMission = "Sky Photo"
                }

                OnboardingMissionCard(
                    icon: "bed.double.fill",
                    title: "Make Bed",
                    subtitle: "Show proof",
                    isSelected: selectedMission == "Make Your Bed",
                    gradient: [Color(hex: "9B59B6"), Color(hex: "8E44AD")]
                ) {
                    selectedMission = "Make Your Bed"
                }

                OnboardingMissionCard(
                    icon: "brain.head.profile",
                    title: "Math",
                    subtitle: "Solve it",
                    isSelected: selectedMission == "Math Problem",
                    gradient: [Color(hex: "3498DB"), Color(hex: "2980B9")]
                ) {
                    selectedMission = "Math Problem"
                }

                OnboardingMissionCard(
                    icon: "sparkles",
                    title: "Affirmation",
                    subtitle: "Read it",
                    isSelected: selectedMission == "Affirmation",
                    gradient: [Color(hex: "FFD700"), Color(hex: "FFA500")]
                ) {
                    selectedMission = "Affirmation"
                }

                OnboardingMissionCard(
                    icon: "magnifyingglass",
                    title: "Object Hunt",
                    subtitle: "Find it",
                    isSelected: selectedMission == "Object Hunt",
                    gradient: [Color(hex: "00A86B"), Color(hex: "00D084")]
                ) {
                    selectedMission = "Object Hunt"
                }
            }
        }
    }

    // MARK: - Wake Time Selection
    var wakeTimeSelectionView: some View {
        VStack(spacing: 24) {
            Text("What Time Do You\nWant to Wake Up?")
                .font(.poppinsBold(size: 32))
                .multilineTextAlignment(.center)

            Text("Choose your ideal wake-up time")
                .font(.faro(size: 16))
                .foregroundColor(.gray)

            DatePicker("", selection: $desiredWakeTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(.wheel)
                .labelsHidden()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.05), radius: 8, y: 4)
        }
    }

    // MARK: - Sound Selection
    var soundSelectionView: some View {
        VStack(spacing: 24) {
            Text("Choose Your\nAlarm Sound")
                .font(.poppinsBold(size: 32))
                .multilineTextAlignment(.center)

            Text("Pick a sound that works for you")
                .font(.faro(size: 16))
                .foregroundColor(.gray)

            VStack(spacing: 12) {
                ForEach(["Default", "Birds", "Ocean", "Gentle", "Upbeat"], id: \.self) { sound in
                    Button(action: {
                        selectedSound = sound
                    }) {
                        HStack {
                            Image(systemName: soundIcon(sound))
                                .font(.system(size: 24))
                                .foregroundColor(selectedSound == sound ? .snapOrange : .gray)

                            Text(sound)
                                .font(.faro(size: 18))
                                .foregroundColor(.black)

                            Spacer()

                            if selectedSound == sound {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.snapOrange)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(selectedSound == sound ? Color.snapOrange : Color.gray.opacity(0.2), lineWidth: 2)
                        )
                    }
                }
            }
        }
    }

    // MARK: - Days Selection
    var daysSelectionView: some View {
        VStack(spacing: 24) {
            Text("Which Days\nShould It Ring?")
                .font(.poppinsBold(size: 32))
                .multilineTextAlignment(.center)

            Text("Select the days for your alarm")
                .font(.faro(size: 16))
                .foregroundColor(.gray)

            VStack(spacing: 12) {
                ForEach(["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"], id: \.self) { day in
                    let shortDay = String(day.prefix(3))
                    Button(action: {
                        if selectedDays.contains(shortDay) {
                            selectedDays.remove(shortDay)
                        } else {
                            selectedDays.insert(shortDay)
                        }
                    }) {
                        HStack {
                            Text(day)
                                .font(.faro(size: 18))
                                .foregroundColor(selectedDays.contains(shortDay) ? .white : .black)

                            Spacer()

                            if selectedDays.contains(shortDay) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        .background(selectedDays.contains(shortDay) ? Color.snapOrange : Color.white)
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(selectedDays.contains(shortDay) ? Color.clear : Color.gray.opacity(0.2), lineWidth: 2)
                        )
                    }
                }
            }

            Button(action: {
                // Select all weekdays
                selectedDays = ["Mon", "Tue", "Wed", "Thu", "Fri"]
            }) {
                Text("Weekdays Only")
                    .font(.faro(size: 16))
                    .foregroundColor(.snapOrange)
            }

            Button(action: {
                // Select all days
                selectedDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
            }) {
                Text("Every Day")
                    .font(.faro(size: 16))
                    .foregroundColor(.snapOrange)
            }
        }
    }

    private func soundIcon(_ sound: String) -> String {
        switch sound {
        case "Birds": return "bird"
        case "Ocean": return "water.waves"
        case "Gentle": return "moon.zzz"
        case "Upbeat": return "bolt.fill"
        default: return "bell.fill"
        }
    }
}

// MARK: - Onboarding Mission Card

struct OnboardingMissionCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let isSelected: Bool
    let gradient: [Color]
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    LinearGradient(colors: gradient, startPoint: .topLeading, endPoint: .bottomTrailing)
                        .frame(width: 60, height: 60)
                        .cornerRadius(16)

                    Image(systemName: icon)
                        .font(.system(size: 28))
                        .foregroundColor(.white)
                }

                Text(title)
                    .font(.faroBold(size: 16))
                    .foregroundColor(.black)

                Text(subtitle)
                    .font(.faro(size: 12))
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? Color.snapOrange : Color.clear, lineWidth: 3)
            )
            .shadow(color: isSelected ? Color.snapOrange.opacity(0.3) : Color.black.opacity(0.05), radius: isSelected ? 12 : 8, y: 4)
        }
    }
}

#Preview {
    VisualSetupView(
        setupStep: .constant(0),
        selectedMission: .constant(""),
        desiredWakeTime: .constant(Date()),
        selectedSound: .constant("Default"),
        selectedDays: .constant([]),
        userName: "John",
        onComplete: {}
    )
}
