# Music Player Lite

Une application mobile Flutter simple et légère pour lire des fichiers audio stockés localement sur votre téléphone.

## 📱 Fonctionnalités principales

### 1. **Lecture Audio**
- Lecture de fichiers audio en formats MP3, WAV, AAC
- Contrôles de base : Play, Pause, Stop
- Barre de progression avec seekbar
- Affichage de la durée totale et du temps écoulé
- Lecture hors-ligne (aucun streaming)

### 2. **Navigation des Pistes**
- Boutons suivant/précédent
- Support du shuffle (lecture aléatoire)
- Modes de boucle :
  - 🔁 Aucune boucle
  - 🔁 Répéter un morceau
  - 🔁 Répéter la playlist

### 3. **Gestion de la Bibliothèque**
- Importation de fichiers audio via sélecteur de fichiers
- Recherche de morceaux (par titre ou artiste)
- Tri par : titre (A-Z), artiste, durée
- Affichage de la liste des morceaux avec :
  - Titre
  - Artiste
  - Durée
  - Icône de musique

### 4. **Mini-Lecteur**
- Barre persistante en bas de l'écran
- Affichage du morceau actuel
- Bouton Play/Pause rapide
- Navigation vers l'écran complet du lecteur

### 5. **Gestion des Playlists**
- Création de playlists locales
- Ajout/suppression de morceaux dans les playlists
- Suppression de playlists complètes
- Lecture d'une playlist entière
- Stockage SQLite des playlists

### 6. **Interface Utilisateur**
- Design sombre et moderne
- Couleurs cyan et blanches
- Animations fluides
- Responsive layout

## 🛠️ Architecture et Structure

### Modèles (lib/models/)
- **Song.dart** : Représentation d'un morceau audio
- **Playlist.dart** : Représentation d'une playlist

### Services (lib/services/)
- **AudioPlayerService.dart** : Gestion du lecteur audio (just_audio)
- **FileService.dart** : Sélection et importation de fichiers
- **DBService.dart** : Gestion de la base de données SQLite
- **MetadataService.dart** : Extraction de métadonnées (durée)

### Providers (lib/providers/) - État avec Provider
- **SongProvider** : Gestion de la liste des morceaux, recherche, tri
- **PlayerProvider** : Contrôle du lecteur (play, pause, seek, navigation)
- **PlaylistProvider** : Gestion des playlists locales

### Vues (lib/views/)
- **HomePage** : Affichage principal de la bibliothèque
- **PlayerPage** : Écran complet du lecteur audio
- **PlaylistsPage** : Gestion des playlists
- **PlaylistDetailsPage** : Contenu d'une playlist

### Widgets (lib/widgets/)
- **MiniPlayer** : Lecteur miniature persistant en bas

## 📦 Dépendances principales

```yaml
# Audio playback
just_audio: ^0.9.36

# File selection
file_picker: ^5.5.0

# Local database
sqflite: ^2.3.0

# State management
provider: ^6.1.1

# Permissions
permission_handler: ^11.4.4

# Device info (pour vérifier la version Android)
device_info_plus: ^9.1.1

# Utilities
path: ^1.8.3
path_provider: ^2.1.1
```

## 🚀 Installation et Configuration

### Prérequis
- Flutter 3.9.2 ou supérieur
- Dart SDK
- Android Studio / Xcode pour iOS

### Étapes d'installation

1. **Cloner le projet**
```bash
git clone <repository-url>
cd music_player_lite
```

2. **Installer les dépendances**
```bash
flutter pub get
```

3. **Configurer les permissions Android**
Les permissions sont déjà configurées dans `android/app/src/main/AndroidManifest.xml`:
- `READ_EXTERNAL_STORAGE` (Android < 13)
- `READ_MEDIA_AUDIO` (Android 13+)

4. **Exécuter l'application**
```bash
flutter run
```

## 📋 Permissions requises

### Android
- **READ_EXTERNAL_STORAGE** : Pour accéder aux fichiers audio
- **READ_MEDIA_AUDIO** : Pour Android 13+

