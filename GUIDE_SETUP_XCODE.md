# Guide Setup Xcode - SnapWake

## ⚠️ ÉTAPES OBLIGATOIRES POUR QUE L'APP FONCTIONNE

---

## 1️⃣ Ajouter les polices Faro au projet

Les fichiers de polices sont déjà dans `Resources/Fonts/`, mais Xcode ne les voit pas encore.

### Étapes détaillées :

1. **Ouvre le projet dans Xcode**
   - Double-clique sur le fichier `.xcodeproj` (tu devras le créer si ce n'est pas déjà fait)

2. **Dans la sidebar gauche de Xcode** (Project Navigator)
   - Clique sur le dossier `SnapWake` (la racine du projet)

3. **Ajoute un nouveau Group pour les Fonts**
   - Clic droit sur `SnapWake` → "New Group"
   - Nomme-le "Resources"
   - Clic droit sur "Resources" → "New Group"
   - Nomme-le "Fonts"

4. **Ajoute les fichiers de polices**
   - Va dans Finder → `/Users/jos/SnapWake/Resources/Fonts/`
   - **Fais glisser** les 3 fichiers `.ttf` dans le groupe "Fonts" dans Xcode :
     - `Faro-Regular.ttf`
     - `Faro-SemiBold.ttf`
     - `Faro-Bold.ttf`

5. **Dans la popup qui apparaît :**
   - ✅ Coche **"Copy items if needed"**
   - ✅ Coche **"Create groups"**
   - ✅ Coche **"Add to targets: SnapWake"**
   - Clique sur **"Finish"**

6. **Vérifie que les polices sont dans le target**
   - Sélectionne un fichier `.ttf` dans Xcode
   - Dans le panneau de droite (File Inspector), vérifie :
     - Target Membership → ✅ **SnapWake** doit être coché

7. **Déclare les polices dans Info.plist**
   - Dans le Project Navigator, sélectionne le **target "SnapWake"**
   - Va dans l'onglet **"Info"**
   - Clique sur le **+** à côté de "Custom iOS Target Properties"
   - Ajoute une nouvelle clé : **"Fonts provided by application"**
   - Clique sur la flèche pour déplier
   - Ajoute 3 items (clique sur le + 3 fois) :
     - Item 0 : `Faro-Regular.ttf`
     - Item 1 : `Faro-SemiBold.ttf`
     - Item 2 : `Faro-Bold.ttf`

---

## 2️⃣ Ajouter les sons d'alarme (optionnel pour l'instant)

1. **Dans Xcode, crée un groupe "Sounds"** dans Resources
2. **Fais glisser tes fichiers .mp3** depuis Finder :
   - `rain.mp3`
   - `fire.mp3`
   - `ocean.mp3`
   - Ou crée un fichier `default.mp3` temporaire
3. **Coche "Copy items" et "Add to targets: SnapWake"**

---

## 3️⃣ Ajouter les permissions dans Info.plist

Dans le même onglet **Info** du target :

1. Ajoute la clé : **"Privacy - Camera Usage Description"**
   - Valeur : `SnapWake needs camera access to verify your photo challenge and wake you up.`

2. Ajoute la clé : **"Privacy - User Notification Usage Description"** (optionnel)
   - Valeur : `SnapWake needs to send you alarm notifications to wake you up.`

---

## 4️⃣ Build et Run

1. Sélectionne un simulateur (ex: iPhone 15 Pro)
2. Clique sur **Product → Build** (⌘B)
3. Si tout compile sans erreur, clique sur **Run** (⌘R)

---

## ✅ Vérification

Au lancement de l'app, tu devrais voir dans la **console Xcode** :

```
✅ Font loaded: Faro-Regular
✅ Font loaded: Faro-SemiBold
✅ Font loaded: Faro-Bold
```

Si tu vois ❌, retourne à l'étape 1.

---

## 🆘 En cas de problème

### "Info.plist multiple commands"
- ✅ Déjà corrigé : le fichier Info.plist manuel a été supprimé
- Xcode génère automatiquement l'Info.plist pour les projets SwiftUI

### "Font not found"
- Vérifie que les fichiers .ttf sont bien dans le dossier du projet
- Vérifie dans Build Phases → Copy Bundle Resources que les .ttf y sont

### "Camera permission doesn't work"
- Vérifie que la description de permission caméra est bien dans Info.plist

---

## 📋 Structure finale attendue dans Xcode

```
SnapWake/
├── SnapWakeApp.swift
├── ContentView.swift
├── Models/
│   ├── Alarm.swift
│   ├── ChallengeObject.swift
│   ├── Difficulty.swift
│   ├── StreakData.swift
│   └── AlarmSound.swift
├── Views/
│   ├── Home/
│   │   └── HomeView.swift
│   ├── Alarms/
│   │   ├── AlarmsListView.swift
│   │   └── EditAlarmView.swift
│   ├── Challenge/
│   │   └── ChallengeView.swift
│   └── Sounds/
│       └── SoundsView.swift
├── Services/
│   ├── AlarmManager.swift
│   ├── CameraService.swift
│   ├── ImageRecognitionService.swift
│   └── AudioPlayerService.swift
├── Utils/
│   └── FontExtension.swift
└── Resources/
    ├── Fonts/
    │   ├── Faro-Regular.ttf
    │   ├── Faro-SemiBold.ttf
    │   └── Faro-Bold.ttf
    └── Sounds/
        ├── rain.mp3 (à ajouter)
        ├── fire.mp3 (à ajouter)
        └── ocean.mp3 (à ajouter)
```

---

## 🎯 Prochaines étapes après le setup

Une fois que l'app compile et run :
1. Tester la création d'une alarme
2. Tester le défi photo (simulateur ou device réel)
3. Ajouter les vrais sons MP3
4. Customiser les couleurs/UI
5. Implémenter le partage d'images
6. Ajouter StoreKit pour le premium
