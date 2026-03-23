//
//  OnboardingReassuranceViews.swift
//  SnapWake
//
//  Motivational, reassurance, and transformation views
//

import SwiftUI
import Lottie

extension CompleteOnboardingView {

    // MARK: - Reassurance View 1: You're Not Alone
    var reassuranceView1: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 40) {
                MascotView(.bienvenue, size: .medium)
                    .padding(.top, 20)

                Text("You're not alone")
                    .font(.poppinsBold(size: 42))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                // Stats cards en grille 2x2
                VStack(spacing: 16) {
                    HStack(spacing: 16) {
                        // 10K+ users
                        VStack(spacing: 12) {
                            Text("👥")
                                .font(.system(size: 48))
                            VStack(spacing: 4) {
                                Text("10K+")
                                    .font(.poppinsBold(size: 32))
                                    .foregroundColor(.black)
                                Text("users")
                                    .font(.faro(size: 14))
                                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 24)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.06), radius: 8, y: 4)

                        // 85% success
                        VStack(spacing: 12) {
                            Text("🎯")
                                .font(.system(size: 48))
                            VStack(spacing: 4) {
                                Text("85%")
                                    .font(.poppinsBold(size: 32))
                                    .foregroundColor(.black)
                                Text("success rate")
                                    .font(.faro(size: 14))
                                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 24)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.06), radius: 8, y: 4)
                    }

                    HStack(spacing: 16) {
                        // 4.8 stars
                        VStack(spacing: 12) {
                            HStack(spacing: 2) {
                                ForEach(0..<5, id: \.self) { _ in
                                    Image(systemName: "star.fill")
                                        .font(.faro(size: 14))
                                        .foregroundColor(Color(hex: "FFD700"))
                                }
                            }
                            VStack(spacing: 4) {
                                Text("4.8/5")
                                    .font(.poppinsBold(size: 32))
                                    .foregroundColor(.black)
                                Text("app rating")
                                    .font(.faro(size: 14))
                                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 24)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.06), radius: 8, y: 4)

                        // Verified
                        VStack(spacing: 12) {
                            Text("✓")
                                .font(.poppinsBold(size: 48))
                                .foregroundColor(Color(hex: "00A86B"))
                            VStack(spacing: 4) {
                                Text("Verified")
                                    .font(.poppinsBold(size: 20))
                                    .foregroundColor(.black)
                                Text("by Apple")
                                    .font(.faro(size: 14))
                                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 24)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.06), radius: 8, y: 4)
                    }
                }
                .padding(.horizontal, 32)

                Text("Join a community that has transformed their mornings")
                    .font(.faro(size: 17))
                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }

            Spacer()
        }
        .background(Color.snapLightBackground)
        .onTapGesture {
            withAnimation {
                currentStep += 1
            }
        }
    }

    func statBox(_ number: String, _ text: String) -> some View {
        HStack(spacing: 16) {
            Text(number)
                .font(.poppinsBold(size: 32))
                .foregroundColor(Color.snapOrange)
                .frame(width: 80)

            Text(text)
                .font(.faro(size: 17))
                .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                .multilineTextAlignment(.leading)

            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
    }

    // MARK: - Pain Amplification View: Time Lost
    var painAmplificationView: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 60)

            // Lottie animation: sand clock
            LottieView(animationName: "sand clock", loopMode: .playOnce)
                .frame(width: 200, height: 200)

            Text("The real cost\nof snoozing")
                .font(.poppinsBold(size: 38))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(.top, 20)
                .padding(.bottom, 40)

            // Progression verticale simple
            VStack(spacing: 16) {
                TimeLostRow(period: "1 semaine", hours: "2h")
                TimeLostRow(period: "1 mois", hours: "10h")
                TimeLostRow(period: "1 an", hours: "120h")

                // Dramatic reveal - 10 ans
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("10 ans")
                                .font(.poppinsBold(size: 24))
                                .foregroundColor(.white)
                            Text("1 200 heures")
                                .font(.faro(size: 18))
                                .foregroundColor(.white.opacity(0.95))
                        }
                        Spacer()
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.poppinsBold(size: 36))
                            .foregroundColor(.white)
                    }
                    .padding(24)
                    .background(
                        LinearGradient(
                            colors: [Color(hex: "FF4757"), Color(hex: "FF6B6B")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(24)
                    .shadow(color: Color.red.opacity(0.3), radius: 20, y: 10)
                }
                .padding(.top, 8)
            }
            .padding(.horizontal, 32)

            Spacer().frame(height: 40)

            // Final impact statement
            VStack(spacing: 8) {
                HStack(spacing: 12) {
                    Image(systemName: "calendar.badge.exclamationmark")
                        .font(.poppinsBold(size: 32))
                        .foregroundColor(.red)

                    Text("50 jours")
                        .font(.poppinsBold(size: 52))
                        .foregroundColor(.red)
                }

                Text("of your life gone up in smoke")
                    .font(.faro(size: 17))
                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))
            }

            Spacer()

            Text("tape pour continuer")
                .font(.faro(size: 15))
                .foregroundColor(Color.snapTextTertiary(for: colorScheme))
                .padding(.bottom, 60)
        }
        .background(Color.snapLightBackground)
        .onTapGesture {
            withAnimation {
                currentStep += 1
            }
        }
    }

    // Nouvelle row simplifiée pour time lost
    func TimeLostRow(period: String, hours: String) -> some View {
        HStack {
            Text(period)
                .font(.faroBold(size: 18))
                .foregroundColor(.black)
            Spacer()
            HStack(spacing: 8) {
                Text(hours)
                    .font(.faro(size: 16))
                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                Image(systemName: "arrow.down")
                    .font(.faroBold(size: 14))
                    .foregroundColor(Color.snapOrange)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.white)
        .cornerRadius(16)
    }

    struct TimeStackCard: View {
        @Environment(\.colorScheme) var colorScheme
        let period: String
        let hours: String
        let position: Int

        var body: some View {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(period)
                        .font(.faroBold(size: 16))
                        .foregroundColor(.black)
                    Text(hours)
                        .font(.faro(size: 14))
                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                }
                Spacer()
                Image(systemName: "arrow.down")
                    .font(.faroBold(size: 16))
                    .foregroundColor(Color.snapOrange)
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 8, y: 4)
            .padding(.horizontal, 32)
            .offset(y: CGFloat(position * -4))
        }
    }

    func timeWasteBar(_ period: String, hours: Double, maxHours: Double, isHighlight: Bool = false, emoji: String = "") -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                HStack(spacing: 6) {
                    if !emoji.isEmpty {
                        Text(emoji)
                            .font(.faro(size: 16))
                    }
                    Text(period)
                        .font(.faroBold(size: 14))
                        .foregroundColor(isHighlight ? .red : .black)
                }
                Spacer()
                Text("\(Int(hours))h")
                    .font(.faroBold(size: 16))
                    .foregroundColor(isHighlight ? .red : Color.snapOrange)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.15))
                        .frame(height: 14)

                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            LinearGradient(
                                colors: isHighlight ? [.red, Color(hex: "FF6B6B")] : [Color.snapOrange, Color(hex: "FFB84D")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * min(hours / maxHours, 1.0), height: 14)
                        .shadow(color: (isHighlight ? Color.red : Color.snapOrange).opacity(0.3), radius: 4, y: 2)
                }
            }
            .frame(height: 14)
        }
        .padding(16)
        .background(isHighlight ? Color.red.opacity(0.05) : Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isHighlight ? Color.red.opacity(0.2) : Color.clear, lineWidth: 2)
        )
    }

    // MARK: - Quote View 1: Marcus Aurelius
    var quoteView1: some View {
        VStack(spacing: 0) {
            Spacer()

            ZStack {
                // Lottie animation: shining stars en arrière-plan
                LottieView(animationName: "shining stars", loopMode: .loop)
                    .frame(width: 200, height: 200)
                    .opacity(0.3)

                VStack(spacing: 0) {
                    HStack(alignment: .top) {
                        Text("\"")
                            .font(.poppinsBold(size: 60))
                            .foregroundColor(.white.opacity(0.3))
                        Spacer()
                    }

                    VStack(spacing: 0) {
                        Text("When you arise in the morning,")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)

                        Text("think of what a precious privilege")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)

                        Text("it is to be alive,")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)

                        Text("to breathe, to be happy.")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }

                    HStack(alignment: .bottom) {
                        Spacer()
                        Text("\"")
                            .font(.poppinsBold(size: 60))
                            .foregroundColor(.white.opacity(0.3))
                    }
                    .padding(.bottom, 16)

                    HStack(spacing: 8) {
                        Rectangle()
                            .fill(Color.black)
                            .frame(width: 40, height: 3)

                        Text("Marcus Aurelius")
                            .font(.faro(size: 14))
                            .foregroundColor(.white.opacity(0.8))

                        Rectangle()
                            .fill(Color.black)
                            .frame(width: 40, height: 3)
                    }
                }
                .padding(.vertical, 48)
                .padding(.horizontal, 40)
            }
            .background(Color.snapOrange)
            .cornerRadius(24)
            .shadow(color: Color.snapOrange.opacity(0.3), radius: 20, x: 0, y: 10)
            .padding(.horizontal, 32)

            Spacer()
        }
        .background(Color.snapLightBackground)
        .onTapGesture {
            withAnimation {
                currentStep += 1
            }
        }
    }

    // MARK: - Quote View 2: Robert Kiyosaki
    var quoteView2: some View {
        VStack(spacing: 0) {
            Spacer()

            ZStack {
                // Lottie animation: shining stars en arrière-plan
                LottieView(animationName: "shining stars", loopMode: .loop)
                    .frame(width: 200, height: 200)
                    .opacity(0.3)

                VStack(spacing: 0) {
                    HStack(alignment: .top) {
                        Text("\"")
                            .font(.poppinsBold(size: 60))
                            .foregroundColor(.white.opacity(0.3))
                        Spacer()
                    }

                    VStack(spacing: 0) {
                        Text("Your future is created by")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)

                        Text("ce que tu fais aujourd'hui,")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)

                        Text("pas demain.")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }

                    HStack(alignment: .bottom) {
                        Spacer()
                        Text("\"")
                            .font(.poppinsBold(size: 60))
                            .foregroundColor(.white.opacity(0.3))
                    }
                    .padding(.bottom, 16)

                    HStack(spacing: 8) {
                        Rectangle()
                            .fill(Color.black)
                            .frame(width: 40, height: 3)

                        Text("Robert Kiyosaki")
                            .font(.faro(size: 14))
                            .foregroundColor(.white.opacity(0.8))

                        Rectangle()
                            .fill(Color.black)
                            .frame(width: 40, height: 3)
                    }
                }
                .padding(.vertical, 48)
                .padding(.horizontal, 40)
            }
            .background(Color.snapOrange)
            .cornerRadius(24)
            .shadow(color: Color.snapOrange.opacity(0.3), radius: 20, x: 0, y: 10)
            .padding(.horizontal, 32)

            Spacer()
        }
        .background(Color.snapLightBackground)
        .onTapGesture {
            withAnimation {
                currentStep += 1
            }
        }
    }

    // MARK: - Empathy View: It's Not Your Fault
    var empathyView: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 40) {
                // Emoji + title
                VStack(spacing: 24) {
                    MascotView(.guide, size: .medium)

                    Text("It's not\nyour fault")
                        .font(.poppinsBold(size: 42))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                }

                // Explication scientifique
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(alignment: .top, spacing: 16) {
                            Text("💤")
                                .font(.system(size: 28))
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Sleep inertia")
                                    .font(.faroBold(size: 18))
                                    .foregroundColor(.black)
                                Text("Your brain needs 15-30 minutes to fully wake up")
                                    .font(.faro(size: 15))
                                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                                    .lineSpacing(4)
                            }
                        }
                        .padding(20)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.06), radius: 8, y: 4)

                        HStack(alignment: .top, spacing: 16) {
                            Text("🔄")
                                .font(.system(size: 28))
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Ingrained habits")
                                    .font(.faroBold(size: 18))
                                    .foregroundColor(.black)
                                Text("Snoozing has become an automatic reflex after years")
                                    .font(.faro(size: 15))
                                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                                    .lineSpacing(4)
                            }
                        }
                        .padding(20)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.06), radius: 8, y: 4)
                    }
                    .padding(.horizontal, 32)

                    // Science badge
                    HStack(spacing: 12) {
                        Image(systemName: "brain.head.profile")
                            .font(.poppinsBold(size: 20))
                            .foregroundColor(Color.snapOrange)

                        Text("Validated by neuroscience")
                            .font(.faroBold(size: 15))
                            .foregroundColor(Color.snapOrange)
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 14)
                    .background(Color.snapOrange.opacity(0.1))
                    .cornerRadius(25)
                }
            }

            Spacer()
        }
        .background(Color.snapLightBackground)
        .onTapGesture {
            withAnimation {
                currentStep += 1
            }
        }
    }

    func empathyPoint(_ emoji: String, _ text: String) -> some View {
        HStack(spacing: 16) {
            Text(emoji)
                .font(.system(size: 28, weight: .bold, design: .rounded))

            Text(text)
                .font(.faro(size: 18))
                .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                .multilineTextAlignment(.leading)

            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
    }

    // MARK: - Transformation Graphic View: Before/After
    var transformationGraphicView: some View {
        VStack(spacing: 0) {
            Spacer()

            Text("One alarm.\nOne mission.")
                .font(.poppinsBold(size: 32))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(.bottom, 40)

            // Single white background card
            HStack(alignment: .top, spacing: 24) {
                // TYPICAL MORNING (Left)
                VStack(spacing: 0) {
                    Text("TYPICAL MORNING")
                        .font(.faroBold(size: 11))
                        .foregroundColor(Color.snapTextTertiary(for: colorScheme))
                        .padding(.bottom, 20)

                    VStack(spacing: 0) {
                        transformationStepWithArrow("bell.fill", "7:00", "Alarm", gradient: [Color(hex: "FFD700"), Color(hex: "FFA500")], index: 0, arrowColor: Color(hex: "FFA500"))
                        transformationStepWithArrow("zzz", "7:09", "Snooze", gradient: [Color(hex: "FFA500"), Color(hex: "FF8C00")], index: 1, arrowColor: Color(hex: "FF8C00"))
                        transformationStepWithArrow("zzz", "7:18", "Snooze", gradient: [Color(hex: "FF8C00"), Color(hex: "FF6347")], index: 2, arrowColor: Color(hex: "FF6347"))
                        transformationStepWithArrow("exclamationmark.triangle.fill", "7:27", "Panic", gradient: [Color(hex: "FF6347"), Color(hex: "DC143C")], index: 3, arrowColor: nil)
                    }
                }
                .frame(maxWidth: .infinity)

                // WAYK MORNING (Right)
                VStack(spacing: 0) {
                    Text("WAYK MORNING")
                        .font(.faroBold(size: 11))
                        .foregroundColor(Color(hex: "00C853"))
                        .padding(.bottom, 20)

                    VStack(spacing: 0) {
                        transformationStepGreenWithArrow("bell.fill", "7:00", "Alarm", index: 4)
                        transformationStepGreenWithArrow("checkmark.circle.fill", "7:01", "Mission", index: 5)
                        transformationStepGreenWithArrow("sun.max.fill", "7:02", "Started", index: 6)
                    }

                    // 25 MINS GAINED
                    VStack(spacing: 4) {
                        Text("25 MINS")
                            .font(.poppinsBold(size: 26))
                            .foregroundColor(Color(hex: "00C853"))
                        Text("GAINED")
                            .font(.faroBold(size: 12))
                            .foregroundColor(Color(hex: "00C853"))
                    }
                    .padding(.vertical, 14)
                    .padding(.horizontal, 18)
                    .background(Color(hex: "00C853").opacity(0.1))
                    .cornerRadius(12)
                    .padding(.top, 20)
                    .opacity(showTransformationItems ? 1 : 0)
                    .animation(.easeIn(duration: 0.3).delay(2.5), value: showTransformationItems)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 28)
            .background(Color.white)
            .cornerRadius(20)
            .padding(.horizontal, 20)

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
        .onAppear {
            showTransformationItems = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                showTransformationItems = true
            }
        }
        .onDisappear {
            showTransformationItems = false
        }
    }

    // Helper for transformation step WITH curved arrow (left side)
    func transformationStepWithArrow(_ iconName: String, _ time: String, _ label: String, gradient: [Color], index: Int, arrowColor: Color?) -> some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 12) {
                // Icon circle with gradient
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: gradient,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)

                    Image(systemName: iconName)
                        .font(.poppinsBold(size: 20))
                        .foregroundColor(.white)
                }
                .opacity(showTransformationItems ? 1 : 0)
                .scaleEffect(showTransformationItems ? 1 : 0.5)
                .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(Double(index) * 0.4), value: showTransformationItems)

                // Time and label
                VStack(alignment: .leading, spacing: 2) {
                    Text(time)
                        .font(.faroBold(size: 18))
                        .foregroundColor(.black)

                    Text(label)
                        .font(.faro(size: 13))
                        .foregroundColor(Color.snapTextTertiary(for: colorScheme))
                }
                .opacity(showTransformationItems ? 1 : 0)
                .animation(.easeIn(duration: 0.3).delay(Double(index) * 0.4 + 0.1), value: showTransformationItems)

                Spacer()
            }

            // Curved arrow
            if let arrowColor = arrowColor {
                CurvedArrow(color: arrowColor)
                    .frame(width: 30, height: 35)
                    .padding(.leading, 10)
                    .scaleEffect(y: showTransformationItems ? 1 : 0, anchor: .top)
                    .opacity(showTransformationItems ? 1 : 0)
                    .animation(.easeOut(duration: 0.4).delay(Double(index) * 0.4 + 0.3), value: showTransformationItems)
            }
        }
    }

    // Helper for transformation step WITH arrow (right side - green)
    func transformationStepGreenWithArrow(_ iconName: String, _ time: String, _ label: String, index: Int) -> some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 12) {
                // Green gradient icon
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "00E676"), Color(hex: "00C853")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)

                    Image(systemName: iconName)
                        .font(.poppinsBold(size: 20))
                        .foregroundColor(.white)
                }
                .opacity(showTransformationItems ? 1 : 0)
                .scaleEffect(showTransformationItems ? 1 : 0.5)
                .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(1.6 + Double(index - 4) * 0.3), value: showTransformationItems)

                // Time and label
                VStack(alignment: .leading, spacing: 2) {
                    Text(time)
                        .font(.faroBold(size: 18))
                        .foregroundColor(.black)

                    Text(label)
                        .font(.faro(size: 13))
                        .foregroundColor(Color.snapTextTertiary(for: colorScheme))
                }
                .opacity(showTransformationItems ? 1 : 0)
                .animation(.easeIn(duration: 0.3).delay(1.6 + Double(index - 4) * 0.3 + 0.1), value: showTransformationItems)

                Spacer()
            }

            // Green line connector (only for first 2)
            if index < 6 {
                Rectangle()
                    .fill(Color(hex: "00C853"))
                    .frame(width: 3, height: 25)
                    .padding(.leading, 24)
                    .scaleEffect(y: showTransformationItems ? 1 : 0, anchor: .top)
                    .opacity(showTransformationItems ? 1 : 0)
                    .animation(.easeOut(duration: 0.3).delay(1.6 + Double(index - 4) * 0.3 + 0.3), value: showTransformationItems)
            }
        }
    }

    // Curved arrow shape
    struct CurvedArrow: View {
        let color: Color

        var body: some View {
            Path { path in
                path.move(to: CGPoint(x: 15, y: 0))
                path.addQuadCurve(
                    to: CGPoint(x: 20, y: 30),
                    control: CGPoint(x: 25, y: 15)
                )
                // Arrow head
                path.move(to: CGPoint(x: 20, y: 30))
                path.addLine(to: CGPoint(x: 15, y: 25))
                path.move(to: CGPoint(x: 20, y: 30))
                path.addLine(to: CGPoint(x: 25, y: 25))
            }
            .stroke(color, lineWidth: 3)
        }
    }

    // MARK: - Vision Board View: Visualize Your New Life
    var visionBoardView: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 20)

            // Lottie animation: Growing Plant en haut
            LottieView(animationName: "Growing Plant", loopMode: .playOnce)
                .frame(width: 180, height: 180)

            Text("Visualize your new life")
                .font(.poppinsBold(size: 28))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(.bottom, 24)

            // Layout en bento box style
            VStack(spacing: 10) {
                // Première ligne - 2 grandes cards
                HStack(spacing: 10) {
                    visionCardLarge("bolt.fill", "Energized", "Every morning", gradient: [Color(hex: "FFB84D"), Color(hex: "FF8C00")])
                    visionCardLarge("target", "Productive", "Every day", gradient: [Color(hex: "FF6B6B"), Color(hex: "FF4757")])
                }

                // Deuxième ligne - 3 petites cards
                HStack(spacing: 10) {
                    visionCardSmall("sparkles", "Confident", gradient: [Color(hex: "FFD700"), Color(hex: "FFA500")])
                    visionCardSmall("star.fill", "Ambitious", gradient: [Color(hex: "00A86B"), Color(hex: "00D084")])
                    visionCardSmall("figure.run", "Disciplined", gradient: [Color(hex: "9B59B6"), Color(hex: "8E44AD")])
                }

                // Troisième ligne - 1 grande card centrée
                visionCardWide("sun.max.fill", "Fulfilled", "Truly", gradient: [Color.snapOrange, Color(hex: "FF6347")])
            }
            .padding(.horizontal, 24)

            Spacer()

            Text("tape pour continuer")
                .font(.faro(size: 15))
                .foregroundColor(Color.snapTextTertiary(for: colorScheme))
                .padding(.bottom, 60)
        }
        .background(Color.snapLightBackground)
        .onTapGesture {
            withAnimation {
                currentStep += 1
            }
        }
    }

    // Card large pour Énergique et Productif
    func visionCardLarge(_ iconName: String, _ title: String, _ subtitle: String, gradient: [Color]) -> some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: gradient,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)

                Image(systemName: iconName)
                    .font(.poppinsBold(size: 24))
                    .foregroundColor(.white)
            }

            VStack(spacing: 4) {
                Text(title)
                    .font(.faroBold(size: 16))
                    .foregroundColor(.black)

                Text(subtitle)
                    .font(.faro(size: 12))
                    .foregroundColor(Color.snapTextTertiary(for: colorScheme))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 8, y: 4)
    }

    // Card small pour Confiant, Ambitieux, Discipliné
    func visionCardSmall(_ iconName: String, _ title: String, gradient: [Color]) -> some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: gradient,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 44, height: 44)

                Image(systemName: iconName)
                    .font(.poppinsBold(size: 20))
                    .foregroundColor(.white)
            }

            Text(title)
                .font(.faroBold(size: 14))
                .foregroundColor(.black)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, y: 4)
    }

    // Card wide pour Épanoui
    func visionCardWide(_ iconName: String, _ title: String, _ subtitle: String, gradient: [Color]) -> some View {
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
                    .frame(width: 54, height: 54)

                Image(systemName: iconName)
                    .font(.poppinsBold(size: 26))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.faroBold(size: 18))
                    .foregroundColor(.black)

                Text(subtitle)
                    .font(.faro(size: 13))
                    .foregroundColor(Color.snapTextTertiary(for: colorScheme))
            }

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 8, y: 4)
    }

    // MARK: - Success Stories View: They Succeeded, You Can Too
    var successStoriesView: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 40) {
                VStack(spacing: 24) {
                    MascotView(.victoire, size: .medium)

                    Text("They succeeded,\nyou can too")
                        .font(.poppinsBold(size: 42))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }

                // Témoignages rapides
                VStack(spacing: 16) {
                    HStack(alignment: .top, spacing: 12) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 4) {
                                ForEach(0..<5, id: \.self) { _ in
                                    Image(systemName: "star.fill")
                                        .font(.faro(size: 10))
                                        .foregroundColor(Color(hex: "FFD700"))
                                }
                            }
                            Text("\"I wake up on the first try now. Cocorise changed my life!\"")
                                .font(.faro(size: 14))
                                .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                                .lineSpacing(4)
                            Text("— Sarah, 28")
                                .font(.faro(size: 12))
                                .foregroundColor(Color.snapTextTertiary(for: colorScheme))
                        }
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.06), radius: 8, y: 4)
                    }

                    HStack(alignment: .top, spacing: 12) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 4) {
                                ForEach(0..<5, id: \.self) { _ in
                                    Image(systemName: "star.fill")
                                        .font(.faro(size: 10))
                                        .foregroundColor(Color(hex: "FFD700"))
                                }
                            }
                            Text("\"Plus besoin de 5 alarmes. Une mission et c'est bon, je suis debout !\"")
                                .font(.faro(size: 14))
                                .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                                .lineSpacing(4)
                            Text("— Marc, 35")
                                .font(.faro(size: 12))
                                .foregroundColor(Color.snapTextTertiary(for: colorScheme))
                        }
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.06), radius: 8, y: 4)
                    }
                }
                .padding(.horizontal, 32)

                // Badge de confiance
                HStack(spacing: 12) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "00A86B"))
                    Text("+10,000 mornings transformed")
                        .font(.faroBold(size: 16))
                        .foregroundColor(.black)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 14)
                .background(Color.white)
                .cornerRadius(25)
                .shadow(color: Color.black.opacity(0.08), radius: 12, y: 4)
            }

            Spacer()
        }
        .background(Color.snapLightBackground)
        .onTapGesture {
            withAnimation {
                currentStep += 1
            }
        }
    }

    func testimonialMini(_ name: String, _ text: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(name)
                .font(.faroBold(size: 14))
                .foregroundColor(Color.snapOrange)
            Text(text)
                .font(.faro(size: 15))
                .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                .italic()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(12)
    }

    // MARK: - Comparison View: One Alarm, One Mission
    var comparisonView: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 20)

            Text("One alarm. One mission.")
                .font(.poppinsBold(size: 34))
                .foregroundColor(Color.snapOrange)
                .padding(.horizontal, 32)
                .padding(.bottom, 40)

            HStack(spacing: 0) {
                VStack(spacing: 16) {
                    Text("TYPICAL MORNING")
                        .font(.faroBold(size: 11))
                        .foregroundColor(.gray)

                    VStack(spacing: 12) {
                        timelineItem("🔔", "7:00", "Alarm", .orange)
                        timelineLine(.orange, .orange)
                        timelineItem("💤", "7:09", "Snooze", .orange)
                        timelineLine(.orange, .red)
                        timelineItem("💤", "7:18", "Snooze", .red)
                        timelineLine(.red, .gray)
                        timelineItem("⚠️", "7:27", "Panic", .red)
                    }
                }
                .frame(maxWidth: .infinity)

                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 1)

                VStack(spacing: 16) {
                    Text("WAYK MORNING")
                        .font(.faroBold(size: 11))
                        .foregroundColor(Color(hex: "00A86B"))

                    VStack(spacing: 12) {
                        timelineItem("🔔", "7:00", "Alarm", Color(hex: "00A86B"))
                        timelineLine(Color(hex: "00A86B"), Color(hex: "00A86B"))
                        timelineItem("✅", "7:01", "Mission", Color(hex: "00A86B"))
                        timelineLine(Color(hex: "00A86B"), Color(hex: "00A86B"))
                        timelineItem("☀️", "7:02", "Started", Color(hex: "00A86B"))

                        Spacer().frame(height: 20)

                        VStack(spacing: 4) {
                            Text("25 MINS")
                                .font(.poppinsBold(size: 24))
                                .foregroundColor(Color(hex: "00A86B"))
                            Text("GAINED")
                                .font(.faroBold(size: 11))
                                .foregroundColor(Color(hex: "00A86B").opacity(0.6))
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color(hex: "00A86B").opacity(0.1))
                        .cornerRadius(12)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(20)
            .padding(.horizontal, 32)

            Spacer()
        }
        .background(Color.snapLightBackground)
    }

    func timelineItem(_ emoji: String, _ time: String, _ label: String, _ color: Color) -> some View {
        HStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 36, height: 36)
                Text(emoji)
                    .font(.faro(size: 18))
            }

            VStack(alignment: .leading, spacing: 0) {
                Text(time)
                    .font(.faroBold(size: 15))
                    .foregroundColor(Color.snapOrange)
                Text(label)
                    .font(.faro(size: 13))
                    .foregroundColor(.gray)
            }
        }
    }

    func timelineLine(_ from: Color, _ to: Color) -> some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [from, to],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(width: 2, height: 20)
            .offset(x: -30)
    }
}
