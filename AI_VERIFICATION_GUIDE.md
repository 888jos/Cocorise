# Guide de Vérification IA - SnapWake

## 🎯 Stratégie Recommandée (Moindre Coût)

### Phase 1: **100% GRATUIT** (Lancement)

#### Photos
1. **Apple Vision Framework** (gratuit, offline)
   - Sky Photo: Détecte "sky", "cloud"
   - Make Bed: Détecte "bed", "bedroom"
   - Object Hunt: Détecte objets spécifiques
   - Touch Grass: Détecte "grass", "plant"

#### Audio
2. **Apple Speech Recognition** (gratuit)
   - Transcrit l'audio en texte
   - Compare avec l'affirmation/verset attendu
   - Validation si similarité > 70%

**Coût total: $0/mois** ✅

---

### Phase 2: **Hybride** (Croissance)

#### Photos sensibles
- Sky/Grass: Apple Vision (gratuit)
- Make Bed/Object Hunt: **GPT-4o-mini Vision** ($0.00015/image)
  - Plus précis pour contexte complexe
  - Peut comprendre "Est-ce que le lit est bien fait?"

#### Audio
- Continue Apple Speech (gratuit)
- Ou upgrade vers **Whisper API** si besoin multilingue ($0.006/min)

**Coût estimé: $5-20/mois pour 1000 utilisateurs actifs**

---

### Phase 3: **Premium** (Scale)

#### Photos
- Tout avec **GPT-4 Vision** ou **Google Cloud Vision**
- Cache les résultats pour éviter re-vérifications

#### Audio
- **Whisper API** pour toutes les langues
- Analyse sentiment pour engagement

**Coût estimé: $50-200/mois pour 10k utilisateurs**

---

## 📊 Comparaison Prix

| Service | Photo | Audio | Gratuit? | Offline? |
|---------|-------|-------|----------|----------|
| Apple Vision | ✅ | ❌ | ✅ Oui | ✅ Oui |
| Apple Speech | ❌ | ✅ | ✅ Oui | ✅ Partiel |
| GPT-4o-mini | ✅ | ✅ | ❌ $0.00015/req | ❌ Non |
| Google Cloud | ✅ | ✅ | 🟡 1k/mois | ❌ Non |
| Whisper API | ❌ | ✅ | ❌ $0.006/min | ❌ Non |

---

## 🔧 Implémentation Recommandée

### 1. Créer `AIVerificationService.swift`

