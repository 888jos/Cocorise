//
//  OnboardingHelpers.swift
//  SnapWake
//
//  Helper views and components used across onboarding screens
//

import SwiftUI

// MARK: - Reusable Helper Functions

extension CompleteOnboardingView {

    func questionView(title: String, options: [String], selection: Binding<String>, isLast: Bool = false) -> some View {
        VStack(spacing: 0) {
            Text(title)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
                .lineSpacing(2)
                .padding(.horizontal, 32)
                .padding(.top, 24)
                .padding(.bottom, 24)
                .frame(maxWidth: .infinity, alignment: .leading)
                .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity), removal: .opacity))

            VStack(spacing: 16) {
                ForEach(Array(options.enumerated()), id: \.element) { index, option in
                    optionButton(option, number: index + 1, isSelected: selection.wrappedValue == option) {
                        selection.wrappedValue = option
                    }
                    .transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity), removal: .opacity))
                    .animation(.easeOut(duration: 0.3).delay(Double(index) * 0.08), value: currentStep)
                }
            }
            .padding(.horizontal, 32)

            Spacer()

            Button(action: {
                withAnimation {
                    if isLast {
                        finishOnboarding()
                    } else {
                        currentStep += 1
                    }
                }
            }) {
                Text("Continue")
                    .font(.faroBold(size: 17))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(!selection.wrappedValue.isEmpty ? Color.snapOrange : Color.gray.opacity(0.3))
                    .cornerRadius(30)
            }
            .disabled(selection.wrappedValue.isEmpty)
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
        .background(Color.snapLightBackground)
    }

    func optionButton(_ text: String, number: Int = 0, isSelected: Bool = false, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                if number > 0 {
                    ZStack {
                        Circle()
                            .fill(Color.snapOrange)
                            .frame(width: 32, height: 32)

                        Text("\(number)")
                            .font(.faroBold(size: 15))
                            .foregroundColor(.white)
                    }
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
                    .stroke(isSelected ? Color.snapOrange : Color.clear, lineWidth: 2)
            )
        }
    }

    func continueButton(enabled: Bool) -> some View {
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
                .background(enabled ? Color.snapOrange : Color.snapDivider(for: colorScheme))
                .cornerRadius(30)
        }
        .disabled(!enabled)
        .padding(.horizontal, 32)
        .padding(.bottom, 40)
    }

    func getMissionIcon(for mission: String) -> some View {
        let iconData = getMissionIconData(for: mission)

        return ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: iconData.gradient,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 120, height: 120)

            Image(systemName: iconData.icon)
                .font(.system(size: 60, weight: .bold))
                .foregroundColor(.white)
        }
    }

    func getMissionIconData(for mission: String) -> (icon: String, gradient: [Color]) {
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
            return ("bell.fill", [Color.snapOrange, Color(hex: "FF8C00")])
        }
    }
}

// MARK: - External Components

// Frame Corner Shape for camera view
struct FrameCorner: View {
    let corners: UIRectCorner

    var body: some View {
        ZStack {
            if corners.contains(.topLeft) {
                VStack(alignment: .leading, spacing: 0) {
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 40, height: 4)
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 4, height: 40)
                }
            }
            if corners.contains(.topRight) {
                VStack(alignment: .trailing, spacing: 0) {
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 40, height: 4)
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 4, height: 40)
                }
            }
            if corners.contains(.bottomLeft) {
                VStack(alignment: .leading, spacing: 0) {
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 4, height: 40)
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 40, height: 4)
                }
            }
            if corners.contains(.bottomRight) {
                VStack(alignment: .trailing, spacing: 0) {
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 4, height: 40)
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 40, height: 4)
                }
            }
        }
        .frame(width: 40, height: 40)
    }
}

// Signature Canvas for commitment view
struct OnboardingSignatureCanvas: View {
    @Binding var signature: String
    @State private var lines: [[CGPoint]] = []
    @State private var currentLine: [CGPoint] = []

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 4, y: 2)

            if lines.isEmpty && currentLine.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "pencil.line")
                        .font(.system(size: 32))
                        .foregroundColor(.gray.opacity(0.4))
                    Text("Sign here with your finger")
                        .font(.faro(size: 16))
                        .foregroundColor(.gray.opacity(0.6))
                }
            }

            Canvas { context, size in
                // Draw all completed lines
                for line in lines {
                    var path = Path()
                    if let firstPoint = line.first {
                        path.move(to: firstPoint)
                        for point in line.dropFirst() {
                            path.addLine(to: point)
                        }
                    }
                    context.stroke(path, with: .color(.black), lineWidth: 3)
                }

                // Draw current line being drawn
                if !currentLine.isEmpty {
                    var path = Path()
                    if let firstPoint = currentLine.first {
                        path.move(to: firstPoint)
                        for point in currentLine.dropFirst() {
                            path.addLine(to: point)
                        }
                    }
                    context.stroke(path, with: .color(.black), lineWidth: 3)
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        currentLine.append(value.location)
                        if !currentLine.isEmpty {
                            signature = "signed"
                        }
                    }
                    .onEnded { _ in
                        if !currentLine.isEmpty {
                            lines.append(currentLine)
                            currentLine = []
                        }
                    }
            )
        }
        .onChange(of: signature) { newValue in
            if newValue.isEmpty {
                lines = []
                currentLine = []
            }
        }
    }
}
