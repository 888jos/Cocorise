//
//  GoalCommittedView.swift
//  SnapWake
//
//  Created by Josselin Biot on 08/03/2026.
//

import SwiftUI
import PencilKit

struct GoalCommittedView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var commitmentManager = CommitmentManager.shared
    @StateObject private var alarmManager = AlarmManager.shared
    @State private var canvasView = PKCanvasView()
    @State private var refreshTrigger = false

    var nextAlarmTime: String {
        guard let alarm = alarmManager.alarms.first(where: { $0.isEnabled }) else {
            return "6:30 AM"
        }
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: alarm.time)
    }

    var goalWakeTime: String {
        _ = refreshTrigger // Force refresh
        if let goalWakeTime = UserDefaults.standard.object(forKey: "goalWakeTime") as? Date {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: goalWakeTime)
        }
        return nextAlarmTime
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            ZStack {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.primary)
                            .padding()
                    }
                    Spacer()
                }

                Text("Goal Committed")
                    .font(.faroSemiBold(size: 20))
                    .foregroundColor(Color.snapTextPrimary(for: colorScheme))
            }
            .frame(height: 60)
            .background(Color.snapBackground(for: colorScheme))

            if commitmentManager.goalCommittedTime != nil {
                // Locked in state
                LockedInView(alarmTime: nextAlarmTime)
            } else {
                // Commitment view with signature
                ScrollView {
                    VStack(spacing: 20) {
                        // Commitment bullet points
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(alignment: .top, spacing: 10) {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(.snapOrange)
                                Text("I commit to waking up at \(goalWakeTime) every day")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .foregroundColor(.black)
                                    .fixedSize(horizontal: false, vertical: true)
                            }

                            HStack(alignment: .top, spacing: 10) {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(.snapOrange)
                                Text("I commit to never hitting snooze again")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .foregroundColor(.black)
                                    .fixedSize(horizontal: false, vertical: true)
                            }

                            HStack(alignment: .top, spacing: 10) {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(.snapOrange)
                                Text("I commit to starting each day with purpose")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .foregroundColor(.black)
                                    .fixedSize(horizontal: false, vertical: true)
                            }

                            HStack(alignment: .top, spacing: 10) {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(.snapOrange)
                                Text("I commit to building unstoppable morning habits")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .foregroundColor(.black)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 32)
                        .padding(.top, 24)

                        // Signature section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Sign below to seal your commitment")
                                .font(.faro(size: 15))
                                .foregroundColor(Color.snapTextSecondary(for: colorScheme))

                            ZStack {
                                // Placeholder text derrière
                                if canvasView.drawing.bounds.isEmpty {
                                    Text("Draw your signature")
                                        .font(.faro(size: 16))
                                        .foregroundColor(Color.gray.opacity(0.5))
                                }

                                // Canvas pour dessiner par-dessus
                                SignatureCanvas(canvasView: $canvasView)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                            }
                            .frame(height: 180)
                        }
                        .padding(.horizontal, 24)

                        // Clear button
                        Button(action: {
                            canvasView.drawing = PKDrawing()
                        }) {
                            Text("Clear Signature")
                                .font(.faro(size: 14))
                                .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                                .underline()
                        }

                        Spacer(minLength: 30)
                    }
                }

                // Seal Goal button at bottom
                VStack {
                    Spacer()

                    Button(action: {
                        commitmentManager.goalCommittedTime = Date()
                        dismiss()
                    }) {
                        Text("Seal Goal")
                    }
                    .snapPrimaryButton(isEnabled: !canvasView.drawing.bounds.isEmpty)
                    .disabled(canvasView.drawing.bounds.isEmpty)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
        }
        .background(Color.snapBackground(for: colorScheme))
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("goalWakeTimeChanged"))) { _ in
            refreshTrigger.toggle()
        }
    }
}

struct SignatureCanvas: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView

    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .anyInput
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 2)
        canvasView.backgroundColor = .clear
        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {}
}

struct LockedInView: View {
    @Environment(\.colorScheme) var colorScheme
    let alarmTime: String

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            VStack(spacing: 16) {
                Text("Locked in.")
                    .font(.faroBold(size: 48))
                    .foregroundColor(Color.snapTextPrimary(for: colorScheme))

                Text("No excuses.")
                    .font(.faroBold(size: 48))
                    .foregroundColor(Color.snapTextPrimary(for: colorScheme))
            }

            // Signature display (placeholder with lock icon)
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.snapGreen.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.snapGreen, lineWidth: 2)
                    )
                    .frame(height: 200)

                // Lock icon
                Image(systemName: "lock.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.snapGreen)
                    .padding(16)

                // Placeholder signature drawing
                Path { path in
                    path.move(to: CGPoint(x: 80, y: 100))
                    path.addCurve(
                        to: CGPoint(x: 280, y: 120),
                        control1: CGPoint(x: 150, y: 60),
                        control2: CGPoint(x: 220, y: 140)
                    )
                }
                .stroke(Color.snapTextPrimary(for: colorScheme), lineWidth: 2)
                .padding(40)
            }
            .padding(.horizontal, 24)

            Text("Wake up at \(alarmTime)")
                .font(.faro(size: 17))
                .foregroundColor(Color.snapTextSecondary(for: colorScheme))

            Spacer()

            Text("You cannot change tomorrow's goal, you've already committed.")
                .font(.faro(size: 15))
                .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
        }
    }
}

#Preview {
    GoalCommittedView()
}
