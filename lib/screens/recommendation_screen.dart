import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_drawing/path_drawing.dart';
import 'package:url_launcher/url_launcher.dart';

// IMPORT YOUR REAL SCREENS HERE
import 'boost_focus.dart';
import 'reduce_stress.dart';
import 'improve_sleep.dart';
import 'fitness_screen.dart';
import 'feel_happier.dart';
import 'healthy_habits.dart';
import '../screens/counselors_screen.dart';
import '../screens/settings.dart';
import 'inner_peace.dart';

// ================= CHART DATA MODELS =================
class MoodDataPoint {
  final String day;
  final double value;
  final String label;
  MoodDataPoint({required this.day, required this.value, required this.label});
}

class SessionStat {
  final String label;
  final int completed;
  final int total;
  final Color color;
  SessionStat({required this.label, required this.completed, required this.total, required this.color});
}

class SuggestionItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String tag;
  SuggestionItem({required this.title, required this.description, required this.icon, required this.color, required this.tag});
}

// ================= MOOD CATEGORIES FOR TESTIMONIALS =================
class MoodCategory {
  final String value;
  final String label;
  final String emoji;
  final Color color;
  final IconData icon;
  final String description;
  
  const MoodCategory({
    required this.value,
    required this.label,
    required this.emoji,
    required this.color,
    required this.icon,
    required this.description,
  });
}

const List<MoodCategory> kMoodCategories = [
  MoodCategory(value: 'stressed', label: 'Stressed', emoji: '😰', color: Color(0xFFFF6B6B), icon: Icons.warning_amber_rounded, description: 'Overwhelmed, tense, or under pressure'),
  MoodCategory(value: 'anxious', label: 'Anxious', emoji: '😟', color: Color(0xFFFFA726), icon: Icons.psychology_rounded, description: 'Worried, nervous, or restless'),
  MoodCategory(value: 'sad', label: 'Sad', emoji: '😢', color: Color(0xFF5C7CFA), icon: Icons.sentiment_dissatisfied_rounded, description: 'Down, low energy, or unmotivated'),
  MoodCategory(value: 'lonely', label: 'Lonely', emoji: '😔', color: Color(0xFF7C4DFF), icon: Icons.person_outline_rounded, description: 'Isolated, disconnected, or alone'),
  MoodCategory(value: 'neutral', label: 'Neutral', emoji: '😐', color: Color(0xFF78909C), icon: Icons.remove_circle_outline_rounded, description: 'Neither good nor bad, just okay'),
  MoodCategory(value: 'calm', label: 'Calm', emoji: '😌', color: Color(0xFF5CC6A9), icon: Icons.spa_rounded, description: 'Peaceful, relaxed, or centered'),
  MoodCategory(value: 'happy', label: 'Happy', emoji: '😊', color: Color(0xFFFFD54F), icon: Icons.sentiment_satisfied_rounded, description: 'Joyful, content, or cheerful'),
  MoodCategory(value: 'energized', label: 'Energized', emoji: '⚡', color: Color(0xFF63EB68), icon: Icons.bolt_rounded, description: 'Motivated, focused, or pumped'),
];

// ================= MAIN SCREEN =================
class RecommendationsScreen extends StatefulWidget {
  final String? mood;
  final String? userId;
  final String? userName;
  const RecommendationsScreen({super.key, this.mood, this.userId, this.userName});

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      RecommendationsContent(mood: widget.mood, userId: widget.userId, userName: widget.userName),
      const InsightsScreen(),
      const SettingsScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final kPrimaryGreen = const Color.fromARGB(255, 99, 235, 104);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10.0)],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          'Personalized for your wellbeing',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w900, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(child: _pages[_selectedIndex]),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [kPrimaryGreen, const Color.fromARGB(255, 60, 200, 65)]),
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [BoxShadow(color: kPrimaryGreen.withOpacity(0.3), blurRadius: 15.0, offset: const Offset(0, 8))],
              ),
              child: ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CounselorsScreen())),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, elevation: 0, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chat_bubble_outline, color: Colors.black87, size: 24),
                    SizedBox(width: 12),
                    Text('Talk to a Counselor', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black87)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: kPrimaryGreen,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.insights), label: 'Insights'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

// ================= RECOMMENDATIONS CONTENT =================
class RecommendationsContent extends StatefulWidget {
  final String? mood;
  final String? userId;
  final String? userName;
  const RecommendationsContent({super.key, this.mood, this.userId, this.userName});

  @override
  State<RecommendationsContent> createState() => _RecommendationsContentState();
}

class _RecommendationsContentState extends State<RecommendationsContent> {
  bool _showAllTips = false;
  bool _showTestimonialForm = false;
  bool _isSubmittingTestimonial = false;

  // Testimonial form state
  final TextEditingController _whatWorkedController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  int _testimonialRating = 5;
  String? _selectedSessionType;
  String? _selectedMood;
  
  // Consent state
  bool _consentForPublic = false;
  String _displayNameType = 'anonymous';
  bool _consentRead = false;

  // Testimonial filter
  String? _testimonialMoodFilter;

  // Loaded testimonials from DB
  List<Map<String, dynamic>> _dbTestimonials = [];
  bool _isLoadingTestimonials = true;

  // Session type options
  final List<Map<String, dynamic>> _sessionTypes = [
    {'value': 'Meditation', 'icon': Icons.self_improvement_rounded, 'color': Color(0xFF7C4DFF)},
    {'value': 'Fitness', 'icon': Icons.fitness_center_rounded, 'color': Color(0xFFFF6B6B)},
    {'value': 'Breathing', 'icon': Icons.air_rounded, 'color': Color(0xFF5C7CFA)},
    {'value': 'Sleep', 'icon': Icons.bedtime_rounded, 'color': Color(0xFF667EEA)},
    {'value': 'Counseling', 'icon': Icons.chat_bubble_rounded, 'color': Color(0xFF63EB68)},
    {'value': 'Focus', 'icon': Icons.center_focus_strong_rounded, 'color': Color(0xFFFF922B)},
    {'value': 'Stress Relief', 'icon': Icons.spa_rounded, 'color': Color(0xFF5CC6A9)},
    {'value': 'General', 'icon': Icons.favorite_rounded, 'color': Color(0xFFE91E63)},
  ];

