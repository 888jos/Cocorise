# 🔥 Comment Activer Firebase Firestore

## Status Actuel

✅ **Le projet compile et fonctionne** sans Firestore
⚠️ **Les features sociales sont désactivées** (temporairement)

L'app utilise actuellement des "stubs" (versions temporaires) qui permettent de build sans erreur, mais les features Firebase sont inactives.

---

## Quand Tu Veux Activer Firestore (Recommandé)

### Étape 1: Ajouter FirebaseFirestore à Xcode (2 minutes)

1. Ouvre `SnapWake.xcodeproj` dans Xcode
2. Clique sur le projet **SnapWake** (icône bleue)
3. Sélectionne le target **SnapWake**
4. Va dans **General** → scroll vers **Frameworks, Libraries, and Embedded Content**
5. Clique sur **+**
6. Cherche **"FirebaseFirestore"**
7. Sélectionne-le et clique **Add**

### Étape 2: Activer le Vrai Service (1 minute)

Dans le terminal:

```bash
cd /Users/jos/SnapWake/SnapWake/Services

# Supprimer le stub
rm OptimizedFirebaseService_Stub.swift

# Activer le vrai service
mv OptimizedFirebaseService.swift.disabled OptimizedFirebaseService.swift

# Optionnel: activer aussi l'ancien service si besoin
mv FirebaseService.swift.disabled FirebaseService.swift
```

### Étape 3: Activer les Imports (1 minute)

Dans `Models/SocialFeatures.swift`:

```swift
// Ligne 9: Décommenter
import FirebaseFirestore
```

Dans `Services/OptimizedFirebaseService.swift`:

```swift
// Ligne 10: Décommenter
import FirebaseFirestore
```

### Étape 4: Activer la Sync dans StreakData (1 minute)

Dans `Models/StreakData.swift`:

```swift
// Ligne 97-101: Décommenter
Task {
    try? await OptimizedFirebaseService.shared.syncAllUserData(streakData: streakData, insightsData: InsightsData())
    try? await OptimizedFirebaseService.shared.updateLeaderboard()
}

// Ligne 124-132: Décommenter
do {
    if let (firebaseStreak, _) = try await OptimizedFirebaseService.shared.fetchUserData(),
       let streak = firebaseStreak {
        streakData = streak
        saveStreak()
    }
} catch {
    print("Error syncing streak from Firebase: \(error.localizedDescription)")
}
```

### Étape 5: Firebase Console Setup (5 minutes)

Suis le guide **FIREBASE_QUICK_START.md**:

1. Active Firestore
2. Copie les règles de sécurité
3. Crée les 5 indexes

### Étape 6: Build & Test

```bash
# Clean
Shift + ⌘ + K

# Build
⌘ + B

# Run
⌘ + R
```

---

## Fichiers Actuels

```
Services/
├── OptimizedFirebaseService_Stub.swift     ✅ Actif (version stub)
├── OptimizedFirebaseService.swift.disabled ⚠️ Désactivé (version complète)
├── FirebaseService.swift.disabled          ⚠️ Désactivé (ancienne version)
├── OptimizedSyncManager.swift              ✅ Actif
└── SocialManager.swift                     ✅ Actif (utilise le stub)

Models/
├── SocialFeatures.swift                    ✅ Actif (import commenté)
└── StreakData.swift                        ✅ Actif (sync désactivé)
```

---

## Pourquoi le Stub?

Le stub permet de:
- ✅ **Compiler** sans erreur même sans Firestore
- ✅ **Développer** les autres features
- ✅ **Tester** l'app localement
- ✅ **Ajouter Firestore** plus tard quand tu es prêt

Les données sont **quand même sauvegardées** en local (UserDefaults), donc rien n'est perdu!

---

## Features Actuellement Actives

✅ **Alarms** - Fonctionnent normalement
✅ **Missions** - Toutes actives
✅ **Streak Counter** - Sauvegardé en local
✅ **Insights** - Stats locales
✅ **Badges** - Système de badges

## Features Désactivées (Temporairement)

⚠️ **Friends System** - Nécessite Firestore
⚠️ **Revenge Alarms** - Nécessite Firestore
⚠️ **Duo Alarms** - Nécessite Firestore
⚠️ **Leaderboard Global** - Nécessite Firestore
⚠️ **Cloud Sync** - Nécessite Firestore

---

## Si Tu Veux Rester Sans Firestore

Pas de problème! L'app fonctionne très bien en mode local:

- Toutes les features principales fonctionnent
- Les données sont sauvegardées sur l'appareil
- Pas de frais Firebase
- Offline-first par défaut

**Avantages:**
- 100% gratuit
- Aucune config Firebase requise
- Pas de dépendance externe
- Privacy maximale

**Inconvénients:**
- Pas de sync cross-device
- Pas de features sociales
- Pas de leaderboard global

---

## Résumé

| Option | Build | Features Locales | Features Sociales | Coût |
|--------|-------|------------------|-------------------|------|
| **Avec Stub (Actuel)** | ✅ | ✅ | ❌ | $0 |
| **Avec Firestore** | ✅ | ✅ | ✅ | $0* |

*Gratuit jusqu'à 15,000 users actifs/jour

---

## Support

Questions? Ouvre **FIREBASE_QUICK_START.md** pour le guide complet!