```swift
import Vision
import Speech
import UIKit

class AIVerificationService {
    static let shared = AIVerificationService()

    // MARK: - Photo Verification
    func verifyPhoto(image: UIImage, mission: Mission, completion: @escaping (Bool, String) -> Void) {
        switch mission.name {
        case "Sky Photo":
            verifyWithVision(image: image, expectedLabels: ["sky", "cloud", "outdoor"]) { success in
                completion(success, success ? "Perfect sky shot!" : "Point at the sky")
            }

        case "Make Bed":
            verifyWithVision(image: image, expectedLabels: ["bed", "bedroom", "furniture"]) { success in
                completion(success, success ? "Bed looks great!" : "Show your made bed")
            }

        case "Object Hunt":
            if let targetObject = mission.targetObject {
                verifyWithVision(image: image, expectedLabels: [targetObject.lowercased()]) { success in
                    completion(success, success ? "Found it!" : "Keep looking for \(targetObject)")
                }
            }

        case "Touch Grass":
            verifyWithVision(image: image, expectedLabels: ["grass", "plant", "outdoor"]) { success in
                completion(success, success ? "Nature vibes!" : "Find some grass")
            }

        default:
            completion(true, "Mission complete!")
        }
    }

    private func verifyWithVision(image: UIImage, expectedLabels: [String], completion: @escaping (Bool) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(false)
            return
        }

        let request = VNClassifyImageRequest { request, error in
            guard let observations = request.results as? [VNClassificationObservation] else {
                completion(false)
                return
            }

            // Check top 10 results
            let topResults = observations.prefix(10)

            for observation in topResults {
                let identifier = observation.identifier.lowercased()

                // Check if any expected label matches
                for label in expectedLabels {
                    if identifier.contains(label) && observation.confidence > 0.3 {
                        print("✅ Detected: \(identifier) (\(observation.confidence))")
                        completion(true)
                        return
                    }
                }
            }

            print("❌ Expected: \(expectedLabels), Got: \(topResults.map { $0.identifier })")
            completion(false)
        }

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            try? handler.perform([request])
        }
    }

    // MARK: - Audio Verification
    func verifyAudio(audioURL: URL, expectedText: String, completion: @escaping (Bool, String) -> Void) {
        let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
        let request = SFSpeechURLRecognitionRequest(url: audioURL)

        recognizer?.recognitionTask(with: request) { result, error in
            guard let result = result, result.isFinal else { return }

            let transcription = result.bestTranscription.formattedString
            let similarity = self.calculateSimilarity(transcription, expectedText)

            if similarity > 0.5 {
                completion(true, "Great job! 💯")
            } else {
                completion(false, "Try reading it out loud clearly")
            }
        }
    }

    private func calculateSimilarity(_ text1: String, _ text2: String) -> Double {
        let words1 = Set(text1.lowercased().components(separatedBy: .whitespacesAndNewlines))
        let words2 = Set(text2.lowercased().components(separatedBy: .whitespacesAndNewlines))

        let intersection = words1.intersection(words2)
        let union = words1.union(words2)

        guard !union.isEmpty else { return 0 }
        return Double(intersection.count) / Double(union.count)
    }
}
```

### 2. Demander Permission Speech

Dans `Info.plist` (déjà fait pour micro):
```xml
<key>NSSpeechRecognitionUsageDescription</key>
<string>SnapWake uses speech recognition to verify you read your affirmations and Bible verses out loud.</string>
```

### 3. Utiliser dans les Missions

**PhotoMissionView:**
```swift
AIVerificationService.shared.verifyPhoto(image: image, mission: mission) { success, message in
    // Afficher résultat
}
```

**AffirmationMissionView:**
```swift
AIVerificationService.shared.verifyAudio(
    audioURL: recordingURL,
    expectedText: selectedAffirmation
) { success, message in
    // Validation
}
```

---

## 💡 Optimisations

### 1. Caching
Cache les résultats de vérification pour éviter re-processing:
```swift
UserDefaults.standard.set(verified, forKey: "mission_\(missionId)_\(date)")
```

### 2. Fallback Manual
Si IA échoue 3x, proposer validation manuelle avec photo envoyée pour review

### 3. A/B Testing
- 50% des utilisateurs: Strict AI (seuil 0.7)
- 50% des utilisateurs: Lenient AI (seuil 0.5)
- Mesurer completion rate

---

## 🚀 Next Steps

1. **Immédiat**: Implémenter Apple Vision + Speech (gratuit)
2. **Semaine 2**: Tester avec beta users
3. **Mois 1**: Si besoin, ajouter GPT-4o-mini pour cas complexes
4. **Scale**: Migrate vers solution cloud si > 10k users

---

## 📈 Estimation Coûts

**Scénario: 1000 utilisateurs actifs/jour**

### Phase 1 (Apple uniquement):
- **$0/mois** ✅

### Phase 2 (Hybride):
- 80% Apple Vision (gratuit)
- 20% GPT-4o-mini pour cas difficiles
- 1000 users × 20% × $0.00015 = **$3/mois** 💰

### Phase 3 (Scale - 10k users):
- Google Cloud Vision: 1000 gratuit + 9000 × $0.0015 = **$13.50/mois**
- Whisper API: 10k × 30s × $0.006/min = **$30/mois**
- **Total: $43.50/mois** pour 10k utilisateurs actifs 🎯

---

## ✅ Conclusion

**Commence avec Apple Vision + Speech (100% gratuit)**

C'est largement suffisant pour valider le concept et les premiers utilisateurs!
