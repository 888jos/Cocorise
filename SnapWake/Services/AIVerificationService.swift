//
//  AIVerificationService.swift
//  SnapWake
//
//  Service d'IA pour vérification des photos/vidéos et audio
//  Utilise Apple Vision + Speech Recognition (100% GRATUIT!)
//

import UIKit
import Foundation
import Vision
import Speech

@MainActor
class AIVerificationService: ObservableObject {
    static let shared = AIVerificationService()

    private init() {
        requestSpeechPermission()
    }

    // MARK: - Speech Permission
    private func requestSpeechPermission() {
        SFSpeechRecognizer.requestAuthorization { status in
            print("Speech recognition permission: \(status.rawValue)")
        }
    }

    // MARK: - Photo Verification

    /// Vérifie une photo selon le type de mission
    func verifyPhoto(
        image: UIImage,
        mission: Mission,
        targetObject: String?,
        completion: @escaping (Bool, String) -> Void
    ) {
        // Dispatch based on mission type
        switch mission.name {
        case "Sky Photo":
            verifySkyPhoto(image: image, completion: completion)
        case "Make Bed":
            verifyBedPhoto(image: image, completion: completion)
        case "Object Hunt":
            verifyObjectPhoto(image: image, targetObject: targetObject ?? "object", completion: completion)
        case "Touch Grass":
            verifyGrassPhoto(image: image, completion: completion)
        default:
            completion(false, "Unknown mission type")
        }
    }

    // MARK: - Sky Detection

    /// Vérifie si la photo contient du ciel (Apple Vision - GRATUIT!)
    private func verifySkyPhoto(image: UIImage, completion: @escaping (Bool, String) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(false, "Invalid image")
            return
        }

