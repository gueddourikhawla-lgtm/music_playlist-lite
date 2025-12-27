# Guide de Développement - Music Player Lite

## 📖 Guide pour les développeurs

Ce document fournit des informations pour continuer le développement de Music Player Lite.

## 🏗️ Architecture actuelle

### Pattern utilisé : Provider + Services

```
UI (Views/Widgets)
    ↓
Providers (State Management)
    ↓
Services (Business Logic)
    ↓
Models (Data)
```

## 📂 Structure des dossiers

```
lib/
├── main.dart                 # Point d'entrée de l'app
├── models/
│   ├── song.dart            # Modèle d'une chanson
│   └── playlist.dart        # Modèle d'une playlist
├── services/
│   ├── audio_player_service.dart    # Gestion du lecteur audio
│   ├── file_service.dart            # Sélection et importation de fichiers
│   ├── db_service.dart              # Gestion de la base de données
│   └── metadata_service.dart        # Extraction de métadonnées
├── providers/
│   ├── song_provider.dart           # Gestion des morceaux et recherche
│   ├── player_provider.dart         # Contrôle du lecteur
│   └── playlist_provider.dart       # Gestion des playlists
├── views/
│   ├── home_page.dart               # Page d'accueil
│   ├── player_page.dart             # Écran du lecteur
│   ├── playlists_page.dart          # Gestion des playlists
│   ├── playlist_details_page.dart   # Détails d'une playlist
│   └── import_page.dart             # (À remplir) Import personnalisé
└── widgets/
    └── mini_player.dart             # Lecteur miniature
```

## 🔄 Flux de données

### Importation de fichiers
```
HomePage (+ button)
    ↓
SongProvider.importSongs()
    ↓
FileService.pickAudioFiles()
    ↓
MetadataService.enrichSongMetadata()
    ↓
Update UI
```

### Lecture d'une chanson
```
ListView.onTap()
    ↓
PlayerProvider.playPlaylist()
    ↓
AudioPlayerService.playLocalFile()
    ↓
PlayerPage (UI mise à jour)
```

### Gestion des playlists
```
PlaylistsPage
    ↓
PlaylistProvider
    ↓
DBService (CRUD operations)
    ↓
SQLite Database
```

## 🎯 Points clés du code

### 1. Audio Player Service

**Fichier** : `lib/services/audio_player_service.dart`

```dart
// Singleton - une seule instance
AudioPlayer _player = AudioPlayer();

// Streams pour la réactivité
Stream<Duration?> durationStream;
Stream<Duration> positionStream;
Stream<PlayerState> playerStateStream;

// Contrôles
playLocalFile(path)
pause()
resume()
seek(duration)
```

**À améliorer** :
- Ajouter la détection de fin de piste
- Implémenter les presets d'égaliseur
- Ajouter la détection d'erreurs réseau (si streaming futur)

### 2. Player Provider

**Fichier** : `lib/providers/player_provider.dart`

```dart
// État
Song? _currentSong
bool _isPlaying
Duration _position
Duration _totalDuration
List<Song> _playlist
int _currentIndex
bool _isShuffling
LoopMode _loopMode

// Méthodes clés
playPlaylist(songs, startIndex)
playSong(song)
playNext()
playPrevious()
togglePlay()
toggleLoopMode()
toggleShuffle()
```

**À améliorer** :
- Ajouter la persistence de l'état lors de fermeture de l'app
- Implémenter la sauvegarde de la position de lecture
- Ajouter des notifications de lecture en arrière-plan

### 3. Song Provider

**Fichier** : `lib/providers/song_provider.dart`

```dart
// Gestion de la liste
List<Song> _allSongs
List<Song> _filteredSongs

// Méthodes clés
importSongs()      // Importer des fichiers
searchSongs(query) // Rechercher
setSortType(type)  // Trier
```

**À améliorer** :
- Ajouter une liste des favoris
- Implémenter un historique de lecture
- Ajouter des métadonnées plus complètes

### 4. Playlist Provider

**Fichier** : `lib/providers/playlist_provider.dart`

```dart
// État
List<Playlist> _playlists

// Méthodes clés
loadPlaylists()
createPlaylist(name)
addSongToPlaylist(playlistId, song)
deletePlaylist(playlistId)
removeSongFromPlaylist(itemId)
```

