// import 'package:emoti_app/screens/splash_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// import 'counselors_screen.dart'; 

// // Import your four full screens
// import 'videos_screen.dart';
// import 'games_screen.dart';
// import 'fitness_screen.dart';
// import 'quotes_screen.dart';

// class RecommendationScreen extends StatefulWidget {
//   final String mood;
//   final String emoji;
//   final List<Color> gradient;

//   const RecommendationScreen({
//     super.key,
//     required this.mood,
//     required this.emoji,
//     required this.gradient,
//   });

//   @override
//   State<RecommendationScreen> createState() => _RecommendationScreenState();
// }

// class _RecommendationScreenState extends State<RecommendationScreen> {
//   late YoutubePlayerController _videoController;
//   late YoutubePlayerController _musicController;
//   final List<String> _customTips = [];

//   /// 🔹 Bottom Navigation State
//   int _currentIndex = 1; // Start on Recommendation tab

//   void _onBottomNavTap(int index) {
//     if (index == 3) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => const CounselorsScreen()),
//       );
//       return;
//     }

//     setState(() {
//       _currentIndex = index;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();

//     final moodVideos = {
//       'Calm': '2OEL4P1Rz04',
//       'Happy': '3GwjfUFyY6M',
//       'Stressed': 'inpok4MKVLM',
//       'Angry': 'wzjWIxXBs_s',
//       'Tired': '4pKly2JojMw',
//       'Neutral': '6p_yaNFSYao',
//       'Confused': 'v7AYKMP6rOE',
//       'Lonely': '6z6vQqf2t2E',
//     };

//     final moodMusic = {
//       'Calm': '5qap5aO4i9A',
//       'Happy': 'ZM3KAw6qv94',
//       'Stressed': 'kXYiU_JCYtU',
//       'Angry': 'XmpYhx9FLk8',
//       'Tired': '1vx8iUvfyCY',
//       'Neutral': '6p_yaNFSYao',
//     };

//     final vid = moodVideos[widget.mood] ?? '2OEL4P1Rz04';
//     final mus = moodMusic[widget.mood] ?? '5qap5aO4i9A';

//     _videoController = YoutubePlayerController(
//       initialVideoId: vid,
//       flags: const YoutubePlayerFlags(autoPlay: false),
//     );

//     _musicController = YoutubePlayerController(
//       initialVideoId: mus,
//       flags: const YoutubePlayerFlags(autoPlay: false, loop: true),
//     );
//   }

//   @override
//   void dispose() {
//     _videoController.dispose();
//     _musicController.dispose();
//     super.dispose();
//   }

//   List<String> _tipsForMood(String mood) {
//     switch (mood) {
//       case 'Calm':
//         return ['Continue deep breaths (4-4-4)', 'Short mindful walk', 'Gratitude list (3 things)'];
//       case 'Stressed':
//         return ['Grounding 5-4-3-2-1', 'Box breathing 4-4-4', '5-min guided session'];
//       case 'Happy':
//         return ['Share with a friend', 'Short dance break', 'Gratitude journaling'];
//       case 'Angry':
//         return ['Physical release', 'Cooling breath', 'Write one small action'];
//       case 'Tired':
//         return ['Power nap (20min)', 'Hydrate + walk', 'Light stretching'];
//       default:
//         return ['Take 3 deep breaths', 'Step outside for a minute'];
//     }
//   }

//   void _addTip() {
//     String tip = '';
//     showDialog(
//       context: context,
//       builder: (_) {
//         return AlertDialog(
//           title: const Text('Add Tip'),
//           content: TextField(
//             onChanged: (v) => tip = v,
//             maxLines: 3,
//           ),
//           actions: [
//             TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('Cancel')),
//             ElevatedButton(
//               onPressed: () {
//                 if (tip.trim().isNotEmpty) {
//                   setState(() {
//                     _customTips.insert(0, tip.trim());
//                   });
//                 }
//                 Navigator.pop(context);
//               },
//               child: const Text('Add'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   /// 🔹 TILES NAVIGATION METHODS
//   void _showVideoList() {
//     Navigator.push(context, MaterialPageRoute(builder: (_) => const VideosScreen()));
//   }

//   void _showGames() {
//     Navigator.push(context, MaterialPageRoute(builder: (_) => const GamesScreen()));
//   }

//   void _showFitness() {
//     Navigator.push(context, MaterialPageRoute(builder: (_) => const FitnessScreen()));
//   }

//   void _showQuote() {
//     Navigator.push(context, MaterialPageRoute(builder: (_) => const QuotesScreen()));
//   }

//   /// 🔹 RECOMMENDATION TAB UI
//   Widget _recommendationTab() {
//     final tips = [..._tipsForMood(widget.mood), ..._customTips];

//     return YoutubePlayerBuilder(
//       player: YoutubePlayer(
//         controller: _videoController,
//         showVideoProgressIndicator: true,
//       ),
//       builder: (context, player) {
//         return Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: widget.gradient,
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//           child: SafeArea(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   /// HEADER
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               widget.mood,
//                               style: const TextStyle(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                             const SizedBox(height: 6),
//                             const Text(
//                               "Personalized wellbeing suggestions",
//                               style: TextStyle(color: Colors.white70),
//                             )
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 20),

