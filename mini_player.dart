import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';
import '../views/player_page.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final player = Provider.of<PlayerProvider>(context);

    // Ne pas afficher le mini-player si aucune chanson n'est en cours de lecture
    if (player.currentSong == null) {
      return SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PlayerPage()),
        );
      },
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.8),
          border: Border(
            top: BorderSide(color: Colors.cyanAccent.withValues(alpha: 0.3), width: 1),
          ),
        ),
        child: Row(
          children: [
            // Pochette
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://via.placeholder.com/70'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 12),
            // Titre et artiste
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    player.currentSong?.title ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    player.currentSong?.artist ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            // Bouton Play/Pause
            IconButton(
              icon: Icon(
                player.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: Colors.cyanAccent,
                size: 28,
              ),
              onPressed: () => player.togglePlay(),
            ),
          ],
        ),
      ),
    );
  }
}