**À améliorer** :
- Ajouter la modification du nom d'une playlist
- Implémenter le réordonnancement des morceaux
- Ajouter les playlists partagées

## 🛠️ Extensions suggérées

### 1. ID3 Tag Reading

**Dépendance** : `metadata_god` ou `audio_metadata_reader`

```dart
// Dans metadata_service.dart
Future<Map<String, String>> extractID3Tags(String filePath) async {
  // Lire les tags ID3
  return {
    'title': '',
    'artist': '',
    'album': '',
    'artwork': '',
  };
}
```

### 2. Audio Visualizer

**Dépendance** : `just_audio`, widget customisé

```dart
// Nouveau widget : lib/widgets/audio_visualizer.dart
class AudioVisualizer extends StatefulWidget {
  // Animation basée sur la fréquence audio
}
```

### 3. Sleep Timer

```dart
// Dans player_provider.dart
Duration? _sleepTimer;
Timer? _sleepTimerTask;

void setSleepTimer(Duration duration) {
  _sleepTimer = duration;
  _sleepTimerTask = Timer(duration, () {
    pause();
    _sleepTimer = null;
  });
}
```

### 4. Background Playback

**Dépendance** : `audio_service`

```dart
// Configurer audio_service
// Ajouter la musique de fond pour continuer même app minimisée
```

### 5. Equalizer

**Dépendance** : `flutter_equalizer` ou `just_audio_service`

```dart
// Dans audio_player_service.dart
Future<void> applyEqualizerPreset(String preset) async {
  // Appliquer bass boost, pop, rock, etc.
}
```

## 🧪 Testing

### À implémenter

```dart
// test/unit/song_provider_test.dart
void main() {
  test('SongProvider sort by title', () {
    // Test tri
  });
}

// test/widget/player_page_test.dart
void main() {
  testWidgets('PlayerPage displays song info', (WidgetTester tester) async {
    // Test UI
  });
}
```

## 📊 Optimisations possibles

### Performance
- Lazy loading des métadonnées
- Caching des durées extraites
- Virtualisation des listes longues
- Compression des images

### Mémoire
- Disposal des streams non utilisés
- Gestion des ressources du lecteur audio
- Nettoyage des données temporaires

### UX
- Animations de transition
- Haptic feedback
- Gestes (swipe pour changer de piste)
- Landscape mode

## 🔐 Sécurité

- Valider les chemins de fichier
- Vérifier les permissions avant d'accéder aux fichiers
- Gérer les erreurs de lecture gracieusement
- Sanitizer les entrées utilisateur

## 📱 Compatibilité multi-plateforme

### Android
- Testé sur API 21+
- Notifications de contrôle à implémenter
- Lecture en arrière-plan à configurer

### iOS
- Testé sur iOS 12+
- AVAudioSession à configurer
- Background modes à ajouter

### Web (non implémenté)
- Nécessiterait des adaptations pour just_audio
- API Web Audio à utiliser

## 🚀 Déploiement

### Release APK Android
```bash
flutter build apk --release
```

### Release IPA iOS
```bash
flutter build ipa --release
```

## 📚 Ressources utiles

- [just_audio documentation](https://pub.dev/packages/just_audio)
- [Provider pattern](https://pub.dev/packages/provider)
- [Flutter state management guide](https://docs.flutter.dev/development/data-and-backend/state-mgmt)
- [SQLite best practices](https://docs.flutter.dev/cookbook/persistence/sqlite)
- [Android permissions](https://developer.android.com/guide/topics/permissions)

## 🤝 Guidelines de contribution

1. **Code style** : Utiliser les conventions Dart
2. **Naming** : Clair et descriptif
3. **Comments** : Expliquer le "pourquoi" pas le "quoi"
4. **Testing** : Tests unitaires et widget
5. **Documentation** : Mettre à jour les commentaires

## 🐛 Bugs connus

- (Aucun actuellement)

## 📝 Changelog

### Version 1.0.0 (Décembre 2025)
- ✅ Lecture audio basique
- ✅ Navigation des pistes
- ✅ Recherche et tri
- ✅ Gestion des playlists
- ✅ Mini-player
- ✅ Modes boucle et shuffle
- ⏳ Métadonnées avancées (ID3)
- ⏳ Visualizer audio
- ⏳ Égaliseur

---

**Pour toute question**, consulter les commentaires du code ou la documentation Flutter.
