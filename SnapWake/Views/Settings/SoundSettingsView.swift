//
//  SoundSettingsView.swift
//  SnapWake
//
//  Created by Claude on 20/03/2026.
//

import SwiftUI

struct SoundSettingsView: View {
    @AppStorage("selectedAlarmSound") private var selectedSound = "Default"
    @StateObject private var soundManager = SoundManager.shared

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    // Dismiss
                }) {
                    Image(systemName: "chevron.left")
                        .font(.faroBold(size: 18))
                        .foregroundColor(.black)
                }

                Spacer()

                Text("Alarm Sound")
                    .font(.faroBold(size: 20))
                    .foregroundColor(.black)

                Spacer()

                // Placeholder for symmetry
                Color.clear
                    .frame(width: 24, height: 24)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)

            ScrollView {
                VStack(spacing: 20) {
                    ForEach(soundManager.getSoundsByCategory(), id: \.category) { category in
                        VStack(spacing: 0) {
                            // Category header
                            if !category.icon.isEmpty {
                                HStack(spacing: 8) {
                                    Text(category.icon)
                                        .font(.faro(size: 16))
                                    Text(category.category)
                                        .font(.faroBold(size: 14))
                                        .foregroundColor(Color(hex: "666666"))
                                    Spacer()
                                }
                                .padding(.horizontal, 20)
                                .padding(.bottom, 8)
                            } else {
                                HStack {
                                    Text(category.category)
                                        .font(.faroBold(size: 14))
                                        .foregroundColor(Color(hex: "666666"))
                                    Spacer()
                                }
                                .padding(.horizontal, 20)
                                .padding(.bottom, 8)
                            }

                            // Sound list
                            VStack(spacing: 0) {
                                ForEach(Array(category.sounds.enumerated()), id: \.element) { index, sound in
                                    soundRow(
                                        sound: sound,
                                        color: Color(hex: category.colors[index]),
                                        isLast: index == category.sounds.count - 1
                                    )
                                }
                            }
                            .background(Color.white)
                            .cornerRadius(16)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
            }
        }
        .background(Color(hex: "F5F5F5").ignoresSafeArea())
    }

    @ViewBuilder
    private func soundRow(sound: String, color: Color, isLast: Bool) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                // Icon
                Circle()
                    .fill(color)
                    .frame(width: 44, height: 44)
                    .overlay(
                        Image(systemName: getSoundIcon(for: sound))
                            .font(.faroBold(size: 18))
                            .foregroundColor(.white)
                    )

                // Sound name
                Text(sound)
                    .font(.faro(size: 17))
                    .foregroundColor(.black)

                Spacer()

                // Play button
                Button(action: {
                    soundManager.previewSound(named: sound)
                }) {
                    Image(systemName: soundManager.isPlaying ? "stop.fill" : "play.fill")
                        .font(.faroBold(size: 14))
                        .foregroundColor(.white)
                        .frame(width: 36, height: 36)
                        .background(Color.snapOrange)
                        .clipShape(Circle())
                }

                // Selection checkmark
                if selectedSound == sound {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.faroBold(size: 24))
                        .foregroundColor(.snapOrange)
                } else {
                    Circle()
                        .stroke(Color(hex: "D0D0D0"), lineWidth: 2)
                        .frame(width: 24, height: 24)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .contentShape(Rectangle())
            .onTapGesture {
                selectedSound = sound
                soundManager.previewSound(named: sound)
            }

            // Separator
            if !isLast {
                Rectangle()
                    .fill(Color(hex: "E0E0E0"))
                    .frame(height: 1)
                    .padding(.leading, 76)
            }
        }
    }

    private func getSoundIcon(for sound: String) -> String {
        switch sound {
        case "Default": return "bell.fill"
        case "Alarm Clock Bell": return "alarm.fill"
        case "UK Tea Timer": return "cup.and.saucer.fill"
        case "Air Raid Siren": return "exclamationmark.triangle.fill"
        case "Rooster Crowing": return "sunrise.fill"
        case "Morning Birds": return "bird.fill"
        case "Ocean Waves": return "water.waves"
        case "Zen Garden": return "leaf.fill"
        default: return "speaker.wave.2.fill"
        }
    }
}

#Preview {
    SoundSettingsView()
}
