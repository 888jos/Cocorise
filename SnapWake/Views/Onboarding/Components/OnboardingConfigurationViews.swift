//
//  OnboardingConfigurationViews.swift
//  SnapWake
//
//  Mission, sound, days, and time configuration views (Steps 22-31)
//

import SwiftUI

extension CompleteOnboardingView {

    // MARK: - Mission Selection (Step 22)
    var missionSelectionView: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 20)

            VStack(alignment: .leading, spacing: 8) {
                Text("Choose your\nwake-up mission")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(.black)

                Text("You will have to complete it to turn off the alarm")
                    .font(.faro(size: 17))
                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 32)
            .padding(.bottom, 40)

            ScrollView {
                VStack(spacing: 16) {
                    missionOption("figure.strengthtraining.traditional", "Push-ups", "15 seconds of push-ups", selectedMission == "Push-ups", gradient: [Color(hex: "FF6B6B"), Color(hex: "FF4757")])
                    missionOption("camera.fill", "Sky Photo", "Take a photo of the sky", selectedMission == "Sky Photo", gradient: [Color(hex: "4A90E2"), Color(hex: "357ABD")])
                    missionOption("bed.double.fill", "Make Your Bed", "Show a made bed", selectedMission == "Make Your Bed", gradient: [Color(hex: "9B59B6"), Color(hex: "8E44AD")])
                    missionOption("book.fill", "Bible Verse", "Say a short verse", selectedMission == "Bible Verse", gradient: [Color(hex: "F39C12"), Color(hex: "E67E22")])
                    missionOption("sparkles", "Affirmation", "Read an affirmation", selectedMission == "Affirmation", gradient: [Color(hex: "FFD700"), Color(hex: "FFA500")])
                    missionOption("magnifyingglass", "Object Hunt", "Find an object", selectedMission == "Object Hunt", gradient: [Color(hex: "00A86B"), Color(hex: "00D084")])
                    missionOption("figure.walk", "Walk", "Take a few steps", selectedMission == "Walk", gradient: [Color.snapOrange, Color(hex: "FF8C00")])
                    missionOption("brain.head.profile", "Math Problem", "Solve a calculation", selectedMission == "Math Problem", gradient: [Color(hex: "3498DB"), Color(hex: "2980B9")])
                }
                .padding(.horizontal, 32)
            }

        }
        .background(Color.snapLightBackground)
    }

    func missionOption(_ iconName: String, _ name: String, _ description: String, _ isSelected: Bool, gradient: [Color]) -> some View {
        Button(action: {
            selectedMission = name
            withAnimation {
                currentStep += 1
            }
        }) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: gradient,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)

                    Image(systemName: iconName)
                        .font(.poppinsBold(size: 26))
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(.faroBold(size: 17))
                        .foregroundColor(.black)
                    Text(description)
                        .font(.faro(size: 13))
                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                }

                Spacer()
            }
            .padding(16)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.snapOrange : Color.clear, lineWidth: 3)
            )
            .cornerRadius(16)
            .shadow(color: isSelected ? Color.snapOrange.opacity(0.3) : Color.black.opacity(0.05), radius: isSelected ? 12 : 8, y: 4)
        }
    }

    // MARK: - Mission Congratulation (Step 23)
    var missionCongratulationView: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 32) {
                MascotView(.victoire, size: .large)

                Text("Congratulations\non your choice!")
                    .font(.poppinsBold(size: 36))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)

                VStack(spacing: 16) {
                    Text(selectedMission.isEmpty ? "Your mission" : selectedMission)
                        .font(.poppinsBold(size: 24))
                        .foregroundColor(Color.snapOrange)

                    Text(missionExplanations[selectedMission] ?? "This mission will help you wake up effectively.")
                        .font(.faro(size: 17))
                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                        .padding(.horizontal, 40)
                }
                .padding(.vertical, 24)
                .padding(.horizontal, 32)
                .background(Color.white)
                .cornerRadius(24)
                .shadow(color: Color.black.opacity(0.05), radius: 20, y: 10)
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

    // MARK: - Desired Wake Time (Step 29)
    var desiredWakeTimeView: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 20)

            VStack(alignment: .leading, spacing: 8) {
                Text("What time do you ideally\nwant to get out of bed?")
                    .font(.poppinsBold(size: 24))
                    .foregroundColor(.black)

                Text("This is the first day of your new life.\nChoose the time that will change everything.")
                    .font(.faro(size: 16))
                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                    .lineSpacing(4)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 32)
            .padding(.bottom, 32)

            DatePicker("", selection: $desiredWakeTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(.wheel)
                .labelsHidden()
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 32)
                .padding(.bottom, 20)

            VStack(spacing: 8) {
                HStack(spacing: 12) {
                    Image(systemName: "sunrise.fill")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(Color.snapOrange)
                    Text("Your new routine starts tomorrow")
                        .font(.faro(size: 14))
                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.snapOrange.opacity(0.1))
                .cornerRadius(20)
            }
            .padding(.horizontal, 32)

            Spacer()

            Button(action: {
                withAnimation {
                    currentStep += 1
                }
            }) {
                Text("C'est parti ! 🚀")
                    .font(.faroBold(size: 17))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        LinearGradient(
                            colors: [Color.snapOrange, Color(hex: "FF8C00")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(30)
                    .shadow(color: Color.snapOrange.opacity(0.3), radius: 10, y: 5)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
        .background(Color.snapLightBackground)
    }

    // MARK: - Sound Selection (Step 30)
    var soundSelectionView: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 20)

            VStack(alignment: .leading, spacing: 8) {
                Text("Choose your alarm sound")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.black)

                Text("Pick the sound that gets you up.")
                    .font(.faro(size: 17))
                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 32)
            .padding(.bottom, 40)

            ScrollView {
                VStack(spacing: 16) {
                    soundCategoryGrouped(icon: "", title: "CLASSIC", sounds: ["Default", "Alarm Clock Bell", "UK Tea Timer"], colors: [Color(hex: "8E8E93"), Color(hex: "5E6C84"), Color(hex: "6B8E23")])

                    soundCategoryGrouped(icon: "⚡", title: "AGGRESSIVE", sounds: ["Air Raid Siren", "Rooster Crowing"], colors: [Color(hex: "DC143C"), Color(hex: "8B4513")])

                    soundCategoryGrouped(icon: "🧘", title: "PEACEFUL", sounds: ["Morning Birds", "Ocean Waves", "Zen Garden"], colors: [Color(hex: "87CEEB"), Color(hex: "4682B4"), Color(hex: "2E8B57")])
                }
                .padding(.horizontal, 32)
            }

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

    func soundCategoryGrouped(icon: String, title: String, sounds: [String], colors: [Color]) -> some View {
        VStack(spacing: 0) {
            // Category header if exists
            if !icon.isEmpty {
                HStack(spacing: 8) {
                    Text(icon)
                        .font(.faro(size: 16))
                    Text(title)
                        .font(.faroBold(size: 13))
                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
            }

            // Grouped sound rows in white rectangle
            VStack(spacing: 0) {
                ForEach(Array(sounds.enumerated()), id: \.element) { index, sound in
                    HStack(spacing: 16) {
                        // Left: Icon circle
                        Circle()
                            .fill(colors[index])
                            .frame(width: 50, height: 50)
                            .overlay(
                                Image(systemName: getSoundIcon(for: sound))
                                    .font(.poppinsBold(size: 20))
                                    .foregroundColor(.white)
                            )

                        // Sound name
                        Text(sound)
                            .font(.faro(size: 17))
                            .foregroundColor(.black)

                        Spacer()

                        // Play button
                        Button(action: {
                            SoundManager.shared.previewSound(named: sound)
                        }) {
                            Image(systemName: "play.fill")
                                .font(.system(size: 14))
                                .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                                .frame(width: 40, height: 40)
                                .background(Color.snapLightCardSecondary)
                                .clipShape(Circle())
                        }

                        // Toggle (circle)
                        Button(action: {
                            selectedSound = sound
                        }) {
                            ZStack {
                                Circle()
                                    .stroke(selectedSound == sound ? Color.snapOrange : Color.snapDivider(for: colorScheme), lineWidth: 2)
                                    .frame(width: 28, height: 28)

                                if selectedSound == sound {
                                    Circle()
                                        .fill(Color.snapOrange)
                                        .frame(width: 16, height: 16)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)

                    // Separator line (except for last item)
                    if index < sounds.count - 1 {
                        Rectangle()
                            .fill(Color.snapBorder(for: colorScheme))
                            .frame(height: 1)
                            .padding(.leading, 86)
                    }
                }
            }
            .background(Color.white)
            .cornerRadius(12)
        }
    }

    func getSoundIcon(for sound: String) -> String {
        switch sound {
        case "Default": return "bell.fill"
        case "Alarm Clock": return "alarm.fill"
        case "Reveille": return "music.note"
        case "Sparkles": return "sparkles"
        case "Mindful Earth": return "leaf.fill"
        case "Dialed": return "phone.fill"
        case "Rise And Shine": return "sunrise.fill"
        case "Air Raid": return "exclamationmark.triangle.fill"
        case "Rooster": return "bird.fill"
        case "Pop Star": return "star.fill"
        case "Sunray": return "sun.max.fill"
        case "Jolly Day": return "face.smiling.fill"
        case "London Town": return "building.2.fill"
        default: return "bell.fill"
        }
    }

    // MARK: - Days Selection (Step 31)
    var daysSelectionView: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 20)

            VStack(alignment: .leading, spacing: 8) {
                Text("Which days do you want\nCocorise to ring?")
                    .font(.poppinsBold(size: 24))
                    .foregroundColor(.black)

                Text("Select all days when you want to wake up with your alarm")
                    .font(.faro(size: 16))
                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 32)
            .padding(.bottom, 24)

            VStack(spacing: 16) {
                ForEach(Array(["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"].enumerated()), id: \.element) { index, day in
                    dayOptionButton(day, number: index + 1, isSelected: selectedDays.contains(day)) {
                        if selectedDays.contains(day) {
                            selectedDays.remove(day)
                        } else {
                            selectedDays.insert(day)
                        }
                    }
                }
            }
            .padding(.horizontal, 32)

            // Quick select buttons
            HStack(spacing: 12) {
                Button(action: {
                    selectedDays = Set(["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"])
                }) {
                    Text("Weekdays")
                        .font(.faro(size: 15))
                        .foregroundColor(Color.snapOrange)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.snapOrange.opacity(0.1))
                        .cornerRadius(20)
                }

                Button(action: {
                    selectedDays = Set(["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"])
                }) {
                    Text("Every day")
                        .font(.faro(size: 15))
                        .foregroundColor(Color.snapOrange)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.snapOrange.opacity(0.1))
                        .cornerRadius(20)
                }
            }
            .padding(.horizontal, 32)
            .padding(.top, 8)

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
                    .background(!selectedDays.isEmpty ? Color.snapOrange : Color.gray.opacity(0.3))
                    .cornerRadius(30)
            }
            .disabled(selectedDays.isEmpty)
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
        .background(Color.snapLightBackground)
    }

    // Day option button (multi-select version)
    func dayOptionButton(_ text: String, number: Int, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 20) {
                // Number circle
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.snapOrange : Color.white)
                        .frame(width: 40, height: 40)
                        .overlay(
                            Circle()
                                .stroke(isSelected ? Color.snapOrange : Color.snapBorder(for: colorScheme), lineWidth: 2)
                        )

                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.faroBold(size: 16))
                            .foregroundColor(.white)
                    } else {
                        Text("\(number)")
                            .font(.faroBold(size: 17))
                            .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                    }
                }

                // Text
                Text(text)
                    .font(.faro(size: 17))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Spacer()
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.snapOrange : Color.snapBorder(for: colorScheme), lineWidth: isSelected ? 2 : 1)
            )
            .cornerRadius(12)
        }
    }
}
