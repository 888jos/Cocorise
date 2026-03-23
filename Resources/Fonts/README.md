# Polices Faro pour SnapWake

## Fichiers installés

✅ **Faro-Regular.ttf** (57 KB)
✅ **Faro-SemiBold.ttf** (57 KB)
✅ **Faro-Bold.ttf** (58 KB)

## Configuration dans Xcode

Pour que les polices fonctionnent, tu dois les ajouter au target Xcode :

1. Ouvre le projet dans Xcode
2. Sélectionne le dossier `Resources/Fonts` dans le navigateur de fichiers
3. Sélectionne les 3 fichiers .ttf
4. Dans l'inspecteur à droite, vérifie que **Target Membership** → ✅ **SnapWake** est coché

Ou :

1. Fais glisser les 3 fichiers .ttf depuis `Resources/Fonts` vers Xcode
2. ✅ Coche "Copy items if needed"
3. ✅ Coche "Add to targets: SnapWake"

## Utilisation dans le code

```swift
// Regular
Text("Hello").font(.faro(size: 16))

// SemiBold
Text("Hello").font(.faroSemiBold(size: 20))

// Bold
Text("Hello").font(.faroBold(size: 24))
```

## Vérification

Au lancement de l'app, tu devrais voir dans la console :
```
✅ Font loaded: Faro-Regular
✅ Font loaded: Faro-SemiBold
✅ Font loaded: Faro-Bold
```

Si tu vois ❌, c'est que les fichiers ne sont pas dans le bundle.

## Fichiers déjà mis à jour avec Faro :

- ✅ HomeView (titre "SnapWake", heure)
- ✅ AlarmsListView (heures, jours)
- Info.plist (UIAppFonts déclarés)