  // ── Morning Meditation Library ──
  final Map<String, List<Map<String, String>>> _morningMeditationLibrary = {
    'Great': [
      {'title': 'Gratitude Morning Flow', 'subtitle': 'Start with thankfulness', 'image': 'https://images.unsplash.com/photo-1470252649378-9c29740c9fa8?auto=format&fit=crop&w=1000&q=80', 'youtubeId': 'inpok4MKVLM'},
      {'title': 'Energizing Sunrise Meditation', 'subtitle': 'Boost your morning energy', 'image': 'https://images.unsplash.com/photo-1502082553048-f009c37129b9?auto=format&fit=crop&w=1000&q=80', 'youtubeId': '4Kf7N0jENEQ'},
      {'title': 'Joyful Body Awakening', 'subtitle': 'Wake up every cell gently', 'image': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?auto=format&fit=crop&w=1000&q=80', 'youtubeId': 'ZTo9Y8aRCUQ'},
      {'title': 'Morning Affirmations & Calm', 'subtitle': 'Set positive intentions', 'image': 'https://images.unsplash.com/photo-1499209974431-9dddcece7f88?auto=format&fit=crop&w=1000&q=80', 'youtubeId': '1vx8iCGOJC8'},
      {'title': 'Abundance & Gratitude', 'subtitle': 'Attract positivity today', 'image': 'https://images.unsplash.com/photo-1501854140801-50d01698950b?auto=format&fit=crop&w=1000&q=80', 'youtubeId': 'tN2ZsEGLy5g'},
      {'title': 'Creative Spark Meditation', 'subtitle': 'Ignite your inner creativity', 'image': 'https://images.unsplash.com/photo-1518173946687-a4c8892bbd9f?auto=format&fit=crop&w=1000&q=80', 'youtubeId': 'mX2RRHhOYqE'},
      {'title': 'Heart-Opening Morning', 'subtitle': 'Connect with your heart space', 'image': 'https://images.unsplash.com/photo-1518837695005-2083093ee35b?auto=format&fit=crop&w=1000&q=80', 'youtubeId': 'Lw5eB18sUQg'},
    ],
    'Stressed': [
      {'title': 'Stress Relief Morning Reset', 'subtitle': 'Release tension before the day', 'image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=1000&q=80', 'youtubeId': '7z9_VWRKzH0'},
      {'title': 'Deep Breathing for Anxiety', 'subtitle': 'Calm your nervous system', 'image': 'https://images.unsplash.com/photo-1515694346937-94d85e41e6f0?auto=format&fit=crop&w=1000&q=80', 'youtubeId': 'O-6f5wQXSu8'},
      {'title': 'Letting Go of Worry', 'subtitle': 'Morning release meditation', 'image': 'https://images.unsplash.com/photo-1473448912268-2022ce9509d8?auto=format&fit=crop&w=1000&q=80', 'youtubeId': 'eKcGx_3f7vg'},
      {'title': 'Grounding Morning Practice', 'subtitle': 'Feel rooted and stable', 'image': 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?auto=format&fit=crop&w=1000&q=80', 'youtubeId': '2OEL4P1Rz04'},
      {'title': 'Tension Release Meditation', 'subtitle': 'Melt away shoulder & jaw tightness', 'image': 'https://images.unsplash.com/photo-1505142468610-359e7d316be0?auto=format&fit=crop&w=1000&q=80', 'youtubeId': 'bJVGQiXQoAI'},
      {'title': 'Calm Before the Storm', 'subtitle': 'Build resilience this morning', 'image': 'https://images.unsplash.com/photo-1439405326854-014607f694d7?auto=format&fit=crop&w=1000&q=80', 'youtubeId': 'xNN7iTA57jM'},
      {'title': 'Morning Nervous System Soothe', 'subtitle': 'Gentle vagus nerve reset', 'image': 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1000&q=80', 'youtubeId': 'W0LHTWG-UmQ'},
    ],
    'Lonely': [
      {'title': 'Self-Compassion Morning', 'subtitle': 'Be gentle with yourself today', 'image': 'https://images.unsplash.com/photo-1490750967868-88aa4f44baee?auto=format&fit=crop&w=1000&q=80', 'youtubeId': 'i8MxI8MNcJk'},
      {'title': 'Loving-Kindness Practice', 'subtitle': 'Send love inward first', 'image': 'https://images.unsplash.com/photo-1474552226712-ac0f0961a954?auto=format&fit=crop&w=1000&q=80', 'youtubeId': 'Lw5eB18sUQg'},
      {'title': 'Connection to Self', 'subtitle': 'You are never truly alone', 'image': 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=80', 'youtubeId': 'eKcGx_3f7vg'},
      {'title': 'Inner Strength Meditation', 'subtitle': 'Find power in solitude', 'image': 'https://images.unsplash.com/photo-1454496522488-7a8e488e8606?auto=format&fit=crop&w=1000&q=80', 'youtubeId': 'ZTo9Y8aRCUQ'},
      {'title': 'Emotional Healing Morning', 'subtitle': 'Gentle heart mending', 'image': 'https://images.unsplash.com/photo-1419242902214-272b3f66ee7a?auto=format&fit=crop&w=1000&q=80', 'youtubeId': '1vx8iCGOJC8'},
      {'title': 'You Are Enough Meditation', 'subtitle': 'Affirm your wholeness', 'image': 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=80', 'youtubeId': 'mX2RRHhOYqE'},
      {'title': 'Self-Love Morning Ritual', 'subtitle': 'Wrap yourself in warmth', 'image': 'https://images.unsplash.com/photo-1500462918059-b1a0cb512f1d?auto=format&fit=crop&w=1000&q=80', 'youtubeId': 'inpok4MKVLM'},
    ],
    'General': [
      {'title': 'Basic Mindfulness Morning', 'subtitle': 'Simple awareness to start', 'image': 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=80', 'youtubeId': 'inpok4MKVLM'},
      {'title': 'Full Body Scan Meditation', 'subtitle': 'Check in head to toe', 'image': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?auto=format&fit=crop&w=1000&q=80', 'youtubeId': 'i8MxI8MNcJk'},
      {'title': 'Morning Intention Setting', 'subtitle': 'Choose how your day unfolds', 'image': 'https://images.unsplash.com/photo-1502082553048-f009c37129b9?auto=format&fit=crop&w=1000&q=80', 'youtubeId': '4Kf7N0jENEQ'},
      {'title': '5-Minute Wake Up', 'subtitle': 'Quick mindful start', 'image': 'https://images.unsplash.com/photo-1499209974431-9dddcece7f88?auto=format&fit=crop&w=1000&q=80', 'youtubeId': 'mX2RRHhOYqE'},
      {'title': 'Present Moment Awareness', 'subtitle': 'Anchor in the now', 'image': 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?auto=format&fit=crop&w=1000&q=80', 'youtubeId': 'ZTo9Y8aRCUQ'},
      {'title': 'Gentle Morning Stretch', 'subtitle': 'Move mindfully into the day', 'image': 'https://images.unsplash.com/photo-1518173946687-a4c8892bbd9f?auto=format&fit=crop&w=1000&q=80', 'youtubeId': 'tN2ZsEGLy5g'},
      {'title': 'Daily Clarity Meditation', 'subtitle': 'Clear mental fog', 'image': 'https://images.unsplash.com/photo-1439405326854-014607f694d7?auto=format&fit=crop&w=1000&q=80', 'youtubeId': '1vx8iCGOJC8'},
    ],
  };

  // ── Nature Music Library ──
  final Map<String, List<Map<String, String>>> _natureMusicLibrary = {
    'Great': [
      {'title': 'Morning Birdsongs & Meadow', 'artist': 'Nature Sounds', 'image': 'https://images.unsplash.com/photo-1502082553048-f009c37129b9?auto=format&fit=crop&w=800&q=80', 'youtubeId': '2OEL4P1Rz04'},
      {'title': 'River Flow & Forest', 'artist': 'Water Sounds', 'image': 'https://images.unsplash.com/photo-1439405326854-014607f694d7?auto=format&fit=crop&w=800&q=80', 'youtubeId': 'bJVGQiXQoAI'},
      {'title': 'Sunny Garden Ambience', 'artist': 'Peaceful Nature', 'image': 'https://images.unsplash.com/photo-1473448912268-2022ce9509d8?auto=format&fit=crop&w=800&q=80', 'youtubeId': 'xNN7iTA57jM'},
    ],
    'Stressed': [
      {'title': 'Heavy Rain on Leaves', 'artist': 'Thunder Storm', 'image': 'https://images.unsplash.com/photo-1515694346937-94d85e41e6f0?auto=format&fit=crop&w=800&q=80', 'youtubeId': 'eKFTSSKCzWA'},
      {'title': 'Deep Ocean Waves', 'artist': 'Blue Ocean', 'image': 'https://images.unsplash.com/photo-1505142468610-359e7d316be0?auto=format&fit=crop&w=800&q=80', 'youtubeId': 'tN2ZsEGLy5g'},
      {'title': 'Wind Through Pine Trees', 'artist': 'Breeze Ambience', 'image': 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80', 'youtubeId': 'W0LHTWG-UmQ'},
    ],
    'Lonely': [
      {'title': 'Mountain Echo & Wind', 'artist': 'High Altitude', 'image': 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=800&q=80', 'youtubeId': 'xNN7iTA57jM'},
      {'title': 'Night Crickets & Stars', 'artist': 'Calm Night', 'image': 'https://images.unsplash.com/photo-1419242902214-272b3f66ee7a?auto=format&fit=crop&w=800&q=80', 'youtubeId': 'W0LHTWG-UmQ'},
      {'title': 'Gentle Stream in Autumn', 'artist': 'Water Flow', 'image': 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?auto=format&fit=crop&w=800&q=80', 'youtubeId': 'bJVGQiXQoAI'},
    ],
    'General': [
      {'title': 'Zen Garden Waterfall', 'artist': 'Nature Hub', 'image': 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=800&q=80', 'youtubeId': '2OEL4P1Rz04'},
      {'title': 'Autumn Forest Walk', 'artist': 'Seasons', 'image': 'https://images.unsplash.com/photo-1500462918059-b1a0cb512f1d?auto=format&fit=crop&w=800&q=80', 'youtubeId': 'xNN7iTA57jM'},
      {'title': 'Calm Lake at Dawn', 'artist': 'Still Water', 'image': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?auto=format&fit=crop&w=800&q=80', 'youtubeId': 'bJVGQiXQoAI'},
    ],
  };

  final List<Map<String, String>> _gridItems = const [
    {'title': 'Reduce Stress', 'image': 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?auto=format&fit=crop&w=400&q=80'},
    {'title': 'Boost Focus', 'image': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=400&q=80'},
    {'title': 'Improve Sleep', 'image': 'https://images.unsplash.com/photo-1516214104703-d870798883c5?auto=format&fit=crop&w=400&q=80'},
    {'title': 'Healthy Habits', 'image': 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=400&q=80'},
    {'title': 'Feel Happier', 'image': 'https://images.unsplash.com/photo-1519824145371-296894a0daa9?auto=format&fit=crop&w=400&q=80'},
    {'title': 'Mindful Fitness', 'image': 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?auto=format&fit=crop&w=400&q=80'},
  ];

  late List<Map<String, String>> _currentMusicList;
  late Map<String, String> _todayMeditation;

  Map<String, String> _getTodayMeditation() {
    final moodKey = (widget.mood != null && _morningMeditationLibrary.containsKey(widget.mood))
        ? widget.mood!
        : 'General';
    final list = _morningMeditationLibrary[moodKey]!;
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
    final index = dayOfYear % list.length;
    return list[index];
  }

  @override
  void initState() {
    super.initState();
    _todayMeditation = _getTodayMeditation();
    _currentMusicList = (widget.mood != null && _natureMusicLibrary.containsKey(widget.mood))
        ? _natureMusicLibrary[widget.mood]!
        : _natureMusicLibrary['General']!;
    if (widget.mood != null) {
      final moodLower = widget.mood!.toLowerCase();
      _selectedMood = kMoodCategories.any((m) => m.value == moodLower) 
          ? moodLower 
          : null;
    }
    _loadTestimonials();
  }

  @override
  void dispose() {
    _whatWorkedController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadTestimonials() async {
    setState(() => _isLoadingTestimonials = true);
    try {
      var uri = Uri.parse('http://127.0.0.1:8001/api/testimonials/feedback');
      final queryParams = <String, String>{'limit': '20'};
      if (_testimonialMoodFilter != null) {
        queryParams['mood'] = _testimonialMoodFilter!;
      }
      uri = uri.replace(queryParameters: queryParams);
      
      final response = await http.get(uri, headers: {'Accept': 'application/json'});
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && mounted) {
          setState(() {
            _dbTestimonials = List<Map<String, dynamic>>.from(data['data']);
            _isLoadingTestimonials = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoadingTestimonials = false);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingTestimonials = false);
    }
  }

  bool _validateForm() {
    if (_selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select the mood you were in"), behavior: SnackBarBehavior.floating, shape: StadiumBorder(), backgroundColor: Color(0xFFFF6B6B)),
      );
      return false;
    }
    if (_selectedSessionType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select the session type"), behavior: SnackBarBehavior.floating, shape: StadiumBorder(), backgroundColor: Color(0xFFFF6B6B)),
      );
      return false;
    }
    if (_whatWorkedController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please tell us what worked for you"), behavior: SnackBarBehavior.floating, shape: StadiumBorder(), backgroundColor: Color(0xFFFF6B6B)),
      );
      return false;
    }
    if (!_consentRead) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please read and acknowledge the consent notice"), behavior: SnackBarBehavior.floating, shape: StadiumBorder(), backgroundColor: Color(0xFFFF6B6B)),
      );
      return false;
    }
    return true;
  }

  Future<void> _submitTestimonial() async {
    if (!_validateForm()) return;

    setState(() => _isSubmittingTestimonial = true);

    String displayName = 'Anonymous';
    if (_consentForPublic && widget.userName != null) {
      if (_displayNameType == 'full_name') {
        displayName = widget.userName!;
      } else if (_displayNameType == 'first_name') {
        displayName = widget.userName!.split(' ').first;
      }
    }

    final selectedMoodCategory = kMoodCategories.firstWhere((m) => m.value == _selectedMood);

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8001/api/testimonials'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: json.encode({
          'user_name': displayName,
          'mood': _selectedMood!,
          'emoji': selectedMoodCategory.emoji,
          'what_worked': _whatWorkedController.text.trim(),
          'text': _descriptionController.text.trim(),
          'session_type': _selectedSessionType!,
          'star_rating': _testimonialRating,
          'display_name_type': _displayNameType, 
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Colors.white),
                  const SizedBox(width: 12),
                  const Expanded(child: Text('Testimonial submitted! It will appear publicly once approved.', style: TextStyle(fontWeight: FontWeight.w700))),
                ],
              ),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              backgroundColor: const Color(0xFF63EB68),
              duration: const Duration(seconds: 4),
              margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
            ),
          );
          
          setState(() {
            _showTestimonialForm = false;
            _whatWorkedController.clear();
            _descriptionController.clear();
            _testimonialRating = 5;
            _selectedSessionType = null;
            _selectedMood = null;
            _consentForPublic = false;
            _displayNameType = 'anonymous';
            _consentRead = false;
          });
          _loadTestimonials();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Couldn't save. Please check your inputs."), behavior: SnackBarBehavior.floating, shape: StadiumBorder(), backgroundColor: Color(0xFFFF6B6B)),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Network error. Please try again."), behavior: SnackBarBehavior.floating, shape: StadiumBorder(), backgroundColor: Color(0xFFFF6B6B)),
        );
      }
    }

    if (mounted) setState(() => _isSubmittingTestimonial = false);
  }

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

  void _navigateToScreen(String title) {
    Widget screen;
    switch (title) {
      case 'Reduce Stress': screen = const ReduceStressScreen(); break;
      case 'Boost Focus': screen = const FocusScreen(); break;
      case 'Improve Sleep': screen = const SleepScreen(); break;
      case 'Healthy Habits': screen = const HealthHabitsScreen(); break;
      case 'Feel Happier': screen = const FeelHappierScreen(); break;
      case 'Mindful Fitness': screen = const FitnessScreen(); break;
      default: screen = const FocusScreen();
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final kPrimaryGreen = const Color.fromARGB(255, 99, 235, 104);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.mood != null)
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: kPrimaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: kPrimaryGreen.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.mood_rounded, color: kPrimaryGreen, size: 20),
                  const SizedBox(width: 8),
                  Text('Mood: ${widget.mood}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87)),
                ],
              ),
            ),

          GestureDetector(
            onTap: () => _openYouTube(_todayMeditation['youtubeId']!),
            child: Container(
              margin: const EdgeInsets.only(bottom: 30),
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                image: DecorationImage(image: NetworkImage(_todayMeditation['image']!), fit: BoxFit.cover),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))],
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(colors: [Colors.transparent, Colors.black.withOpacity(0.75)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                ),
                padding: const EdgeInsets.all(20),
                alignment: Alignment.bottomLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: kPrimaryGreen, borderRadius: BorderRadius.circular(8)), child: const Text("Today's Pick", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white))),
                              const SizedBox(width: 8),
                              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.calendar_today_rounded, color: Colors.white70, size: 11), const SizedBox(width: 4), Text(_getDayLabel(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white70))])),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(_todayMeditation['title']!, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
                          const SizedBox(height: 3),
                          Text(_todayMeditation['subtitle']!, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white.withOpacity(0.7))),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(mainAxisSize: MainAxisSize.min, children: [Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.redAccent.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 5))]), child: const Icon(Icons.play_arrow, color: Colors.white, size: 30)), const SizedBox(height: 6), Text('YouTube', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white.withOpacity(0.6), letterSpacing: 0.5))]),
                  ],
                ),
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Top Tips', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.black87)),
              GestureDetector(onTap: () => setState(() => _showAllTips = !_showAllTips), child: Text(_showAllTips ? 'See Less' : 'See All', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: kPrimaryGreen))),
            ],
          ),
          const SizedBox(height: 15),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            childAspectRatio: 1.0,
            children: (_showAllTips ? _gridItems : _gridItems.take(4)).map((item) => _buildGridItem(item['title']!, item['image']!)).toList(),
          ),

          const SizedBox(height: 35),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Nature Sounds & Music', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.black87)),
              Row(children: [Icon(Icons.open_in_new, size: 14, color: Colors.grey.shade400), const SizedBox(width: 4), Text('YouTube', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade400))]),
            ],
          ),
          const SizedBox(height: 6),
          Text('Tap to watch in high quality', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade400)),
          const SizedBox(height: 18),

          ...List.generate(_currentMusicList.length, (index) => _buildMusicCard(track: _currentMusicList[index])),

          const SizedBox(height: 40),

          // ══════════════════════════════════════════════════════
          // ── TESTIMONIALS SECTION ──
          // ══════════════════════════════════════════════════════
          
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF667EEA), Color(0xFF5C7CFA)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: const Color(0xFF5C7CFA).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [Container(width: 52, height: 52, decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.rate_review_rounded, color: Colors.white, size: 28)), const SizedBox(width: 16), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Share Your Experience', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)), SizedBox(height: 4), Text('Help others discover what worked for you', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white70))]))]),
                const SizedBox(height: 16),
                Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.2))), child: Row(children: [Icon(Icons.shield_moon_rounded, color: Colors.white.withOpacity(0.9), size: 18), const SizedBox(width: 10), Expanded(child: Text('Your privacy matters. You control how your testimonial is shared.', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white.withOpacity(0.9))))])),
              ],
            ),
          ),
          const SizedBox(height: 20),

          if (!_showTestimonialForm)
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () => setState(() => _showTestimonialForm = true),
                style: ElevatedButton.styleFrom(backgroundColor: kPrimaryGreen, elevation: 5, shadowColor: kPrimaryGreen.withOpacity(0.4), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                icon: const Icon(Icons.edit_note_rounded, size: 24, color: Colors.black87),
                label: const Text('Share What Worked for You', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w800, fontSize: 16)),
              ),
            ),

          if (_showTestimonialForm) _buildTestimonialForm(),

          const SizedBox(height: 35),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Community Experiences', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.black87)),
              GestureDetector(onTap: _loadTestimonials, child: Row(children: [Icon(Icons.refresh_rounded, size: 16, color: Colors.grey.shade400), const SizedBox(width: 4), Text('Refresh', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade400))])),
            ],
          ),
          const SizedBox(height: 4),
          Text('Real stories from people like you, categorized by mood', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey.shade400)),
          const SizedBox(height: 14),

          SizedBox(
            height: 42,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildMoodFilterChip(null, 'All', Icons.apps_rounded, Colors.grey.shade500),
                ...kMoodCategories.map((mood) => _buildMoodFilterChip(mood.value, '${mood.emoji} ${mood.label}', mood.icon, mood.color)),
              ],
            ),
          ),
          const SizedBox(height: 18),

          if (_isLoadingTestimonials)
            const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator(color: Color(0xFF5C7CFA))))
          else if (_dbTestimonials.isEmpty)
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200)),
              child: Column(children: [Icon(Icons.rate_review_outlined, size: 48, color: Colors.grey.shade300), const SizedBox(height: 16), Text('No testimonials yet for this mood', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.grey.shade400)), const SizedBox(height: 8), Text('Be the first to share your experience!', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey.shade400))]),
            )
          else
            ...List.generate(_dbTestimonials.length, (index) => _buildDbTestimonialCard(_dbTestimonials[index])),

          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildMoodFilterChip(String? mood, String label, IconData icon, Color color) {
    final isSelected = _testimonialMoodFilter == mood;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => setState(() { _testimonialMoodFilter = mood; _loadTestimonials(); }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.15) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isSelected ? color : Colors.grey.shade200, width: isSelected ? 1.5 : 1),
            boxShadow: isSelected ? [BoxShadow(color: color.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 2))] : null,
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 14, color: isSelected ? color : Colors.grey.shade400), const SizedBox(width: 6), Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: isSelected ? color : Colors.grey.shade500))]),
        ),
      ),
    );
  }

  Widget _buildTestimonialForm() {
    final kPrimaryGreen = const Color.fromARGB(255, 99, 235, 104);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 24, offset: const Offset(0, 10))], border: Border.all(color: kPrimaryGreen.withOpacity(0.3), width: 1.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Share Your Story', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF2C3E50))), GestureDetector(onTap: () => setState(() => _showTestimonialForm = false), child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle), child: Icon(Icons.close_rounded, size: 18, color: Colors.grey.shade500)))]),
          const SizedBox(height: 6),
          Text('Your experience can help someone going through the same thing', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey.shade500)),
          const SizedBox(height: 24),

          // ── STEP 1: Mood ──
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFFF6B6B).withOpacity(0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFFF6B6B).withOpacity(0.2))), child: Row(children: [Container(width: 24, height: 24, decoration: BoxDecoration(color: const Color(0xFFFF6B6B), borderRadius: BorderRadius.circular(8)), child: const Center(child: Text('1', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white)))), const SizedBox(width: 10), const Text('What mood were you in?', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF2C3E50)))])),
          const SizedBox(height: 12),
          
          Container(
            decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(14), border: Border.all(color: _selectedMood != null ? kMoodCategories.firstWhere((m) => m.value == _selectedMood).color : Colors.grey.shade200, width: 1.5)),
            child: DropdownButtonFormField<String>(
              value: _selectedMood,
              itemHeight: 80, // ✅ INCREASED to fix overflow
              hint: const Row(children: [Icon(Icons.mood_rounded, color: Colors.grey, size: 20), SizedBox(width: 10), Text('Select your mood', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey))]),
              isExpanded: true,
              decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
              items: kMoodCategories.map((mood) {
                return DropdownMenuItem<String>(
                  value: mood.value,
                  child: Row(children: [Container(width: 36, height: 36, decoration: BoxDecoration(color: mood.color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)), child: Center(child: Text(mood.emoji, style: const TextStyle(fontSize: 18)))), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [Text(mood.label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF2C3E50))), Text(mood.description, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.grey.shade500))]))]),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedMood = value),
            ),
          ),
          const SizedBox(height: 24),

          // ── STEP 2: Session Type ──
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFF5C7CFA).withOpacity(0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF5C7CFA).withOpacity(0.2))), child: Row(children: [Container(width: 24, height: 24, decoration: BoxDecoration(color: const Color(0xFF5C7CFA), borderRadius: BorderRadius.circular(8)), child: const Center(child: Text('2', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white)))), const SizedBox(width: 10), const Text('What type of session helped?', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF2C3E50)))])),
          const SizedBox(height: 12),
          
          Container(
            decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(14), border: Border.all(color: _selectedSessionType != null ? (_sessionTypes.firstWhere((t) => t['value'] == _selectedSessionType)['color'] as Color) : Colors.grey.shade200, width: 1.5)),
            child: DropdownButtonFormField<String>(
              value: _selectedSessionType,
              itemHeight: 60, // ✅ FIX: Prevents RenderFlex overflow
              hint: const Row(children: [Icon(Icons.self_improvement_rounded, color: Colors.grey, size: 20), SizedBox(width: 10), Text('Select session type', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey))]),
              isExpanded: true,
              decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
              items: _sessionTypes.map((type) {
                final color = type['color'] as Color;
                final icon = type['icon'] as IconData;
                return DropdownMenuItem<String>(
                  value: type['value'],
                  child: Row(children: [Container(width: 36, height: 36, decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: color, size: 20)), const SizedBox(width: 12), Text(type['value'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF2C3E50)))]),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedSessionType = value),
            ),
          ),
          const SizedBox(height: 24),

          // ── STEP 3: What Worked ──
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFF63EB68).withOpacity(0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF63EB68).withOpacity(0.2))), child: Row(children: [Container(width: 24, height: 24, decoration: BoxDecoration(color: const Color(0xFF63EB68), borderRadius: BorderRadius.circular(8)), child: const Center(child: Text('3', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white)))), const SizedBox(width: 10), const Text('What specifically worked? *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF2C3E50)))])),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(16), border: Border.all(color: _whatWorkedController.text.isEmpty ? Colors.grey.shade200 : kPrimaryGreen, width: 1.5)),
            child: TextField(controller: _whatWorkedController, maxLength: 120, textCapitalization: TextCapitalization.sentences, onChanged: (_) => setState(() {}), decoration: InputDecoration(labelText: 'The key thing that helped you', labelStyle: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade500), hintText: 'e.g., 4-7-8 breathing before bed, guided body scan meditation', hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400), counterStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.grey.shade400), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), prefixIcon: Icon(Icons.lightbulb_outline_rounded, color: kPrimaryGreen))),
          ),
          const SizedBox(height: 16),

          Container(
            decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
            child: TextField(controller: _descriptionController, maxLines: 3, maxLength: 400, textCapitalization: TextCapitalization.sentences, decoration: InputDecoration(labelText: 'Tell us more (optional)', labelStyle: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade500), hintText: 'How did it help? How long did you try it? Any tips for others?', hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400), counterStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.grey.shade400), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), prefixIcon: Icon(Icons.edit_note_rounded, color: Colors.grey.shade400))),
          ),
          const SizedBox(height: 24),

          // ── STEP 4: Rating ──
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFFFD700).withOpacity(0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.2))), child: Row(children: [Container(width: 24, height: 24, decoration: BoxDecoration(color: const Color(0xFFFFD700), borderRadius: BorderRadius.circular(8)), child: const Center(child: Text('4', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white)))), const SizedBox(width: 10), const Text('How effective was it?', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF2C3E50)))])),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final filled = index < _testimonialRating;
              return GestureDetector(onTap: () => setState(() => _testimonialRating = index + 1), child: AnimatedScale(scale: filled ? 1.2 : 1.0, duration: const Duration(milliseconds: 150), child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: Icon(filled ? Icons.star_rounded : Icons.star_outline_rounded, size: 38, color: filled ? const Color(0xFFFFD700) : Colors.grey.shade300))));
            }),
          ),
          if (_testimonialRating > 0) Center(child: Padding(padding: const EdgeInsets.only(top: 8), child: Text(["", "Not Helpful", "Slightly Helpful", "Helpful", "Very Helpful", "Life Changing!"][_testimonialRating], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFFFFD700))))),
          const SizedBox(height: 28),

          // ── STEP 5: Consent ──
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFF7C4DFF).withOpacity(0.06), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF7C4DFF).withOpacity(0.15))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [Container(width: 24, height: 24, decoration: BoxDecoration(color: const Color(0xFF7C4DFF), borderRadius: BorderRadius.circular(8)), child: const Center(child: Text('5', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white)))), const SizedBox(width: 10), const Text('Privacy & Consent', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF2C3E50)))]),
                const SizedBox(height: 12),
                Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Icon(Icons.info_outline_rounded, size: 16, color: Colors.grey.shade600), const SizedBox(width: 8), const Text('Consent Notice', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF2C3E50)))]), const SizedBox(height: 8), Text('Your testimonial may be displayed publicly to help other users discover effective techniques. By submitting, you acknowledge that:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.grey.shade600, height: 1.5)), const SizedBox(height: 8), Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.check_circle_outline_rounded, size: 14, color: Colors.grey.shade500), const SizedBox(width: 8), Expanded(child: Text('Content may be reviewed and moderated before publication', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.grey.shade500)))]), const SizedBox(height: 4), Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.check_circle_outline_rounded, size: 14, color: Colors.grey.shade500), const SizedBox(width: 8), Expanded(child: Text('You can request removal of your testimonial at any time', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.grey.shade500)))]), const SizedBox(height: 4), Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.check_circle_outline_rounded, size: 14, color: Colors.grey.shade500), const SizedBox(width: 8), Expanded(child: Text('Your contact information will never be shared', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.grey.shade500)))])])),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: () => setState(() => _consentRead = !_consentRead),
                  child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: _consentRead ? const Color(0xFF7C4DFF).withOpacity(0.08) : Colors.transparent, borderRadius: BorderRadius.circular(10), border: Border.all(color: _consentRead ? const Color(0xFF7C4DFF) : Colors.grey.shade300)), child: Row(children: [Container(width: 22, height: 22, decoration: BoxDecoration(color: _consentRead ? const Color(0xFF7C4DFF) : Colors.transparent, borderRadius: BorderRadius.circular(6), border: Border.all(color: _consentRead ? const Color(0xFF7C4DFF) : Colors.grey.shade400, width: 2)), child: _consentRead ? const Icon(Icons.check, size: 14, color: Colors.white) : null), const SizedBox(width: 10), Expanded(child: Text('I have read and understand the consent notice', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _consentRead ? const Color(0xFF7C4DFF) : Colors.grey.shade600)))])),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Allow public display?', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.grey.shade700)), const SizedBox(height: 2), Text('Uncheck to keep private (for internal use only)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.grey.shade500))])), Switch(value: _consentForPublic, onChanged: (value) => setState(() => _consentForPublic = value), activeColor: const Color(0xFF7C4DFF))]),
                      if (_consentForPublic) ...[
                        const SizedBox(height: 14), const Divider(height: 1), const SizedBox(height: 14),
                        Text('How should we display your name?', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.grey.shade700)),
                        const SizedBox(height: 10),
                        ...['anonymous', 'first_name', 'full_name'].map((option) {
                          final isSelected = _displayNameType == option;
                          final labelMap = {'anonymous': 'Anonymous', 'first_name': 'First name only', 'full_name': 'Full name'};
                          final iconMap = {'anonymous': Icons.visibility_off_rounded, 'first_name': Icons.person_outline_rounded, 'full_name': Icons.person_rounded};
                          final descMap = {'anonymous': 'No name shown', 'first_name': 'e.g., "Sarah"', 'full_name': 'e.g., "Sarah Johnson"'};
                          
                          return GestureDetector(
                            onTap: () => setState(() => _displayNameType = option),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(color: isSelected ? const Color(0xFF7C4DFF).withOpacity(0.08) : Colors.grey.shade50, borderRadius: BorderRadius.circular(10), border: Border.all(color: isSelected ? const Color(0xFF7C4DFF) : Colors.grey.shade200, width: isSelected ? 1.5 : 1)),
                              child: Row(children: [Icon(iconMap[option], size: 18, color: isSelected ? const Color(0xFF7C4DFF) : Colors.grey.shade400), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(labelMap[option]!, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: isSelected ? const Color(0xFF7C4DFF) : Colors.grey.shade600)), Text(descMap[option]!, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.grey.shade400))])), if (isSelected) Container(width: 20, height: 20, decoration: BoxDecoration(color: const Color(0xFF7C4DFF), shape: BoxShape.circle), child: const Icon(Icons.check, size: 12, color: Colors.white))]),
                            ),
                          );
                        }),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: (_isSubmittingTestimonial || !_consentRead) ? null : _submitTestimonial,
              style: ElevatedButton.styleFrom(backgroundColor: kPrimaryGreen, elevation: 0, disabledBackgroundColor: kPrimaryGreen.withOpacity(0.4), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
              icon: _isSubmittingTestimonial ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white)) : const Icon(Icons.send_rounded, size: 20, color: Colors.white),
              label: Text(_isSubmittingTestimonial ? 'Submitting...' : 'Submit Testimonial', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
            ),
          ),
          const SizedBox(height: 12),
          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)), child: Row(children: [Icon(Icons.lock_outline_rounded, size: 14, color: Colors.grey.shade500), const SizedBox(width: 8), Expanded(child: Text('Your data is encrypted and protected. You can delete your testimonial anytime from Settings.', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.grey.shade500)))])),
        ],
      ),
    );
  }

  Widget _buildDbTestimonialCard(Map<String, dynamic> testimonial) {
    // ✅ ULTRA-SAFE PARSING: Prevents ALL Null subtype crashes
    final String sessionTypeStr = (testimonial['session_type'] ?? testimonial['sessionType'])?.toString() ?? 'General';
    
    Map<String, dynamic> sessionTypeData = {'value': 'General', 'icon': Icons.favorite_rounded, 'color': const Color(0xFFE91E63)};
    for (var t in _sessionTypes) {
      if (t['value'] == sessionTypeStr) {
        sessionTypeData = t;
        break;
      }
    }

    final String rawMood = (testimonial['mood_when_it_worked'] ?? testimonial['mood'])?.toString() ?? 'neutral';
    MoodCategory moodCategory = kMoodCategories[4]; // Default Neutral
    for (var m in kMoodCategories) {
      if (m.value == rawMood.toLowerCase()) {
        moodCategory = m;
        break;
      }
    }

    final String displayName = (testimonial['user_name'] ?? testimonial['name'])?.toString() ?? 'Anonymous';
    final String displayNameType = (testimonial['display_name_type'] ?? testimonial['displayNameType'])?.toString() ?? 'anonymous';
    
    String visibleName = displayName;
    if (displayNameType == 'anonymous') {
      visibleName = 'Anonymous';
    } else if (displayNameType == 'first_name' && visibleName.isNotEmpty) {
      visibleName = visibleName.split(' ').first;
    }

    final String whatWorkedText = (testimonial['what_worked'] ?? testimonial['whatWorked'])?.toString() ?? '';
    final String descriptionText = (testimonial['description'] ?? testimonial['content'])?.toString() ?? '';
    
    int starRating = 5;
    if (testimonial['star_rating'] != null) {
      starRating = (testimonial['star_rating'] as num).toInt();
    } else if (testimonial['rating'] != null) {
      starRating = (testimonial['rating'] as num).toInt();
    }

    int helpfulCount = 0;
    if (testimonial['helpful_count'] != null) {
      helpfulCount = (testimonial['helpful_count'] as num).toInt();
    } else if (testimonial['helpfulCount'] != null) {
      helpfulCount = (testimonial['helpfulCount'] as num).toInt();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12)], border: Border.all(color: moodCategory.color.withOpacity(0.15), width: 1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: moodCategory.color.withOpacity(0.12), borderRadius: BorderRadius.circular(10), border: Border.all(color: moodCategory.color.withOpacity(0.3))), child: Row(mainAxisSize: MainAxisSize.min, children: [Text(moodCategory.emoji, style: const TextStyle(fontSize: 14)), const SizedBox(width: 4), Text(moodCategory.label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: moodCategory.color))])), const Spacer(), Row(children: List.generate(5, (i) => Icon(i < starRating ? Icons.star_rounded : Icons.star_outline_rounded, size: 14, color: i < starRating ? const Color(0xFFFFD700) : Colors.grey.shade300)))]),
          const SizedBox(height: 14),
          Row(children: [Container(width: 32, height: 32, decoration: BoxDecoration(color: (sessionTypeData['color'] as Color).withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(sessionTypeData['icon'] as IconData, color: sessionTypeData['color'] as Color, size: 16)), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Text(visibleName, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Color(0xFF2C3E50))), if (displayNameType == 'anonymous') ...[const SizedBox(width: 6), Icon(Icons.visibility_off_rounded, size: 12, color: Colors.grey.shade400)]]), Text(sessionTypeStr, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: sessionTypeData['color'] as Color))]))]),
          const SizedBox(height: 14),
          if (whatWorkedText.isNotEmpty) Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFF63EB68).withOpacity(0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFF63EB68).withOpacity(0.2))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Icon(Icons.check_circle_rounded, color: const Color(0xFF63EB68), size: 16), const SizedBox(width: 6), Text('What Worked', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: const Color(0xFF63EB68).withOpacity(0.8), letterSpacing: 0.5))]), const SizedBox(height: 8), Text(whatWorkedText, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF2C3E50), height: 1.4))])),
          if (descriptionText.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.format_quote_rounded, size: 16, color: Colors.grey.shade400), const SizedBox(width: 8), Expanded(child: Text(descriptionText, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey.shade600, height: 1.5, fontStyle: FontStyle.italic)))])),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              GestureDetector(
                onTap: () async {
                  try {
                    await http.post(Uri.parse('http://127.0.0.1:8001/api/testimonials/${testimonial['id']}/helpful'), headers: {'Accept': 'application/json'});
                    _loadTestimonials();
                  } catch(e) {}
                },
                child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.thumb_up_outlined, size: 14, color: Colors.grey.shade500), const SizedBox(width: 5), Text('Helpful ($helpfulCount)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade500))])),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  showDialog(context: context, builder: (ctx) => AlertDialog(title: const Text('Report Testimonial'), content: const Text('Is this testimonial inappropriate or misleading?'), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')), TextButton(onPressed: () { Navigator.pop(ctx); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Report submitted. We\'ll review it shortly.'), behavior: SnackBarBehavior.floating)); }, child: const Text('Report', style: TextStyle(color: Colors.red)))]));
                },
                child: Icon(Icons.flag_outlined, size: 14, color: Colors.grey.shade400),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getDayLabel() {
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
    final moodKey = (widget.mood != null && _morningMeditationLibrary.containsKey(widget.mood)) ? widget.mood! : 'General';
    final total = _morningMeditationLibrary[moodKey]!.length;
    return 'Day ${(dayOfYear % total) + 1} of $total';
  }

  Widget _buildGridItem(String title, String imageUrl) {
    return GestureDetector(
      onTap: () => _navigateToScreen(title),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))]),
        child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), gradient: LinearGradient(colors: [Colors.black.withOpacity(0.1), Colors.black.withOpacity(0.6)], begin: Alignment.topCenter, end: Alignment.bottomCenter)), alignment: Alignment.bottomLeft, padding: const EdgeInsets.all(15), child: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15))),
      ),
    );
  }

  Widget _buildMusicCard({required Map<String, String> track}) {
    final kPrimaryGreen = const Color.fromARGB(255, 99, 235, 104);
    return GestureDetector(
      onTap: () => _openYouTube(track['youtubeId']!),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 5))]),
        child: Row(
          children: [
            Stack(children: [ClipRRect(borderRadius: BorderRadius.circular(14), child: Image.network(track['image']!, width: 64, height: 64, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: Colors.grey[300], width: 64, height: 64))), Positioned.fill(child: Container(decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), borderRadius: BorderRadius.circular(14)), child: const Center(child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 28))))]),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Text(track['title']!, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Color(0xFF2C3E50))), const SizedBox(height: 3), Text(track['artist']!, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Colors.grey.shade500)), const SizedBox(height: 5), Row(children: [Icon(Icons.hd_rounded, size: 12, color: kPrimaryGreen), const SizedBox(width: 3), Text('High Quality', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: kPrimaryGreen)), const SizedBox(width: 8), Icon(Icons.open_in_new_rounded, size: 10, color: Colors.grey.shade400), const SizedBox(width: 3), Text('YouTube', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.grey.shade400))])])),
            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle), child: Icon(Icons.open_in_browser_rounded, color: Colors.grey.shade600, size: 20)),
          ],
        ),
      ),
    );
  }
}

