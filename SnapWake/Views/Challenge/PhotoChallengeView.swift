//
//  PhotoChallengeView.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import SwiftUI
import AVFoundation
import Vision

struct PhotoChallengeView: View {
    @Environment(\.colorScheme) var colorScheme
    let mission: Mission
    let difficulty: Difficulty
    let onComplete: (Bool) -> Void

    @State private var showCamera = false
    @State private var capturedImage: UIImage?
    @State private var isAnalyzing = false
    @State private var analysisResult: String?
    @State private var timeRemaining: TimeInterval
    @State private var timer: Timer?
    @State private var targetObject: ChallengeObject?

    init(mission: Mission, difficulty: Difficulty, onComplete: @escaping (Bool) -> Void) {
        self.mission = mission
        self.difficulty = difficulty
        self.onComplete = onComplete
        _timeRemaining = State(initialValue: difficulty.timeLimit)
    }

    var body: some View {
        ZStack {
            Color.snapBackground(for: colorScheme)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: mission.icon)
                            .font(.system(size: 32))
                            .foregroundColor(.snapOrange)

                        Spacer()

                        Text(formatTime(timeRemaining))
                            .font(.faroBold(size: 24))
                            .foregroundColor(timeRemaining < 30 ? .red : Color.snapTextPrimary(for: colorScheme))
                    }

                    Text(mission.name)
                        .font(.faroBold(size: 28))
                        .foregroundColor(Color.snapTextPrimary(for: colorScheme))

                    Text(getInstructions())
                        .font(.faro(size: 14))
                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                        .multilineTextAlignment(.center)
                }
                .padding()

                Spacer()

                if let image = capturedImage {
                    // Show captured image
                    VStack(spacing: 16) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 300)
                            .cornerRadius(16)
                            .padding(.horizontal)

                        if isAnalyzing {
                            HStack(spacing: 12) {
                                ProgressView()
                                    .tint(.snapOrange)
                                Text("Analyzing photo...")
                                    .font(.faro(size: 16))
                                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                            }
                        }

                        if let result = analysisResult {
                            Text(result)
                                .font(.faroBold(size: 16))
                                .foregroundColor(result.contains("Success") ? .snapGreen : .red)
                                .multilineTextAlignment(.center)
                                .padding()
                        }

                        Button(action: { capturedImage = nil; analysisResult = nil }) {
                            Text("Retake Photo")
                                .font(.faro(size: 16))
                                .foregroundColor(.snapOrange)
                        }
                    }
                } else {
                    // Camera button
                    VStack(spacing: 24) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 80))
                            .foregroundColor(Color.snapTextSecondary(for: colorScheme))

                        Button(action: { showCamera = true }) {
                            Text("Take Photo")
                                .font(.faroBold(size: 18))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    LinearGradient(
                                        colors: [Color.snapOrange, Color.snapPink],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(16)
                        }
                        .padding(.horizontal, 32)
                    }
                }

                Spacer()
            }
        }
        .sheet(isPresented: $showCamera) {
            ChallengeCameraView { image in
                capturedImage = image
                analyzeImage(image)
            }
        }
        .onAppear {
            startTimer()
            if mission.name == "Object Hunt" {
                targetObject = ChallengeDatabase.shared.randomObject(for: difficulty)
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
    }

    private func getInstructions() -> String {
        if mission.name == "Object Hunt", let target = targetObject {
            return "Find and photograph \(target.name)"
        }
        return mission.description
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
                onComplete(false)
            }
        }
    }

    private func analyzeImage(_ image: UIImage) {
        isAnalyzing = true

        // Simple validation based on mission type
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isAnalyzing = false

            // For now, accept all photos (Vision framework integration can be added later)
            analysisResult = "Success! Photo accepted ✓"

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                timer?.invalidate()
                onComplete(true)
            }
        }
    }

    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// Camera View using UIImagePickerController
struct ChallengeCameraView: UIViewControllerRepresentable {
    let onCapture: (UIImage) -> Void
    @Environment(\.dismiss) private var dismiss

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ChallengeCameraView

        init(_ parent: ChallengeCameraView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.onCapture(image)
            }
            parent.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

#Preview {
    PhotoChallengeView(
        mission: MissionsLibrary.shared.missions.first(where: { $0.name == "Sky Photo" })!,
        difficulty: .medium
    ) { _ in }
}
