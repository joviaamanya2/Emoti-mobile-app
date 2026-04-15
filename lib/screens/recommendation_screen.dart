import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ✅ IMPORT YOUR REAL SCREENS HERE
import 'boost_focus.dart';
import 'reduce_stress.dart';
import 'improve_sleep.dart';
import 'fitness_screen.dart';
import 'feel_happier.dart';
import 'healthy_habits.dart';
import '../screens/counselors_screen.dart';
import '../screens/settings.dart';

class RecommendationsScreen extends StatefulWidget {
  final String? mood;
  const RecommendationsScreen({super.key, this.mood});

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  int _selectedIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _buildPages();
  }

  void _buildPages() {
    _pages = [
      RecommendationsContent(mood: widget.mood),
      const InsightsScreen(),
      const SettingsScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final Color kPrimaryGreen = const Color.fromARGB(255, 99, 235, 104);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F8F6), // Match app background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Recommendations',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _pages[_selectedIndex],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const CounselorsScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryGreen,
                  elevation: 2,
                  shadowColor: kPrimaryGreen.withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Talk to a Counselor',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
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
        elevation: 10,
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

// -------------------- RECOMMENDATIONS CONTENT --------------------
class RecommendationsContent extends StatelessWidget {
  final String? mood;
   RecommendationsContent({super.key, this.mood});

  final Map<String, Map<String, String>> _recommendationData = {
    'Boost Focus': {
      'image':
          'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=800&q=80'
    },
    'Reduce Stress': {
      'image':
          'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=800&q=80'
    },
    'Improve Sleep': {
      'image':
          'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80'
    },
    'Fitness': {
      'image':
          'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?auto=format&fit=crop&w=800&q=80'
    },
    'Feel Happy': {
      'image':
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?fit=crop&w=80&h=80'
    },
    'Health Habits': {
      'image':
          'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?auto=format&fit=crop&w=800&q=80'
    },
  };

  @override
  Widget build(BuildContext context) {
    final Color kPrimaryGreen = const Color.fromARGB(255, 99, 235, 104);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (mood != null)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: kPrimaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Mood: $mood',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryGreen),
              ),
            ),

          const SizedBox(height: 10),
          const Text(
            'For You',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 16),

          /// ✅ Dynamic Vertical Cards
          ..._recommendationData.entries.map((entry) {
            return _buildRecommendationCard(
              context,
              entry.key,
              entry.value['image']!,
            );
          }).toList(),

          const SizedBox(height: 30),
          const Text(
            'Top Tips',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          _tipCard('Daily Mindfulness',
              'Take 10 minutes to practice mindfulness breathing.'),
          _tipCard('Relaxing Tonight',
              'Try light stretching or calming music before sleep.'),
          _tipCard('Stay Hydrated',
              'Drink at least 8 glasses of water to maintain energy.'),

          const SizedBox(height: 30),
          const Text(
            'Mood Music',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 16),

          SizedBox(
            height: 140,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _musicCard(
                  'Lo-Fi Chill',
                  'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?auto=format&fit=crop&w=800&q=80',
                  'https://www.youtube.com/watch?v=5qap5aO4i9A',
                ),
                _musicCard(
                  'Nature Sounds',
                  'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?fit=crop&w=80&h=80',
                  'https://www.youtube.com/watch?v=DWcJFNfaw9c',
                ),
                _musicCard(
                  'Calm Piano',
                  'https://images.unsplash.com/photo-1491553895911-0055eca6402d?auto=format&fit=crop&w=800&q=80',
                  'https://www.youtube.com/watch?v=lFcSrYw-ARY',
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20), // Bottom spacing
        ],
      ),
    );
  }

  // -------------------- RECOMMENDATION CARD --------------------
  Widget _buildRecommendationCard(
      BuildContext context, String title, String imageUrl) {
    return GestureDetector(
      onTap: () {
        Widget screen;
        switch (title) {
          case 'Boost Focus':
            screen = const FocusScreen();
            break;
          case 'Reduce Stress':
            screen = const ReduceStressScreen();
            break;
          case 'Improve Sleep':
            screen = const SleepScreen();
            break;
          case 'Fitness':
            screen = const FitnessScreen();
            break;
          case 'Feel Happy':
            screen = const FeelHappierScreen();
            break;
          case 'Health Habits':
            screen = const HealthHabitsScreen();
            break;
          default:
            screen = const FocusScreen();
        }
        Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              child: Image.network(
                imageUrl,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 90,
                    height: 90,
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  );
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Tap to explore',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Icon(
                Icons.chevron_right,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------- TIP CARD --------------------
  Widget _tipCard(String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 99, 235, 104).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lightbulb_outline_rounded,
              color: Color.fromARGB(255, 99, 235, 104),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -------------------- MUSIC CARD --------------------
  Widget _musicCard(String title, String imageUrl, String musicUrl) {
    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(musicUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child: Container(
        width: 110,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                height: 90,
                width: 110,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 90,
                    width: 110,
                    color: Colors.grey[200],
                    child: const Icon(Icons.music_note, color: Colors.grey),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------- INSIGHTS SCREEN --------------------
class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Insights',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 20),
          
          _insightCard(
            'Mindfulness Progress',
            'You have meditated 5 times this week. Great job!',
            Icons.self_improvement,
            Colors.blue,
          ),
          _insightCard(
            'Mood Trends',
            'Your mood has improved over the past 7 days.',
            Icons.trending_up,
            Colors.green,
          ),
          _insightCard(
            'Sleep Quality',
            'Average sleep duration: 7 hours 15 minutes.',
            Icons.bedtime,
            Colors.purple,
          ),
          _insightCard(
            'Fitness Activity',
            'You completed 3 workout sessions this week.',
            Icons.fitness_center,
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _insightCard(String title, String description, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}