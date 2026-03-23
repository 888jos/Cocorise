# SnapWake - Configuration Setup

## Permissions requises dans Xcode

Ouvre le projet dans Xcode et ajoute ces permissions dans **Info.plist** :

### 1. Camera Access
- Key: `NSCameraUsageDescription`
- Value: `SnapWake needs camera access to verify your photo challenge and wake you up.`

### 2. Notifications
- Key: `NSUserNotificationUsageDescription` (optionnel, mais recommandé)
- Value: `SnapWake needs to send you alarm notifications to wake you up.`

## Comment ajouter les permissions :

1. Ouvre le projet dans Xcode
2. Sélectionne le target **SnapWake**
3. Va dans l'onglet **Info**
4. Clique sur le **+** pour ajouter une nouvelle clé
5. Cherche "Privacy - Camera Usage Description"
6. Ajoute la description ci-dessus

## Capabilities requises :

Dans Xcode, va dans **Signing & Capabilities** et ajoute :
- **Push Notifications** (pour les alarmes locales)
- **Background Modes** → Cocher "Remote notifications" si nécessaire

## Tests

Pour tester l'app en développement :

1. L'app va demander la permission caméra au premier lancement
2. L'app va demander la permission notifications au premier lancement
3. Crée une alarme et active-la
4. Le défi photo s'affichera quand l'alarme sonne

## Structure du projet

```
SnapWake/
├── Models/
│   ├── Alarm.swift
│   ├── ChallengeObject.swift
│   └── Difficulty.swift
├── Views/
│   ├── Alarms/
│   │   ├── AlarmsListView.swift
│   │   └── EditAlarmView.swift
│   └── Challenge/
│       └── ChallengeView.swift
├── Services/
│   ├── AlarmManager.swift
│   ├── CameraService.swift
│   └── ImageRecognitionService.swift
└── ContentView.swift
```

## Features implémentées (MVP)

✅ Alarmes avec sélection de l'heure et jours
✅ Système de difficulté (Easy, Medium, Hard, Impossible)
✅ Base de données d'objets à photographier
✅ Capture photo via caméra
✅ Reconnaissance d'image avec Vision framework
✅ Anti-triche : vérification de luminosité
✅ Timer pour suivre le temps mis
✅ Commentaires sarcastiques
✅ Interface style iOS natif

## À implémenter (Phase 2)

- Streak counter (nombre de jours consécutifs)
- Image partageable (Story format)
- IA pour commentaires plus personnalisés
- RevenueCat pour premium
- Social features (revenge alarm, duo alarm)
- Statistiques détaillées
