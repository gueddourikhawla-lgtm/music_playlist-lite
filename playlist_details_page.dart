import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/playlist.dart';
import '../providers/player_provider.dart';
import '../providers/song_provider.dart';
import '../providers/playlist_provider.dart';
import 'player_page.dart';

class PlaylistDetailsPage extends StatelessWidget {
  final Playlist playlist;

  const PlaylistDetailsPage({required this.playlist, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0E17),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(playlist.name, style: const TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.cyanAccent),
            onPressed: () => _showAddSongsDialog(context),
          ),
        ],
      ),
      body: playlist.songs.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.music_note, size: 64, color: Colors.white30),
                  SizedBox(height: 16),
                  Text(
                    'Aucun morceau dans cette playlist',
                    style: TextStyle(color: Colors.white54, fontSize: 16),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showAddSongsDialog(context),
                    icon: Icon(Icons.add),
                    label: Text('Ajouter des morceaux'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyanAccent,
                      foregroundColor: Colors.black,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: playlist.songs.length,
              itemBuilder: (context, index) {
                final song = playlist.songs[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.white10,
                    child: Icon(Icons.music_note, color: Colors.cyanAccent),
                  ),
                  title: Text(song.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text(song.artist, style: const TextStyle(color: Colors.white60)),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: const Text('Supprimer'),
                        onTap: () {
                          // The pop is delayed due to [flutter/flutter#42522](https://github.com/flutter/flutter/issues/42522)
                          Future.delayed(Duration(milliseconds: 100), () {
                            _removeSong(context, song, index);
                          });
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    // Play the song from this playlist
                    Provider.of<PlayerProvider>(context, listen: false)
                        .playPlaylist(playlist.songs, startIndex: index);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PlayerPage()));
                  },
                );
              },
            ),
    );
  }

  void _showAddSongsDialog(BuildContext context) {
    final songProvider = Provider.of<SongProvider>(context, listen: false);
    final playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
    final availableSongs = songProvider.songs
        .where((song) => !playlist.songs.any((s) => s.filePath == song.filePath))
        .toList();

    if (availableSongs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tous les morceaux sont déjà dans cette playlist')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Color(0xFF1a1a2e),
          title: const Text('Ajouter des morceaux', style: TextStyle(color: Colors.white)),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: availableSongs.length,
              itemBuilder: (context, index) {
                final song = availableSongs[index];
                return CheckboxListTile(
                  title: Text(song.title, style: const TextStyle(color: Colors.white)),
                  subtitle: Text(song.artist, style: const TextStyle(color: Colors.white60)),
                  value: false,
                  onChanged: (value) async {
                    if (value ?? false) {
                      await playlistProvider.addSongToPlaylist(playlist.id, song);
                    }
                  },
                  activeColor: Colors.cyanAccent,
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fermer'),
            ),
          ],
        ),
      ),
    );
  }

  void _removeSong(BuildContext context, dynamic song, int index) {
    // Note: To properly support removal, we'd need to modify the Song model
    // to include the database ID for playlist_items table
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Supression via modification ultérieure')),
    );
  }
}
