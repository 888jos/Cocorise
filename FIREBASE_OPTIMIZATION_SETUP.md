# Firebase Setup Optimisé - Configuration Complète

## 🎯 Objectif
Configurer Firebase pour minimiser les coûts (reads/writes) tout en gardant toutes les fonctionnalités.

---

## 1. Structure Firestore Optimisée

### ❌ AVANT (Non-optimisé - trop de writes)
```
users/{userId}/data/streak  → 1 write par wake-up
users/{userId}/data/insights → 1 write par wake-up
leaderboard/{userId} → 1 write par wake-up
= 3 writes par wake-up 😱
```

### ✅ APRÈS (Optimisé - writes groupés)
```
users/{userId}  → 1 seul document avec tout
= 1 write par wake-up 🎉
```

---

## 2. Configuration Firebase Console

### Étape 1: Activer Firestore

1. Va sur [Firebase Console](https://console.firebase.google.com/)
2. Sélectionne ton projet SnapWake
3. **Firestore Database** → **Create Database**
4. **Mode**: Start in **Production Mode** (plus sécurisé)
5. **Location**: `us-east1` (gratuit, proche de la plupart des users)
6. **Enable**

### Étape 2: Règles de Sécurité Optimisées

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Helper functions
    function isSignedIn() {
      return request.auth != null;
    }

    function isOwner(userId) {
      return isSignedIn() && request.auth.uid == userId;
    }

    // ========================================
    // USERS - Document unique par user
    // ========================================
    match /users/{userId} {
      // L'utilisateur peut lire/écrire ses propres données
      allow read: if isOwner(userId);
      allow write: if isOwner(userId);

      // Friends subcollection (lecture publique pour les amis)
      match /friends/{friendId} {
        allow read: if isSignedIn();
        allow write: if isOwner(userId);
      }
    }

    // ========================================
    // FRIEND REQUESTS
    // ========================================
    match /friendRequests/{requestId} {
      allow read: if isSignedIn() && (
        resource.data.fromUserId == request.auth.uid ||
        resource.data.toUserId == request.auth.uid
      );

      allow create: if isSignedIn() &&
        request.resource.data.fromUserId == request.auth.uid;

      allow update: if isSignedIn() &&
        resource.data.toUserId == request.auth.uid;

      allow delete: if isSignedIn() && (
        resource.data.fromUserId == request.auth.uid ||
        resource.data.toUserId == request.auth.uid
      );
    }

    // ========================================
    // REVENGE ALARMS
    // ========================================
    match /revengeAlarms/{alarmId} {
      allow read: if isSignedIn() && (
        resource.data.senderId == request.auth.uid ||
        resource.data.targetUserId == request.auth.uid
      );

      allow create: if isSignedIn() &&
        request.resource.data.senderId == request.auth.uid;

      allow update: if isSignedIn() &&
        resource.data.targetUserId == request.auth.uid;

      allow delete: if isSignedIn() &&
        resource.data.senderId == request.auth.uid;
    }

    // ========================================
    // DUO ALARMS
    // ========================================
    match /duoAlarms/{alarmId} {
      allow read: if isSignedIn() && (
        resource.data.hostUserId == request.auth.uid ||
        resource.data.partnerUserId == request.auth.uid
      );

      allow create: if isSignedIn() &&
        request.resource.data.hostUserId == request.auth.uid;

      allow update: if isSignedIn() && (
        resource.data.hostUserId == request.auth.uid ||
        resource.data.partnerUserId == request.auth.uid
      );

      allow delete: if isSignedIn() &&
        resource.data.hostUserId == request.auth.uid;
    }

    // ========================================
    // LEADERBOARD - Lecture publique
    // ========================================
    match /leaderboard/{userId} {
      allow read: if isSignedIn();
      allow write: if isOwner(userId);
    }
  }
}
```

### Étape 3: Indexes Firestore (REQUIS)

Dans **Firestore → Indexes → Composite**:

**Index 1 - Friend Requests:**
```
Collection: friendRequests
Fields:
  - toUserId (Ascending)
  - status (Ascending)
```

**Index 2 - Revenge Alarms:**
```
Collection: revengeAlarms
Fields:
  - targetUserId (Ascending)
  - isCompleted (Ascending)
```

**Index 3 - Duo Alarms (Host):**
```
Collection: duoAlarms
Fields:
  - hostUserId (Ascending)
  - isEnabled (Ascending)
```

**Index 4 - Duo Alarms (Partner):**
```
Collection: duoAlarms
Fields:
  - partnerUserId (Ascending)
  - isEnabled (Ascending)
