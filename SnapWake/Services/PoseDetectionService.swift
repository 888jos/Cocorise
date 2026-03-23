//
//  PoseDetectionService.swift
//  SnapWake
//
//  Service de détection de pose avec Apple Vision
//  Détecte push-ups et squats en temps réel via la caméra
//

import Foundation
import Vision
import UIKit
import AVFoundation

@MainActor
class PoseDetectionService: ObservableObject {
    @Published var currentReps = 0
    @Published var feedback = ""
    @Published var isDetecting = false

    private var exerciseType: ExerciseType = .pushUp
    private var targetReps = 10
    private var repCallback: ((Int, String) -> Void)?

    // State tracking for rep counting
    private var isInDownPosition = false
    private var lastAngle: Double = 0

    enum ExerciseType {
        case pushUp
        case squat
    }

    // MARK: - Public Methods

    func startDetection(exerciseType: String, targetReps: Int = 10, callback: @escaping (Int, String) -> Void) {
        self.targetReps = targetReps
        self.repCallback = callback
        self.currentReps = 0
        self.isDetecting = true
        self.isInDownPosition = false

        // Determine exercise type
        if exerciseType.lowercased().contains("push") {
            self.exerciseType = .pushUp
        } else if exerciseType.lowercased().contains("squat") {
            self.exerciseType = .squat
        }

        feedback = "Position yourself in frame"
        callback(0, feedback)
    }

    func stopDetection() {
        isDetecting = false
    }

    // MARK: - Process Frame

    func processFrame(_ sampleBuffer: CMSampleBuffer) {
        guard isDetecting else { return }
        guard currentReps < targetReps else { return }

        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }

        let request = VNDetectHumanBodyPoseRequest()
        request.revision = VNDetectHumanBodyPoseRequestRevision1

        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])

        do {
            try handler.perform([request])

            guard let observation = request.results?.first else {
                updateFeedback("Stand in frame")
                return
            }

            // Process based on exercise type
            switch exerciseType {
            case .pushUp:
                processPushUpPose(observation)
            case .squat:
                processSquatPose(observation)
            }

        } catch {
            print("Failed to perform pose detection: \(error)")
        }
    }

    // MARK: - Push-up Detection

    private func processPushUpPose(_ observation: VNHumanBodyPoseObservation) {
        // Get key points for push-up
        guard let leftShoulder = getPoint(.leftShoulder, from: observation),
              let leftElbow = getPoint(.leftElbow, from: observation),
              let leftWrist = getPoint(.leftWrist, from: observation),
              let rightShoulder = getPoint(.rightShoulder, from: observation),
              let rightElbow = getPoint(.rightElbow, from: observation),
              let rightWrist = getPoint(.rightWrist, from: observation) else {
            updateFeedback("Position yourself in frame")
            return
        }

        // Calculate elbow angles (average of both arms)
        let leftElbowAngle = calculateAngle(
            pointA: leftShoulder,
            pointB: leftElbow,
            pointC: leftWrist
        )

        let rightElbowAngle = calculateAngle(
            pointA: rightShoulder,
            pointB: rightElbow,
            pointC: rightWrist
        )

        let avgElbowAngle = (leftElbowAngle + rightElbowAngle) / 2
        lastAngle = avgElbowAngle

        // Push-up detection logic
        // Down position: elbow angle < 120 degrees (more tolerant)
        // Up position: elbow angle > 140 degrees (more tolerant)

        if avgElbowAngle < 120 {
            if !isInDownPosition {
                isInDownPosition = true
                updateFeedback("Good! Now push up 💪")
            }
        } else if avgElbowAngle > 140 && isInDownPosition {
            // Rep completed!
            isInDownPosition = false
            currentReps += 1

            if currentReps >= targetReps {
                updateFeedback("Complete! 🎉")
            } else if currentReps >= targetReps - 2 {
                updateFeedback("Almost there! 🔥")
            } else {
                updateFeedback("Good! \(currentReps)/\(targetReps)")
            }

            repCallback?(currentReps, feedback)
        }
    }

    // MARK: - Squat Detection

    private func processSquatPose(_ observation: VNHumanBodyPoseObservation) {
        // Get key points for squat
        guard let leftHip = getPoint(.leftHip, from: observation),
              let leftKnee = getPoint(.leftKnee, from: observation),
              let leftAnkle = getPoint(.leftAnkle, from: observation),
              let rightHip = getPoint(.rightHip, from: observation),
              let rightKnee = getPoint(.rightKnee, from: observation),
              let rightAnkle = getPoint(.rightAnkle, from: observation) else {
            updateFeedback("Position yourself in frame")
            return
        }

        // Calculate knee angles (average of both legs)
        let leftKneeAngle = calculateAngle(
            pointA: leftHip,
            pointB: leftKnee,
            pointC: leftAnkle
        )

        let rightKneeAngle = calculateAngle(
            pointA: rightHip,
            pointB: rightKnee,
            pointC: rightAnkle
        )

        let avgKneeAngle = (leftKneeAngle + rightKneeAngle) / 2
        lastAngle = avgKneeAngle

        // Squat detection logic
        // Down position: knee angle < 120 degrees (more tolerant)
        // Up position: knee angle > 150 degrees (more tolerant)

        if avgKneeAngle < 120 {
            if !isInDownPosition {
                isInDownPosition = true
                updateFeedback("Good! Now stand up 💪")
            }
        } else if avgKneeAngle > 150 && isInDownPosition {
            // Rep completed!
            isInDownPosition = false
            currentReps += 1

            if currentReps >= targetReps {
                updateFeedback("Complete! 🎉")
            } else if currentReps >= targetReps - 2 {
                updateFeedback("Almost there! 🔥")
            } else {
                updateFeedback("Good! \(currentReps)/\(targetReps)")
            }

            repCallback?(currentReps, feedback)
        }
    }

    // MARK: - Helper Methods

    private func getPoint(_ jointName: VNHumanBodyPoseObservation.JointName, from observation: VNHumanBodyPoseObservation) -> CGPoint? {
        guard let point = try? observation.recognizedPoint(jointName),
              point.confidence > 0.2 else {
            return nil
        }
        return CGPoint(x: point.location.x, y: point.location.y)
    }

    private func calculateAngle(pointA: CGPoint, pointB: CGPoint, pointC: CGPoint) -> Double {
        // Calculate angle at point B
        let vectorBA = CGVector(dx: pointA.x - pointB.x, dy: pointA.y - pointB.y)
        let vectorBC = CGVector(dx: pointC.x - pointB.x, dy: pointC.y - pointB.y)

        let angleBA = atan2(vectorBA.dy, vectorBA.dx)
        let angleBC = atan2(vectorBC.dy, vectorBC.dx)

        var angle = abs(angleBA - angleBC)

        // Convert to degrees
        angle = angle * 180 / .pi

        // Normalize to 0-180
        if angle > 180 {
            angle = 360 - angle
        }

        return angle
    }

    private func updateFeedback(_ message: String) {
        feedback = message
        repCallback?(currentReps, feedback)
    }
}
