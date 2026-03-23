# 🔊 Guide du Système de Sons SnapWake

## 📁 Structure des Fichiers

```
SnapWake/
├── Resources/
│   └── Sounds/
│       ├── alarm_clock_bell.mp3      (626KB)
│       ├── air_raid_siren.mp3        (1.7MB)
│       ├── morning_birds.mp3         (961KB)
│       ├── ocean_waves.mp3           (158KB)
│       ├── rooster_crowing.mp3       (66KB)
│       ├── uk_tea_timer.mp3          (307KB)
│       └── zen_garden.mp3            (3.9MB)
└── Utils/
    ├── SoundManager.swift             (Gestionnaire principal)
    ├── AlarmSoundPlayer.swift         (Lecteur d'alarme)
    └── ...
```

## 🎵 Sons Disponibles

### 🎵 CLASSIC
- **Default** - Son système par défaut
- **Alarm Clock Bell** - Alarme classique forte (626KB)
- **UK Tea Timer** - Timer britannique (307KB)

### ⚡ AGGRESSIVE
- **Air Raid Siren** - Sirène d'alerte civile (1.7MB)
- **Rooster Crowing** - Coq qui chante (66KB)

### 🧘 PEACEFUL
- **Morning Birds** - Chants d'oiseaux matinaux (961KB)
- **Ocean Waves** - Vagues de l'océan (158KB)
- **Zen Garden** - Ambiance jardin zen (3.9MB)

## 🛠️ Utilisation

### 1. Prévisualiser un son (3 secondes)

```swift
import SwiftUI

struct MyView: View {
    var body: some View {
        Button("Preview Sound") {
            SoundManager.shared.previewSound(named: "Air Raid Siren")
        }
    }
}
```

### 2. Jouer un son en boucle

```swift
// Jouer en boucle
SoundManager.shared.playSound(named: "Morning Birds", loop: true)

// Arrêter
SoundManager.shared.stopSound()
```

### 3. Jouer une alarme

```swift
// Jouer l'alarme avec le son sélectionné par l'utilisateur
let selectedSound = UserDefaults.standard.selectedAlarmSound
AlarmSoundPlayer.shared.playAlarm(soundName: selectedSound)

// Arrêter l'alarme
AlarmSoundPlayer.shared.stopAlarm()

// Fade in (volume progressif sur 10 secondes)
AlarmSoundPlayer.shared.fadeInVolume(duration: 10.0)
```

### 4. Sauvegarder le son sélectionné

```swift
// Sauvegarder
UserDefaults.standard.selectedAlarmSound = "Air Raid Siren"

// Récupérer
let sound = UserDefaults.standard.selectedAlarmSound  // Default: "Default"
```

### 5. Obtenir la liste des sons par catégorie

```swift
let categories = SoundManager.shared.getSoundsByCategory()

ForEach(categories, id: \.category) { category in
    Text(category.category)  // "CLASSIC", "AGGRESSIVE", "PEACEFUL"
    ForEach(category.sounds, id: \.self) { sound in
        Text(sound)
    }
}
```

## 📱 Exemples d'Intégration

### Dans l'Onboarding

Le fichier `CompleteOnboardingView.swift` contient déjà l'intégration:

```swift
// Prévisualiser un son quand on clique sur le bouton play
Button(action: {
    SoundManager.shared.previewSound(named: sound)
}) {
    Image(systemName: "play.fill")
}
```

### Dans les Paramètres

Le fichier `SoundSettingsView.swift` montre un exemple complet:

```swift
struct SoundSettingsView: View {
    @AppStorage("selectedAlarmSound") private var selectedSound = "Default"
    @StateObject private var soundManager = SoundManager.shared

    // ... voir le fichier pour l'implémentation complète
}
```

### Quand l'Alarme Sonne

```swift
// Dans AlarmManager ou AlarmTriggerView
func triggerAlarm() {
    let selectedSound = UserDefaults.standard.selectedAlarmSound
    AlarmSoundPlayer.shared.playAlarm(soundName: selectedSound)
}

func alarmCompleted() {
    AlarmSoundPlayer.shared.stopAlarm()
}
```

## 🎯 Fonctionnalités Principales

