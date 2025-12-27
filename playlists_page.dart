import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/playlist_provider.dart';
import 'playlist_details_page.dart';

class PlaylistsPage extends StatefulWidget {
  const PlaylistsPage({super.key});

  @override
  State<PlaylistsPage> createState() => _PlaylistsPageState();
}

class _PlaylistsPageState extends State<PlaylistsPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final playlistProvider = Provider.of<PlaylistProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0E17),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Playlists', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.cyanAccent),
            onPressed: () => _showCreatePlaylistDialog(context, playlistProvider),
          ),
        ],
      ),
      body: playlistProvider.playlists.isEmpty
          ? const Center(child: Text('Aucune playlist', style: TextStyle(color: Colors.white)))
          : ListView.builder(
              itemCount: playlistProvider.playlists.length,
              itemBuilder: (context, index) {
                final playlist = playlistProvider.playlists[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.cyanAccent.withValues(alpha: 0.3),
                    child: Icon(Icons.playlist_play, color: Colors.cyanAccent),
                  ),
                  title: Text(playlist.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text('${playlist.songs.length} morceau${playlist.songs.length > 1 ? 'x' : ''}', 
                      style: const TextStyle(color: Colors.white60)),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Text('Supprimer'),
                        onTap: () {
                          // Ajouter un délai pour permettre au menu de se fermer
                          Future.delayed(Duration(milliseconds: 100), () {
                            _showDeleteConfirmDialog(context, playlist.id, playlistProvider);
                          });
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlaylistDetailsPage(playlist: playlist),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  void _showCreatePlaylistDialog(BuildContext context, PlaylistProvider provider) {
    _controller.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF1a1a2e),
        title: const Text('Nouvelle playlist', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: _controller,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Nom de la playlist',
            hintStyle: TextStyle(color: Colors.white54),
            filled: true,
            fillColor: Colors.white10,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              if (_controller.text.isNotEmpty) {
                await provider.createPlaylist(_controller.text);
                _controller.clear();
                Navigator.pop(context);
              }
            },
            child: const Text('Créer'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, int playlistId, PlaylistProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF1a1a2e),
        title: const Text('Supprimer la playlist', style: TextStyle(color: Colors.white)),
        content: const Text('Êtes-vous sûr de vouloir supprimer cette playlist ?', 
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              await provider.deletePlaylist(playlistId);
              Navigator.pop(context);
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

