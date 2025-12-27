import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song.dart';
import '../services/audio_player_service.dart';

enum LoopMode { none, one, all }

class PlayerProvider with ChangeNotifier {
  final AudioPlayerService _audioService = AudioPlayerService();
  
  Song? _currentSong;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _totalDuration = Duration.zero;
  List<Song> _playlist = [];
  int _currentIndex = -1;
  bool _isShuffling = false;
  LoopMode _loopMode = LoopMode.none;

  // Getters [cite: 50]
  Song? get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  Duration get position => _position;
  Duration get totalDuration => _totalDuration;
  List<Song> get playlist => _playlist;
  int get currentIndex => _currentIndex;
  bool get isShuffling => _isShuffling;
  LoopMode get loopMode => _loopMode;

  PlayerProvider() {
    // Écouter la progression en temps réel [cite: 50]
    _audioService.positionStream.listen((pos) {
      _position = pos;
      notifyListeners();
    });

    _audioService.durationStream.listen((dur) {
      _totalDuration = dur ?? Duration.zero;
      notifyListeners();
    });

    // Écouter la fin de la chanson pour passer à la suivante
    _audioService.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _handleSongEnded();
      }
    });
  }

  // Jouer une playlist de morceaux [cite: 46]
  void playPlaylist(List<Song> songs, {int startIndex = 0}) {
    _playlist = songs;
    _currentIndex = startIndex;
    if (_playlist.isNotEmpty) {
      playSong(_playlist[_currentIndex]);
    }
  }

  // Jouer un morceau [cite: 46]
  void playSong(Song song) async {
    _currentSong = song;
    await _audioService.playLocalFile(song.filePath); 
    _isPlaying = true;
    notifyListeners();
  }

  // Pause / Reprise [cite: 47]
  void togglePlay() {
    if (_isPlaying) {
      _audioService.pause();
    } else {
      _audioService.resume();
    }
    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  // Chanson suivante
  void playNext() {
    if (_playlist.isEmpty) return;
    
    int nextIndex;
    if (_isShuffling) {
      nextIndex = (DateTime.now().millisecondsSinceEpoch % _playlist.length).toInt();
    } else {
      nextIndex = (_currentIndex + 1) % _playlist.length;
    }
    
    _currentIndex = nextIndex;
    playSong(_playlist[_currentIndex]);
  }

  // Chanson précédente
  void playPrevious() {
    if (_playlist.isEmpty) return;
    
    // Si on est passé plus de 3 secondes, revenir au début
    if (_position.inSeconds > 3) {
      seek(Duration.zero);
      return;
    }
    
    int prevIndex = (_currentIndex - 1 + _playlist.length) % _playlist.length;
    _currentIndex = prevIndex;
    playSong(_playlist[_currentIndex]);
  }

  // Basculer le mode shuffle
  void toggleShuffle() {
    _isShuffling = !_isShuffling;
    notifyListeners();
  }

  // Basculer le mode boucle (none -> one -> all -> none)
  void toggleLoopMode() {
    _loopMode = LoopMode.values[(_loopMode.index + 1) % LoopMode.values.length];
    notifyListeners();
  }

  // Gestion automatique quand une chanson se termine
  void _handleSongEnded() {
    if (_loopMode == LoopMode.one) {
      // Recommencer le même morceau
      playSong(_currentSong!);
    } else if (_loopMode == LoopMode.all || _currentIndex + 1 < _playlist.length) {
      playNext();
    } else {
      // Fin de la playlist
      _isPlaying = false;
      notifyListeners();
    }
  }

  // Changer de position (Seekbar) [cite: 50]
  void seek(Duration pos) {
    _audioService.seek(pos);
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }
}