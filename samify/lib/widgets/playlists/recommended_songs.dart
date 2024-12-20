import 'package:flutter/material.dart';
import 'package:samify/providers/spotify_service.dart';
import './components/trending_card.dart';
import './music_player.dart';

class RecommendedSongs extends StatefulWidget {
  const RecommendedSongs({super.key});

  @override
  _RecommendedSongsState createState() => _RecommendedSongsState();
}

class _RecommendedSongsState extends State<RecommendedSongs> {
  late Future<List<Map<String, String>>> recommendedSongs;

  @override
  void initState() {
    super.initState();
    recommendedSongs = SpotifyService.getRecommendedSongs();
  }

  void _navigateToMusicPlayerPage(Map<String, String> song) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MusicPlayerPage(
        songTitle: song['name']!, // Use the song title from your list
        artistName: song['artist']!, // Use the artist name from your list
        imageUrl: song['image']!, // Use the image URL from your list
        audioUrl: song['audioUrl']!, // The actual song URL to play
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Recommended For You',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        FutureBuilder<List<Map<String, String>>>(
          future: recommendedSongs,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Error fetching recommended songs'));
            }

            final songs = snapshot.data ?? [];
            return SizedBox(
              height: 200, // Adjust height for the cards
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  final song = songs[index];
                  return SongCard(
                    songName: song['name']!,
                    author: song['artist']!,
                    imageUrl: song['image']!,
                    onTap: () {
                      _navigateToMusicPlayerPage(song);
                    },
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
