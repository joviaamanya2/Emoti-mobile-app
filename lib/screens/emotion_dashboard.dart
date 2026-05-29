import 'package:emoti_app/screens/auth_screen.dart';
import 'package:emoti_app/screens/home_screen.dart';
import 'package:emoti_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';
import '../services/database_service.dart';
import '../screens/recommendation_screen.dart';
import '../screens/library.dart';
import '../screens/settings.dart';
import 'inner_peace.dart';
import 'profile_screen.dart';

class HomeContent extends StatefulWidget {
  final String userName;
  final String gender;

  const HomeContent({super.key, this.userName = "User", this.gender = ""});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String get userName => widget.userName;
  String profileImage = "https://via.placeholder.com/150";
  bool isLoading = true;
  bool isMoodSending = false;
  bool isTestimonialsLoading = false;
  int selectedEmojiIndex = 0;
  int _currentIndex = 0;

  final Color kPrimaryGreen = const Color.fromARGB(255, 99, 235, 104);
  final Color kDarkGreen = const Color.fromARGB(255, 50, 190, 55);

  // ================= EMOJI DATA =================
  final List<String> emojiFaces = ["😊", "😟", "😔", "😢", "😕"];
  final List<String> emojiLabels = ["Great", "Stressed", "Lonely", "Sad", "Confused"];

  // ================= MOOD-SPECIFIC SESSION VIDEOS (YouTube) =================
  final List<Map<String, String>> sessionDetails = [
    {
      "title": "Energize Your Day",
      "desc": "Boost your positivity with this morning session.",
      "youtubeId": "inpok4MKVLM",
      "duration": "10 min",
    },
    {
      "title": "Anxiety Relief",
      "desc": "Calm your nerves and find your center.",
      "youtubeId": "7z9_VWRKzH0",
      "duration": "15 min",
    },
    {
      "title": "Self-Love & Connection",
      "desc": "Reconnect with yourself and find comfort.",
      "youtubeId": "i8MxI8MNcJk",
      "duration": "12 min",
    },
    {
      "title": "Comfort & Healing",
      "desc": "A gentle session to help you process sadness.",
      "youtubeId": "eKcGx_3f7vg",
      "duration": "20 min",
    },
    {
      "title": "Clarity & Focus",
      "desc": "Clear your mind and find direction.",
      "youtubeId": "4Kf7N0jENEQ",
      "duration": "8 min",
    },
  ];

  final List<String> moodImages = [
    'https://images.pexels.com/photos/34950/pexels-photo.jpg',
    'https://images.pexels.com/photos/355465/pexels-photo-355465.jpeg',
    'https://images.pexels.com/photos/167699/pexels-photo-167699.jpeg',
    'https://images.pexels.com/photos/414171/pexels-photo-414171.jpeg',
    'https://images.pexels.com/photos/158607/cairn-fog-mystical-background-158607.jpeg',
  ];

  // ================= TESTIMONIALS DATA =================
  // Default testimonials to use when API fails
  final List<Map<String, dynamic>> defaultTestimonials = [
    {
      "name": "Sarah M.",
      "avatar": "https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=100&q=80",
      "mood": "Stressed",
      "content": "The breathing exercises helped me calm down before my big presentation. I felt so much more centered!",
      "whatWorked": "Deep Breathing + Body Scan",
      "daysAgo": 2,
      "rating": 5,
    },
    {
      "name": "James K.",
      "avatar": "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=100&q=80",
      "mood": "Lonely",
      "content": "I started the self-love meditation series and it genuinely changed how I view alone time. I feel more connected to myself.",
      "whatWorked": "Self-Love Meditations",
      "daysAgo": 5,
      "rating": 5,
    },
    {
      "name": "Priya R.",
      "avatar": "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=100&q=80",
      "mood": "Great",
      "content": "Morning gratitude journaling has made me notice so many good things I was overlooking. My whole day feels brighter now.",
      "whatWorked": "Gratitude Journaling",
      "daysAgo": 1,
      "rating": 4,
    },
    {
      "name": "Michael T.",
      "avatar": "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=100&q=80",
      "mood": "Sad",
      "content": "When I was going through a tough time, the healing sessions helped me process my emotions without feeling overwhelmed.",
      "whatWorked": "Emotional Processing Sessions",
      "daysAgo": 7,
      "rating": 5,
    },
    {
      "name": "Emma L.",
      "avatar": "https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=100&q=80",
      "mood": "Confused",
      "content": "The clarity meditation helped me make a difficult career decision. I finally felt sure about my path forward.",
      "whatWorked": "Clarity & Decision Making",
      "daysAgo": 3,
      "rating": 4,
    },
  ];
  
