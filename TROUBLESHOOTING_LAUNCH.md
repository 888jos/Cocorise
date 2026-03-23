# 🔧 Troubleshooting - App Launch Issues

## Problème: App crash au lancement du simulateur

### Message d'erreur:
```
Simulator device failed to launch com.wrap.SnapWake.
Domain: FBSOpenApplicationServiceErrorDomain
Code: 3
Failure Reason: The process did launch, but has since exited or crashed.
```

---

## ✅ Solutions (dans l'ordre)

### Solution 1: Clean Build & Restart Simulator

```bash
# 1. Clean DerivedData
rm -rf ~/Library/Developer/Xcode/DerivedData/*

# 2. Fermer tous les simulateurs
killall Simulator

# 3. Dans Xcode:
# Product → Clean Build Folder (Shift + ⌘ + K)
# Product → Build (⌘ + B)
# Product → Run (⌘ + R)
```

### Solution 2: Vérifier Firebase Configuration

Le crash peut venir de Firebase qui ne trouve pas GoogleService-Info.plist.

**Vérifier:**
```bash
# Le fichier existe?
ls -la /Users/jos/SnapWake/SnapWake/GoogleService-Info.plist

# Le fichier est dans le target?
# Dans Xcode:
# 1. Click sur GoogleService-Info.plist
# 2. Inspector (⌥ + ⌘ + 1)
# 3. Target Membership → SnapWake doit être coché ✓
```

**Si le fichier n'est PAS dans le target:**
1. Clic droit sur `SnapWake/GoogleService-Info.plist`
2. Delete → Remove Reference (PAS "Move to Trash")
3. Drag & drop le fichier depuis Finder vers Xcode
4. Cocher "Copy items if needed" ✓
5. Cocher "SnapWake" target ✓
6. Add

### Solution 3: Désactiver Firebase temporairement

Si Firebase cause le crash, désactivons-le temporairement:

**Dans `/Users/jos/SnapWake/SnapWake/SnapWakeApp.swift`:**

```swift
init() {
    // TEMPORAIREMENT COMMENTÉ pour debug
    // FirebaseApp.configure()

    // Charger les polices custom au démarrage
    FontLoader.loadCustomFonts()
}
```

Puis:
```bash
# Clean & Build
⇧⌘K puis ⌘B puis ⌘R
```

Si l'app lance sans Firebase → le problème vient de Firebase configuration.

### Solution 4: Vérifier les Logs de Crash

**Dans Xcode:**
1. Window → Devices and Simulators (⇧⌘2)
2. Sélectionner le simulateur (ex: iPhone 16)
3. View Device Logs
4. Chercher "SnapWake" dans les logs récents
5. Ouvrir le dernier crash log

**Le crash log dira exactement où ça crash.**

Exemple de ce qu'on cherche:
```
Exception Type: EXC_CRASH (SIGABRT)
Exception Codes: ...
Crashed Thread: 0

Thread 0 Crashed:
0   libsystem_kernel.dylib    ...
1   SnapWake                  0x... FirebaseApp.configure() + 123
```

### Solution 5: Vérifier ContentView

Le crash peut venir de ContentView qui essaie d'accéder à quelque chose qui n'existe pas.

**Tester avec un ContentView minimal:**

Créer `/Users/jos/SnapWake/SnapWake/TestView.swift`:
```swift
import SwiftUI

struct TestView: View {
    var body: some View {
        Text("Hello, SnapWake!")
            .font(.largeTitle)
    }
}
```

**Dans SnapWakeApp.swift, remplacer temporairement:**
```swift
var body: some Scene {
    WindowGroup {
        TestView()  // Au lieu de ContentView()
    }
}
```

Si TestView lance sans problème → le crash vient de ContentView ou ses dépendances.

### Solution 6: Vérifier les Fonts

FontLoader peut crasher si les fonts ne sont pas trouvées.

**Vérifier que les fonts existent:**
```bash
ls -la /Users/jos/SnapWake/SnapWake/Resources/*.ttf
```

Tu devrais voir:
```
Faro-Bold.ttf
Faro-Regular.ttf
Faro-SemiBold.ttf
```

**Si les fonts manquent**, commenter temporairement:
```swift
init() {
    FirebaseApp.configure()
    // TEMPORAIREMENT COMMENTÉ
    // FontLoader.loadCustomFonts()
}
```

---

## 🔍 Méthode Systématique de Debug

### Étape 1: Simplifier au maximum

1. Commenter Firebase
2. Commenter FontLoader
3. Utiliser TestView au lieu de ContentView
4. Build & Run

**Si ça marche** → Réactiver un par un:
- Fonts
- ContentView
- Firebase

**Dès que ça crash**, tu sais où est le problème.

### Étape 2: Lire les logs

Dans Xcode Console (⇧⌘C pendant que l'app run), chercher:
- Messages d'erreur en rouge
- "Fatal error"
- "Assertion failed"
- Stack trace

### Étape 3: Breakpoint Exception

Dans Xcode:
1. Breakpoint Navigator (⌘8)
2. + en bas
3. Exception Breakpoint
4. Run l'app

**L'app s'arrêtera exactement où elle crash.**

---

## 📋 Checklist Rapide

Avant de lancer l'app:

- [ ] Clean Build Folder (⇧⌘K)
- [ ] Build réussit (⌘B) → ✅ BUILD SUCCEEDED
- [ ] GoogleService-Info.plist dans le target
- [ ] Fonts (.ttf) présentes dans Resources/
- [ ] Simulateur fermé et relancé
- [ ] DerivedData nettoyé
- [ ] Info.plist permissions configurées (Camera, Motion)

---

## 🆘 Si Rien Ne Marche

**Dernière option - Reset complet:**

```bash
# 1. Fermer Xcode
# 2. Supprimer DerivedData
rm -rf ~/Library/Developer/Xcode/DerivedData/*

# 3. Reset simulator
xcrun simctl shutdown all
xcrun simctl erase all

# 4. Réouvrir Xcode
open /Users/jos/SnapWake/SnapWake.xcodeproj

# 5. Clean + Build + Run
# ⇧⌘K → ⌘B → ⌘R
```

---

## 💡 Message Typique d'Erreur Firebase

Si tu vois dans les logs:
```
[Firebase] Could not find GoogleService-Info.plist
```

**Solution:**
Le fichier existe mais n'est pas copié dans l'app bundle.

Dans Xcode:
1. Sélectionner le target SnapWake
2. Build Phases
3. Copy Bundle Resources
4. Vérifier que GoogleService-Info.plist est dans la liste
5. Si absent, cliquer + et l'ajouter

---

## 📱 Test Minimal qui Devrait Fonctionner

Si TOUT crash, crée un nouveau fichier `MinimalApp.swift`:

```swift
import SwiftUI

@main
struct MinimalApp: App {
    var body: some Scene {
        WindowGroup {
            Text("Test")
        }
    }
}
```

Commente `@main` dans `SnapWakeApp.swift`, décommente dans `MinimalApp.swift`.

Si même ça ne marche pas → Problème Xcode/Simulator, pas ton code.

---

## 🎯 Prochaine Étape

**Depuis Xcode:**
1. ⇧⌘K (Clean)
2. ⌘B (Build)
3. ⌘R (Run)
4. Regarder la console Xcode (⇧⌘C)
5. Copier/coller les messages d'erreur

Avec le message exact, on saura exactement où ça crash!
