# Sons d'alarme pour SnapWake

## Instructions pour ajouter les fichiers .mp3

Pour que les sons fonctionnent dans l'app, tu dois ajouter les fichiers suivants dans ce dossier :

1. **default.mp3** - Son d'alarme par défaut
2. **rain.mp3** - Son de pluie 🌧️
3. **fire.mp3** - Son de feu 🔥
4. **ocean.mp3** - Son d'océan 🌊

## Comment ajouter les fichiers dans Xcode :

### Méthode 1 : Via Xcode (recommandé)
1. Ouvre le projet dans Xcode
2. Fais glisser tes fichiers .mp3 depuis le Finder vers le dossier "Resources/Sounds" dans Xcode
3. ✅ Coche "Copy items if needed"
4. ✅ Coche "Add to targets: SnapWake"
5. Clique sur "Finish"

### Méthode 2 : Manuellement
1. Copie tes fichiers .mp3 dans ce dossier `/Users/jos/SnapWake/Resources/Sounds/`
2. Ouvre Xcode
3. Sélectionne le target "SnapWake"
4. Va dans "Build Phases" → "Copy Bundle Resources"
5. Clique sur "+" et ajoute chaque fichier .mp3

## Vérification

Pour vérifier que les sons sont bien intégrés :
1. Build l'app
2. Va dans Settings → Sounds
3. Clique sur le bouton play ▶️ à côté de chaque son
4. Tu devrais entendre le son jouer pendant 10 secondes

## Format recommandé

- **Format** : MP3
- **Durée** : 10-30 secondes (ça va loop quand l'alarme sonne)
- **Qualité** : 128-192 kbps (pas besoin de haute qualité)
- **Taille** : < 1 MB par fichier

## Sons par défaut

Si tu n'as pas encore de fichiers MP3, tu peux :
- Utiliser des sons libres de droits (freesound.org, zapsplat.com)
- Créer tes propres sons
- Utiliser le son système iOS par défaut (l'app affichera un warning mais continuera de fonctionner)