//                   /// TIPS
//                   const Text(
//                     "Top Tips",
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18),
//                   ),
//                   const SizedBox(height: 8),

//                   ...tips.map(
//                     (t) => Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.all(12),
//                       margin: const EdgeInsets.symmetric(vertical: 6),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.12),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.check_circle_outline,
//                               color: Colors.white70),
//                           const SizedBox(width: 10),
//                           Expanded(
//                               child: Text(t,
//                                   style:
//                                       const TextStyle(color: Colors.white))),
//                         ],
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 20),

//                   /// VIDEO
//                   const Text(
//                     "Recommended Video",
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18),
//                   ),
//                   const SizedBox(height: 8),
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: player,
//                   ),

//                   const SizedBox(height: 20),

//                   /// MUSIC
//                   const Text(
//                     "Mood Music",
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18),
//                   ),
//                   const SizedBox(height: 8),
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: YoutubePlayer(controller: _musicController),
//                   ),

//                   const SizedBox(height: 25),

//                   /// TILES
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _tile(
//                             "Videos",
//                             Icons.play_circle_fill,
//                             Colors.deepPurpleAccent,
//                             _showVideoList),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child:
//                             _tile("Games", Icons.videogame_asset, Colors.teal, _showGames),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 12),

//                   Row(
//                     children: [
//                       Expanded(
//                         child: _tile("Fitness", Icons.fitness_center,
//                             const Color.fromARGB(255, 16, 68, 5), _showFitness),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: _tile("Quote", Icons.format_quote, Colors.indigo, _showQuote),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 30),

//                   /// BACK + SAVE
//                   Row(
//                     children: [
//                       ElevatedButton.icon(
//                         onPressed: () => Navigator.pop(context),
//                         icon: const Icon(Icons.arrow_back),
//                         label: const Text("Back"),
//                       ),
//                       const SizedBox(width: 12),
//                       ElevatedButton.icon(
//                         onPressed: _addTip,
//                         label: const Text("More"),
//                       ),
//                       const Spacer(),
                      
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _tile(String title, IconData icon, Color color, Function() onTap) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         height: 95,
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               color.withOpacity(0.95),
//               color.withOpacity(0.75),
//             ],
//           ),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Icon(icon, color: Colors.white, size: 28),
//             const Spacer(),
//             Text(
//               title,
//               style: const TextStyle(
//                   color: Colors.white, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 4),
//             const Text(
//               "Open suggestions",
//               style: TextStyle(color: Colors.white70, fontSize: 12),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final tabs = [
//       const SplashScreen(),
//       _recommendationTab(),
//       _recommendationTab(),
//     ];

//     return Scaffold(
//       body: tabs[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: _onBottomNavTap,
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: Colors.green,
//         unselectedItemColor: Colors.grey,
//         items: const [
//           BottomNavigationBarItem(
//               icon: Icon(Icons.home_outlined),
//               activeIcon: Icon(Icons.home),
//               label: 'Home'),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.lightbulb_outline),
//               activeIcon: Icon(Icons.lightbulb),
//               label: 'Recommendation'),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.bar_chart_outlined),
//               activeIcon: Icon(Icons.bar_chart),
//               label: 'Activity'),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.people_outline),
//               activeIcon: Icon(Icons.people),
//               label: 'Counselors'),
//         ],
//       ),
//     );
//   }
// }
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'counselors_screen.dart';
import 'videos_screen.dart';
import 'games_screen.dart';
import 'fitness_screen.dart';
import 'quotes_screen.dart';
import 'splash_screen.dart';

class RecommendationScreen extends StatefulWidget {
  final String mood;
  final String emoji;
  final List<Color> gradient;

  const RecommendationScreen({
    super.key,
    required this.mood,
    required this.emoji,
    required this.gradient,
  });

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen>
    with SingleTickerProviderStateMixin {
  late YoutubePlayerController _videoController;
  late YoutubePlayerController _musicController;
  final List<String> _customTips = [];

  int _currentIndex = 1;

  void _onBottomNavTap(int index) {
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CounselorsScreen()),
      );
      return;
    }
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    final moodVideos = {
      'Calm': '2OEL4P1Rz04',
      'Happy': '3GwjfUFyY6M',
      'Stressed': 'inpok4MKVLM',
      'Angry': 'wzjWIxXBs_s',
      'Tired': '4pKly2JojMw',
      'Neutral': '6p_yaNFSYao',
      'Confused': 'v7AYKMP6rOE',
      'Lonely': '6z6vQqf2t2E',
    };

    final moodMusic = {
      'Calm': '5qap5aO4i9A',
      'Happy': 'ZM3KAw6qv94',
      'Stressed': 'kXYiU_JCYtU',
      'Angry': 'XmpYhx9FLk8',
      'Tired': '1vx8iUvfyCY',
      'Neutral': '6p_yaNFSYao',
    };

    final vid = moodVideos[widget.mood] ?? '2OEL4P1Rz04';
    final mus = moodMusic[widget.mood] ?? '5qap5aO4i9A';

    _videoController = YoutubePlayerController(
      initialVideoId: vid,
      flags: const YoutubePlayerFlags(autoPlay: false),
    );

    _musicController = YoutubePlayerController(
      initialVideoId: mus,
      flags: const YoutubePlayerFlags(autoPlay: false, loop: true),
    );
  }

  @override
  void dispose() {
    _videoController.dispose();
    _musicController.dispose();
    super.dispose();
  }

  List<String> _tipsForMood(String mood) {
    switch (mood) {
      case 'Calm':
        return ['Continue deep breaths (4-4-4)', 'Short mindful walk', 'Gratitude list (3 things)'];
      case 'Stressed':
        return ['Grounding 5-4-3-2-1', 'Box breathing 4-4-4', '5-min guided session'];
      case 'Happy':
        return ['Share with a friend', 'Short dance break', 'Gratitude journaling'];
      case 'Angry':
        return ['Physical release', 'Cooling breath', 'Write one small action'];
      case 'Tired':
        return ['Power nap (20min)', 'Hydrate + walk', 'Light stretching'];
      default:
        return ['Take 3 deep breaths', 'Step outside for a minute'];
    }
  }

  /// Tiles Navigation
  void _showVideoList() => Navigator.push(context, MaterialPageRoute(builder: (_) => const VideosScreen()));
  void _showGames() => Navigator.push(context, MaterialPageRoute(builder: (_) => const GamesScreen()));
  void _showFitness() => Navigator.push(context, MaterialPageRoute(builder: (_) => const FitnessScreen()));
  void _showQuote() => Navigator.push(context, MaterialPageRoute(builder: (_) => const QuotesScreen()));

  Widget _recommendationTab() {
    final tips = [..._tipsForMood(widget.mood), ..._customTips];

    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _videoController,
        showVideoProgressIndicator: true,
      ),
      builder: (context, player) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// HEADER
                  Row(
                    children: [
                      Text(widget.emoji, style: const TextStyle(fontSize: 40)),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.mood,
                              style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [Shadow(color: Colors.black45, blurRadius: 4)])),
                          const SizedBox(height: 4),
                          const Text("Personalized wellbeing suggestions",
                              style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// TIPS
                  const Text("Top Tips",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                  const SizedBox(height: 12),

                  ...tips.map(
                    (t) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle_outline, color: Colors.white70),
                                const SizedBox(width: 12),
                                Expanded(child: Text(t, style: const TextStyle(color: Colors.white, fontSize: 16))),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// VIDEO
                  const Text("Recommended Video",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: player,
                  ),

                  const SizedBox(height: 20),

                  /// MUSIC
                  const Text("Mood Music",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: YoutubePlayer(controller: _musicController),
                  ),

                  const SizedBox(height: 25),

                  /// TILES
                  Row(
                    children: [
                      Expanded(child: _tile("Videos", Icons.play_circle_fill, Colors.deepPurpleAccent, _showVideoList)),
                      const SizedBox(width: 12),
                      Expanded(child: _tile("Games", Icons.videogame_asset, Colors.teal, _showGames)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _tile("Fitness", Icons.fitness_center, Colors.orange, _showFitness)),
                      const SizedBox(width: 12),
                      Expanded(child: _tile("Quote", Icons.format_quote, Colors.indigo, _showQuote)),
                    ],
                  ),

                  const SizedBox(height: 30),

                  /// BACK + MORE
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                        label: const Text("Back"),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 243, 239, 239)),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MoreTipsScreen(
                                customTips: _customTips,
                                defaultTips: _tipsForMood(widget.mood),
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.more_horiz),
                        label: const Text("More"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 239, 238, 241),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _tile(String title, IconData icon, Color color, Function() onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color.withOpacity(0.95), color.withOpacity(0.75)]),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6, offset: const Offset(0, 3))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const Spacer(),
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text("Open suggestions", style: TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [const SplashScreen(), _recommendationTab(), _recommendationTab()];
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.lightbulb_outline), activeIcon: Icon(Icons.lightbulb), label: 'Recommendation'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), activeIcon: Icon(Icons.bar_chart), label: 'Activity'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), activeIcon: Icon(Icons.people), label: 'Counselors'),
        ],
      ),
    );
  }
}

/// MORE TIPS SCREEN
class MoreTipsScreen extends StatelessWidget {
  final List<String> customTips;
  final List<String> defaultTips;

  const MoreTipsScreen({
    super.key,
    required this.customTips,
    required this.defaultTips,
  });

  @override
  Widget build(BuildContext context) {
    final tips = [...defaultTips, ...customTips];
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Tips'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tips.length,
        itemBuilder: (_, index) {
          return Card(
            elevation: 5,
            shadowColor: Colors.black45,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: const Icon(Icons.check_circle_outline, color: Colors.deepPurpleAccent),
              title: Text(tips[index], style: const TextStyle(fontWeight: FontWeight.w500)),
            ),
          );
        },
      ),
    );
  }
}

