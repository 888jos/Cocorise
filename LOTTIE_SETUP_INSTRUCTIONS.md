# Instructions d'installation Lottie pour SnapWake

## Étape 1: Ajouter Lottie via Swift Package Manager

1. Ouvre **SnapWake.xcodeproj** dans Xcode
2. Va dans **File → Add Package Dependencies...**
3. Dans la barre de recherche, entre: `https://github.com/airbnb/lottie-ios`
4. Sélectionne la version **4.x.x** (dernière version)
5. Clique sur **Add Package**
6. Assure-toi que **Lottie** est coché pour la target **SnapWake**
7. Clique sur **Add Package**

## Étape 2: Ajouter les fichiers Lottie au projet

1. Dans Xcode, clique droit sur le dossier **Resources**
2. Sélectionne **Add Files to "SnapWake"...**
3. Navigate vers `/Users/jos/SnapWake/SnapWake/Resources/Lottie`
4. Sélectionne tous les fichiers `.json`
5. **IMPORTANT**: Coche "Copy items if needed" et assure-toi que la target "SnapWake" est cochée
6. Clique sur **Add**

## Étape 3: Vérifier l'intégration

Les fichiers Lottie ont déjà été copiés dans:
```
/Users/jos/SnapWake/SnapWake/Resources/Lottie/
```

Liste des animations:
- ✅ `Handshake Loop.json` - Pour "Tu n'es pas seul"
- ✅ `sun happy.json` - Pour "On comprend"
- ✅ `Bell Snooze.json` - Pour "Le coût du snooze"
- ✅ `Clock_loop.json` - Alternative pour "Le coût du snooze"
- ✅ `sand clock.json` - Pour temps perdu
- ✅ `shining stars.json` - Pour citations/quotes
- ✅ `confetti on transparent background.json` - Pour "Tu es au bon endroit"
- ✅ `Growing Plant.json` - Pour "Transformation"

## Étape 4: Build le projet

Une fois Lottie ajouté via SPM:
1. Dans Xcode, fais **Product → Clean Build Folder** (Cmd+Shift+K)
2. Puis **Product → Build** (Cmd+B)

Si tout compile, les animations sont prêtes à être utilisées !

## Mapping des animations dans l'onboarding

| Écran | Fichier Lottie | Taille recommandée |
|-------|----------------|-------------------|
| "Tu n'es pas seul" | Handshake Loop.json | 120x120 |
| "On comprend" | sun happy.json | 100x100 |
| "Le coût du snooze" | sand clock.json | 140x140 |
| Citations (Quote 1, 2, 3) | shining stars.json | 80x80 |
| "Tu es au bon endroit" | confetti on transparent background.json | 200x200 |
| "Transformation" | Growing Plant.json | 150x150 |

## Code déjà créé

Le fichier `LottieView.swift` a été créé dans `/Users/jos/SnapWake/SnapWake/Utils/`

Les animations seront automatiquement intégrées dans `CompleteOnboardingView.swift`

## En cas d'erreur

Si Xcode ne trouve pas les fichiers JSON:
1. Vérifie que les fichiers sont dans **Resources/Lottie/**
2. Dans Xcode, sélectionne chaque fichier .json
3. Dans l'inspecteur à droite, assure-toi que **Target Membership** → **SnapWake** est coché
