# 🚀 Firebase Quick Start - 10 Minutes Setup

## Étape 1: Firestore (2 min)

1. Va sur https://console.firebase.google.com/
2. Sélectionne ton projet SnapWake
3. **Firestore Database** (menu gauche) → **Créer une base de données**
4. Mode: **Production**
5. Région: **us-east1**
6. **Activer**

✅ Done!

---

## Étape 2: Règles de Sécurité (2 min)

Dans **Firestore → Règles**, copie/colle:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    function isSignedIn() {
      return request.auth != null;
    }
    function isOwner(userId) {
      return isSignedIn() && request.auth.uid == userId;
    }

    match /users/{userId} {
      allow read: if isOwner(userId);
      allow write: if isOwner(userId);
      match /friends/{friendId} {
        allow read: if isSignedIn();
        allow write: if isOwner(userId);
      }
    }

    match /friendRequests/{requestId} {
      allow read: if isSignedIn() && (resource.data.fromUserId == request.auth.uid || resource.data.toUserId == request.auth.uid);
      allow create: if isSignedIn() && request.resource.data.fromUserId == request.auth.uid;
      allow update: if isSignedIn() && resource.data.toUserId == request.auth.uid;
      allow delete: if isSignedIn() && (resource.data.fromUserId == request.auth.uid || resource.data.toUserId == request.auth.uid);
    }

    match /revengeAlarms/{alarmId} {
      allow read: if isSignedIn() && (resource.data.senderId == request.auth.uid || resource.data.targetUserId == request.auth.uid);
      allow create: if isSignedIn() && request.resource.data.senderId == request.auth.uid;
      allow update: if isSignedIn() && resource.data.targetUserId == request.auth.uid;
      allow delete: if isSignedIn() && resource.data.senderId == request.auth.uid;
    }

    match /duoAlarms/{alarmId} {
      allow read: if isSignedIn() && (resource.data.hostUserId == request.auth.uid || resource.data.partnerUserId == request.auth.uid);
      allow create: if isSignedIn() && request.resource.data.hostUserId == request.auth.uid;
      allow update: if isSignedIn() && (resource.data.hostUserId == request.auth.uid || resource.data.partnerUserId == request.auth.uid);
      allow delete: if isSignedIn() && resource.data.hostUserId == request.auth.uid;
    }

    match /leaderboard/{userId} {
      allow read: if isSignedIn();
      allow write: if isOwner(userId);
    }
  }
}
```

Clique **Publier**.

✅ Done!

---

## Étape 3: Indexes (3 min)

Dans **Firestore → Indexes → Onglet "Composite"**:

Clique **Créer un index** 5 fois:

### Index 1
- Collection: `friendRequests`
- Champs:
  - `toUserId` → Ascending
  - `status` → Ascending
- Mode requête: Collection
- **Créer**

### Index 2
- Collection: `revengeAlarms`
- Champs:
  - `targetUserId` → Ascending
  - `isCompleted` → Ascending
- **Créer**

### Index 3
- Collection: `duoAlarms`
- Champs:
  - `hostUserId` → Ascending
  - `isEnabled` → Ascending
- **Créer**

### Index 4
- Collection: `duoAlarms`
- Champs:
  - `partnerUserId` → Ascending
  - `isEnabled` → Ascending
- **Créer**

### Index 5
- Collection: `users`
- Champs:
  - `leaderboard.currentStreak` → Descending
- **Créer**

⏳ Indexes vont se créer (2-5 minutes). Continue pendant ce temps!

---

## Étape 4: Xcode - Ajouter FirebaseFirestore (2 min)

1. Ouvre `SnapWake.xcodeproj`
2. Sélectionne le projet (icône bleue en haut)
3. Sélectionne le target **SnapWake**
4. Onglet **General**
5. Scroll vers **Frameworks, Libraries, and Embedded Content**
6. Clique **+**
7. Cherche "FirebaseFirestore"
8. **Add**

✅ Done!

---

## Étape 5: Code - Utiliser le Service Optimisé (1 min)

Les fichiers sont déjà créés! Il faut juste les utiliser.

### Dans `AlarmManager.swift`:

Trouve la fonction `dismissAlarm` (ligne ~202) et remplace:

```swift
// ❌ AVANT
if success {
    InsightsManager.shared.logWakeUp(
        alarm: alarm,
        wakeUpTime: Date(),
        missionCompleted: true
    )
    StreakManager.shared.logWakeUp()
    // ...
}
```

Par:

```swift
// ✅ APRÈS
if success {
    InsightsManager.shared.logWakeUpOptimized(
        alarm: alarm,
        wakeUpTime: Date(),
        missionCompleted: true
    )
    StreakManager.shared.logWakeUpOptimized()
    // ...
}
```

### Dans `ContentView.swift`:

Ajoute après `task { _ = await alarmManager.requestNotificationPermission() }`:

```swift
.task {
    _ = await alarmManager.requestNotificationPermission()

    // Load data from Firebase
    await OptimizedSyncManager.shared.fetchAllData()
}
```

✅ Done!

---

## Étape 6: Build & Test

1. Clean Build Folder: **Shift + ⌘ + K**
2. Build: **⌘ + B**
3. Run: **⌘ + R**

### Test Streak Sync

1. Crée un compte (ou login)
2. Crée une alarme
3. Clique sur le bouton Play (test alarm)
4. Complete la mission
5. Va dans Firebase Console → Firestore → Data
6. Tu devrais voir: `users/{userId}` avec `streak`, `insights`, etc.

✅ Ça marche!

---

## Étape 7: Test Social Features

1. Crée un 2ème compte (email différent)
2. Compte 1: **Insights → Friends → Add Friend** (email du compte 2)
3. Compte 2: Accepte la demande
4. Compte 1: Clique sur l'ami → **Send Revenge Alarm**
5. Configure l'alarme → **Send**
6. Firebase Console → Firestore → `revengeAlarms` → Tu devrais voir l'alarme

✅ Social features marchent!

---

## Étape 8: Monitoring

Firebase Console → **Firestore → Usage**

Regarde:
- **Document reads** (devrait être bas)
- **Document writes** (1 par wake-up)

Avec les optimisations:
- ✅ 1 write par wake-up (au lieu de 3)
- ✅ Cache local (moins de reads)
- ✅ Batch operations

---

## 🎉 C'est tout!

Firebase est configuré et optimisé pour:
- **$0/mois** jusqu'à 15,000 users actifs
- **1 seul write** par wake-up event
- **Cache offline** automatique
- **Support social features** complet

---

## Troubleshooting

### "Permission denied" dans Firestore
→ Vérifie que les règles de sécurité sont bien publiées
→ Vérifie que l'user est bien authentifié

### "Index required" error
→ Attends 2-5 minutes que les indexes se créent
→ Vérifie dans Firebase Console → Indexes que le statut est "Enabled"

### Build error "Cannot find FirebaseFirestore"
→ Clean build folder (Shift+⌘+K)
→ Vérifie que FirebaseFirestore est ajouté dans General → Frameworks

### Data ne sync pas
→ Vérifie la console Xcode pour les erreurs
→ Vérifie ta connexion internet
→ Le sync est debounced (attend 5 secondes)

---

## Next Steps

1. Test avec plusieurs comptes
2. Envoie des revenge alarms
3. Crée des duo alarms
4. Check le leaderboard
5. Surveille l'usage Firebase

Tout est prêt! 🚀