  // This will hold testimonials fetched from API or defaults
  List<Map<String, dynamic>> testimonials = [];

  // ================= MOOD-SPECIFIC SUGGESTIONS =================
  final Map<String, List<Map<String, dynamic>>> moodSuggestions = {
    "Great": [
      {"title": "Keep the Momentum", "desc": "You're feeling great! Try a gratitude meditation to amplify this positive energy.", "icon": Icons.auto_awesome_rounded, "color": Color(0xFFFFD700)},
      {"title": "Share the Joy", "desc": "Reach out to someone you care about. Spreading positivity boosts your own mood.", "icon": "🙏", "color": Color(0xFF63EB68)},
      {"title": "Creative Expression", "desc": "Channel your good energy into something creative today.", "icon": Icons.palette_rounded, "color": Color(0xFF748FFC)},
    ],
    "Stressed": [
      {"title": "Emergency Calm Down", "desc": "Try the 4-7-8 breathing technique right now. It activates your relaxation response.", "icon": Icons.air_rounded, "color": Color(0xFF5C7CFA)},
      {"title": "Progressive Muscle Relaxation", "desc": "Release tension systematically from your toes to your head.", "icon": Icons.self_improvement_rounded, "color": Color(0xFF5CC6A9)},
      {"title": "Step Away", "desc": "Take a 5-minute walk. Movement helps process stress hormones.", "icon": Icons.directions_walk_rounded, "color": Color(0xFFFF922B)},
    ],
    "Lonely": [
      {"title": "Connection Meditation", "desc": "Focus on the connections you have, even if they're far away.", "icon": Icons.favorite_rounded, "color": Color(0xFFFF6B6B)},
      {"title": "Join a Community", "desc": "Consider joining a local group or online community that shares your interests.", "icon": Icons.groups_rounded, "color": Color(0xFF748FFC)},
      {"title": "Self-Date", "desc": "Do something kind for yourself today. You deserve your own company.", "icon": "☕", "color": Color(0xFFFF922B)},
    ],
    "Sad": [
      {"title": "Gentle Healing", "desc": "Allow yourself to feel. This guided session helps process sadness safely.", "icon": Icons.healing_rounded, "color": Color(0xFF5C7CFA)},
      {"title": "Reach Out", "desc": "You don't have to do this alone. Text or call someone you trust.", "icon": Icons.phone_rounded, "color": Color(0xFF5CC6A9)},
      {"title": "Comfort Routine", "desc": "Create a small comfort ritual: warm tea, soft music, gentle stretching.", "icon": Icons.spa_rounded, "color": Color(0xFFFFD700)},
    ],
    "Confused": [
      {"title": "Brain Dump", "desc": "Write down everything on your mind. Seeing it helps organize chaos.", "icon": Icons.edit_note_rounded, "color": Color(0xFF667EEA)},
      {"title": "Clarity Meditation", "desc": "This 8-minute session helps cut through mental fog.", "icon": Icons.lightbulb_rounded, "color": Color(0xFFFFD700)},
      {"title": "One Small Step", "desc": "Pick just ONE thing to focus on. Clarity comes from action.", "icon": Icons.arrow_forward_rounded, "color": Color(0xFF63EB68)},
    ],
  };

  @override
  void initState() {
    super.initState();
    _setProfileIcon();
    _loadTestimonials();
    isLoading = false;
  }

  void _setProfileIcon() {
    if (widget.gender == 'Male') {
      profileImage = 'https://cdn-icons-png.flaticon.com/512/4140/4140051.png';
    } else if (widget.gender == 'Female') {
      profileImage = 'https://cdn-icons-png.flaticon.com/512/4140/4140047.png';
    } else {
      profileImage = 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png';
    }
  }

