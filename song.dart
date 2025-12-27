class Song {
  final String id;
  final String title;
  final String artist;
  final String filePath; // Chemin local sur le téléphone
  String duration; // Durée formatée (ex: "03:45")

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.filePath,
    required this.duration,
  });

  // Convertir un objet Song en Map pour l'insertion dans SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'filePath': filePath,
    };
  }

  // Créer un objet Song à partir d'une ligne de la base de données
  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      id: map['filePath'] ?? '',
      title: map['title'] ?? 'Titre inconnu',
      artist: map['artist'] ?? 'Artiste inconnu',
      filePath: map['filePath'] ?? '',
      duration: '0:00',
    );
  }
}