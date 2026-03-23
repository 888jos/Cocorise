//
//  ImageRecognitionService.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import Vision
import UIKit
import CoreImage

class ImageRecognitionService {
    static let shared = ImageRecognitionService()

    // Anti-triche: vérifier la luminosité
    func checkImageBrightness(_ image: UIImage) -> Bool {
        guard let ciImage = CIImage(image: image) else { return false }

        let extentVector = CIVector(x: ciImage.extent.origin.x,
                                    y: ciImage.extent.origin.y,
                                    z: ciImage.extent.size.width,
                                    w: ciImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage",
                                    parameters: [kCIInputImageKey: ciImage,
                                                kCIInputExtentKey: extentVector]) else { return false }

        guard let outputImage = filter.outputImage else { return false }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull as Any])
        context.render(outputImage,
                      toBitmap: &bitmap,
                      rowBytes: 4,
                      bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                      format: .RGBA8,
                      colorSpace: nil)

        let brightness = (CGFloat(bitmap[0]) + CGFloat(bitmap[1]) + CGFloat(bitmap[2])) / 3.0 / 255.0

        // La photo doit avoir une luminosité minimale (pas une photo très sombre/prise dans le noir)
        return brightness > 0.15
    }

    // Reconnaissance d'image avec Vision
    func recognizeObject(in image: UIImage, keywords: [String], completion: @escaping (Bool, String) -> Void) {
        guard let ciImage = CIImage(image: image) else {
            completion(false, "Failed to process image")
            return
        }

        // Vérifier la luminosité d'abord
        guard checkImageBrightness(image) else {
            completion(false, "Image too dark - take a photo in a well-lit area")
            return
        }

        let request = VNRecognizeTextRequest { request, error in
            // Cette version utilise la reconnaissance de texte
            // Pour une vraie reconnaissance d'objets, utiliser VNClassifyImageRequest
            // ou un modèle CoreML custom
        }

        // Utiliser VNClassifyImageRequest pour reconnaître des objets
        let classificationRequest = VNClassifyImageRequest { request, error in
            guard let results = request.results as? [VNClassificationObservation] else {
                completion(false, "No objects detected")
                return
            }

            // Chercher si un des keywords correspond aux objets détectés
            let detectedLabels = results.prefix(10).map { $0.identifier.lowercased() }

            for keyword in keywords {
                let lowercasedKeyword = keyword.lowercased()
                for label in detectedLabels {
                    if label.contains(lowercasedKeyword) || lowercasedKeyword.contains(label) {
                        completion(true, "Found: \(label)")
                        return
                    }
                }
            }

            // Si aucun match, retourner les objets détectés
            let topResults = results.prefix(3).map { "\($0.identifier) (\(Int($0.confidence * 100))%)" }.joined(separator: ", ")
            completion(false, "I see: \(topResults)")
        }

        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([classificationRequest])
            } catch {
                DispatchQueue.main.async {
                    completion(false, "Recognition failed: \(error.localizedDescription)")
                }
            }
        }
    }

    // Anti-triche: vérifier que la photo n'est pas de la galerie (timestamp)
    func isPhotoRecent(_ image: UIImage, maxAgeSeconds: TimeInterval = 30) -> Bool {
        // Dans une vraie implémentation, on vérifierait les métadonnées EXIF
        // Pour l'instant, on assume que toute photo prise via la caméra est récente
        return true
    }
}
