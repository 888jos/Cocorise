//
//  NoMissionView.swift
//  SnapWake
//
//  Vue simple pour alarmes sans mission
//

import SwiftUI

struct NoMissionView: View {
    let onComplete: (Bool) -> Void

    @State private var countdown = 5
    @State private var isActive = false
    @State private var sunScale: CGFloat = 0.8
    @State private var greetingOpacity: Double = 0

    var body: some View {
        ZStack {
            // Beautiful sunrise gradient
            LinearGradient(
                colors: [
                    Color(hex: "FFA07A"), // Light Salmon
                    Color(hex: "FFD700"), // Gold
                    Color(hex: "FF6B6B"), // Coral Red
                    Color(hex: "FF8C42")  // Orange
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Animated circles in background
            Circle()
                .fill(Color.white.opacity(0.1))
                .frame(width: 300, height: 300)
                .offset(x: -100, y: -200)
                .blur(radius: 50)

            Circle()
                .fill(Color.yellow.opacity(0.15))
                .frame(width: 400, height: 400)
                .offset(x: 150, y: 250)
                .blur(radius: 60)

            VStack(spacing: 0) {
                Spacer()

                // Animated sun with rays
                ZStack {
                    // Sun rays
                    ForEach(0..<8) { index in
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.yellow.opacity(0.7))
                            .frame(width: 8, height: 40)
                            .offset(y: -80)
                            .rotationEffect(.degrees(Double(index) * 45))
                    }

                    // Sun circle
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color.yellow, Color.orange],
                                center: .center,
                                startRadius: 0,
                                endRadius: 70
                            )
                        )
                        .frame(width: 140, height: 140)
                        .shadow(color: Color.yellow.opacity(0.6), radius: 40, x: 0, y: 0)
                        .scaleEffect(sunScale)
                }
                .padding(.bottom, 60)

                // Greeting text
                VStack(spacing: 16) {
                    Text("Good Morning!")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.2), radius: 10, y: 5)

                    Text("Ready to start your day?")
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.95))
                        .shadow(color: .black.opacity(0.1), radius: 5, y: 3)
                }
                .opacity(greetingOpacity)

                Spacer()

                // Dismiss button or countdown
                if isActive {
                    VStack(spacing: 24) {
                        ZStack {
                            Circle()
                                .stroke(Color.white.opacity(0.3), lineWidth: 8)
                                .frame(width: 150, height: 150)

                            Text("\(countdown)")
                                .font(.system(size: 72, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }

                        Text("Alarm dismissed")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundColor(.white.opacity(0.9))
                    }
                } else {
                    Button(action: startDismiss) {
                        HStack(spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 24, weight: .semibold))

                            Text("Dismiss Alarm")
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                        }
                        .foregroundColor(Color(hex: "FF6B6B"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 22)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.2), radius: 20, y: 10)
                        )
                    }
                    .padding(.horizontal, 40)
                }

                Spacer().frame(height: 80)
            }
        }
        .onAppear {
            // Animate sun
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                sunScale = 1.0
            }

            // Fade in greeting
            withAnimation(.easeOut(duration: 0.8)) {
                greetingOpacity = 1.0
            }

            // Auto-dismiss after showing for a moment
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if !isActive {
                    startDismiss()
                }
            }
        }
    }

    private func startDismiss() {
        isActive = true
        startCountdown()
    }

    private func startCountdown() {
        guard countdown > 0 else {
            onComplete(true)
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            countdown -= 1
            startCountdown()
        }
    }
}

#Preview {
    NoMissionView(onComplete: { _ in })
}
