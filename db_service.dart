import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/playlist.dart';
import '../models/song.dart';

class DBService {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'music_lite.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Table des noms de playlists
        await db.execute('''
          CREATE TABLE playlists (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL
          )
        ''');
        // Table des morceaux contenus dans les playlists
        await db.execute('''
          CREATE TABLE playlist_items (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            playlistId INTEGER NOT NULL,
            filePath TEXT NOT NULL,
            title TEXT NOT NULL,
            artist TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // Ajouter une playlist
  Future<int> createPlaylist(String name) async {
    final dbClient = await db;
    return await dbClient.insert('playlists', {'name': name});
  }

  // Charger toutes les playlists avec leurs chansons
  Future<List<Playlist>> loadPlaylists() async {
    try {
      final dbClient = await db;
      final List<Map<String, dynamic>> maps = await dbClient.query('playlists');
      List<Playlist> playlists = [];
      for (var map in maps) {
        int id = map['id'];
        final items = await dbClient.query('playlist_items', where: 'playlistId = ?', whereArgs: [id]);
        List<Song> songs = items.map((item) => Song.fromMap(item)).toList();
        playlists.add(Playlist.fromMap(map, songs: songs));
      }
      return playlists;
    } catch (e) {
      print("Erreur lors du chargement des playlists : $e");
      return [];
    }
  }

  // Ajouter une chanson à une playlist
  Future<int> addSongToPlaylist(int playlistId, Song song) async {
    final dbClient = await db;
    return await dbClient.insert('playlist_items', {
      'playlistId': playlistId,
      'filePath': song.filePath,
      'title': song.title,
      'artist': song.artist,
    });
  }

  // Supprimer une playlist et ses chansons
  Future<void> deletePlaylist(int playlistId) async {
    final dbClient = await db;
    await dbClient.delete('playlist_items', where: 'playlistId = ?', whereArgs: [playlistId]);
    await dbClient.delete('playlists', where: 'id = ?', whereArgs: [playlistId]);
  }

  // Supprimer une chanson d'une playlist
  Future<void> removeSongFromPlaylist(int itemId) async {
    final dbClient = await db;
    await dbClient.delete('playlist_items', where: 'id = ?', whereArgs: [itemId]);
  }
}
