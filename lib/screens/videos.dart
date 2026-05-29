import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// =======================================================
/// MODEL
/// =======================================================
class ExerciseVideo {
  final String title;
  final String category;
  final String section;
  final String thumbnail;
  final String youtubeId;
  final String duration;
  final String views;

  ExerciseVideo({
    required this.title,
    required this.category,
    required this.section,
    required this.thumbnail,
    required this.youtubeId,
    required this.duration,
    required this.views,
  });
}

/// =======================================================
/// MAIN SCREEN
/// =======================================================
class VideosScreen extends StatefulWidget {
  const VideosScreen({super.key});

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  String selectedCategory = "All";
  final categories = ["All", "Meditation", "Yoga", "Stretching"];

  final List<ExerciseVideo> videos = [
    ExerciseVideo(
      title: "Morning Calm Meditation",
      category: "Meditation",
      section: "Guided Meditation",
      thumbnail: "https://images.unsplash.com/photo-1506126613408-eca07ce68773?auto=format&fit=crop&w=800&q=80",
      youtubeId: "inpok4MKVLM", // Morning Calm Meditation
      duration: "10 mins",
      views: "1.2M views",
    ),
    ExerciseVideo(
      title: "Evening Stress Relief Meditation",
      category: "Meditation",
      section: "Guided Meditation",
      thumbnail: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=80",
      youtubeId: "O-6f5wQXSu8", // Evening Stress Relief
      duration: "15 mins",
      views: "8.2M views",
    ),
    ExerciseVideo(
      title: "Beginner Yoga Flow",
      category: "Yoga",
      section: "Yoga for Beginners",
      thumbnail: "https://images.unsplash.com/photo-1518611012118-696072aa579a?auto=format&fit=crop&w=800&q=80",
      youtubeId: "v7AYKMP6rOE", // Yoga for Beginners
      duration: "12 mins",
      views: "4.5M views",
    ),
    ExerciseVideo(
      title: "Post-Work Yoga Stretch",
      category: "Yoga",
      section: "Yoga for Beginners",
      thumbnail: "https://images.unsplash.com/photo-1599447421416-3414500d18a5?auto=format&fit=crop&w=800&q=80",
      youtubeId: "g_tea8ZNtKA", // Post Workout Stretch
      duration: "14 mins",
      views: "2.1M views",
    ),
    ExerciseVideo(
      title: "Full Body Stretch Routine",
      category: "Stretching",
      section: "Stretching",
      thumbnail: "https://images.unsplash.com/photo-1552196563-55cd4e45efb3?auto=format&fit=crop&w=800&q=80",
      youtubeId: "mX2RRHhOYqE", // Full Body Stretch
      duration: "20 mins",
      views: "15.3M views",
    ),
  ];

  /// FILTER
  List<ExerciseVideo> get filteredVideos {
    if (selectedCategory == "All") return videos;
    return videos.where((v) => v.category == selectedCategory).toList();
  }

  /// GROUP BY SECTION
  Map<String, List<ExerciseVideo>> groupedVideos() {
    Map<String, List<ExerciseVideo>> map = {};
    for (var v in filteredVideos) {
      map.putIfAbsent(v.section, () => []);
      map[v.section]!.add(v);
    }
    return map;
  }

  // ── Open YouTube in external browser ──
  Future<void> _openYouTube(String videoId) async {
    final uri = Uri.parse('https://www.youtube.com/watch?v=$videoId');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(uri);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Could not open YouTube. Check your browser settings."),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final grouped = groupedVideos();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Video Library"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// CATEGORY FILTER
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (_, i) {
                final cat = categories[i];
                final selected = selectedCategory == cat;

                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () => setState(() => selectedCategory = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selected ? Colors.green : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected ? Colors.green : Colors.grey.shade300,
                        ),
                        boxShadow: selected
                            ? [BoxShadow(color: Colors.green.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))]
                            : null,
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: selected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          /// SECTIONS
          ...grouped.entries.map(
            (entry) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 12),
                Column(
                  children: entry.value
                      .map((video) => Padding(
                            padding: const EdgeInsets.only(bottom: 18),
                            child: VideoCard(video: video, onPlay: () => _openYouTube(video.youtubeId)),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// =======================================================
/// VIDEO CARD (List Item)
/// =======================================================
class VideoCard extends StatelessWidget {
  final ExerciseVideo video;
  final VoidCallback onPlay;

  const VideoCard({super.key, required this.video, required this.onPlay});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPlay,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 6)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail Section
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(
                    video.thumbnail,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                  ),
                  // Dark overlay for better visibility
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.05),
                          Colors.black.withOpacity(0.35),
                        ],
                      ),
                    ),
                  ),
                  // YouTube Red Play Icon
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.redAccent.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 5))
                      ],
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                  // Duration Badge (Bottom Left)
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        video.duration,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ),
                  // HD Badge (Top Right)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.hd_rounded, color: Colors.white, size: 14),
                          SizedBox(width: 3),
                          Text("HD", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Content Footer Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        video.views,
                        style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.circle, size: 4, color: Colors.grey.shade400),
                      const SizedBox(width: 8),
                      Icon(Icons.open_in_new_rounded, size: 14, color: Colors.grey.shade400),
                      const SizedBox(width: 4),
                      Text(
                        "YouTube",
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Start Session Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: onPlay,
                      icon: const Icon(Icons.play_arrow_rounded, size: 20, color: Colors.white),
                      label: const Text("Watch on YouTube", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}