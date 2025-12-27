import 'song.dart';

class Playlist {
  final int id;
  final String name;
  final List<Song> songs; // Liste des morceaux contenus dans cette playlist

  Playlist({
    required this.id,
    required this.name,
    this.songs = const [],
  });

  // Convertir en Map pour SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  // Créer une Playlist à partir de la base de données
  factory Playlist.fromMap(Map<String, dynamic> map, {List<Song> songs = const []}) {
    return Playlist(
      id: map['id'],
      name: map['name'],
      songs: songs,
    );
  }
}