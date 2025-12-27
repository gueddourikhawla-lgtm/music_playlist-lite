# Guide de Démarrage Rapide - Music Player Lite

## ⚡ Démarrage rapide

### Pour les utilisateurs finaux

#### Prérequis
- Android 6+ (API 21+) ou iOS 12+
- Espace libre sur le téléphone
- Fichiers audio au format MP3, WAV, ou AAC

#### Installation
1. Télécharger l'APK ou l'IPA depuis les releases
2. Installer l'application sur votre appareil
3. Accorder les permissions d'accès au stockage

#### Utilisation de base
1. Appuyer sur le bouton "+" pour importer des fichiers audio
2. Sélectionner un ou plusieurs fichiers audio
3. Appuyer sur une chanson pour la lire
4. Utiliser les contrôles du lecteur pour jouer, pauser, etc.

---

### Pour les développeurs

## 🔧 Configuration de l'environnement de développement

### 1. Installer Flutter

#### Windows
```bash
# Télécharger et installer Flutter depuis flutter.dev
# Ou utiliser chocolatey
choco install flutter

# Vérifier l'installation
flutter --version
```

#### macOS
```bash
# Avec Homebrew
brew install flutter

# Ou manuellement depuis flutter.dev
flutter --version
```

#### Linux
```bash
# Voir https://docs.flutter.dev/get-started/install/linux
flutter --version
```

### 2. Vérifier l'environnement

```bash
flutter doctor
```

Cela affichera l'état de votre installation Flutter et les dépendances manquantes.

### 3. Cloner et configurer le projet

```bash
# Cloner le repository
git clone <url-du-repo>
cd music_player_lite

# Installer les dépendances
flutter pub get

# Générer les fichiers nécessaires (si besoin)
flutter pub run build_runner build
```

## 🏃 Exécuter l'application

### En mode debug (développement)

```bash
flutter run
```

Pour spécifier un device particulier :
```bash
# Voir les devices disponibles
flutter devices

# Exécuter sur un device spécifique
flutter run -d <device-id>
```

### En mode release (production)

```bash
flutter run --release
```

### Avec hot reload

Pendant l'exécution, appuyer sur `r` pour hot reload ou `R` pour hot restart.

## 🏗️ Build

### Android APK

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# APK split par architecture (plus petit)
flutter build apk --split-per-abi --release
```

Le fichier APK sera dans : `build/app/outputs/flutter-apk/`

### iOS IPA

```bash
# Debug IPA
flutter build ios --debug

# Release IPA
flutter build ipa --release
```

L'application sera dans `build/ios/`

## 📱 Configuration des appareils

### Émulateur Android

```bash
# Voir les émulateurs disponibles
flutter emulators

# Lancer un émulateur
flutter emulators --launch <nom-emulateur>

# Ou créer un nouveau via Android Studio
```

### Simulateur iOS (macOS seulement)

```bash
# Lancer le simulateur iOS
open -a Simulator

# Vérifier les simulateurs disponibles
xcrun simctl list devices
```

### Appareil physique

#### Android
1. Activer le mode développeur sur le téléphone
2. Activer le débogage USB
3. Connecter le téléphone par USB
4. Exécuter `flutter run`

#### iOS
1. Signer l'application avec votre compte Apple
2. Connecter l'appareil
3. Exécuter `flutter run`

## 🔍 Débogage

### Afficher les logs

```bash
flutter logs
```

### Utiliser la console Dart

```bash
flutter attach
```

### Déboguer le UI

Utiliser DevTools dans Android Studio ou VS Code:
```bash
flutter pub global activate devtools
devtools
```

## 📦 Gestion des dépendances

### Mettre à jour les dépendances

```bash
# Vérifier les mises à jour disponibles
flutter pub outdated

# Mettre à jour toutes les dépendances
flutter pub upgrade

# Mettre à jour une dépendance spécifique
flutter pub add <package-name>
```

### Ajouter une nouvelle dépendance

```bash
flutter pub add <package-name>