  // Load testimonials from API or use defaults
  Future<void> _loadTestimonials() async {
    setState(() => isTestimonialsLoading = true);
    
    try {
      // Try to get testimonials from API
      final apiTestimonials = await ApiService().fetchTestimonials();


      
      if (apiTestimonials.isNotEmpty) {
        // Save to local storage for offline use
        await DatabaseService.saveTestimonialsLocally(apiTestimonials);
        setState(() {
          testimonials = apiTestimonials;
          isTestimonialsLoading = false;
        });
      } else {
        // Try to get from local storage
        final localTestimonials = await DatabaseService.getLocalTestimonials();
        
        if (localTestimonials.isNotEmpty) {
          setState(() {
            testimonials = localTestimonials;
            isTestimonialsLoading = false;
          });
        } else {
          // Use default testimonials
          setState(() {
            testimonials = defaultTestimonials;
            isTestimonialsLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error loading testimonials: $e');
      
      // Try to get from local storage as fallback
      final localTestimonials = await DatabaseService.getLocalTestimonials();
      
      if (localTestimonials.isNotEmpty) {
        setState(() {
          testimonials = localTestimonials;
          isTestimonialsLoading = false;
        });
      } else {
        // Use default testimonials
        setState(() {
          testimonials = defaultTestimonials;
          isTestimonialsLoading = false;
        });
      }
    }
  }

  // Load testimonials filtered by mood
  Future<void> _loadTestimonialsByMood(String mood) async {
    setState(() => isTestimonialsLoading = true);
    
    try {
      // Try to get testimonials from API with mood filter
      final apiTestimonials = await ApiService().fetchTestimonials(moodFilter: mood);
      
      if (apiTestimonials.isNotEmpty) {
        // Save to local storage for offline use
        await DatabaseService.saveTestimonialsLocally(apiTestimonials);
        setState(() {
          testimonials = apiTestimonials;
          isTestimonialsLoading = false;
        });
      } else {
        // If no mood-specific testimonials, load all testimonials
        await _loadTestimonials();
      }
    } catch (e) {
      print('Error loading testimonials by mood: $e');
      // Fall back to all testimonials
      await _loadTestimonials();
    }
  }

  Future<void> _sendMoodToBackend(String label, String emoji) async {
    setState(() => isMoodSending = true);
    
    try {
      // Try to send to API
final success = await ApiService().sendMood(label, emoji);
      
      if (success) {
        print("Mood Sent to API: $label ($emoji)");
        // Load testimonials for this mood
        await _loadTestimonialsByMood(label);
      } else {
        print("Failed to send mood to API, saving locally");
        // Save locally as backup
        await DatabaseService.saveMoodLocally(label, emoji);
        // Load testimonials from local storage
        await _loadTestimonials();
      }
    } catch (e) {
      print("Error sending mood: $e");
      // Save locally as backup
      await DatabaseService.saveMoodLocally(label, emoji);
      // Load testimonials from local storage
      await _loadTestimonials();
    } finally {
      setState(() => isMoodSending = false);
    }
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
            content: const Text("Could not open. Check your browser settings."),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  // ── Filter testimonials by current mood ──
  List<Map<String, dynamic>> get filteredTestimonials {
    if (testimonials.isEmpty) return [];
    
    final currentMood = emojiLabels[selectedEmojiIndex];
    // Prioritize testimonials matching current mood, then show others
    final matching = testimonials.where((t) => t['mood'] == currentMood).toList();
    final others = testimonials.where((t) => t['mood'] != currentMood).toList();
    return [...matching, ...others].take(4).toList();
  }

  List<Map<String, dynamic>> get currentSuggestions {
    return moodSuggestions[emojiLabels[selectedEmojiIndex]] ?? [];
  }

  void handleMoodSelection(int index) async {
    HapticFeedback.heavyImpact();
    setState(() {
      selectedEmojiIndex = index;
    });
    String label = emojiLabels[index];
    String icon = emojiFaces[index];
    await _sendMoodToBackend(label, icon);
  }

  void onTabTapped(int index) {
    setState(() => _currentIndex = index);
    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AuthScreen()));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (_) => const RecommendationsScreen()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (_) => const LibraryScreen()));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
        break;
    }
  }

