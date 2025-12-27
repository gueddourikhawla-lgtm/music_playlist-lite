import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';

class PlayerPage extends StatelessWidget {
  const PlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final player = Provider.of<PlayerProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        // Permettre de quitter sans arrêter la musique
        return true;
      },
      child: Scaffold(
        backgroundColor: Color(0xFF0F0E17),
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text("Lecteur", style: TextStyle(color: Colors.white70)),
        ),
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.cyanAccent.withValues(alpha: 0.2), blurRadius: 30)],
                    image: DecorationImage(
                      image: NetworkImage('https://via.placeholder.com/300'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            _buildControlCard(player),
          ],
        ),
      ),
    );
  }

  Widget _buildControlCard(PlayerProvider player) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            player.currentSong?.title ?? "Titre",
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            player.currentSong?.artist ?? "Artiste",
            style: TextStyle(color: Colors.white60, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          // Barre de progression
          Slider(
            value: player.position.inSeconds.toDouble(),
            max: player.totalDuration.inSeconds.toDouble() > 0 
                ? player.totalDuration.inSeconds.toDouble() 
                : 1.0,
            activeColor: Colors.cyanAccent,
            inactiveColor: Colors.white10,
            onChanged: (value) => player.seek(Duration(seconds: value.toInt())),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatDuration(player.position), style: TextStyle(color: Colors.white54, fontSize: 12)),
              Text(_formatDuration(player.totalDuration), style: TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          ),
          SizedBox(height: 20),
          // Contrôles principaux
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Shuffle
              IconButton(
                icon: Icon(
                  Icons.shuffle,
                  size: 30,
                  color: player.isShuffling ? Colors.cyanAccent : Colors.white,
                ),
                onPressed: () => player.toggleShuffle(),
              ),
              // Précédent
              IconButton(
                icon: Icon(Icons.skip_previous_rounded, size: 50, color: Colors.white),
                onPressed: () => player.playPrevious(),
              ),
              // Play/Pause
              GestureDetector(
                onTap: () => player.togglePlay(),
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.cyanAccent,
                  child: Icon(
                    player.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    size: 50,
                    color: Colors.black,
                  ),
                ),
              ),
              // Suivant
              IconButton(
                icon: Icon(Icons.skip_next_rounded, size: 50, color: Colors.white),
                onPressed: () => player.playNext(),
              ),
              // Boucle
              IconButton(
                icon: Icon(
                  _getLoopIcon(player.loopMode),
                  size: 30,
                  color: player.loopMode != LoopMode.none ? Colors.cyanAccent : Colors.white,
                ),
                onPressed: () => player.toggleLoopMode(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  IconData _getLoopIcon(LoopMode mode) {
    switch (mode) {
      case LoopMode.none:
        return Icons.repeat;
      case LoopMode.one:
        return Icons.repeat_one;
      case LoopMode.all:
        return Icons.repeat;
    }
  }
}