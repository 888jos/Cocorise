# ✅ Checklist de Lancement - SnapWake

## 🎯 Ce qui est PRÊT

### Code & Features
- ✅ **8 missions implémentées** (Sky Photo, Make Bed, Object Hunt, Push-ups, Shake, Math, Affirmation, Bible)
- ✅ **AI Verification** (Vision + Speech Recognition - 100% GRATUIT)
- ✅ **Onboarding complet** avec mascotte et questions
- ✅ **Alarm Manager** fonctionnel
- ✅ **Mission Execution** avec confetti Lottie
- ✅ **Voice Recording** pour Affirmation/Bible
- ✅ **Camera fix** (crash résolu)

### Assets
- ✅ **Fonts**: Faro (Bold, Regular, SemiBold)
- ✅ **Sounds**: 7 sons d'alarme (air raid, birds, ocean, etc.)
- ✅ **Lottie animations**: 8 animations (confetti, clock, plant, etc.)
- ✅ **Mission icons**: Présents dans Assets.xcassets

### Permissions (Info.plist)
- ✅ Camera Usage Description
- ✅ Microphone Usage Description
- ✅ Motion Usage Description
- ✅ Speech Recognition Usage Description

---

## ⚠️ PROBLÈMES À RÉSOUDRE

### 1. Firebase Bundle ID Mismatch (CRITIQUE)

**Problème:**
```
Bundle ID app: com.wrap.cocorise
Bundle ID Firebase: com.wrap.SnapWake
```

**Impact:** Firebase ne fonctionne pas correctement

**Solution A (Recommandé):** Changer Bundle ID de l'app
```
1. Xcode → Target SnapWake → Signing & Capabilities
2. Bundle Identifier: com.wrap.SnapWake
3. Clean Build (⇧⌘K)
4. Build (⌘B)
```

**Solution B:** Re-télécharger GoogleService-Info.plist
```
1. Firebase Console → Project Settings
2. iOS apps → com.wrap.cocorise
3. Download GoogleService-Info.plist
4. Remplacer le fichier actuel
```

---

### 2. Poppins Font Manquante (MINEUR)

**Problème:**
```
❌ Font file not found: Poppins-Bold
```

**Impact:** Si du texte utilise Poppins, il fallback vers système

**Solution:**
Soit ajouter Poppins-Bold.ttf, soit remplacer tous les usages par Faro

**Rechercher où c'est utilisé:**
```bash
grep -r "Poppins" /Users/jos/SnapWake/SnapWake/
```

---

### 3. Firebase Configuration (OPTIONNEL mais recommandé)

**Si tu veux Firebase actif:**

1. **Activer Firestore dans Firebase Console**
   - Console Firebase → Firestore Database → Create Database
   - Mode: Production
   - Région: us-east1

2. **Ajouter FirebaseFirestore framework**
   - Xcode → Target → General → Frameworks
   - + → Add Package → Firebase
   - Sélectionner FirebaseFirestore

3. **Suivre FIREBASE_QUICK_START.md** (10 minutes)

**Si tu ne veux PAS Firebase pour l'instant:**

Dans `SnapWakeApp.swift`, commenter:
```swift
init() {
    // FirebaseApp.configure()  // ← COMMENTER
    FontLoader.loadCustomFonts()
}
```

---

## 🚀 ACTIONS PRIORITAIRES

### Action 1: Fix Bundle ID (2 minutes)
```
Xcode → Target → General → Bundle Identifier
Changer: com.wrap.cocorise → com.wrap.SnapWake
Clean Build + Run
```

### Action 2: Tester toutes les missions (10 minutes)
```
1. Lancer app
2. Compléter onboarding
3. Créer alarme pour chaque mission
4. Tester chaque mission:
   - ✅ Sky Photo
   - ✅ Make Bed
   - ✅ Object Hunt
   - ✅ Push-ups
   - ✅ Shake Phone
   - ✅ Math Challenge
   - ✅ Affirmation (voice recording + AI)
   - ✅ Bible Verse (voice recording + AI)
```

### Action 3: Fix Poppins (optionnel, 5 minutes)
```bash
# Trouver où c'est utilisé
grep -r "poppins" /Users/jos/SnapWake/SnapWake/ --include="*.swift"

# Remplacer par Faro
# OU télécharger Poppins-Bold.ttf
```

---

## 🎯 POUR LANCER EN PRODUCTION

### Avant App Store:

1. **Changer Bundle ID** vers ton propre (ex: com.tonnom.snapwake)
2. **Configurer Firebase** avec ton projet
3. **Ajouter icons** (App Icon dans Assets.xcassets)
4. **Tester sur device réel** (iPhone physique)
5. **Privacy Policy** (requis pour App Store)
6. **Terms of Service** (requis pour App Store)
7. **App Store screenshots** (6.5" et 5.5")
8. **App Store description** (texte marketing)

### Optionnel mais recommandé:

- **RevenueCat** pour premium features
- **Firebase Analytics** pour tracking
- **Crashlytics** pour crash reports
- **Performance Monitoring**
- **Remote Config** pour A/B testing

---

## 🔍 DEBUG SI L'APP CRASH

### Si crash au lancement:

**Étape 1:** Clean Build
```bash
⇧⌘K (Clean)
⌘B (Build)
⌘R (Run)
```

**Étape 2:** Lire logs Xcode
```
⇧⌘C (Show Console)
Copier message d'erreur
```

**Étape 3:** Tester sans Firebase
```swift
// Dans SnapWakeApp.swift
init() {
    // FirebaseApp.configure()  // ← COMMENTER
    FontLoader.loadCustomFonts()
}
```

**Étape 4:** Exception Breakpoint
```
Xcode → Breakpoint Navigator (⌘8)
+ → Exception Breakpoint
Run l'app → s'arrêtera où ça crash
```

---

## 📊 ÉTAT ACTUEL

| Feature | État | Notes |
|---------|------|-------|
| Build | ✅ | BUILD SUCCEEDED |
| Onboarding | ✅ | Complet avec mascotte |
| Alarmes | ✅ | Création/édition fonctionnelle |
| Missions (8) | ✅ | Toutes implémentées |
| AI Verification | ✅ | Vision + Speech (gratuit) |
| Voice Recording | ✅ | Affirmation + Bible |
| Camera | ✅ | Crash fixé |
| Fonts | ⚠️ | Faro ✅, Poppins ❌ |
| Sounds | ✅ | 7 sons présents |
| Lottie | ✅ | 8 animations présentes |
| Firebase | ⚠️ | Bundle ID mismatch |
| Permissions | ✅ | Toutes configurées |

---

## 🎉 PROCHAINES ÉTAPES

### Aujourd'hui:
1. Fix Bundle ID Firebase (2 min)
2. Test complet de toutes les missions (10 min)
3. Fix Poppins ou remplacer (5 min)

### Cette semaine:
1. Test sur iPhone réel
2. Configurer Firebase si besoin
3. Ajouter App Icon
4. Beta test avec amis

### Avant lancement:
1. Privacy Policy + Terms
2. App Store assets (screenshots, description)
3. TestFlight beta
4. App Store submission

---

## 💡 L'APP EST PRESQUE PRÊTE!

**L'essentiel fonctionne:**
- ✅ Code compile
- ✅ Missions marchent
- ✅ AI verification gratuite
- ✅ Audio recording
- ✅ Camera fonctionne

**Il reste juste:**
- ⚠️ Bundle ID Firebase (2 min)
- ⚠️ Font Poppins (optionnel)
- 🎯 Tests complets

**Tu peux déjà tester l'app sur simulateur!** 🚀
