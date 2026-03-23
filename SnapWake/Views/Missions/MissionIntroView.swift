//
//  MissionIntroView.swift
//  SnapWake
//
//  Écran d'introduction avant chaque mission
//

import SwiftUI
import Lottie

struct MissionIntroView: View {
    let mission: Mission
    let onContinue: () -> Void

    @State private var contentOpacity: Double = 0
    @State private var cardScale: CGFloat = 0.9
    @State private var mascotScale: CGFloat = 0.95

    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                colors: [
                    Color(hex: "FFF4E6"),
                    Color(hex: "FFE8CC"),
                    Color.snapLightBackground
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Decorative circles
            Circle()
                .fill(Color.snapOrange.opacity(0.08))
                .frame(width: 300, height: 300)
                .offset(x: -120, y: -300)
                .blur(radius: 40)
                .opacity(contentOpacity)

            Circle()
                .fill(Color.snapPink.opacity(0.06))
                .frame(width: 250, height: 250)
                .offset(x: 130, y: 350)
                .blur(radius: 40)
                .opacity(contentOpacity)

            VStack(spacing: 0) {
                Spacer().frame(height: 60)

                // Good Morning text en haut (plus bas)
                VStack(spacing: 8) {
                    Text("Good Morning!")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundColor(.black)

                    Text("Let's crush this day! 💪")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.snapOrange)
                }
                .opacity(contentOpacity)

                Spacer().frame(height: 20)

                // Mission card au milieu - style moderne
                if !mission.isNoMission {
                    VStack(alignment: .leading, spacing: 12) {
                        // Badge avec icône SF Symbol
                        HStack(spacing: 8) {
                            Image(systemName: mission.icon)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                            Text("TODAY'S MISSION")
                                .font(.system(size: 11, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                                .tracking(1)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [Color.snapOrange, Color.snapPink],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )

                        // Nom de la mission
                        Text(mission.name)
                            .font(.system(size: 32, weight: .black, design: .rounded))
                            .foregroundColor(.black)

                        // Description
                        Text(mission.description)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(.black.opacity(0.6))
                            .lineLimit(2)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.1), radius: 30, y: 10)
                    )
                    .padding(.horizontal, 24)
                    .scaleEffect(cardScale)
                    .opacity(contentOpacity)
                }

                Spacer().frame(height: 30)

                // Mascotte + Lottie animations en bas
                HStack(spacing: -80) {
                    // Lottie gauche (crop pour coller)
                    LottieView(
                        animationName: "music equalizer",
                        loopMode: .loop,
                        contentMode: .scaleAspectFill,
                        animationSpeed: 1.0
                    )
                    .frame(width: 60, height: 100)
                    .clipped()
                    .opacity(contentOpacity)

                    // Mascotte au centre (2x plus grande)
                    Image("mascotte_morning")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 360, height: 360)
                        .scaleEffect(mascotScale)

                    // Lottie droite (crop pour coller)
                    LottieView(
                        animationName: "music equalizer",
                        loopMode: .loop,
                        contentMode: .scaleAspectFill,
                        animationSpeed: 1.0
                    )
                    .frame(width: 60, height: 100)
                    .clipped()
                    .opacity(contentOpacity)
                }
                .opacity(contentOpacity)

                Spacer()

                // Animated progress dots
                HStack(spacing: 10) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.snapOrange, Color.snapPink],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: 10, height: 10)
                            .opacity(contentOpacity)
                    }
                }
                .padding(.bottom, 70)
            }
        }
        .onAppear {
            // Fade in animation
            withAnimation(.easeOut(duration: 0.6)) {
                contentOpacity = 1.0
            }

            // Card scale animation
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                cardScale = 1.0
            }

            // Mascot bounce animation
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                mascotScale = 1.0
            }

            // Auto-continue to mission after 2.5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                onContinue()
            }
        }
    }
}

#Preview {
    MissionIntroView(
        mission: MissionsLibrary.shared.missions.first(where: { $0.type == .math })!,
        onContinue: { }
    )
}
