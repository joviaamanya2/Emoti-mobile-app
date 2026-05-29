import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ================= EXERCISE MODEL =================
class Exercise {
  final String title;
  final String category;
  final String image;
  final String youtubeId;
  final String duration;

  Exercise({
    required this.title,
    required this.category,
    required this.image,
    required this.youtubeId,
    required this.duration,
  });
}

// ================= FITNESS SCREEN =================
class FitnessScreen extends StatefulWidget {
  const FitnessScreen({super.key});

  @override
  State<FitnessScreen> createState() => _FitnessScreenState();
}

class _FitnessScreenState extends State<FitnessScreen> {
  String selectedCategory = "All";
  
  final Color kPrimaryGreen = const Color.fromARGB(255, 54, 218, 68);
  final Color kSoftOrange = const Color.fromARGB(255, 255, 232, 214);
  final Color kDeepGreen = const Color.fromARGB(255, 44, 209, 58);

  final List<String> categories = ["All", "Walking", "Yoga", "Cardio"];

  final List<Exercise> exercises = [
    Exercise(
      title: "Morning Stretch",
      category: "Walking",
      image: "https://images.unsplash.com/photo-1552196563-55cd4e45efb3?auto=format&fit=crop&w=800&q=80",
      youtubeId: "g_tea8ZNtKA", // 10 Min Morning Stretch
      duration: "10 min",
    ),
    Exercise(
      title: "Power Walk",
      category: "Walking",
      image: "https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?auto=format&fit=crop&w=800&q=80",
      youtubeId: "ml6cT4AZdqI", // 15 Min Power Walk at Home
      duration: "15 min",
    ),
    Exercise(
      title: "Yoga for Anxiety",
      category: "Yoga",
      image: "https://images.unsplash.com/photo-1545205597-3d9d02c29597?auto=format&fit=crop&w=800&q=80",
      youtubeId: "inpok4MKVLM", // Yoga for Anxiety and Stress
      duration: "20 min",
    ),
    Exercise(
      title: "Box Breathing",
      category: "Walking",
      image: "https://images.unsplash.com/photo-1544367563-12123d896889?auto=format&fit=crop&w=800&q=80",
      youtubeId: "FJJazKt3_4Q", // Box Breathing Technique
      duration: "10 min",
    ),
    Exercise(
      title: "HIIT Workout",
      category: "Cardio",
      image: "https://images.unsplash.com/photo-1601422407692-ec4eeec1d9b3?auto=format&fit=crop&w=800&q=80",
      youtubeId: "ml6cT4AZdqI", // 15 Min HIIT Cardio
      duration: "25 min",
    ),
  ];

  List<Exercise> get filteredExercises {
    if (selectedCategory == "All") return exercises;
    return exercises.where((e) => e.category == selectedCategory).toList();
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
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 22),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          "Fitness Library",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // CATEGORY FILTER
          SizedBox(
            height: 60,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = selectedCategory == cat;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = cat;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: isSelected ? kPrimaryGreen : Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: isSelected ? kPrimaryGreen : Colors.grey.shade200,
                        width: 1,
                      ),
                      boxShadow: isSelected
                          ? [BoxShadow(color: kPrimaryGreen.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))]
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      cat,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black54,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // EXERCISE LIST
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: filteredExercises.length,
              itemBuilder: (context, index) {
                final exercise = filteredExercises[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: _buildExerciseCard(context, exercise),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ================= EXERCISE CARD =================
  Widget _buildExerciseCard(BuildContext context, Exercise exercise) {
    return GestureDetector(
      onTap: () => _openYouTube(exercise.youtubeId),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 8))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  child: Image.network(
                    exercise.image,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                // Duration Badge
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.access_time, color: Colors.white, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          exercise.duration,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                // YouTube Quality Badge
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.hd_rounded, color: Colors.white, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          "HD",
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
                // YouTube Play Button Overlay
                Positioned.fill(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.redAccent.withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 6))
                        ],
                      ),
                      child: const Icon(Icons.play_arrow, color: Colors.white, size: 34),
                    ),
                  ),
                ),
              ],
            ),
            
            // Content Footer
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exercise.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: kSoftOrange,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                exercise.category.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: kDeepGreen,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Icon(Icons.open_in_new_rounded, size: 14, color: Colors.grey.shade400),
                            const SizedBox(width: 4),
                            Text(
                              "YouTube",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: kSoftOrange,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.chevron_right, color: kDeepGreen),
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