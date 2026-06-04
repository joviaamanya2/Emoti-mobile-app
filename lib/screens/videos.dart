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
/// MOOD → CATEGORY MAPPING
/// =======================================================
const Map<String, List<String>> moodCategoryMap = {
  "Happy": ["Funny", "Encouraging"],
  "Calm": ["Meditation", "Yoga", "Relaxing"],
  "Sad": ["Encouraging", "Motivational"],
  "Stressed": ["Meditation", "Stretching", "Relaxing"],
  "Motivated": ["Motivational", "Yoga"],
  "Bored": ["Funny", "Stretching"],
  "Anxious": ["Meditation", "Relaxing"],
  "Angry": ["Stretching", "Relaxing"],
};

/// =======================================================
/// MAIN SCREEN
/// =======================================================
class VideosScreen extends StatefulWidget {
  /// Mood captured from emotion_screen.dart
  final String? mood;

  const VideosScreen({super.key, this.mood});

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  String selectedCategory = "All";
  String? activeMood;

  final List<String> categories = [
    "All",
    "Meditation",
    "Yoga",
    "Stretching",
    "Funny",
    "Encouraging",
    "Motivational",
    "Relaxing",
  ];

  final List<ExerciseVideo> videos = [
    // Meditation
    ExerciseVideo(
      title: "Morning Calm Meditation",
      category: "Meditation",
      section: "Guided Meditation",
      thumbnail: "https://images.unsplash.com/photo-1506126613408-eca07ce68773?auto=format&fit=crop&w=800&q=80",
      youtubeId: "inpok4MKVLM",
      duration: "10 mins",
      views: "1.2M views",
    ),
    ExerciseVideo(
      title: "Evening Stress Relief Meditation",
      category: "Meditation",
      section: "Guided Meditation",
      thumbnail: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=80",
      youtubeId: "O-6f5wQXSu8",
      duration: "15 mins",
      views: "8.2M views",
    ),
    ExerciseVideo(
      title: "5-Minute Breathing Exercise",
      category: "Meditation",
      section: "Quick Relief",
      thumbnail: "https://images.unsplash.com/photo-1545389336-cf090694435e?auto=format&fit=crop&w=800&q=80",
      youtubeId: "ZToiY1aUgBk",
      duration: "5 mins",
      views: "3.4M views",
    ),

    // Yoga
    ExerciseVideo(
      title: "Beginner Yoga Flow",
      category: "Yoga",
      section: "Yoga for Beginners",
      thumbnail: "https://images.unsplash.com/photo-1518611012118-696072aa579a?auto=format&fit=crop&w=800&q=80",
      youtubeId: "v7AYKMP6rOE",
      duration: "12 mins",
      views: "4.5M views",
    ),
    ExerciseVideo(
      title: "Post-Work Yoga Stretch",
      category: "Yoga",
      section: "Yoga for Beginners",
      thumbnail: "https://images.unsplash.com/photo-1599447421416-3414500d18a5?auto=format&fit=crop&w=800&q=80",
      youtubeId: "g_tea8ZNtKA",
      duration: "14 mins",
      views: "2.1M views",
    ),
    ExerciseVideo(
      title: "Yoga for Better Sleep",
      category: "Yoga",
      section: "Bedtime Yoga",
      thumbnail: "https://images.unsplash.com/photo-1506126613408-eca07ce68773?auto=format&fit=crop&w=800&q=80",
      youtubeId: "L1M1H1o3jJk",
      duration: "20 mins",
      views: "5.7M views",
    ),

    // Stretching
    ExerciseVideo(
      title: "Full Body Stretch Routine",
      category: "Stretching",
      section: "Stretching",
      thumbnail: "https://images.unsplash.com/photo-1552196563-55cd4e45efb3?auto=format&fit=crop&w=800&q=80",
      youtubeId: "mX2RRHhOYqE",
      duration: "20 mins",
      views: "15.3M views",
    ),
    ExerciseVideo(
      title: "Desk Stretch Break",
      category: "Stretching",
      section: "Office Relief",
      thumbnail: "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?auto=format&fit=crop&w=800&q=80",
      youtubeId: "Nj2U6RMfhJg",
      duration: "7 mins",
      views: "2.8M views",
    ),

    // Funny
    ExerciseVideo(
      title: "Funniest Animal Moments",
      category: "Funny",
      section: "Laugh Out Loud",
      thumbnail: "https://images.unsplash.com/photo-1474511320723-9a56873571b7?auto=format&fit=crop&w=800&q=80",
      youtubeId: "nGeKSiCQkPw",
      duration: "12 mins",
      views: "45M views",
    ),
    ExerciseVideo(
      title: "Stand-Up Comedy Best Bits",
      category: "Funny",
      section: "Laugh Out Loud",
      thumbnail: "https://images.unsplash.com/photo-1585699324551-f6c309eedeca?auto=format&fit=crop&w=800&q=80",
      youtubeId: "HJU4dF__OYg",
      duration: "18 mins",
      views: "12M views",
    ),
    ExerciseVideo(
      title: "Kids Saying Hilarious Things",
      category: "Funny",
      section: "Feel-Good Comedy",
      thumbnail: "https://images.unsplash.com/photo-1503919545889-aef636e10ad4?auto=format&fit=crop&w=800&q=80",
      youtubeId: "Rt1MdN2iMUA",
      duration: "10 mins",
      views: "28M views",
    ),
    ExerciseVideo(
      title: "Try Not To Laugh Challenge",
      category: "Funny",
      section: "Feel-Good Comedy",
      thumbnail: "https://images.unsplash.com/photo-1527224857830-43a7acc85260?auto=format&fit=crop&w=800&q=80",
      youtubeId: "BqJUxQnWDTg",
      duration: "15 mins",
      views: "52M views",
    ),

    // Encouraging
    ExerciseVideo(
      title: "You Are Stronger Than You Think",
      category: "Encouraging",
      section: "Uplifting Talks",
      thumbnail: "https://images.unsplash.com/photo-1499209974431-9dddcece7f88?auto=format&fit=crop&w=800&q=80",
      youtubeId: "ZXsQAXx_ao0",
      duration: "8 mins",
      views: "9.1M views",
    ),
    ExerciseVideo(
      title: "Never Give Up - Inspirational Stories",
      category: "Encouraging",
      section: "Uplifting Talks",
      thumbnail: "https://images.unsplash.com/photo-1522202176988-66273c2fd55f?auto=format&fit=crop&w=800&q=80",
      youtubeId: "ZXsQAXx_ao0",
      duration: "14 mins",
      views: "6.3M views",
    ),
    ExerciseVideo(
      title: "How to Believe in Yourself",
      category: "Encouraging",
      section: "Self-Worth",
      thumbnail: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=800&q=80",
      youtubeId: "ZXsQAXx_ao0",
      duration: "11 mins",
      views: "4.7M views",
    ),

    // Motivational
    ExerciseVideo(
      title: "Wake Up With Purpose",
      category: "Motivational",
      section: "Daily Motivation",
      thumbnail: "https://images.unsplash.com/photo-1497633762265-9d179a990aa6?auto=format&fit=crop&w=800&q=80",
      youtubeId: "ZXsQAXx_ao0",
      duration: "6 mins",
      views: "18M views",
    ),
    ExerciseVideo(
      title: "The Power of Discipline",
      category: "Motivational",
      section: "Daily Motivation",
      thumbnail: "https://images.unsplash.com/photo-1517836357463-d25dfeac3438?auto=format&fit=crop&w=800&q=80",
      youtubeId: "ZXsQAXx_ao0",
      duration: "13 mins",
      views: "11M views",
    ),
    ExerciseVideo(
      title: "Overcoming Failure - Real Stories",
      category: "Motivational",
      section: "Real Stories",
      thumbnail: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=800&q=80",
      youtubeId: "ZXsQAXx_ao0",
      duration: "16 mins",
      views: "7.8M views",
    ),

    // Relaxing
    ExerciseVideo(
      title: "Rain Sounds for Deep Sleep",
      category: "Relaxing",
      section: "Ambient Sounds",
      thumbnail: "https://images.unsplash.com/photo-1515694346937-94d85e41e6f0?auto=format&fit=crop&w=800&q=80",
      youtubeId: "wJQDeQcjKgI",
      duration: "3 hrs",
      views: "92M views",
    ),
    ExerciseVideo(
      title: "Lo-Fi Beats to Relax To",
      category: "Relaxing",
      section: "Music & Vibes",
      thumbnail: "https://images.unsplash.com/photo-1511379938547-c1f69419868d?auto=format&fit=crop&w=800&q=80",
      youtubeId: "jfKfPfyJRdk",
      duration: "2 hrs",
      views: "120M views",
    ),
    ExerciseVideo(
      title: "Nature Scenes with Calm Music",
      category: "Relaxing",
      section: "Music & Vibes",
      thumbnail: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?auto=format&fit=crop&w=800&q=80",
      youtubeId: "wJQDeQcjKgI",
      duration: "1 hr",
      views: "34M views",
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Apply mood from emotion_screen.dart if provided
    if (widget.mood != null && moodCategoryMap.containsKey(widget.mood)) {
      activeMood = widget.mood;
      selectedCategory = moodCategoryMap[widget.mood!]!.first;
    }
  }

  /// CATEGORY COLOR MAP
  Color getCategoryColor(String cat) {
    switch (cat) {
      case "Meditation":
        return const Color.fromARGB(255, 77, 255, 101);
      case "Yoga":
        return const Color(0xFF00BFA5);
      case "Stretching":
        return const Color(0xFFFF6D00);
      case "Funny":
        return const Color(0xFFFFD600);
      case "Encouraging":
        return const Color(0xFF2979FF);
      case "Motivational":
        return const Color(0xFFD500F9);
      case "Relaxing":
        return const Color(0xFF26A69A);
      default:
        return const Color(0xFF424242);
    }
  }

  /// CATEGORY ICON MAP
  IconData getCategoryIcon(String cat) {
    switch (cat) {
      case "Meditation":
        return Icons.self_improvement_rounded;
      case "Yoga":
        return Icons.spa_rounded;
      case "Stretching":
        return Icons.accessibility_new_rounded;
      case "Funny":
        return Icons.emoji_emotions_rounded;
      case "Encouraging":
        return Icons.favorite_rounded;
      case "Motivational":
        return Icons.bolt_rounded;
      case "Relaxing":
        return Icons.nights_stay_rounded;
      default:
        return Icons.video_library_rounded;
    }
  }

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

  /// VIDEOS COUNT FOR CURRENT MOOD
  int get videoCountForMood {
    if (activeMood == null) return 0;
    final suggested = moodCategoryMap[activeMood] ?? [];
    return videos.where((v) => suggested.contains(v.category)).length;
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
          /// MOOD BANNER (from emotion_screen.dart)
          if (activeMood != null) ...[
            _buildMoodBanner(),
            const SizedBox(height: 20),
          ],

          /// CATEGORY DROPDOWN
          _buildCategoryDropdown(),
          const SizedBox(height: 24),

          /// RESULTS COUNT
          Row(
            children: [
              Text(
                "${filteredVideos.length} video${filteredVideos.length != 1 ? 's' : ''}",
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              if (selectedCategory != "All")
                GestureDetector(
                  onTap: () => setState(() {
                    selectedCategory = "All";
                    activeMood = null;
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.close_rounded, size: 14, color: Colors.red.shade400),
                        const SizedBox(width: 4),
                        Text("Clear filter", style: TextStyle(fontSize: 12, color: Colors.red.shade400, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          /// SECTIONS
          if (filteredVideos.isEmpty)
            _buildEmptyState()
          else
            ...grouped.entries.map(
              (entry) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 20,
                        decoration: BoxDecoration(
                          color: getCategoryColor(entry.value.first.category),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        entry.key,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "${entry.value.length}",
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children: entry.value
                        .map((video) => Padding(
                              padding: const EdgeInsets.only(bottom: 18),
                              child: VideoCard(
                                video: video,
                                onPlay: () => _openYouTube(video.youtubeId),
                                categoryColor: getCategoryColor(video.category),
                                categoryIcon: getCategoryIcon(video.category),
                              ),
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

  /// MOOD BANNER (shows mood passed from emotion_screen.dart)
  Widget _buildMoodBanner() {
    final suggested = moodCategoryMap[activeMood!] ?? [];
    final moodColor = _getMoodColor(activeMood!);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: moodColor.withOpacity(0.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: moodColor.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Icon(Icons.mood_rounded, color: moodColor, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Feeling ${activeMood!.toLowerCase()}?",
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.black87),
                ),
                const SizedBox(height: 2),
                Text(
                  "We recommend: ${suggested.join(' • ')} ($videoCountForMood videos)",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => setState(() {
              activeMood = null;
              selectedCategory = "All";
            }),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close_rounded, size: 16, color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }

  /// MOOD COLOR HELPER
  Color _getMoodColor(String mood) {
    switch (mood) {
      case "Happy":
        return const Color(0xFFFFC107);
      case "Calm":
        return const Color(0xFF66BB6A);
      case "Sad":
        return const Color(0xFF42A5F5);
      case "Stressed":
        return const Color(0xFFFF7043);
      case "Motivated":
        return const Color.fromARGB(255, 71, 188, 87);
      case "Bored":
        return const Color(0xFF9E9D24);
      case "Anxious":
        return const Color(0xFF5C6BC0);
      case "Angry":
        return const Color(0xFFE53935);
      default:
        return const Color(0xFF7C4DFF);
    }
  }

  /// CATEGORY DROPDOWN
  Widget _buildCategoryDropdown() {
    final color = getCategoryColor(selectedCategory);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: selectedCategory == "All" ? Colors.grey.shade300 : color.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCategory,
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down_rounded, color: selectedCategory == "All" ? Colors.grey : color),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
          items: categories.map((cat) {
            return DropdownMenuItem<String>(
              value: cat,
              child: Row(
                children: [
                  if (cat != "All") ...[
                    Icon(
                      getCategoryIcon(cat),
                      size: 20,
                      color: getCategoryColor(cat),
                    ),
                    const SizedBox(width: 10),
                  ] else ...[
                    const Icon(
                      Icons.apps_rounded,
                      size: 20,
                      color: Color(0xFF424242),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Text(cat),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                selectedCategory = value;
                // Clear mood if manually picking a category outside mood suggestions
                if (activeMood != null) {
                  final suggested = moodCategoryMap[activeMood!] ?? [];
                  if (!suggested.contains(value) && value != "All") {
                    activeMood = null;
                  }
                }
              });
            }
          },
        ),
      ),
    );
  }

  /// EMPTY STATE
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            Icon(Icons.video_library_rounded, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text("No videos found", style: TextStyle(fontSize: 16, color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text("Try selecting a different category", style: TextStyle(fontSize: 13, color: Colors.grey.shade400)),
          ],
        ),
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
  final Color categoryColor;
  final IconData categoryIcon;

  const VideoCard({
    super.key,
    required this.video,
    required this.onPlay,
    required this.categoryColor,
    required this.categoryIcon,
  });

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
                    errorBuilder: (_, __, ___) => Container(
                      height: 200,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.video_library_rounded, size: 50, color: Colors.grey),
                    ),
                  ),
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
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.redAccent.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 5))
                      ],
                    ),
                    child: const Icon(Icons.play_arrow, size: 32, color: Colors.white),
                  ),
                  // Duration Badge
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
                  // Category Badge (Top Left)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: categoryColor.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(categoryIcon, color: Colors.white, size: 13),
                          const SizedBox(width: 4),
                          Text(video.category, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                        ],
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