### iOS
- **Music Permission** : Pour accéder à la bibliothèque musicale

Les permissions sont demandées à l'utilisateur lors de la première importation de fichiers.

## 🎯 Flux utilisateur

1. **Démarrage** : L'app se lance sur la page d'accueil (HomePage)
2. **Importation** : L'utilisateur clique sur "+" pour importer des fichiers audio
3. **Lecture** : Clic sur un morceau pour ouvrir le lecteur complet
4. **Navigation** : Utilisation du mini-lecteur pour contrôler rapidement la lecture
5. **Playlists** : Création et gestion des playlists via le menu Playlists

## 🔧 Utilisation des Providers

### SongProvider
```dart
// Importer des fichiers
songProvider.importSongs();

// Rechercher
songProvider.searchSongs("query");

// Trier
songProvider.setSortType(SortType.title);
```

### PlayerProvider
```dart
// Jouer une playlist
playerProvider.playPlaylist(songs, startIndex: 0);

// Contrôles
playerProvider.togglePlay();
playerProvider.playNext();
playerProvider.playPrevious();

// Modes
playerProvider.toggleShuffle();
playerProvider.toggleLoopMode();

// Seek
playerProvider.seek(Duration(seconds: 30));
```

### PlaylistProvider
```dart
// Charger les playlists
playlistProvider.loadPlaylists();

// Créer une playlist
playlistProvider.createPlaylist("Ma playlist");

// Ajouter une chanson
playlistProvider.addSongToPlaylist(playlistId, song);

// Supprimer
playlistProvider.deletePlaylist(playlistId);
playlistProvider.removeSongFromPlaylist(itemId);
```

## 🎨 Thème et Couleurs

- **Couleur primaire** : Cyan (#00BCD4)
- **Couleur de fond** : Très foncée (#0F0E17)
- **Couleur secondaire** : Blanc avec alpha variable
- **Thème** : Dark theme (Brightness.dark)

## 🐛 Troubleshooting

### L'app ne démarre pas
- Vérifier que Flutter est correctement installé : `flutter doctor`
- Vérifier les dépendances : `flutter pub get`
- Nettoyer le build : `flutter clean && flutter pub get`

### Les permissions ne sont pas demandées
- Vérifier AndroidManifest.xml
- Supprimer l'app du téléphone et réinstaller
- Vérifier les paramètres de permission du téléphone

### La musique ne joue pas
- Vérifier que le fichier audio est valide
- Vérifier les permissions d'accès au stockage
- Consulter les logs : `flutter logs`

## 📚 Ressources supplémentaires

- [Flutter Docs](https://docs.flutter.dev/)
- [just_audio Documentation](https://pub.dev/packages/just_audio)
- [Provider Documentation](https://pub.dev/packages/provider)
- [SQLite with Flutter](https://docs.flutter.dev/cookbook/persistence/sqlite)

## 📝 Notes de développement

### Améliorations futures possibles

1. **ID3 Tag Reading** : Lire les métadonnées complètes des fichiers MP3
2. **Audio Visualizer** : Effet visuel de l'audio en temps réel
3. **Égaliseur** : Presets audio (bass boost, pop, rock, etc.)
4. **Sleep Timer** : Arrêt automatique après un délai
5. **Lecture en arrière-plan** : Musique qui continue même si l'app est minimisée
6. **Notifications de contrôle** : Boutons de contrôle dans la notification
7. **Gestion des favoris** : Marquer les morceaux préférés
8. **Export/Import** : Sauvegarder et restaurer les playlists

### Performance
- Utilisation du singleton pour AudioPlayer
- Chargement lazy des métadonnées
- Optimisation de la liste avec ListView.builder

## 📄 License

Ce projet est fourni à titre pédagogique.

## 👤 Auteur

Développé comme projet pédagogique Flutter.

---

**Version actuelle** : 1.0.0

**Dernière mise à jour** : Décembre 2025
