import 'package:just_audio/just_audio.dart';
import '../models/song.dart';

class MetadataService {
  static final MetadataService _instance = MetadataService._internal();
  
  MetadataService._internal();

  factory MetadataService() {
    return _instance;
  }

  // Extraire la durée d'un fichier audio
  Future<String> extractDuration(String filePath) async {
    AudioPlayer tempPlayer = AudioPlayer();
    try {
      await tempPlayer.setFilePath(filePath);
      final duration = tempPlayer.duration ?? Duration.zero;
      return _formatDuration(duration);
    } catch (e) {
      print("Erreur lors de l'extraction de la durée : $e");
      return "0:00";
    } finally {
      await tempPlayer.dispose();
    }
  }

  // Extraire les métadonnées complètes (durée, titre, artiste si disponibles)
  Future<void> enrichSongMetadata(Song song) async {
    try {
      // Extraire la durée
      final duration = await extractDuration(song.filePath);
      song.duration = duration;
      
      // Note: pour extraire le titre et l'artiste des tags ID3, 
      // on pourrait utiliser un plugin comme 'metadata_god' ou 'audio_metadata_reader'
      // mais pour cette implémentation simple, on utilise le nom du fichier
    } catch (e) {
      print("Erreur lors de l'enrichissement des métadonnées : $e");
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds.remainder(60))}";
  }
}
