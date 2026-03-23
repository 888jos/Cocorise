//
//  SoundsView.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import SwiftUI

struct SoundsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var alarmManager = AlarmManager.shared
    @StateObject private var audioPlayer = AudioPlayerService.shared
    @Binding var selectedSoundName: String

    var body: some View {
        VStack(spacing: 0) {
            // Header fixe - très compact
            ZStack {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.primary)
                    }
                    Spacer()
                }

                Text("Alarm Sound")
                    .font(.faroBold(size: 16))
                    .foregroundColor(Color.snapTextPrimary(for: colorScheme))
            }
            .padding(.horizontal, 16)
            .frame(height: 44)
            .background(Color.snapBackground(for: colorScheme))

            ScrollView {
                VStack(spacing: 20) {
                    // AI Generated Banner (placeholder)
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("NEW")
                                    .font(.faro(size: 10))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 7)
                                    .padding(.vertical, 3)
                                    .background(Color.white.opacity(0.3))
                                    .cornerRadius(5)

                                Spacer()
                            }

                            Text("Create Your Alarm Sound")
                                .font(.faroBold(size: 17))
                                .foregroundColor(.white)

                            Text("AI-generated jingles, made for you")
                                .font(.faro(size: 13))
                                .foregroundColor(.white.opacity(0.9))

                            HStack(spacing: 4) {
                                Image(systemName: "sparkles")
                                    .font(.system(size: 11))
                                Text("1 credit")
                                    .font(.faro(size: 12))
                            }
                            .foregroundColor(.white.opacity(0.9))
                        }

                        Spacer()

                        Image(systemName: "sparkles")
                            .font(.system(size: 36))
                            .foregroundColor(.white.opacity(0.3))
                    }
                    .padding(14)
                    .background(
                        LinearGradient(
                            colors: [Color.orange, Color.red],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(12)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)

                    // Upload Sound button
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Your Sounds")
                            .font(.faroBold(size: 16))
                            .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                            .padding(.horizontal, 16)

                        Button(action: {}) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))

                                Text("Upload Sound")
                                    .font(.faro(size: 15))
                                    .foregroundColor(Color.snapTextPrimary(for: colorScheme))

                                Spacer()
                            }
                            .padding(14)
                            .background(Color.snapCard(for: colorScheme))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal, 16)
                    }

                    // Classic sounds
                    SoundCategorySection(
                        category: .classic,
                        selectedSoundName: selectedSoundName,
                        onSoundSelect: { sound in
                            selectedSoundName = sound.name
                            dismiss()
                        },
                        onPlayTap: { sound in
                            audioPlayer.playSound(sound)
                        }
                    )

                    // Viral sounds
                    SoundCategorySection(
                        category: .viral,
                        selectedSoundName: selectedSoundName,
                        onSoundSelect: { sound in
                            selectedSoundName = sound.name
                            dismiss()
                        },
                        onPlayTap: { sound in
                            audioPlayer.playSound(sound)
                        }
                    )

                    // Aggressive sounds
                    SoundCategorySection(
                        category: .aggressive,
                        selectedSoundName: selectedSoundName,
                        onSoundSelect: { sound in
                            selectedSoundName = sound.name
                            dismiss()
                        },
                        onPlayTap: { sound in
                            audioPlayer.playSound(sound)
                        }
                    )

                    // Peaceful sounds
                    SoundCategorySection(
                        category: .peaceful,
                        selectedSoundName: selectedSoundName,
                        onSoundSelect: { sound in
                            selectedSoundName = sound.name
                            dismiss()
                        },
                        onPlayTap: { sound in
                            audioPlayer.playSound(sound)
                        }
                    )

                    Spacer(minLength: 20)
                }
            }
            .background(Color.snapBackground(for: colorScheme))
        }
        .background(Color.snapBackground(for: colorScheme))
        .onDisappear {
            audioPlayer.stopSound()
        }
    }
}

struct SoundCategorySection: View {
    @Environment(\.colorScheme) var colorScheme
    let category: SoundCategory
    let selectedSoundName: String
    let onSoundSelect: (AlarmSound) -> Void
    let onPlayTap: (AlarmSound) -> Void

    var sounds: [AlarmSound] {
        SoundsLibrary.shared.sounds(for: category)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 5) {
                Image(systemName: category.icon)
                    .font(.system(size: 14))
                    .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                Text(category.rawValue)
                    .font(.faroBold(size: 16))
                    .foregroundColor(Color.snapTextPrimary(for: colorScheme))
            }
            .padding(.horizontal, 16)

            ForEach(sounds) { sound in
                SoundRowNew(
                    sound: sound,
                    isSelected: selectedSoundName == sound.name,
                    onTap: {
                        onSoundSelect(sound)
                    },
                    onPlayTap: {
                        onPlayTap(sound)
                    }
                )
                .padding(.horizontal, 16)
            }
        }
    }
}

struct SoundRowNew: View {
    @Environment(\.colorScheme) var colorScheme
    let sound: AlarmSound
    let isSelected: Bool
    let onTap: () -> Void
    let onPlayTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Color square
                RoundedRectangle(cornerRadius: 10)
                    .fill(sound.displayColor)
                    .frame(width: 45, height: 45)

                // Name
                Text(sound.name)
                    .font(.faroBold(size: 15))
                    .foregroundColor(Color.snapTextPrimary(for: colorScheme))

                Spacer()

                // Play button
                Button(action: onPlayTap) {
                    Image(systemName: "play.fill")
                        .font(.system(size: 12))
                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                        .frame(width: 30, height: 30)
                        .background(Color.snapCardSecondary(for: colorScheme))
                        .clipShape(Circle())
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(12)
            .background(Color.snapCard(for: colorScheme))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.snapGreen : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SoundsView(selectedSoundName: .constant("Default"))
}