// ================= INSIGHTS SCREEN (unchanged) =================
class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});
  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedPeriod = 0;

  final List<MoodDataPoint> _weeklyMood = [MoodDataPoint(day: 'Mon', value: 0.6, label: 'Good'), MoodDataPoint(day: 'Tue', value: 0.35, label: 'Low'), MoodDataPoint(day: 'Wed', value: 0.75, label: 'Great'), MoodDataPoint(day: 'Thu', value: 0.5, label: 'Okay'), MoodDataPoint(day: 'Fri', value: 0.85, label: 'Great'), MoodDataPoint(day: 'Sat', value: 0.9, label: 'Amazing'), MoodDataPoint(day: 'Sun', value: 0.7, label: 'Good')];
  final List<MoodDataPoint> _monthlyMood = [MoodDataPoint(day: 'W1', value: 0.45, label: 'Okay'), MoodDataPoint(day: 'W2', value: 0.6, label: 'Good'), MoodDataPoint(day: 'W3', value: 0.72, label: 'Great'), MoodDataPoint(day: 'W4', value: 0.68, label: 'Good')];
  final List<MoodDataPoint> _weeklySleep = [MoodDataPoint(day: 'Mon', value: 0.72, label: '5.8h'), MoodDataPoint(day: 'Tue', value: 0.55, label: '4.4h'), MoodDataPoint(day: 'Wed', value: 0.85, label: '6.8h'), MoodDataPoint(day: 'Thu', value: 0.65, label: '5.2h'), MoodDataPoint(day: 'Fri', value: 0.9, label: '7.2h'), MoodDataPoint(day: 'Sat', value: 0.95, label: '7.6h'), MoodDataPoint(day: 'Sun', value: 0.78, label: '6.2h')];
  final List<SessionStat> _sessionStats = [SessionStat(label: 'Meditation', completed: 12, total: 14, color: const Color(0xFF5CC6A9)), SessionStat(label: 'Focus', completed: 8, total: 10, color: const Color(0xFF63EB68)), SessionStat(label: 'Sleep', completed: 5, total: 7, color: const Color(0xFF5C7CFA)), SessionStat(label: 'Fitness', completed: 3, total: 5, color: const Color(0xFFFF922B))];
  final List<SuggestionItem> _suggestions = [SuggestionItem(title: 'Your stress peaks on Tuesdays', description: 'Try a 10-minute breathing session every Tuesday morning to build resilience before the week intensifies.', icon: Icons.analytics_rounded, color: const Color(0xFFFF6B6B), tag: 'Pattern Detected'), SuggestionItem(title: 'Sleep improving — keep it up!', description: 'Your average sleep jumped from 5.1h to 6.3h this week. Maintaining your bedtime routine is working.', icon: Icons.trending_up_rounded, color: const Color(0xFF5CC6A9), tag: 'Positive Trend'), SuggestionItem(title: "You haven't tried Fitness yet", description: 'Just 1 mindful fitness session per week can boost your mood scores by up to 15%. Start with a gentle stretch.', icon: Icons.directions_run_rounded, color: const Color(0xFFFF922B), tag: 'Suggestion'), SuggestionItem(title: 'Weekend mood is consistently high', description: 'You feel best on Saturdays. Consider scheduling creative activities or social time to carry this into weekdays.', icon: Icons.emoji_emotions_rounded, color: const Color(0xFF748FFC), tag: 'Insight')];

  double get _avgMood { final data = _selectedPeriod == 0 ? _weeklyMood : _monthlyMood; return data.map((e) => e.value).reduce((a, b) => a + b) / data.length; }
  double get _avgSleep { return _weeklySleep.map((e) => e.value).reduce((a, b) => a + b) / _weeklySleep.length; }

  @override
  void initState() { super.initState(); _tabController = TabController(length: 3, vsync: this); }
  @override
  void dispose() { _tabController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final kPrimaryGreen = const Color.fromARGB(255, 99, 235, 104);
    return Scaffold(backgroundColor: const Color(0xFFFAFAFA), body: SafeArea(child: Column(children: [Padding(padding: const EdgeInsets.fromLTRB(24, 16, 24, 0), child: Row(children: [const Text('Your Journey', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF2C3E50))), const Spacer(), Container(decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12.0)), child: Row(children: ['Week', 'Month'].asMap().entries.map((e) { final active = _selectedPeriod == e.key; return GestureDetector(onTap: () => setState(() => _selectedPeriod = e.key), child: AnimatedContainer(duration: const Duration(milliseconds: 250), padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7), decoration: BoxDecoration(color: active ? kPrimaryGreen : Colors.transparent, borderRadius: BorderRadius.circular(10)), child: Text(e.value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: active ? Colors.white : Colors.grey.shade500)))); }).toList()))])), const SizedBox(height: 20), Container(margin: const EdgeInsets.symmetric(horizontal: 24), decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(16)), child: TabBar(controller: _tabController, indicator: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))]), indicatorSize: TabBarIndicatorSize.tab, dividerColor: Colors.transparent, labelColor: const Color(0xFF2C3E50), unselectedLabelColor: Colors.grey.shade400, labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800), unselectedLabelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600), tabs: const [Tab(text: 'Mood'), Tab(text: 'Activity'), Tab(text: 'Insights')])), const SizedBox(height: 16), Expanded(child: TabBarView(controller: _tabController, children: [_buildMoodTab(), _buildActivityTab(), _buildInsightsTab()]))])));
  }

  Widget _buildMoodTab() {
    final moodData = _selectedPeriod == 0 ? _weeklyMood : _monthlyMood;
    final moodLabels = ['Low', 'Okay', 'Good', 'Great', 'Amazing'];
    final moodColors = [Colors.red.shade300, Colors.orange.shade300, Colors.yellow.shade400, Colors.lightGreen, const Color(0xFF63EB68)];
    final moodIdx = (_avgMood * 4).round().clamp(0, 4);
    return SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF5CC6A9), Color(0xFF3DA88A)], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: const Color(0xFF5CC6A9).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))]), child: Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Current Streak', style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600)), const SizedBox(height: 4), const Row(crossAxisAlignment: CrossAxisAlignment.end, children: [Text('5', style: TextStyle(fontSize: 42, color: Colors.white, fontWeight: FontWeight.w900, height: 1.0)), SizedBox(width: 6), Padding(padding: EdgeInsets.only(bottom: 8), child: Text('days', style: TextStyle(fontSize: 16, color: Colors.white70, fontWeight: FontWeight.w500)))])]) ), Container(width: 70, height: 70, decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle, border: Border.all(color: Colors.white.withOpacity(0.3), width: 2)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text('${(_avgMood * 100).round()}%', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)), Text('avg', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 10, fontWeight: FontWeight.w600))]))])), const SizedBox(height: 28), Row(children: [Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: moodColors[moodIdx].withOpacity(0.15), borderRadius: BorderRadius.circular(12), border: Border.all(color: moodColors[moodIdx].withOpacity(0.3))), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.mood_rounded, color: moodColors[moodIdx], size: 18), const SizedBox(width: 6), Text('Avg: ${moodLabels[moodIdx]}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: moodColors[moodIdx]))])), const Spacer(), Text(_selectedPeriod == 0 ? 'This week' : 'This month', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey))]), const SizedBox(height: 20), Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5))]), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Mood Trend', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF2C3E50))), const SizedBox(height: 6), Text('How you felt each day', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade400)), const SizedBox(height: 20), SizedBox(height: 180, child: CustomPaint(size: Size.infinite, painter: _MoodBarChartPainter(data: moodData, barColor: const Color(0xFF5CC6A9), backgroundColor: const Color(0xFFF0F3F4))))])), const SizedBox(height: 24), Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5))]), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [const Icon(Icons.bedtime_rounded, color: Color(0xFF5C7CFA), size: 20), const SizedBox(width: 8), const Text('Sleep Pattern', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF2C3E50))), const Spacer(), Text('Avg: ${(_avgSleep * 8).toStringAsFixed(1)}h', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF5C7CFA)))]), const SizedBox(height: 20), SizedBox(height: 160, child: CustomPaint(size: Size.infinite, painter: _SleepLineChartPainter(data: _weeklySleep, lineColor: const Color(0xFF5C7CFA), fillColor: const Color(0xFF5C7CFA), goalLine: 0.875)))])), const SizedBox(height: 40)]));
  }

  Widget _buildActivityTab() {
    final totalSessions = _sessionStats.fold(0, (sum, s) => sum + s.completed);
    final totalGoals = _sessionStats.fold(0, (sum, s) => sum + s.total);
    final completionRate = totalGoals > 0 ? totalSessions / totalGoals : 0;
    return SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF667EEA), Color(0xFF5C7CFA)], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: const Color(0xFF5C7CFA).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))]), child: Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Total Sessions', style: TextStyle(fontSize: 13, color: Colors.white70, fontWeight: FontWeight.w600)), const SizedBox(height: 4), Text('$totalSessions', style: const TextStyle(fontSize: 38, color: Colors.white, fontWeight: FontWeight.w900, height: 1.0)), Text('of $totalGoals goals', style: const TextStyle(fontSize: 13, color: Colors.white60, fontWeight: FontWeight.w500))])), SizedBox(width: 72, height: 72, child: CustomPaint(painter: _CircularProgressPainter(progress: completionRate.toDouble().clamp(0.0, 1.0), color: Colors.white, bgColor: Colors.white.withOpacity(0.2), strokeWidth: 6.0), child: Center(child: Text('${(completionRate * 100).round()}%', style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w900)))))])), const SizedBox(height: 28), const Text('Session Breakdown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF2C3E50))), const SizedBox(height: 16), ..._sessionStats.map((stat) { final progress = stat.total > 0 ? stat.completed / stat.total : 0; return Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))]), child: Row(children: [Container(width: 42, height: 42, decoration: BoxDecoration(color: stat.color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Center(child: Text('${stat.completed}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: stat.color)))), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(stat.label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF2C3E50))), Text('${stat.completed}/${stat.total}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: stat.color))]), const SizedBox(height: 8), ClipRRect(borderRadius: BorderRadius.circular(6), child: LinearProgressIndicator(value: progress.toDouble(), minHeight: 6, backgroundColor: Colors.grey.shade100, valueColor: AlwaysStoppedAnimation(stat.color)))]))])); }), const SizedBox(height: 40)]));
  }

  Widget _buildInsightsTab() {
    return SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF2C3E50), Color(0xFF34495E)], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: const Color(0xFF2C3E50).withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10))]), child: Row(children: [Container(width: 48, height: 48, decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFFF922B), Color(0xFFFF6B6B)]), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 24)), const SizedBox(width: 16), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('AI-Powered Insights', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: Colors.white)), SizedBox(height: 3), Text('Personalized suggestions based on your patterns', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white60))]))])), const SizedBox(height: 24), const Text('Detected Patterns', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF2C3E50))), const SizedBox(height: 16), ..._suggestions.map((s) => Container(margin: const EdgeInsets.only(bottom: 14), padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 12, offset: const Offset(0, 5))], border: Border.all(color: s.color.withOpacity(0.15), width: 1)), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(width: 44, height: 44, decoration: BoxDecoration(color: s.color.withOpacity(0.1), borderRadius: BorderRadius.circular(14)), child: Icon(s.icon, color: s.color, size: 22)), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: s.color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)), child: Text(s.tag, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: s.color))), const SizedBox(height: 8), Text(s.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF2C3E50), height: 1.3)), const SizedBox(height: 4), Text(s.description, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Colors.grey.shade500, height: 1.5))]))]))), const SizedBox(height: 40)]));
  }
}