### SoundManager
- ✅ Lecture simple de sons
- ✅ Prévisualisation (3 secondes)
- ✅ Boucle infinie
- ✅ Play/Pause/Stop
- ✅ Mapping nom d'affichage ↔️ nom de fichier
- ✅ Vérification d'existence des sons

### AlarmSoundPlayer
- ✅ Lecture d'alarme en boucle infinie
- ✅ Volume maximum automatique
- ✅ Vibration du téléphone en boucle
- ✅ Fade in (volume progressif)
- ✅ Fallback sur son système si fichier manquant
- ✅ Joue même en mode silencieux

## 🔧 Configuration Audio

Les deux managers configurent automatiquement la session audio pour:
- 📢 Jouer même en mode silencieux
- 🔊 Volume maximum pour les alarmes
- 🎵 Mixer avec d'autres apps (mode playback)

## ⚠️ Important

1. **Ajouter les sons à Xcode**:
   - Les fichiers MP3 doivent être ajoutés au projet via Xcode
   - Cocher "Copy items if needed"
   - Vérifier que la target "SnapWake" est cochée
   - Les sons doivent être dans le groupe "Resources/Sounds"

2. **Permissions**:
   - Pas besoin de permissions spéciales pour jouer des sons
   - La vibration fonctionne automatiquement

3. **Performance**:
   - Les sons sont chargés à la demande (pas en mémoire tout le temps)
   - Le plus gros fichier (zen_garden.mp3) fait 3.9MB
   - Total: ~7.8MB pour tous les sons

## 📝 Ajouter un Nouveau Son

1. Télécharger le fichier MP3
2. Le copier dans `/SnapWake/Resources/Sounds/`
3. L'ajouter dans Xcode (drag & drop + cocher target)
4. Mettre à jour `SoundManager.swift`:

```swift
let availableSounds: [String: String] = [
    // ... sons existants
    "Mon Nouveau Son": "mon_nouveau_son",  // ← Ajouter ici
]
```

5. Mettre à jour `getSoundsByCategory()` pour l'ajouter à une catégorie

6. Mettre à jour `getSoundIcon()` dans `SoundSettingsView.swift`:

```swift
case "Mon Nouveau Son": return "mon.icone.sf.symbol"
```

## 🎨 Personnalisation

### Changer la durée de prévisualisation

Dans `SoundManager.swift`:

```swift
func previewSound(named displayName: String, duration: TimeInterval = 5.0) {
    playSound(named: displayName, loop: false)

    DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
        self?.stopSound()
    }
}
```

### Changer le comportement de fade in

Dans `AlarmSoundPlayer.swift`:

```swift
// Fade in plus rapide (5 secondes au lieu de 10)
AlarmSoundPlayer.shared.fadeInVolume(duration: 5.0)

// Ou modifier la méthode directement
func fadeInVolume(duration: TimeInterval = 5.0) {
    guard let player = audioPlayer else { return }
    player.volume = 0.0  // Commencer à 0
    player.setVolume(1.0, fadeDuration: duration)
}
```

## 🐛 Troubleshooting

**Le son ne joue pas**:
- Vérifier que le fichier est bien ajouté au projet dans Xcode
- Vérifier que la target "SnapWake" est cochée
- Vérifier que le nom du fichier correspond (underscore vs tiret)
- Check les logs dans la console Xcode

**Le son est coupé trop tôt**:
- Vérifier que `audioPlayer` n'est pas released (utiliser `[weak self]`)
- Pour les alarmes, utiliser `AlarmSoundPlayer` qui garde une référence forte

**L'alarme ne joue pas en arrière-plan**:
- Activer "Audio, AirPlay, and Picture in Picture" dans les Capabilities
- Vérifier que la catégorie audio est bien `.playback`

## ✅ Checklist d'Intégration

- [x] Fichiers MP3 copiés dans Resources/Sounds
- [x] SoundManager.swift créé avec mapping complet
- [x] AlarmSoundPlayer.swift créé pour les alarmes
- [x] SoundSettingsView.swift pour les paramètres
- [x] Intégration dans CompleteOnboardingView.swift
- [ ] Ajouter les fichiers dans Xcode via "Add Files to SnapWake"
- [ ] Vérifier que tous les sons jouent correctement
- [ ] Tester l'alarme en mode silencieux
- [ ] Tester la vibration
- [ ] Tester le fade in
