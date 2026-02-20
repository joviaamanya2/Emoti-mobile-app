import 'package:flutter/material.dart';

import 'recommendation_screen.dart';
import '../services/mood_history_service.dart';
// import '../services/notification_service.dart';

class EmotionDashboard extends StatefulWidget {
  const EmotionDashboard({super.key});

  @override
  State<EmotionDashboard> createState() => _EmotionDashboardState();
}

class _EmotionDashboardState extends State<EmotionDashboard> {
  String currentMood = 'confused';
  int _currentIndex = 0;

  /// 🔹 EMOJIS
  final Map<String, String> moodIcons = {
    'Confused': '😕',
    'Sad': '😢',
    'Tired': '😫',
    'Lonely': '😔',
    'Excited': '🤩',
    'Stressed': '😩',
  };

  /// 🔹 DISPLAY NAMES
  final Map<String, String> moodNames = {
    'confused': 'Confused',
    'sad': 'Sad',
    'tired': 'Tired',
    'lonely': 'Lonely',
    'excited': 'Excited',
    'stressed': 'Stressed',
  };

  /// 🔹 GRADIENTS
  final Map<String, List<Color>> moodGradients = {
    'Confused': [Colors.orange, Colors.pink],
    'Sad': [Colors.blueGrey, Colors.blue],
    'Tired': [Colors.blueGrey, Colors.blue],
    'Lonely': [Colors.teal, Colors.lightBlueAccent],
    'Excited': [Colors.purple, Colors.indigo],
    'Stressed': [Colors.amber, Colors.deepOrange],
  };

  /// 🔹 IMAGES
  final Map<String, String> moodImages = {
    'confused': 'assets/images/confused.png',
    'sad': 'assets/images/sad.png',
    'tired': 'assets/images/tired.png',
    'lonely': 'assets/images/lonely.png',
    'excited': 'assets/images/excited.png',
    'stressed': 'assets/images/stressed.png',
  };

  /// 🔹 WELLNESS TIP (RESTORED)
  final String wellnessTip =
      "Pause. Breathe slowly.\n"
      "Inhale for 4 • Hold for 4 • Exhale for 4";

  Future<void> _goToRecommendation(String mood) async {
    final emoji = moodIcons[mood] ?? '🙂';
    final gradient = moodGradients[mood] ?? [Colors.green, Colors.teal];

    await MoodHistoryService.saveMood(mood, emoji: emoji);
    // await NotificationService.scheduleMoodNotification(mood);

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RecommendationScreen(
          mood: mood,
          emoji: emoji,
          gradient: gradient,
        ),
      ),
    );
  }

  void _onBottomNavTap(int index) {
    setState(() => _currentIndex = index);
    if (index == 1 || index == 2) {
      _goToRecommendation(currentMood);
    }
  }

  @override
  Widget build(BuildContext context) {
    final heroImage =
        moodImages[currentMood] ?? 'assets/images/confused.png';

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hello!",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                      Text("Jovia",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.green)),
                    ],
                  ),
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Color(0xFFE8F5E9),
                    child: Icon(Icons.person, color: Colors.green),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              const Text(
                "How are you feeling?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 18),

              /// 🔹 MOOD SELECTOR
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: moodIcons.entries.map((entry) {
                  final mood = entry.key;
                  final emoji = entry.value;
                  final isSelected = currentMood == mood;

                  return Tooltip(
                    message: moodNames[mood] ?? mood,
                    child: GestureDetector(
                      onTap: () {
                        setState(() => currentMood = mood);
                        
                      },
                      child: AnimatedScale(
                        scale: isSelected ? 1.2 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: isSelected
                                ? LinearGradient(
                                    colors: moodGradients[mood] ??
                                        [Colors.green, Colors.teal],
                                  )
                                : null,
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: (moodGradients[mood]?.last ??
                                              Colors.black)
                                          .withOpacity(0.4),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    )
                                  ]
                                : [],
                          ),
                          child: CircleAvatar(
                            radius: 24,
                            backgroundColor: isSelected
                                ? Colors.transparent
                                : const Color(0xFFF1F1F1),
                            child: Text(emoji,
                                style: const TextStyle(fontSize: 22)),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 28),

              /// 🔹 HERO CARD
              Container(
                height: 240,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  image: DecorationImage(
                    image: AssetImage(heroImage),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.15),
                        Colors.black.withOpacity(0.55),
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        moodNames[currentMood] ?? currentMood,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Tap to get personalized recommendations",
                        style:
                            TextStyle(fontSize: 15, color: Color.fromARGB(249, 245, 240, 240)),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () =>
                            _goToRecommendation(currentMood),
                        child: const Text(
                          "Start",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              /// 🔹 WELLNESS TIP CARD (RESTORED & CLEAN)
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4CAF50), Color(0xFF64B5F6)],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.self_improvement,
                        color: Colors.white, size: 28),
                    const SizedBox(height: 12),
                    const Text(
                      "Today's Wellness Tip",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 24, 23, 23)),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      wellnessTip,
                      style: const TextStyle(
                          fontSize: 15,
                          height: 1.4,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      /// 🔹 BOTTOM NAV
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.lightbulb_outline),
              activeIcon: Icon(Icons.lightbulb),
              label: 'Recommendation'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart),
              label: 'Activity'),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              activeIcon: Icon(Icons.people),
              label: 'Counselors'),
        ],
      ),
    );
  }
}
