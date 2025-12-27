import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/song_provider.dart';
import '../providers/player_provider.dart';
import '../providers/playlist_provider.dart';
import '../widgets/mini_player.dart';
import 'player_page.dart';
import 'playlists_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Load playlists on start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PlaylistProvider>(context, listen: false).loadPlaylists();
    });
  }

  @override
  Widget build(BuildContext context) {
    final songProvider = Provider.of<SongProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFF0F0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: TextField(
          onChanged: (value) => songProvider.searchSongs(value), // Logique de recherche [cite: 38]
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Rechercher un morceau...",
            hintStyle: TextStyle(color: Colors.white54),
            prefixIcon: Icon(Icons.search, color: Colors.cyanAccent),
            filled: true,
            fillColor: Colors.white10,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
          ),
        ),
        actions: [
          PopupMenuButton<SortType>(
            icon: Icon(Icons.sort, color: Colors.cyanAccent),
            onSelected: (SortType value) {
              songProvider.setSortType(value);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<SortType>>[
              PopupMenuItem<SortType>(
                value: SortType.title,
                child: Text('Titre (A-Z)'),
              ),
              PopupMenuItem<SortType>(
                value: SortType.artist,
                child: Text('Artiste'),
              ),
              PopupMenuItem<SortType>(
                value: SortType.duration,
                child: Text('Durée'),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.playlist_play, color: Colors.cyanAccent),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PlaylistsPage())),
          ),
          IconButton(
            icon: Icon(Icons.add_circle, color: Colors.cyanAccent),
            onPressed: () => songProvider.importSongs(),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Liste des chansons
          songProvider.songs.isEmpty
              ? Center(child: Text("Aucun morceau trouvé", style: TextStyle(color: Colors.white)))
              : ListView.builder(
                  itemCount: songProvider.songs.length,
                  itemBuilder: (context, index) {
                    final song = songProvider.songs[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white10,
                        child: Icon(Icons.music_note, color: Colors.cyanAccent),
                      ),
                      title: Text(song.title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      subtitle: Text(song.artist, style: TextStyle(color: Colors.white60)),
                      trailing: Text(song.duration, style: TextStyle(color: Colors.white54)),
                      onTap: () {
                        // Créer une playlist pour jouer à partir de cette chanson
                        Provider.of<PlayerProvider>(context, listen: false)
                            .playPlaylist(songProvider.songs, startIndex: index);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PlayerPage()));
                      },
                    );
                  },
                  padding: EdgeInsets.only(bottom: 70),
                ),
          // Mini-player en bas
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: MiniPlayer(),
          ),
        ],
      ),
    );
  }
}