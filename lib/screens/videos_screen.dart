import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideosScreen extends StatelessWidget {
  const VideosScreen({super.key});

  final List<Map<String, String>> videos = const [
    {"title": "Morning Yoga Flow", "id": "v7AYKMP6rOE"},
    {"title": "Calming Meditation", "id": "2OEL4P1Rz04"},
    {"title": "Stress Relief Stretch", "id": "inpok4MKVLM"},
    {"title": "Happy Dance Break", "id": "3GwjfUFyY6M"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Wellness Videos")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(video["title"]!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: YoutubePlayer(
                      controller: YoutubePlayerController(
                        initialVideoId: video["id"]!,
                        flags: const YoutubePlayerFlags(autoPlay: false),
                      ),
                      showVideoProgressIndicator: true,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