```

**Index 5 - Leaderboard:**
```
Collection: leaderboard
Fields:
  - currentStreak (Descending)
Single field exemption: Yes
```

---

## 3. Quotas Firebase Gratuits

### Plan Spark (Gratuit)
- ✅ **Stockage**: 1 GB
- ✅ **Reads**: 50,000 / jour
- ✅ **Writes**: 20,000 / jour
- ✅ **Deletes**: 20,000 / jour

### Avec nos optimisations:
- **Avant**: 3 writes par wake-up = 6,666 wake-ups max/jour
- **Après**: 1 write par wake-up = 20,000 wake-ups max/jour! 🎉

---

## 4. Structure de Document Optimisée

### Document Unique par User

```javascript
users/{userId} = {
  // Profile
  email: "user@example.com",
  displayName: "John Doe",

  // Streak (au lieu d'un sous-document)
  streak: {
    currentStreak: 15,
    longestStreak: 30,
    lastWakeUpDate: Timestamp,
    weeklyWakeUpsCount: 7
  },

  // Insights summary (pas tout l'historique!)
  insights: {
    totalWakeUps: 150,
    successRate: 85.5,
    averageWakeTime: "06:30",
    favoriteMission: "Math"
  },

  // Leaderboard data (pour requêtes publiques)
  leaderboard: {
    displayName: "John Doe",
    currentStreak: 15,
    longestStreak: 30,
    totalMissions: 150
  },

  // Friends array (au lieu d'une sous-collection)
  friends: [
    {
      id: "userId123",
      displayName: "Jane",
      addedDate: Timestamp
    }
  ],

  // Metadata
  lastUpdated: Timestamp
}
```

**Avantages:**
- ✅ 1 seul read pour tout charger
- ✅ 1 seul write pour tout update
- ✅ Pas de sous-collections = moins de reads
- ✅ Cache local efficace

---

## 5. Stratégies d'Optimisation Implémentées

### A. Debouncing (grouper les writes)
```
User wake-up → Marquer "needs sync"
    ↓
Attendre 5 secondes
    ↓
Grouper tous les changements
    ↓
1 seul write Firebase
```

### B. Cache Local (éviter des reads)
```
Premier load → Firebase read → Cache
    ↓
Prochains loads → Cache local (0 reads!)
    ↓
Cache valide pendant 5 minutes
```

### C. Batch Writes
```
Accept friend request:
  1. Update request status
  2. Add to user1 friends
  3. Add to user2 friends

= 1 batch write au lieu de 3! ✅
```

### D. Historique Local
```
❌ Stocker 90 jours de wake-ups dans Firebase
✅ Stocker historique dans UserDefaults
✅ Sync seulement le summary vers Firebase
```

### E. Indexes Optimisés
```
Requêtes avec WHERE + ORDER BY
→ Utilisent des indexes
→ Beaucoup plus rapides
→ Consomment moins de reads
```

---

## 6. Configuration Firebase Authentication

### Email/Password (déjà configuré)

Dans Firebase Console → Authentication:

1. **Sign-in method** → Email/Password → ✅ Enable
2. **Settings** → Authorized domains → Ajoute ton domaine si besoin

### Optimisation Auth

Ajoute dans `SnapWakeApp.swift`:

```swift
init() {
    FirebaseApp.configure()

    // Cache auth state
    Auth.auth().useUserAccessGroup("com.snapwake.auth")

    // Load fonts
    FontLoader.loadCustomFonts()
}
```

---

## 7. Offline Support (GRATUIT!)

Firestore garde un cache local automatiquement:

```swift
// Déjà configuré dans OptimizedFirebaseService.swift
let settings = FirestoreSettings()
settings.isPersistenceEnabled = true
settings.cacheSizeBytes = FirestoreCacheSizeUnlimited
db.settings = settings
```

**Avantages:**
- ✅ App fonctionne offline
- ✅ Sync auto quand internet revient
- ✅ 0 reads supplémentaires pour données en cache

---

## 8. Migration depuis l'ancien service

### Remplacer FirebaseService par OptimizedFirebaseService

Dans tous les fichiers qui utilisent `FirebaseService.shared`:

```swift
// ❌ Avant
FirebaseService.shared.syncStreak(streakData)