# Ou éditer pubspec.yaml manuellement et faire
flutter pub get
```

### Supprimer une dépendance

```bash
flutter pub remove <package-name>
```

## 🧹 Nettoyage et maintenance

### Nettoyer le build

```bash
flutter clean
```

### Réinitialiser la base de données SQLite

La base de données est stockée à :
- **Android** : `/data/data/com.example.music_player_lite/databases/music_lite.db`
- **iOS** : `~/Library/Caches/music_lite.db`

Pour réinitialiser (en développement) :
1. Désinstaller l'application
2. Réinstaller via `flutter run`

## 🐛 Troubleshooting

### "flutter: command not found"

```bash
# Ajouter Flutter au PATH
# Sur Windows: Ajouter C:\path\to\flutter\bin au PATH
# Sur macOS/Linux: export PATH="$PATH:<path-to-flutter>/bin"
```

### Erreurs de dépendances

```bash
# Nettoyer et réinstaller
flutter clean
flutter pub get
```

### Problèmes de build

```bash
# Nettoyer le cache Gradle (Android)
cd android
./gradlew clean
cd ..

# Réessayer le build
flutter clean
flutter pub get
flutter run
```

### Permission denied sur Android

```bash
# Vérifier les permissions dans AndroidManifest.xml
# Les permissions sont déjà configurées pour accès aux fichiers audio
```

### Issue avec les permissions iOS

```dart
// Les permissions sont gérées automatiquement par permission_handler
// Vérifier que info.plist contient les bonnes entrées
```

## 🎯 Points de contrôle du développement

### Avant de committer

- [ ] `flutter analyze` passe sans erreurs
- [ ] Code formaté : `flutter format .`
- [ ] Tests passent : `flutter test`
- [ ] Pas de warnings inutiles
- [ ] Documentation à jour

### Avant de release

- [ ] Version bump dans pubspec.yaml
- [ ] CHANGELOG mis à jour
- [ ] Code testé sur device physique
- [ ] Performance acceptable (< 60fps)
- [ ] Tous les tests passent

## 📊 Profiling et optimisation

### Analyser les performances

```bash
# Utiliser DevTools
flutter pub global activate devtools
devtools
```

### Vérifier la taille du APK

```bash
flutter build apk --analyze-size --release
```

## 🔐 Code signing (release)

### Android

Voir : `android/app/build.gradle`

```bash
# Créer une clé de signature
keytool -genkey -v -keystore ~/music_player_lite.jks \
  -keyalg RSA -keysize 2048 -validity 10000

# Configuration dans gradle
# (Éditer android/key.properties)
```

### iOS

Utiliser Xcode ou configuration manuelle des signing identities.

## 📚 Documentation utile

- [Flutter Official Docs](https://docs.flutter.dev/)
- [Flutter CLI](https://docs.flutter.dev/reference/flutter-cli)
- [Dart Language Guide](https://dart.dev/guides)
- [Android Development](https://developer.android.com/)
- [iOS Development](https://developer.apple.com/)

## 🤝 Support et contributions

Pour des problèmes :
1. Vérifier les logs : `flutter logs`
2. Consulter Flutter documentation
3. Chercher sur Stack Overflow
4. Vérifier les GitHub issues du project

## ✅ Checklist de vérification

Avant de déployer en production :

- [ ] Toutes les fonctionnalités testées
- [ ] Pas de crash connus
- [ ] Performance optimisée
- [ ] Permissions correctement gérées
- [ ] Erreurs gracieuses
- [ ] Textes et UI localisés si nécessaire
- [ ] Icônes et splash screens configurés
- [ ] Version et build number corrects
- [ ] Signing keys sécurisés
- [ ] Changelog documenté

---

**Problème ?** Consulter les logs ou la documentation pour plus de détails.

**Besoin d'aide ?** Voir DEVELOPMENT.md pour plus d'informations techniques.
