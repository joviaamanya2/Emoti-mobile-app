import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ================= EXERCISE MODEL =================
class Exercise {
  final String title;
  final String category;
  final String image;
  final String youtubeId;
  final String duration;
  final String calories;

  Exercise({
    required this.title,
    required this.category,
    required this.image,
    required this.youtubeId,
    required this.duration,
    this.calories = "",
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

  // Green palette
  final Color kPrimaryGreen = const Color(0xFF2E7D32);
  final Color kLightGreen = const Color(0xFFE8F5E9);
  final Color kAccentGreen = const Color(0xFF66BB6A);
  final Color kDarkGreen = const Color(0xFF1B5E20);
  final Color kMintGreen = const Color(0xFFC8E6C9);
  final Color kBgGreen = const Color(0xFFF1F8E9);

  final List<String> categories = ["All", "Walking", "Yoga", "Cardio", "Strength"];

  final List<Exercise> exercises = [
    Exercise(
      title: "10 Min Morning Stretch",
      category: "Walking",
      image: "https://images.unsplash.com/photo-1552196563-55cd4e45efb3?auto=format&fit=crop&w=800&q=80",
      youtubeId: "g_tea8ZNtKA",
      duration: "10 min",
      calories: "~50 kcal",
    ),
    Exercise(
      title: "15 Min Power Walk at Home",
      category: "Walking",
      image: "https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?auto=format&fit=crop&w=800&q=80",
      youtubeId: "ml6cT4AZdqI",
      duration: "15 min",
      calories: "~120 kcal",
    ),
    Exercise(
      title: "Yoga for Beginners",
      category: "Yoga",
      image: "https://images.unsplash.com/photo-1545205597-3d9d02c29597?auto=format&fit=crop&w=800&q=80",
      youtubeId: "v7AYKMP6rOE",
      duration: "20 min",
      calories: "~80 kcal",
    ),
    Exercise(
      title: "Full Body Stretch Routine",
      category: "Yoga",
      image: "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?auto=format&fit=crop&w=800&q=80",
      youtubeId: "mX2RRHhOYqE",
      duration: "25 min",
      calories: "~90 kcal",
    ),
    Exercise(
      title: "20 Min Full Body HIIT",
      category: "Cardio",
      image: "https://images.unsplash.com/photo-1601422407692-ec4eeec1d9b3?auto=format&fit=crop&w=800&q=80",
      youtubeId: "CJ_eHqVcwfI",
      duration: "20 min",
      calories: "~250 kcal",
    ),
    Exercise(
      title: "15 Min Beginner Strength",
      category: "Strength",
      image: "https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?auto=format&fit=crop&w=800&q=80",
      youtubeId: "UBMk30rjy0o",
      duration: "15 min",
      calories: "~180 kcal",
    ),
  ];

  List<Exercise> get filteredExercises {
    if (selectedCategory == "All") return exercises;
    return exercises.where((e) => e.category == selectedCategory).toList();
  }

  Future<void> _openYouTube(String videoId) async {
    // Try YouTube app first, fallback to browser
    final appUri = Uri.parse('youtube://watch?v=$videoId');
    final webUri = Uri.parse('https://www.youtube.com/watch?v=$videoId');

    try {
      // Try launching in YouTube app
      if (await canLaunchUrl(appUri)) {
        await launchUrl(appUri, mode: LaunchMode.externalApplication);
      } else {
        // Fallback to browser
        if (await canLaunchUrl(webUri)) {
          await launchUrl(webUri, mode: LaunchMode.externalApplication);
        } else {
          await launchUrl(webUri);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Could not open video. Try again or check your browser."),
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
      backgroundColor: kBgGreen,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            color: kLightGreen,
            shape: BoxShape.circle,
            border: Border.all(color: kMintGreen),
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: kDarkGreen, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          "Fitness Library",
          style: TextStyle(color: kDarkGreen, fontWeight: FontWeight.w900, fontSize: 22),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(color: kMintGreen, height: 1),
        ),
      ),
      body: Column(
        children: [
          // HEADER SUMMARY
          Container(
            margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [kPrimaryGreen, kAccentGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: kPrimaryGreen.withOpacity(0.25), blurRadius: 16, offset: const Offset(0, 6)),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.fitness_center_rounded, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Move Your Body",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 17)),
                      const SizedBox(height: 3),
                      Text("${filteredExercises.length} workouts available",
                          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Text("💪", style: TextStyle(fontSize: 22)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // CATEGORY FILTER
          SizedBox(
            height: 44,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () => setState(() => selectedCategory = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: isSelected ? kPrimaryGreen : Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: isSelected ? kPrimaryGreen : kMintGreen,
                          width: isSelected ? 0 : 1.5,
                        ),
                        boxShadow: isSelected
                            ? [BoxShadow(color: kPrimaryGreen.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (cat != "All") ...[
                            Icon(_getCategoryIcon(cat),
                                size: 16, color: isSelected ? Colors.white : kPrimaryGreen),
                            const SizedBox(width: 6),
                          ],
                          Text(
                            cat,
                            style: TextStyle(
                              color: isSelected ? Colors.white : kDarkGreen,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                        ],
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

  IconData _getCategoryIcon(String cat) {
    switch (cat) {
      case "Walking":
        return Icons.directions_walk_rounded;
      case "Yoga":
        return Icons.self_improvement_rounded;
      case "Cardio":
        return Icons.favorite_rounded;
      case "Strength":
        return Icons.fitness_center_rounded;
      default:
        return Icons.circle;
    }
  }

  // ================= EXERCISE CARD =================
  Widget _buildExerciseCard(BuildContext context, Exercise exercise) {
    return GestureDetector(
      onTap: () => _openYouTube(exercise.youtubeId),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(color: kDarkGreen.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 6)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                  child: Image.network(
                    exercise.image,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: kLightGreen,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(_getCategoryIcon(exercise.category), size: 48, color: kPrimaryGreen),
                          const SizedBox(height: 8),
                          Text(exercise.category, style: TextStyle(color: kPrimaryGreen, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                ),
                // Dark gradient overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                ),
                // Duration Badge (Top Left)
                Positioned(
                  top: 14,
                  left: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.access_time_rounded, color: Colors.white, size: 13),
                        const SizedBox(width: 4),
                        Text(
                          exercise.duration,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                // Category Badge (Top Right)
                Positioned(
                  top: 14,
                  right: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: kPrimaryGreen.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_getCategoryIcon(exercise.category), color: Colors.white, size: 13),
                        const SizedBox(width: 4),
                        Text(
                          exercise.category,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
                // Play Button
                Positioned.fill(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.redAccent.withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 6)),
                        ],
                      ),
                      child: const Icon(Icons.play_arrow, color: Colors.white, size: 32),
                    ),
                  ),
                ),
              ],
            ),

            // Content Footer
            Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exercise.title,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: kDarkGreen,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            if (exercise.calories.isNotEmpty) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: kLightGreen,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.local_fire_department_rounded, size: 13, color: kPrimaryGreen),
                                    const SizedBox(width: 4),
                                    Text(
                                      exercise.calories,
                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: kDarkGreen),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                            Icon(Icons.open_in_new_rounded, size: 13, color: Colors.grey.shade400),
                            const SizedBox(width: 4),
                            Text(
                              "YouTube",
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade400),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: kLightGreen,
                      shape: BoxShape.circle,
                      border: Border.all(color: kMintGreen),
                    ),
                    child: Icon(Icons.chevron_right_rounded, color: kPrimaryGreen, size: 24),
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