# Guide de Configuration des Alarmes SnapWake

## Permissions Nécessaires

### 1. Notifications Locales ✅ (Déjà configuré)
- Fichier: `AlarmManager.swift`
- Permission demandée: `.alert, .sound, .badge, .criticalAlert`

### 2. Critical Alerts (À configurer dans Xcode)

#### Étape A: Signing & Capabilities
1. Ouvre Xcode
2. Sélectionne le projet SnapWake
3. Target: SnapWake
4. Onglet "Signing & Capabilities"
5. Clique "+ Capability"
6. Ajoute **"Push Notifications"**
7. Ajoute **"Background Modes"** → Coche "Audio, AirPlay, and Picture in Picture"

#### Étape B: Info.plist
Dans Xcode, ajoute ces clés au Info.plist:

```xml
<key>UIBackgroundModes</key>
<array>
    <string>audio</string>
</array>

<key>NSUserActivityTypes</key>
<array>
    <string>AlarmIntent</string>
</array>
```

### 3. Permissions Audio
Pour que l'alarme sonne même en arrière-plan:

```swift
import AVFoundation

// Dans AppDelegate ou au lancement de l'app
let audioSession = AVAudioSession.sharedInstance()
try? audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers])
try? audioSession.setActive(true)
```

## Limitations iOS

### ❌ Ce qu'on NE PEUT PAS faire
- Sonner plus de 30 secondes (limitation système)
- Forcer l'ouverture de l'app
- Empêcher le dismiss de la notification
- Être aussi puissant que l'app Horloge native (privilège Apple)

### ✅ Ce qu'on PEUT faire
- Sons critiques (bypass mode silencieux) avec `.criticalAlert`
- Volume maximum
- Vibration forte
- Relancer l'alarme si l'utilisateur tap sur la notification
- Snooze automatique
- Live Activities (iOS 16+) pour afficher l'alarme en cours

## Meilleures Pratiques

### 1. Alarme locale avec son critique
```swift
content.sound = .defaultCritical
content.interruptionLevel = .critical
```

### 2. Loop du son dans l'app (quand ouverte)
```swift
AudioPlayerService.shared.playAlarmSound(alarm.sound, loop: true, volume: 1.0)
```

### 3. Fallback: Notifications multiples
Programme plusieurs notifications à 1 minute d'intervalle pour relancer si ignorée:
```swift
// Notification principale
// + 5 notifications de backup à 1, 2, 3, 4, 5 minutes
```

### 4. Live Activity (Recommandé pour iOS 16+)
Affiche un timer en cours dans la Dynamic Island et sur le lock screen.

## Test de l'Alarme

1. Active une alarme pour dans 1 minute
2. Ferme l'app
3. Mets le téléphone en mode silencieux
4. Attends la notification
5. Vérifie:
   - ✅ Son joue (même en silencieux si Critical Alert activé)
   - ✅ Notification apparaît
   - ✅ Tap ouvre l'app avec la mission

## Prochaines Étapes

- [ ] Configurer Background Modes dans Xcode
- [ ] Tester Critical Alerts sur device réel (pas simulateur)
- [ ] Implémenter Live Activities pour iOS 16+
- [ ] Ajouter des notifications de backup (1 min après)
