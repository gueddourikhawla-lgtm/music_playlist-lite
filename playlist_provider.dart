import 'package:flutter/material.dart';
import '../models/playlist.dart';
import '../models/song.dart';
import '../services/db_service.dart';

class PlaylistProvider with ChangeNotifier {
  List<Playlist> _playlists = [];
  final DBService _dbService = DBService();

  List<Playlist> get playlists => _playlists;

  // Charger les playlists depuis SQLite
  Future<void> loadPlaylists() async {
    _playlists = await _dbService.loadPlaylists();
    notifyListeners();
  }

  // Créer une nouvelle playlist
  Future<void> createPlaylist(String name) async {
    await _dbService.createPlaylist(name);
    await loadPlaylists();
  }

  // Ajouter une chanson à une playlist
  Future<void> addSongToPlaylist(int playlistId, Song song) async {
    await _dbService.addSongToPlaylist(playlistId, song);
    await loadPlaylists();
  }

  // Supprimer une playlist
  Future<void> deletePlaylist(int playlistId) async {
    await _dbService.deletePlaylist(playlistId);
    await loadPlaylists();
  }

  // Supprimer une chanson d'une playlist
  Future<void> removeSongFromPlaylist(int itemId) async {
    await _dbService.removeSongFromPlaylist(itemId);
    await loadPlaylists();
  }
}
