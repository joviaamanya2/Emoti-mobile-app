import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

/// =======================================================
/// MODEL
/// =======================================================
class ExerciseVideo {
  final String title;
  final String category;
  final String section;
  final String thumbnail;
  final String videoUrl;
  final String duration;
  final String views;

  ExerciseVideo({
    required this.title,
    required this.category,
    required this.section,
    required this.thumbnail,
    required this.videoUrl,
    required this.duration,
    required this.views,
  });
}

/// Global controller to ensure only one video plays at a time across the app
VideoPlayerController? globalActiveVideoController;

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
      thumbnail: "https://images.unsplash.com/photo-1506126613408-eca07ce68773",
      videoUrl:
          "https://cdn.coverr.co/videos/coverr-meditating-woman-3296/1080p.mp4",
      duration: "10 mins",
      views: "1.2k views",
    ),
    ExerciseVideo(
      title: "Evening Stress Relief Meditation",
      category: "Meditation",
      section: "Guided Meditation",
      thumbnail: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e",
      videoUrl:
          "https://cdn.coverr.co/videos/coverr-woman-relaxing-and-breathing-1571/1080p.mp4",
      duration: "15 mins",
      views: "8.2k views",
    ),
    ExerciseVideo(
      title: "Beginner Yoga Flow",
      category: "Yoga",
      section: "Yoga for Beginners",
      thumbnail: "https://images.unsplash.com/photo-1518611012118-696072aa579a",
      videoUrl:
          "https://cdn.coverr.co/videos/coverr-young-woman-doing-yoga-poses-5176/1080p.mp4",
      duration: "12 mins",
      views: "4.5k views",
    ),
    ExerciseVideo(
      title: "Post-Work Yoga Stretch",
      category: "Yoga",
      section: "Yoga for Beginners",
      thumbnail: "https://images.unsplash.com/photo-1599447421416-3414500d18a5",
      videoUrl:
          "https://cdn.coverr.co/videos/coverr-woman-practicing-yoga-1560/1080p.mp4",
      duration: "14 mins",
      views: "2.1k views",
    ),
    ExerciseVideo(
      title: "Full Body Stretch Routine",
      category: "Stretching",
      section: "Stretching",
      thumbnail: "https://images.unsplash.com/photo-1552196563-55cd4e45efb3",
      videoUrl:
          "https://cdn.coverr.co/videos/coverr-athlete-stretching-before-training-9892/1080p.mp4",
      duration: "20 mins",
      views: "15.3k views",
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

  @override
  void dispose() {
    // Clean up global controller when leaving screen
    globalActiveVideoController?.dispose();
    globalActiveVideoController = null;
    super.dispose();
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
          /// CATEGORY FILTER (Intact)
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
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selected ? Colors.green : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: selected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          /// SECTIONS
          ...grouped.entries.map(
            (entry) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.key,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Column(
                  children: entry.value
                      .map((video) => Padding(
                            padding: const EdgeInsets.only(bottom: 18),
                            child: VideoCard(video: video),
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

  const VideoCard({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to Full Screen Player
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullScreenVideoPlayer(video: video),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  video.thumbnail,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
                // Dark overlay for better text visibility
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.1),
                        Colors.black.withOpacity(0.3),
                      ],
                    ),
                  ),
                ),
                // Play Icon
                const Icon(
                  Icons.play_circle_outline,
                  size: 60,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  "${video.views} • ${video.duration}",
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                       // Navigate to Full Screen Player
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenVideoPlayer(video: video),
                        ),
                      );
                    },
                    icon: const Icon(Icons.play_arrow, size: 18),
                    label: const Text("Start Session"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green,
                      side: const BorderSide(color: Colors.green),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
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
/// FULL SCREEN VIDEO PLAYER WITH CONTROLS
/// =======================================================
class FullScreenVideoPlayer extends StatefulWidget {
  final ExerciseVideo video;
  const FullScreenVideoPlayer({super.key, required this.video});

  @override
  State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _showControls = true;
  Timer? _hideControlsTimer;

  @override
  void initState() {
    super.initState();
    _initializeAndPlay();
  }

  Future<void> _initializeAndPlay() async {
    // Pause any other playing video globally
    if (globalActiveVideoController != null) {
      await globalActiveVideoController!.pause();
    }

    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.video.videoUrl));

    try {
      await _controller.initialize();
      globalActiveVideoController = _controller;

      setState(() {
        _isInitialized = true;
      });

      _controller.play();
      _startHideControlsTimer();

      _controller.addListener(() {
        if (_controller.value.position == _controller.value.duration) {
          setState(() {}); // Update UI on completion
        }
      });
    } catch (e) {
      print("Error loading video: $e");
    }
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
        _startHideControlsTimer();
      }
      _showControls = true;
    });
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _controller.value.isPlaying) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _controller.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            _controller.pause();
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.video.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: _isInitialized
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    _showControls = !_showControls;
                    if (_showControls) _startHideControlsTimer();
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                    // Controls Overlay
                    AnimatedOpacity(
                      opacity: _showControls ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        color: Colors.black26,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Center Play/Pause Icon
                            IconButton(
                              iconSize: 64,
                              icon: Icon(
                                _controller.value.isPlaying
                                    ? Icons.pause_circle_filled
                                    : Icons.play_circle_filled,
                                color: Colors.white,
                              ),
                              onPressed: _togglePlayPause,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Bottom Progress Bar
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: AnimatedOpacity(
                        opacity: _showControls ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          color: Colors.black54,
                          child: Column(
                            children: [
                              VideoProgressIndicator(
                                _controller,
                                allowScrubbing: true,
                                colors: const VideoProgressColors(
                                  playedColor: Colors.green,
                                  bufferedColor: Colors.grey,
                                  backgroundColor: Colors.white24,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _formatDuration(_controller.value.position),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  Text(
                                    _formatDuration(_controller.value.duration),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : const CircularProgressIndicator(color: Colors.green),
      ),
    );
  }
}