        let request = VNClassifyImageRequest { request, error in
            guard let observations = request.results as? [VNClassificationObservation] else {
                DispatchQueue.main.async {
                    completion(false, "Unable to analyze image")
                }
                return
            }

            // Check top 10 results for sky-related labels
            let topResults = observations.prefix(10)
            let skyLabels = ["sky", "cloud", "outdoor", "blue sky", "cloudy", "sunset", "sunrise"]

            for observation in topResults {
                let identifier = observation.identifier.lowercased()
                for label in skyLabels {
                    if identifier.contains(label) && observation.confidence > 0.25 {
                        print("✅ Sky detected: \(identifier) (\(observation.confidence))")
                        DispatchQueue.main.async {
                            completion(true, "Perfect sky shot!")
                        }
                        return
                    }
                }
            }

            print("❌ No sky detected. Top: \(topResults.map { $0.identifier }.prefix(3))")
            DispatchQueue.main.async {
                completion(false, "Point camera at the sky")
            }
        }

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            try? handler.perform([request])
        }
    }

    // MARK: - Bed Detection

    /// Vérifie si le lit est fait (Apple Vision - GRATUIT!)
    private func verifyBedPhoto(image: UIImage, completion: @escaping (Bool, String) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(false, "Invalid image")
            return
        }

        let request = VNClassifyImageRequest { request, error in
            guard let observations = request.results as? [VNClassificationObservation] else {
                DispatchQueue.main.async {
                    completion(false, "Unable to analyze image")
                }
                return
            }

            let topResults = observations.prefix(15)
            let bedLabels = ["bed", "bedroom", "furniture", "mattress", "pillow", "duvet", "sheet"]

            for observation in topResults {
                let identifier = observation.identifier.lowercased()
                for label in bedLabels {
                    if identifier.contains(label) && observation.confidence > 0.2 {
                        print("✅ Bed detected: \(identifier) (\(observation.confidence))")
                        DispatchQueue.main.async {
                            completion(true, "Bed looks great!")
                        }
                        return
                    }
                }
            }

            print("❌ No bed detected. Top: \(topResults.map { $0.identifier }.prefix(3))")
            DispatchQueue.main.async {
                completion(false, "Show your made bed")
            }
        }

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            try? handler.perform([request])
        }
    }

    // MARK: - Object Detection

    /// Vérifie si l'objet cible est présent dans la photo
    private func verifyObjectPhoto(image: UIImage, targetObject: String, completion: @escaping (Bool, String) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(false, "Invalid image")
            return
        }

        let request = VNClassifyImageRequest { request, error in
            guard let observations = request.results as? [VNClassificationObservation] else {
                DispatchQueue.main.async {
                    completion(false, "Unable to analyze image")
                }
                return
            }

            // Check top 30 results for target object (increased from 20)
            let topResults = observations.prefix(30)
            let targetLower = targetObject.lowercased()

            // Get possible labels for this object
            let possibleLabels = self.getObjectLabels(for: targetLower)

            for observation in topResults {
                let identifier = observation.identifier.lowercased()

                // Check if identifier matches any possible label
                for label in possibleLabels {
                    if identifier.contains(label) && observation.confidence > 0.15 {
                        print("✅ Object detected: \(identifier) (\(observation.confidence))")
                        DispatchQueue.main.async {
                            completion(true, "\(targetObject) found!")
                        }
                        return
                    }
                }
            }

            print("❌ Object not found. Top: \(topResults.map { $0.identifier }.prefix(5))")
            DispatchQueue.main.async {
                completion(false, "Find \(targetObject)")
            }
        }

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            try? handler.perform([request])
        }
    }

    /// Returns possible Vision labels for an object
    private func getObjectLabels(for object: String) -> [String] {
        let objectLower = object.lowercased()

        switch objectLower {
        // Bathroom
        case let obj where obj.contains("toothbrush"):
            return ["toothbrush", "brush", "dental", "hygiene", "bathroom"]
        case let obj where obj.contains("shower"):
            return ["shower", "bathroom", "bathtub", "tile", "water"]
        case let obj where obj.contains("toilet") && !obj.contains("paper"):
            return ["toilet", "bathroom", "restroom", "wc", "lavatory"]
        case let obj where obj.contains("mirror"):
            return ["mirror", "glass", "reflection", "bathroom"]
        case let obj where obj.contains("shampoo"):
            return ["shampoo", "bottle", "bathroom", "hair care", "soap"]
        case let obj where obj.contains("toilet paper"):
            return ["toilet paper", "paper", "tissue", "roll", "bathroom"]
        case let obj where obj.contains("faucet"):
            return ["faucet", "tap", "sink", "water", "bathroom", "kitchen"]
        case let obj where obj.contains("soap"):
            return ["soap", "bar", "bathroom", "hygiene", "cleaner"]

        // Kitchen
        case let obj where obj.contains("coffee") || obj.contains("mug"):
            return ["coffee", "mug", "cup", "beverage", "drink", "kitchen"]
        case let obj where obj.contains("spoon"):
            return ["spoon", "utensil", "silverware", "cutlery", "kitchen"]
        case let obj where obj.contains("fork"):
            return ["fork", "utensil", "silverware", "cutlery", "kitchen"]
        case let obj where obj.contains("knife"):
            return ["knife", "utensil", "silverware", "cutlery", "blade", "kitchen"]
        case let obj where obj.contains("pan"):
            return ["pan", "frying pan", "cookware", "kitchen", "skillet"]
        case let obj where obj.contains("glass") && !obj.contains("eye"):
            return ["glass", "cup", "drinking glass", "glassware", "beverage"]
        case let obj where obj.contains("plate"):
            return ["plate", "dish", "tableware", "kitchen", "dining"]
        case let obj where obj.contains("fridge") || obj.contains("refrigerator"):
            return ["refrigerator", "fridge", "appliance", "kitchen"]
        case let obj where obj.contains("bread"):
            return ["bread", "loaf", "baguette", "food", "bakery"]
        case let obj where obj.contains("fruit"):
            return ["fruit", "apple", "orange", "banana", "food", "produce"]

        // Bedroom
        case let obj where obj.contains("bed"):
            return ["bed", "bedroom", "furniture", "mattress", "sleep"]
        case let obj where obj.contains("pillow"):
            return ["pillow", "cushion", "bed", "bedroom", "furniture"]
        case let obj where obj.contains("clock"):
            return ["clock", "time", "alarm", "watch", "timepiece"]
        case let obj where obj.contains("lamp"):
            return ["lamp", "light", "lighting", "illumination", "furniture"]
        case let obj where obj.contains("book"):
            return ["book", "reading", "literature", "novel", "publication"]
        case let obj where obj.contains("window"):
            return ["window", "glass", "pane", "frame", "architecture"]

        // Personal Items
        case let obj where obj.contains("shoe"):
            return ["shoe", "footwear", "sneaker", "boot", "sandal"]
        case let obj where obj.contains("keys"):
            return ["key", "keys", "keychain", "metal"]
        case let obj where obj.contains("water bottle") || (obj.contains("bottle") && obj.contains("water")):
            return ["water bottle", "bottle", "container", "drink", "hydration"]
        case let obj where obj.contains("backpack"):
            return ["backpack", "bag", "pack", "luggage", "school"]
        case let obj where obj.contains("charger") || obj.contains("phone charger"):
            return ["charger", "cable", "cord", "phone", "electronic"]
        case let obj where obj.contains("headphone"):
            return ["headphone", "earphone", "audio", "music", "earbuds"]
        case let obj where obj.contains("shirt"):
            return ["shirt", "clothing", "apparel", "garment", "tshirt"]
        case let obj where obj.contains("watch"):
            return ["watch", "wristwatch", "timepiece", "clock"]

        // Living Room
        case let obj where obj.contains("tv") || obj.contains("television"):
            return ["television", "tv", "screen", "monitor", "display"]
        case let obj where obj.contains("remote"):
            return ["remote", "control", "controller", "device"]
        case let obj where obj.contains("plant"):
            return ["plant", "houseplant", "potted plant", "flora", "green"]
        case let obj where obj.contains("door"):
            return ["door", "doorway", "entrance", "frame", "wood"]
        case let obj where obj.contains("picture") || obj.contains("frame"):
            return ["picture frame", "frame", "photo", "wall art", "decoration"]
        case let obj where obj.contains("candle"):
            return ["candle", "wax", "flame", "light", "decoration"]

        // Office/Study
        case let obj where obj.contains("pen"):
            return ["pen", "writing", "ballpoint", "stationery"]
        case let obj where obj.contains("laptop"):
            return ["laptop", "computer", "notebook", "electronic", "device"]
        case let obj where obj.contains("mouse"):
            return ["mouse", "computer mouse", "device", "peripheral"]
        case let obj where obj.contains("notebook"):
            return ["notebook", "book", "notepad", "journal", "stationery"]
        case let obj where obj.contains("printer"):
            return ["printer", "device", "office", "machine", "electronic"]

        // Pets & Nature
        case let obj where obj.contains("dog"):
            return ["dog", "pet", "animal", "canine", "puppy"]
        case let obj where obj.contains("cat"):
            return ["cat", "pet", "animal", "feline", "kitten"]
        case let obj where obj.contains("tree"):
            return ["tree", "plant", "nature", "outdoor", "wood"]
        case let obj where obj.contains("flower"):
            return ["flower", "plant", "bloom", "blossom", "nature"]

        // Misc
        case let obj where obj.contains("car"):
            return ["car", "automobile", "vehicle", "sedan", "transport"]
        case let obj where obj.contains("bike") || obj.contains("bicycle"):
            return ["bike", "bicycle", "cycle", "vehicle", "transport"]
        case let obj where obj.contains("smile") || obj.contains("face"):
            return ["face", "person", "smile", "human", "portrait"]

        default:
            // Return the object name itself
            return [objectLower]
        }
    }

    // MARK: - Grass Detection

    /// Vérifie si la photo contient de l'herbe
    private func verifyGrassPhoto(image: UIImage, completion: @escaping (Bool, String) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(false, "Invalid image")
            return
        }

        let request = VNClassifyImageRequest { request, error in
            guard let observations = request.results as? [VNClassificationObservation] else {
                DispatchQueue.main.async {
                    completion(false, "Unable to analyze image")
                }
                return
            }

            let topResults = observations.prefix(15)
            let grassLabels = ["grass", "lawn", "field", "meadow", "plant", "outdoor", "nature", "green"]

            for observation in topResults {
                let identifier = observation.identifier.lowercased()
                for label in grassLabels {
                    if identifier.contains(label) && observation.confidence > 0.2 {
                        print("✅ Grass detected: \(identifier) (\(observation.confidence))")
                        DispatchQueue.main.async {
                            completion(true, "Grass detected!")
                        }
                        return
                    }
                }
            }

            print("❌ No grass detected. Top: \(topResults.map { $0.identifier }.prefix(3))")
            DispatchQueue.main.async {
                completion(false, "Take photo of grass")
            }
        }

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            try? handler.perform([request])
        }
    }

    // MARK: - Exercise Detection (Video/Pose)

    /// Détecte un push-up (pompe) à partir d'une image
    /// TODO: Intégrer Vision Pose Detection
    func detectPushUp(from image: UIImage) -> Bool {
        // TODO: Utiliser VNDetectHumanBodyPoseRequest
        // Détecter:
        // - Corps horizontal
        // - Bras fléchis à ~90°
        // - Alignement corps droit

        /*
        let request = VNDetectHumanBodyPoseRequest()
        let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])

        try? handler.perform([request])

        guard let observation = request.results?.first else { return false }

        // Analyser points clés: épaules, coudes, poignets, hanches
        let shoulderY = observation.recognizedPoint(.leftShoulder)?.y ?? 0
        let hipY = observation.recognizedPoint(.leftHip)?.y ?? 0
        let elbowAngle = calculateElbowAngle(observation)

        // Push-up = corps horizontal + coudes fléchis
        return abs(shoulderY - hipY) < 0.1 && elbowAngle < 120
        */

        return false
    }

    /// Détecte un squat à partir d'une image
    /// TODO: Intégrer Vision Pose Detection
    func detectSquat(from image: UIImage) -> Bool {
        // TODO: Utiliser VNDetectHumanBodyPoseRequest
        // Détecter:
        // - Genoux fléchis à ~90°
        // - Dos droit
        // - Hanches descendues

        /*
        let request = VNDetectHumanBodyPoseRequest()
        let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])

        try? handler.perform([request])

        guard let observation = request.results?.first else { return false }

        // Analyser points clés: genoux, hanches, chevilles
        let kneeAngle = calculateKneeAngle(observation)
        let hipY = observation.recognizedPoint(.leftHip)?.y ?? 0
        let kneeY = observation.recognizedPoint(.leftKnee)?.y ?? 0

        // Squat = genoux fléchis + hanches basses
        return kneeAngle < 120 && hipY > kneeY
        */

        return false
    }

    // MARK: - Audio Verification

    /// Vérifie un enregistrement audio en le transcrivant et comparant avec le texte attendu
    func verifyAudio(audioURL: URL, expectedText: String, completion: @escaping (Bool, String) -> Void) {
        guard let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US")) else {
            DispatchQueue.main.async {
                completion(false, "Speech recognition not available")
            }
            return
        }

        guard recognizer.isAvailable else {
            DispatchQueue.main.async {
                completion(false, "Speech recognition not available")
            }
            return
        }

        let request = SFSpeechURLRecognitionRequest(url: audioURL)

        recognizer.recognitionTask(with: request) { result, error in
            if let error = error {
                print("❌ Speech recognition error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(false, "Unable to process audio")
                }
                return
            }

            guard let result = result, result.isFinal else { return }

            let transcription = result.bestTranscription.formattedString
            let similarity = self.calculateSimilarity(transcription, expectedText)

            print("📝 Transcription: \(transcription)")
            print("🎯 Expected: \(expectedText)")
            print("📊 Similarity: \(similarity)")

            DispatchQueue.main.async {
                if similarity > 0.5 {
                    completion(true, "Great job! 💯")
                } else {
                    completion(false, "Try reading it out loud clearly")
                }
            }
        }
    }

    /// Calcule la similarité entre deux textes (Jaccard similarity)
    private func calculateSimilarity(_ text1: String, _ text2: String) -> Double {
        let words1 = Set(text1.lowercased().components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty })
        let words2 = Set(text2.lowercased().components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty })

        let intersection = words1.intersection(words2)
        let union = words1.union(words2)

        guard !union.isEmpty else { return 0 }
        return Double(intersection.count) / Double(union.count)
    }

    // MARK: - Future Vision Pose Methods

    /*
    /// Calcule l'angle du coude pour détection de push-up
    /// TODO: Implémenter avec Vision Pose
    private func calculateElbowAngle(_ observation: VNHumanBodyPoseObservation) -> Double {
        // Placeholder
        return 90
    }

    /// Calcule l'angle du genou pour détection de squat
    /// TODO: Implémenter avec Vision Pose
    private func calculateKneeAngle(_ observation: VNHumanBodyPoseObservation) -> Double {
        // Placeholder
        return 90
    }
    */
}

// MARK: - Vision Body Pose Observation Extension (for future use)
/*
import Vision

extension VNHumanBodyPoseObservation {
    func recognizedPoint(_ jointName: VNHumanBodyPoseObservation.JointName) -> VNRecognizedPoint? {
        guard let point = try? recognizedPoint(jointName) else { return nil }
        return point.confidence > 0.5 ? point : nil
    }
}
*/