  String _getTimeAgo(int daysAgo) {
    if (daysAgo == 0) return "Today";
    if (daysAgo == 1) return "Yesterday";
    return "$daysAgo days ago";
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      backgroundColor: const Color(0xFFF9F8F6),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
                      ),
                      child: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
                    child: Hero(
                      tag: 'profile',
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: kPrimaryGreen, width: 3),
                          boxShadow: [BoxShadow(color: kPrimaryGreen.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))],
                        ),
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: NetworkImage(profileImage),
                          onBackgroundImageError: (_, __) => setState(() => profileImage = "https://via.placeholder.com/150"),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      "Hello, $userName",
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.black87, letterSpacing: -0.5),
                    ),
                    const SizedBox(height: 20),

                    // ================= MOOD SELECTOR =================
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [BoxShadow(color: kPrimaryGreen.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 8))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('How are you feeling today?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black87)),
                          const SizedBox(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(emojiFaces.length, (index) {
                              bool isSelected = selectedEmojiIndex == index;
                              return GestureDetector(
                                onTap: () => handleMoodSelection(index),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: isSelected ? kPrimaryGreen.withOpacity(0.15) : Colors.grey[50],
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: isSelected ? kPrimaryGreen : Colors.transparent, width: 2),
                                    boxShadow: isSelected ? [BoxShadow(color: kPrimaryGreen.withOpacity(0.2), blurRadius: 8)] : [],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Transform.scale(
                                        scale: isSelected ? 1.2 : 1.0,
                                        child: Text(
                                          emojiFaces[index],
                                          style: const TextStyle(fontSize: 30, fontFamily: 'Segoe UI Emoji', height: 1.0),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        emojiLabels[index],
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: isSelected ? kDarkGreen : Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                          // Show loading indicator when sending mood
                          if (isMoodSending) ...[
                            const SizedBox(height: 16),
                            const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF63EB68)),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // ================= MOOD-SPECIFIC SESSION CARD (opens YouTube) =================
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: Container(
                        key: ValueKey<int>(selectedEmojiIndex),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), boxShadow: [BoxShadow(color: Colors.black.withOpacity(.08), blurRadius: 25)]),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Stack(
                            children: [
                              Image.network(
                                moodImages[selectedEmojiIndex],
                                height: 240,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(height: 240, color: Colors.grey[300], child: const Center(child: Icon(Icons.broken_image, size: 50))),
                              ),
                              Positioned.fill(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [Colors.black.withOpacity(0.1), Colors.black.withOpacity(0.65)],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 16,
                                right: 16,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.play_circle_filled, color: Colors.white, size: 16),
                                      const SizedBox(width: 4),
                                      Text(sessionDetails[selectedEmojiIndex]["duration"]!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: kPrimaryGreen,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.recommend_rounded, color: Colors.black87, size: 14),
                                            const SizedBox(width: 4),
                                            Text('For ${emojiLabels[selectedEmojiIndex]} Mood', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black87)),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(sessionDetails[selectedEmojiIndex]["title"]!, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white)),
                                      const SizedBox(height: 8),
                                      Text(sessionDetails[selectedEmojiIndex]["desc"]!, style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w500)),
                                      const SizedBox(height: 20),
                                      SizedBox(
                                        width: double.infinity,
                                        height: 54,
                                        child: ElevatedButton.icon(
                                          onPressed: () => _openYouTube(sessionDetails[selectedEmojiIndex]["youtubeId"]!),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.redAccent,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                          ),
                                          icon: const Icon(Icons.play_arrow_rounded, size: 24),
                                          label: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text('Watch on YouTube', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                                              const SizedBox(width: 8),
                                              Icon(Icons.open_in_new_rounded, size: 16, color: Colors.white.withOpacity(0.8)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),

                    // ================= PERSONALIZED SUGGESTIONS =================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Suggested for You', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22, color: Colors.black87)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(color: kPrimaryGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(emojiFaces[selectedEmojiIndex], style: const TextStyle(fontSize: 14)),
                              const SizedBox(width: 4),
                              Text(emojiLabels[selectedEmojiIndex], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: kDarkGreen)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...List.generate(
                      currentSuggestions.length,
                      (index) => _buildSuggestionCard(currentSuggestions[index]),
                    ),
                    const SizedBox(height: 35),

                    // ================= RECENT TESTIMONIALS =================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('What Worked for Others', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22, color: Colors.black87)),
                        TextButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RecommendationsScreen())),
                          child: Text("See All", style: TextStyle(color: kPrimaryGreen, fontWeight: FontWeight.w800, fontSize: 16)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text("Real stories from people who felt like you", style: TextStyle(fontSize: 14, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 20),
                    // Show loading indicator when fetching testimonials
                    if (isTestimonialsLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF63EB68)),
                          ),
                        ),
                      )
                    else if (filteredTestimonials.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            "No testimonials available yet",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                    else
                      SizedBox(
                        height: 230,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: filteredTestimonials.length,
                          itemBuilder: (context, index) {
                            final t = filteredTestimonials[index];
                            return _buildTestimonialCard(t);
                          },
                        ),
                      ),
                    const SizedBox(height: 30),

                    // ================= VIEW RECOMMENDATIONS BUTTON =================
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RecommendationsScreen(mood: emojiLabels[selectedEmojiIndex]))),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryGreen,
                          elevation: 5,
                          shadowColor: kPrimaryGreen.withOpacity(0.4),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        icon: const Icon(Icons.recommend, size: 24, color: Colors.black87),
                        label: const Text('View More Recommendations', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w800, fontSize: 18)),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        selectedItemColor: kPrimaryGreen,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 20,
        iconSize: 28,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.recommend_rounded), label: 'Recommend'),
          BottomNavigationBarItem(icon: Icon(Icons.library_books_rounded), label: 'Library'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: 'Settings'),
        ],
      ),
    );
  }

  // ================= SUGGESTION CARD WIDGET =================
  Widget _buildSuggestionCard(Map<String, dynamic> suggestion) {
    final icon = suggestion['icon'];
    final isEmoji = icon is String;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12)],
        border: Border.all(color: (suggestion['color'] as Color).withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: (suggestion['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: isEmoji
                ? Center(child: Text(icon, style: const TextStyle(fontSize: 24)))
                : Icon(icon as IconData, color: suggestion['color'] as Color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(suggestion['title'], style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Color(0xFF2C3E50))),
                const SizedBox(height: 4),
                Text(suggestion['desc'], style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey.shade500, height: 1.4)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: (suggestion['color'] as Color).withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(Icons.arrow_forward_rounded, color: suggestion['color'] as Color, size: 18),
          ),
        ],
      ),
    );
  }

  // ================= TESTIMONIAL CARD WIDGET =================
  Widget _buildTestimonialCard(Map<String, dynamic> testimonial) {
    final isMatchingMood = testimonial['mood'] == emojiLabels[selectedEmojiIndex];

    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: isMatchingMood ? Colors.white : Colors.grey[50],
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: isMatchingMood ? kPrimaryGreen.withOpacity(0.1) : Colors.black.withOpacity(0.03),
            blurRadius: isMatchingMood ? 20 : 12,
            offset: const Offset(0, 6),
          ),
        ],
        border: isMatchingMood ? Border.all(color: kPrimaryGreen.withOpacity(0.3), width: 1.5) : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Avatar + Name + Time
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: NetworkImage(testimonial['avatar']),
                  onBackgroundImageError: (_, __) => const Icon(Icons.person, color: Colors.grey),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(testimonial['name'], style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Color(0xFF2C3E50))),
                      Text(_getTimeAgo(testimonial['daysAgo']), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.grey.shade400)),
                    ],
                  ),
                ),
                // Star rating
                Row(
                  children: List.generate(5, (i) => Icon(
                    i < testimonial['rating'] ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 14,
                    color: i < testimonial['rating'] ? const Color(0xFFFFD700) : Colors.grey.shade300,
                  )),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Mood tag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _getMoodColor(testimonial['mood']).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _getMoodColor(testimonial['mood']).withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_getMoodEmoji(testimonial['mood']), style: const TextStyle(fontSize: 12)),
                  const SizedBox(width: 4),
                  Text('Felt ${testimonial['mood']}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _getMoodColor(testimonial['mood']))),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Content
            Expanded(
              child: Text(
                '"${testimonial['content']}"',
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Colors.grey[700],
                  height: 1.5,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 14),

            // What worked
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: kPrimaryGreen.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle_rounded, color: kPrimaryGreen, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      testimonial['whatWorked'],
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: kDarkGreen),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // "Helpful for you" indicator
            if (isMatchingMood) ...[
              const SizedBox(height: 10),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: kPrimaryGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.recommend_rounded, color: kDarkGreen, size: 12),
                      const SizedBox(width: 4),
                      Text('Relevant for you', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: kDarkGreen)),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getMoodColor(String mood) {
    switch (mood) {
      case "Great": return const Color(0xFF63EB68);
      case "Stressed": return const Color(0xFFFF922B);
      case "Lonely": return const Color(0xFF748FFC);
      case "Sad": return const Color(0xFF5C7CFA);
      case "Confused": return const Color(0xFF667EEA);
      default: return Colors.grey;
    }
  }

  String _getMoodEmoji(String mood) {
    switch (mood) {
      case "Great": return "😊";
      case "Stressed": return "😟";
      case "Lonely": return "😔";
      case "Sad": return "😢";
      case "Confused": return "😕";
      default: return "😐";
    }
  }
}