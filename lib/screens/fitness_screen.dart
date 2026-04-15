import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

/// ================= EXERCISE MODEL =================
class Exercise {
  final String title;
  final String category;
  final String image;
  final String videoUrl;
  final String duration;

  Exercise({
    required this.title,
    required this.category,
    required this.image,
    required this.videoUrl,
    required this.duration,
  });
}

/// Global controller to ensure only one video plays at a time
VideoPlayerController? globalActiveController;

/// ================= FITNESS SCREEN =================
class FitnessScreen extends StatefulWidget {
  const FitnessScreen({super.key});

  @override
  State<FitnessScreen> createState() => _FitnessScreenState();
}

class _FitnessScreenState extends State<FitnessScreen> {
  String selectedCategory = "All";

  final List<String> categories = ["All", "Breathing", "Walking", "Yoga"];

  final List<Exercise> exercises = [
    Exercise(
      title: "Morning Stretch",
      category: "Walking",
      image: "https://images.unsplash.com/photo-1552196563-55cd4e45efb3",
      videoUrl:
          "https://cdn.coverr.co/videos/coverr-athlete-stretching-before-training-9892/1080p.mp4",
      duration: "10 min",
    ),
    Exercise(
      title: "10 min Walk",
      category: "Walking",
      image: "https://images.unsplash.com/photo-1506744038136-46273834b3fb",
      videoUrl:
          "https://cdn.coverr.co/videos/coverr-walking-on-nature-trail-3003/1080p.mp4",
      duration: "10 min",
    ),
    Exercise(
      title: "Yoga for Anxiety",
      category: "Yoga",
      image: "https://images.unsplash.com/photo-1552196563-55cd4e45efb3",
      videoUrl:
          "https://cdn.coverr.co/videos/coverr-young-woman-doing-yoga-poses-5176/1080p.mp4",
      duration: "15 min",
    ),
    Exercise(
      title: "Box Breathing",
      category: "Breathing",
      image: "https://images.unsplash.com/photo-1506126613408-eca07ce68773",
      videoUrl:
          "https://cdn.coverr.co/videos/coverr-woman-relaxing-and-breathing-1571/1080p.mp4",
      duration: "5 min",
    ),
  ];

  List<Exercise> get filteredExercises {
    if (selectedCategory == "All") return exercises;
    return exercises.where((e) => e.category == selectedCategory).toList();
  }

  @override
  void dispose() {
    // Clean up global controller when leaving the screen completely
    globalActiveController?.dispose();
    globalActiveController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Exercise Library",
          style: TextStyle(color: Colors.black),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.more_vert, color: Colors.black),
          )
        ],
      ),
      body: Column(
        children: [
          /// CATEGORY FILTER (Intact)
          SizedBox(
            height: 50,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = selectedCategory == cat;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = cat;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.green : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      cat,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          /// EXERCISE LIST
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredExercises.length,
              itemBuilder: (context, index) {
                final exercise = filteredExercises[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ExerciseCard(exercise: exercise),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= EXERCISE CARD (List Item) =================
class ExerciseCard extends StatelessWidget {
  final Exercise exercise;

  const ExerciseCard({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Open the full screen video player when tapping the card
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullScreenVideoPlayer(exercise: exercise),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[100],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(
                    exercise.image,
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    color: Colors.black26,
                    height: 180,
                  ),
                  const Icon(
                    Icons.play_circle_outline,
                    size: 60,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(exercise.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(exercise.duration,
                      style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                         // Open the full screen video player when clicking button
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullScreenVideoPlayer(exercise: exercise),
                          ),
                        );
                      },
                      child: const Text("Start Session"),
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

/// ================= FULL SCREEN VIDEO PLAYER =================
/// This screen handles the actual video playback with controls
class FullScreenVideoPlayer extends StatefulWidget {
  final Exercise exercise;
  const FullScreenVideoPlayer({super.key, required this.exercise});

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
    // Stop any other playing video globally
    if (globalActiveController != null) {
      await globalActiveController!.pause();
    }

    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.exercise.videoUrl));
    
    try {
      await _controller.initialize();
      // Set global controller
      globalActiveController = _controller;
      
      setState(() {
        _isInitialized = true;
      });
      
      // Auto play
      _controller.play();
      _startHideControlsTimer();
      
      // Listen to video completion to reset controller
      _controller.addListener(() {
        if (_controller.value.position == _controller.value.duration) {
           setState(() {}); // Update UI if needed (e.g. show replay icon)
        }
      });
    } catch (e) {
      print("Error initializing video: $e");
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

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    // We don't dispose the controller here if we want to keep state or allow minimizing
    // But for this specific simple flow, we pause it.
    _controller.pause();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
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
          widget.exercise.title,
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
                    // Custom Controls Overlay
                    AnimatedOpacity(
                      opacity: _showControls ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        color: Colors.black26,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Play/Pause Big Button
                            IconButton(
                              iconSize: 64,
                              icon: Icon(
                                _controller.value.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
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
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          color: Colors.black54,
                          child: Column(
                            children: [
                              // Progress Bar
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _formatDuration(_controller.value.position),
                                    style: const TextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                  Text(
                                    _formatDuration(_controller.value.duration),
                                    style: const TextStyle(color: Colors.white, fontSize: 12),
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