import 'package:file_picker/file_picker.dart';
import '../models/song.dart';

class FileService {
  // Demander les permissions d'accès aux fichiers
  // Note: permission_handler et device_info_plus devraient être ajoutés à pubspec.yaml
  Future<bool> requestStoragePermission() async {
    try {
      // Les permissions sont gérées automatiquement par file_picker
      // qui demande les permissions nécessaires
      return true;
    } catch (e) {
      print("Erreur lors de la demande de permission : $e");
      return false;
    }
  }

  // Sélectionner des fichiers audio sur le téléphone
  Future<List<Song>?> pickAudioFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: true, // Permet d'importer plusieurs morceaux d'un coup
      );

      if (result != null) {
        return result.files.map((file) {
          return Song(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: file.name.split('.').first,
            artist: "Artiste inconnu",
            filePath: file.path ?? '',
            duration: "0:00",
          );
        }).toList();
      }
      return null;
    } catch (e) {
      print("Erreur lors de la sélection de fichiers : $e");
      return null;
    }
  }
}