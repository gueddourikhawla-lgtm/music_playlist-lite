import 'package:flutter/material.dart';
import '../models/song.dart';
import '../services/file_service.dart';
import '../services/metadata_service.dart';

enum SortType { title, artist, duration, dateAdded }

class SongProvider with ChangeNotifier {
  final List<Song> _allSongs = [];
  List<Song> _filteredSongs = [];
  final FileService _fileService = FileService();
  final MetadataService _metadataService = MetadataService();
  SortType _sortType = SortType.dateAdded;
  bool _sortAscending = true;

  List<Song> get songs => _filteredSongs.isEmpty ? _allSongs : _filteredSongs;
  SortType get sortType => _sortType;
  bool get sortAscending => _sortAscending;

  
  Future<void> importSongs() async {
    final newSongs = await _fileService.pickAudioFiles(); 
    if (newSongs != null) {
      // Extraire les métadonnées (notamment la durée)
      for (var song in newSongs) {
        await _metadataService.enrichSongMetadata(song);
      }
      _allSongs.addAll(newSongs); 
      _sortSongs();
      notifyListeners();
    }
  }

 
  void searchSongs(String query) {
    if (query.isEmpty) {
      _filteredSongs = [];
    } else {
      _filteredSongs = _allSongs
          .where((song) => song.title.toLowerCase().contains(query.toLowerCase()) ||
                          song.artist.toLowerCase().contains(query.toLowerCase()))
          .toList();
      _sortSongs();
    }
    notifyListeners();
  }

  // Trier les chansons
  void setSortType(SortType type) {
    if (_sortType == type) {
      _sortAscending = !_sortAscending;
    } else {
      _sortType = type;
      _sortAscending = true;
    }
    _sortSongs();
    notifyListeners();
  }

  void _sortSongs() {
    List<Song> listToSort = _filteredSongs.isEmpty ? _allSongs : _filteredSongs;
    
    switch (_sortType) {
      case SortType.title:
        listToSort.sort((a, b) => _sortAscending 
            ? a.title.compareTo(b.title)
            : b.title.compareTo(a.title));
        break;
      case SortType.artist:
        listToSort.sort((a, b) => _sortAscending 
            ? a.artist.compareTo(b.artist)
            : b.artist.compareTo(a.artist));
        break;
      case SortType.duration:
        listToSort.sort((a, b) {
          int aDuration = _parseDuration(a.duration);
          int bDuration = _parseDuration(b.duration);
          return _sortAscending ? aDuration.compareTo(bDuration) : bDuration.compareTo(aDuration);
        });
        break;
      case SortType.dateAdded:
        // Conserve l'ordre chronologique d'ajout
        break;
    }
  }

  int _parseDuration(String duration) {
    // Parse "MM:SS" format to seconds
    try {
      List<String> parts = duration.split(':');
      if (parts.length == 2) {
        int minutes = int.parse(parts[0]);
        int seconds = int.parse(parts[1]);
        return minutes * 60 + seconds;
      }
    } catch (e) {
    print("Erreur lors du parsing de la durée : $e");
    }
    return 0;
  }
}