// ================= CHART PAINTERS (unchanged) =================
class _MoodBarChartPainter extends CustomPainter {
  final List<MoodDataPoint> data; final Color barColor; final Color backgroundColor;
  _MoodBarChartPainter({required this.data, required this.barColor, required this.backgroundColor});
  @override void paint(Canvas canvas, Size size) { final count = data.length; if (count == 0) return; final barWidth = size.width / (count * 2); final maxH = size.height - 30; final baseY = size.height - 20; for (int i = 0; i <= 4; i++) { final y = baseY - (maxH * i / 4); canvas.drawLine(Offset(0, y), Offset(size.width, y), Paint()..color = Colors.grey.shade100..strokeWidth = 1); final labels = ['0', '25', '50', '75', '100']; final tp = TextPainter(text: TextSpan(text: labels[i], style: TextStyle(fontSize: 9, color: Colors.grey.shade400, fontWeight: FontWeight.w600)), textDirection: TextDirection.ltr)..layout(); tp.paint(canvas, Offset(0, y - 12)); } for (int i = 0; i < count; i++) { final x = (size.width / count) * i + (size.width / count - barWidth) / 2; final h = maxH * data[i].value; final y = baseY - h; final r = Radius.circular(barWidth / 2.0); canvas.drawRRect(RRect.fromRectAndCorners(Rect.fromLTWH(x, baseY - maxH, barWidth, maxH), topRight: r, topLeft: r), Paint()..color = backgroundColor); final rect = Rect.fromLTWH(x, y, barWidth, h); final gradient = LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [barColor.withOpacity(0.6), barColor]); canvas.drawRRect(RRect.fromRectAndCorners(rect, topRight: r, topLeft: r), Paint()..shader = gradient.createShader(rect)); final valPaint = TextPainter(text: TextSpan(text: '${(data[i].value * 100).round()}', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: barColor)), textDirection: TextDirection.ltr)..layout(); valPaint.paint(canvas, Offset(x + barWidth / 2 - valPaint.width / 2, y - 14)); final dayPaint = TextPainter(text: TextSpan(text: data[i].day, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF))), textDirection: TextDirection.ltr)..layout(); dayPaint.paint(canvas, Offset(x + barWidth / 2 - dayPaint.width / 2, baseY + 4)); } }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SleepLineChartPainter extends CustomPainter {
  final List<MoodDataPoint> data; final Color lineColor; final Color fillColor; final double goalLine;
  _SleepLineChartPainter({required this.data, required this.lineColor, required this.fillColor, required this.goalLine});
  @override void paint(Canvas canvas, Size size) { if (data.isEmpty) return; final padding = 10.0; final chartW = size.width - padding * 2; final maxH = size.height - 30; final baseY = size.height - 20; for (int i = 0; i <= 4; i++) { final y = baseY - (maxH * i / 4); canvas.drawLine(Offset(padding, y), Offset(size.width - padding, y), Paint()..color = Colors.grey.shade100..strokeWidth = 1); } final goalY = baseY - maxH * goalLine; final goalPath = Path()..moveTo(padding, goalY)..lineTo(size.width - padding, goalY); canvas.drawPath(dashPath(goalPath, dashArray: CircularIntervalList<double>(const [6.0, 4.0])), Paint()..color = const Color(0xFFFF6B6B)..strokeWidth = 1.5..style = PaintingStyle.stroke); final points = <Offset>[]; for (int i = 0; i < data.length; i++) { final x = padding + (chartW / (data.length - 1)) * i; final y = baseY - maxH * data[i].value; points.add(Offset(x, y)); } final fillPath = Path()..moveTo(points.first.dx, baseY)..lineTo(points.first.dx, points.first.dy); for (int i = 1; i < points.length; i++) { final cp1x = (points[i - 1].dx + points[i].dx) / 2; final cp1y = points[i - 1].dy; final cp2x = (points[i - 1].dx + points[i].dx) / 2; final cp2y = points[i].dy; fillPath.cubicTo(cp1x, cp1y, cp2x, cp2y, points[i].dx, points[i].dy); } fillPath.lineTo(points.last.dx, baseY); fillPath.close(); canvas.drawPath(fillPath, Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [fillColor.withOpacity(0.15), fillColor.withOpacity(0.02)]).createShader(Rect.fromLTWH(0.0, 0.0, size.width, size.height))); final linePath = Path()..moveTo(points.first.dx, points.first.dy); for (int i = 1; i < points.length; i++) { final cp1x = (points[i - 1].dx + points[i].dx) / 2; final cp1y = points[i - 1].dy; final cp2x = (points[i - 1].dx + points[i].dx) / 2; final cp2y = points[i].dy; linePath.cubicTo(cp1x, cp1y, cp2x, cp2y, points[i].dx, points[i].dy); } canvas.drawPath(linePath, Paint()..color = lineColor..strokeWidth = 2.5..style = PaintingStyle.stroke..strokeCap = StrokeCap.round); for (int i = 0; i < points.length; i++) { canvas.drawCircle(points[i], 5, Paint()..color = Colors.white); canvas.drawCircle(points[i], 3.5, Paint()..color = lineColor); final labelPaint = TextPainter(text: TextSpan(text: data[i].label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: lineColor)), textDirection: TextDirection.ltr)..layout(); labelPaint.paint(canvas, Offset(points[i].dx - labelPaint.width / 2, points[i].dy - 16)); final dayPaint = TextPainter(text: TextSpan(text: data[i].day, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF))), textDirection: TextDirection.ltr)..layout(); dayPaint.paint(canvas, Offset(points[i].dx - dayPaint.width / 2, baseY + 4)); } }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CircularProgressPainter extends CustomPainter {
  final double progress; final Color color; final Color bgColor; final double strokeWidth;
  _CircularProgressPainter({required this.progress, required this.color, required this.bgColor, required this.strokeWidth});
  @override void paint(Canvas canvas, Size size) { final center = Offset(size.width / 2, size.height / 2); final radius = size.width / 2 - strokeWidth; canvas.drawCircle(center, radius, Paint()..color = bgColor..style = PaintingStyle.stroke..strokeWidth = strokeWidth..strokeCap = StrokeCap.round); canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -math.pi / 2, 2 * math.pi * progress, false, Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = strokeWidth..strokeCap = StrokeCap.round); }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}