// ✅ Après
OptimizedSyncManager.shared.syncNow()
```

### Mettre à jour StreakManager

```swift
// Dans StreakManager.swift
func logWakeUp() {
    // Utiliser la version optimisée
    logWakeUpOptimized()
}
```

### Mettre à jour AlarmManager

```swift
// Dans AlarmManager.swift - dismissAlarm()
if success {
    // Log insights (optimisé)
    InsightsManager.shared.logWakeUpOptimized(
        alarm: alarm,
        wakeUpTime: Date(),
        missionCompleted: true
    )

    // Update streak (optimisé)
    StreakManager.shared.logWakeUpOptimized()
}
```

---

## 9. Tests de Performance

### Avant Optimisation
```
Wake-up event:
  - StreakManager.syncStreak() → 1 write
  - InsightsManager.syncInsights() → 1 write
  - LeaderboardManager.update() → 1 write
  = 3 writes total 😱

10,000 users × 1 wake-up/jour = 30,000 writes/jour
→ Dépasse le quota gratuit! ❌
```

### Après Optimisation
```
Wake-up event:
  - markNeedsSync()
  - Debounce 5 seconds
  - syncAllUserData() → 1 write
  = 1 write total 🎉

10,000 users × 1 wake-up/jour = 10,000 writes/jour
→ Reste dans le quota gratuit! ✅
```

---

## 10. Monitoring Firebase

### Dans Firebase Console

1. **Usage** tab → Voir consommation reads/writes
2. **Graphs** → Surveiller les pics
3. **Alerts** → Configurer alertes si proche du quota

### Alertes Recommandées

```
Reads > 40,000/jour → Email warning
Writes > 15,000/jour → Email warning
```

---

## 11. Best Practices à Suivre

### ✅ DO
- Grouper les updates en batch
- Utiliser le cache local
- Debouncer les writes fréquents
- Limiter les listeners temps-réel
- Utiliser des indexes pour les requêtes

### ❌ DON'T
- Sync à chaque petit changement
- Faire des scans complets de collections
- Stocker l'historique complet dans Firebase
- Utiliser .onSnapshot() partout
- Oublier les indexes

---

## 12. Commandes Utiles

### Tester en local avec emulator (optionnel)

```bash
# Installer Firebase tools
npm install -g firebase-tools

# Login
firebase login

# Init project
firebase init firestore

# Lancer emulator
firebase emulators:start
```

### Monitoring

```bash
# Voir usage Firebase
firebase firestore:usage

# Export data (backup)
gcloud firestore export gs://your-bucket/backup
```

---

## 13. Résumé des Fichiers Créés

```
Services/
├── OptimizedFirebaseService.swift   # Service ultra-optimisé
├── OptimizedSyncManager.swift       # Gestion sync avec debouncing
└── FirebaseService.swift            # Ancien (peut être supprimé)

Docs/
└── FIREBASE_OPTIMIZATION_SETUP.md   # Ce guide
```

---

## 14. Checklist Setup Firebase

- [ ] Activer Firestore dans Firebase Console
- [ ] Copier/coller les règles de sécurité
- [ ] Créer les 5 indexes composites
- [ ] Ajouter FirebaseFirestore au projet Xcode
- [ ] Remplacer FirebaseService par OptimizedFirebaseService
- [ ] Tester avec quelques wake-ups
- [ ] Vérifier usage dans Firebase Console
- [ ] Configurer alertes de quota

---

## 15. Coût Estimé

### Scénario Réaliste

**100 users actifs:**
- 100 wake-ups/jour × 1 write = 100 writes/jour
- 100 users × 1 login/jour × 1 read = 100 reads/jour
- 20 friend requests/jour × 2 writes = 40 writes/jour
- 10 revenge alarms/jour × 1 write = 10 writes/jour

**Total: ~150 writes/jour + 100 reads/jour**
→ Largement dans le quota gratuit! ✅

**1,000 users actifs:**
- 1,000 wake-ups/jour = 1,000 writes
- 1,000 logins/jour = 1,000 reads
- Social features = ~200 writes

**Total: ~1,200 writes/jour + 1,000 reads/jour**
→ Toujours gratuit! ✅

**10,000 users actifs:**
- 10,000 wake-ups/jour = 10,000 writes
- 10,000 logins/jour = 10,000 reads
- Social features = ~2,000 writes

**Total: ~12,000 writes/jour + 10,000 reads/jour**
→ Encore gratuit! ✅

---

## 🎉 Résultat Final

Avec ces optimisations, tu peux supporter:
- **20,000 wake-ups/jour** gratuitement
- **50,000 users** qui consultent le leaderboard
- **Stockage illimité** en cache local
- **Offline-first** app

Coût Firebase: **$0/mois** jusqu'à ~15,000 utilisateurs actifs quotidiens! 🚀

