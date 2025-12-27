import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  // Instance du lecteur audio
  final AudioPlayer _player = AudioPlayer();

  // Flux pour surveiller la durée totale et la position actuelle [cite: 19]
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  // Charger et lire un fichier local [cite: 17]
  Future<void> playLocalFile(String path) async {
    try {
      await _player.setFilePath(path);
      await _player.play();
    } catch (e) {
      print("Erreur de lecture : $e");
    }
  }

  // Contrôles de base [cite: 14]
  Future<void> pause() async {
    try {
      await _player.pause();
    } catch (e) {
      print("Erreur lors de la pause : $e");
    }
  }

  Future<void> resume() async {
    try {
      await _player.play();
    } catch (e) {
      print("Erreur lors de la reprise : $e");
    }
  }

  Future<void> stop() async {
    try {
      await _player.stop();
    } catch (e) {
      print("Erreur lors de l'arrêt : $e");
    }
  }
  
  // Aller à un moment précis dans le morceau [cite: 14]
  Future<void> seek(Duration position) async {
    try {
      await _player.seek(position);
    } catch (e) {
      print("Erreur lors du seek : $e");
    }
  }

  // Libérer les ressources quand l'app ferme
  void dispose() {
    _player.dispose();
  }
}