import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key});

  @override
  State<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  String selectedCategory = 'All';
  String searchQuery = '';

  final List<String> categories = ['All', 'Cognitive', 'Focus', 'Relaxing'];

  final List<Map<String, dynamic>> dailyRecommendations = [
    {
      'title': 'Mood Match',
      'description': 'Harmonize colors with your current vibe',
      'duration': '5 mins',
      'rating': 4.8,
      'image':
          'https://images.unsplash.com/photo-1550684848-fac1c5b4e853?auto=format&fit=crop&w=800&q=80',
    },
  ];

  final List<Map<String, dynamic>> libraryFavorites = [
    {
      'title': 'Zen Puzzles',
      'description': 'Solvability guaranteed puzzles',
      'category': 'Relaxing',
      'icon': Icons.extension,
      'color': Color(0xFF6C63FF), // Soft Purple
    },
    {
      'title': 'Pattern Path',
      'description': 'Memory strengthening',
      'category': 'Cognitive',
      'icon': Icons.psychology,
      'color': Color(0xFFFF6584), // Soft Red
    },
    {
      'title': 'Bubble Flow',
      'description': 'Stress relief bubbles',
      'category': 'Relaxing',
      'icon': Icons.bubble_chart,
      'color': Color(0xFF4FC3F7), // Light Blue
    },
    {
      'title': 'Focus Eye',
      'description': 'Attention training',
      'category': 'Focus',
      'icon': Icons.center_focus_strong,
      'color': Color(0xFFFFB74D), // Orange
    },
  ];

  List<Map<String, dynamic>> get filteredFavorites {
    return libraryFavorites.where((item) {
      final matchesCategory = selectedCategory == 'All' ||
          item['category'].toLowerCase() == selectedCategory.toLowerCase();
      final matchesSearch = searchQuery.isEmpty ||
          item['title'].toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  List<Map<String, dynamic>> get filteredDaily {
    return dailyRecommendations.where((item) {
      return searchQuery.isEmpty ||
          item['title'].toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  void openGame(String gameTitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GamePlayScreen(gameTitle: gameTitle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Lighter Blue/Cyan Theme
    final Color kLightBlue = const Color.fromARGB(255, 59, 64, 92);
    final Color kCyan = const Color.fromARGB(255, 98, 137, 139);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8), // Very light blue-grey background
      // ADDED APP BAR WITH BACK ARROW
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0F4F8), // Matches Scaffold background
        elevation: 0, // No shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Pops this screen to return to Library
          },
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // 1. Cool Header with Light Blue Gradient
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [kLightBlue, kCyan], // Lighter Blue Gradient
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      'Games Arena',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        shadows: [
                          Shadow(
                            color: Colors.blue.withOpacity(0.3),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Train your brain & relax',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.95),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.1),
                            blurRadius: 15,
                          )
                        ],
                      ),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search games...',
                          prefixIcon: const Icon(Icons.search, color: Color.fromARGB(199, 137, 209, 238)),
                          suffixIcon: Icon(Icons.tune, color: kCyan),
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 2. Categories Pills
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: SizedBox(
                height: 45,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = category == selectedCategory;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? kLightBlue : Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                      color: kLightBlue.withOpacity(0.4),
                                      blurRadius: 12)
                                ]
                              : [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 2)
                                ],
                        ),
                        child: Center(
                          child: Text(
                            category,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.grey.shade600,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // 3. Daily Recommendation
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daily Pick',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 180,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: filteredDaily.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 20),
                      itemBuilder: (context, index) {
                        final item = filteredDaily[index];
                        return GestureDetector(
                          onTap: () => openGame(item['title']),
                          child: Container(
                            width: 320,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              image: DecorationImage(
                                image: NetworkImage(item['image']),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.8),
                                  ],
                                ),
                              ),
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: kLightBlue,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'FEATURED',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    item['title'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
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
                ],
              ),
            ),
          ),

          // 4. Library Grid
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.1,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = filteredFavorites[index];
                  return _buildGameCard(item);
                },
                childCount: filteredFavorites.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 80))
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.white,
        elevation: 5,
        child: const Icon(Icons.games_outlined, color: Colors.grey),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: const Color(0xFF4FC3F7),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 10,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.apps_rounded), label: 'Games'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildGameCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () => openGame(item['title']),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: item['color'].withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: item['color'].withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Icon(item['icon'], size: 40, color: item['color']),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item['title'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['description'],
                      style: const TextStyle(fontSize: 11, color: Colors.grey, height: 1.2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= ADVANCED GAME SCREEN =================
class GamePlayScreen extends StatefulWidget {
  final String gameTitle;
  const GamePlayScreen({super.key, required this.gameTitle});

  @override
  State<GamePlayScreen> createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends State<GamePlayScreen> {
  // Mood Match
  int moodScore = 0;
  int moodLevel = 1;
  List<Color> moodColors = [];
  Color? targetMoodColor;

  // Zen Puzzle
  List<int> puzzleNumbers = [];
  int emptyIndex = 8;

  // Bubble Flow
  List<bool> bubbles = [];
  int bubbleScore = 0;
  int bubbleTime = 15;
  Timer? bubbleTimer;

  // Pattern Path
  List<int> patternSequence = [];
  List<Color> patternTiles = [];
  int playerStep = 0;
  bool isShowingPattern = false;
  int patternScore = 0;
  int patternLevel = 1;

  // Focus Eye
  int focusScore = 0;
  int focusLevel = 1;
  int correctTileIndex = 0;
  Color baseColor = Colors.blue;
  Color diffColor = Colors.blue;
  int gridSize = 2;

  // Theme Colors
  final Color kLightBlue = const Color.fromARGB(255, 24, 59, 75);

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    if (widget.gameTitle == 'Mood Match') _initMoodMatch();
    else if (widget.gameTitle == 'Zen Puzzles') _initZenPuzzle();
    else if (widget.gameTitle == 'Bubble Flow') _initBubbleFlow();
    else if (widget.gameTitle == 'Pattern Path') _initPatternPath();
    else if (widget.gameTitle == 'Focus Eye') _initFocusEye();
  }

  void _initMoodMatch() {
    moodColors = List.generate(
        moodLevel + 3,
        (index) =>
            Colors.primaries[Random().nextInt(Colors.primaries.length)]);
    targetMoodColor = moodColors[Random().nextInt(moodColors.length)];
  }

  void _initZenPuzzle() {
    puzzleNumbers = List.generate(9, (index) => index == 8 ? 0 : index + 1);
    // Reverse Shuffle: Start solved and make valid moves backwards to ensure solvability
    for (int i = 0; i < 100; i++) {
      _makeValidMoveRandomly();
    }
    emptyIndex = puzzleNumbers.indexOf(0);
  }

  void _makeValidMoveRandomly() {
    List<int> neighbors = [];
    int empty = puzzleNumbers.indexOf(0);
    int row = empty ~/ 3;
    int col = empty % 3;

    if (row > 0) neighbors.add(empty - 3); // Up
    if (row < 2) neighbors.add(empty + 3); // Down
    if (col > 0) neighbors.add(empty - 1); // Left
    if (col < 2) neighbors.add(empty + 1); // Right

    if (neighbors.isNotEmpty) {
      int randomNeighbor = neighbors[Random().nextInt(neighbors.length)];
      puzzleNumbers[empty] = puzzleNumbers[randomNeighbor];
      puzzleNumbers[randomNeighbor] = 0;
    }
  }

  void _initBubbleFlow() {
    bubbles = List.generate(9, (_) => true);
    bubbleScore = 0;
    bubbleTime = 15;
    bubbleTimer?.cancel();
    bubbleTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (bubbleTime > 0) {
            bubbleTime--;
          } else {
            bubbleTimer?.cancel();
            _showGameOverPopup();
          }
        });
      }
    });
  }

  void _initPatternPath() {
    patternSequence = [];
    patternTiles = List.generate(9, (index) => Colors.grey.shade300);
    playerStep = 0;
    isShowingPattern = false;
    patternScore = 0;
    patternLevel = 1;
    _nextPatternLevel();
  }

  void _initFocusEye() {
    _generateFocusLevel();
  }

  void _generateFocusLevel() {
    gridSize = 2 + (focusLevel ~/ 3);
    correctTileIndex = Random().nextInt(gridSize * gridSize);
    baseColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    diffColor = baseColor.withOpacity(0.6);
  }

  // ================= SUCCESS POPUP LOGIC =================
  void _showSuccessPopup({
    required String title,
    required String message,
    required int score,
    required VoidCallback onNextLevel,
    VoidCallback? onRestart,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                  color: kLightBlue.withOpacity(0.2), blurRadius: 20, spreadRadius: 5)
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: kLightBlue.withOpacity(0.2),
                child: Icon(Icons.check_circle, size: 50, color: kLightBlue),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  if (onRestart != null)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          onRestart();
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Restart", style: TextStyle(color: Colors.grey)),
                      ),
                    ),
                  if (onRestart != null) const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onNextLevel();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kLightBlue,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Next Level",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showGameOverPopup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Time's Up!"),
        content: Text("Your Score: $bubbleScore"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Go back to list
            },
            child: const Text('Exit'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _initBubbleFlow());
            },
            style: ElevatedButton.styleFrom(backgroundColor: kLightBlue),
            child: const Text("Play Again"),
          ),
        ],
      ),
    );
  }

  // Pattern Path Logic
  void _nextPatternLevel() async {
    setState(() {
      isShowingPattern = true;
      patternSequence.add(Random().nextInt(9));
      playerStep = 0;
    });

    await Future.delayed(const Duration(seconds: 1));

    for (int index in patternSequence) {
      if (!mounted) return;
      setState(() => patternTiles[index] = Colors.yellow);
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      setState(() => patternTiles[index] = Colors.grey.shade300);
      await Future.delayed(const Duration(milliseconds: 200));
    }

    if (mounted) setState(() => isShowingPattern = false);
  }

  void _handlePatternTap(int index) {
    if (isShowingPattern) return;

    if (index == patternSequence[playerStep]) {
      // Correct
      setState(() {
        patternTiles[index] = kLightBlue;
        playerStep++;
      });

      if (playerStep == patternSequence.length) {
        // Level Complete
        patternScore++;
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _showSuccessPopup(
              title: "Sequence Complete!",
              message: "Great memory! Ready for level $patternLevel?",
              score: patternScore,
              onNextLevel: () {
                patternLevel++;
                _nextPatternLevel();
              },
            );
          }
        });
      }
    } else {
      // Wrong
      setState(() => patternTiles[index] = Colors.red);
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            patternSequence = [];
            patternScore = 0;
            patternLevel = 1;
            _nextPatternLevel();
          });
        }
      });
    }
  }

  // Focus Eye Logic
  void _handleFocusTap(int index) {
    if (index == correctTileIndex) {
      // Show mini success popup or animation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: kLightBlue,
          content: Text("Level $focusLevel Complete!"),
          duration: Duration(milliseconds: 500),
        ),
      );
      
      setState(() {
        focusScore++;
        focusLevel++;
        _generateFocusLevel();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Wrong tile! Try again."))
      );
    }
  }

  @override
  void dispose() {
    bubbleTimer?.cancel();
    super.dispose();
  }

  void _showHelp() {
    String content = '';
    switch (widget.gameTitle) {
      case 'Mood Match':
        content = 'Tap the matching color.';
        break;
      case 'Zen Puzzles':
        content = 'Order numbers 1-8.';
        break;
      case 'Bubble Flow':
        content = 'Tap all bubbles before time runs out!';
        break;
      case 'Pattern Path':
        content = 'Watch the yellow tiles, then repeat.';
        break;
      case 'Focus Eye':
        content = 'Find the different shade.';
        break;
      default:
        content = 'Enjoy the game!';
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('How to Play'),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it', style: TextStyle(color: Color.fromARGB(225, 44, 57, 75))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        // Back to Previous Screen
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.gameTitle,
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.black54),
            onPressed: _showHelp,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _buildGameContent(),
      ),
    );
  }

  Widget _buildGameContent() {
    switch (widget.gameTitle) {
      case 'Mood Match':
        return Column(
          children: [
            _buildStatCard('Level', '$moodLevel', kLightBlue),
            const SizedBox(height: 40),
            const Text('Find this color:', style: TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 10),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: targetMoodColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: targetMoodColor ?? Colors.black,
                      blurRadius: 20,
                      spreadRadius: -5)
                ],
              ),
            ),
            const SizedBox(height: 50),
            Wrap(
              spacing: 15,
              runSpacing: 15,
              children: moodColors.map((c) {
                return GestureDetector(
                  onTap: () {
                    if (c == targetMoodColor) {
                      setState(() {
                        moodScore++;
                        moodLevel++;
                      });
                      _initMoodMatch();
                    }
                  },
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: c,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: c.withOpacity(0.4), blurRadius: 10)
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );

      case 'Zen Puzzles':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 9,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, mainAxisSpacing: 8, crossAxisSpacing: 8),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (_canMove(index)) {
                        setState(() {
                          puzzleNumbers[emptyIndex] = puzzleNumbers[index];
                          puzzleNumbers[index] = 0;
                          emptyIndex = index;
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: puzzleNumbers[index] == 0
                            ? Colors.grey.shade100
                            : kLightBlue.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                           if (puzzleNumbers[index] != 0)
                             BoxShadow(color: kLightBlue.withOpacity(0.2), blurRadius: 4)
                        ],
                      ),
                      child: Center(
                        child: Text(
                          puzzleNumbers[index] == 0 ? '' : '${puzzleNumbers[index]}',
                          style: TextStyle(
                              fontSize: 32,
                              color: puzzleNumbers[index] == 0 ? Colors.transparent : kLightBlue,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );

      case 'Bubble Flow':
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard('Time', '$bubbleTime', Colors.red),
                _buildStatCard('Score', '$bubbleScore', kLightBlue),
              ],
            ),
            const SizedBox(height: 30),
            AspectRatio(
              aspectRatio: 1,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: bubbles.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, mainAxisSpacing: 15, crossAxisSpacing: 15),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (bubbles[index] && bubbleTime > 0) {
                        setState(() {
                          bubbles[index] = false;
                          bubbleScore++;
                          // Check if board cleared
                          if (!bubbles.contains(true)) {
                            bubbleTime += 10; // Bonus time
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Bonus Time! +10s"), backgroundColor: kLightBlue)
                            );
                            Future.delayed(Duration(milliseconds: 500), () {
                              if(mounted) setState(() => bubbles = List.generate(9, (_) => true));
                            });
                          }
                        });
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: bubbles[index] ? kLightBlue : Colors.grey.shade200,
                        shape: BoxShape.circle,
                        boxShadow: bubbles[index]
                            ? [
                                BoxShadow(
                                    color: kLightBlue.withOpacity(0.4), blurRadius: 10)
                              ]
                            : [],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );

      case 'Pattern Path':
        return Column(
          children: [
            _buildStatCard('Level', '$patternLevel', kLightBlue),
            const SizedBox(height: 20),
            Text(isShowingPattern ? 'Watch carefully...' : 'Your turn!',
                style: const TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 20),
            AspectRatio(
              aspectRatio: 1,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10),
                itemCount: 9,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _handlePatternTap(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: patternTiles[index],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );

      case 'Focus Eye':
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard('Level', '$focusLevel', Colors.orange),
                _buildStatCard('Score', '$focusScore', kLightBlue),
              ],
            ),
            const SizedBox(height: 40),
            AspectRatio(
              aspectRatio: 1,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridSize,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: gridSize * gridSize,
                itemBuilder: (context, index) {
                  bool isDiff = index == correctTileIndex;
                  return GestureDetector(
                    onTap: () => _handleFocusTap(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDiff ? diffColor : baseColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.1), blurRadius: 4)
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        );

      default:
        return Center(child: Text('Coming Soon'));
    }
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  bool _canMove(int index) {
    int rowIndex = index ~/ 3;
    int colIndex = index % 3;
    int emptyRow = emptyIndex ~/ 3;
    int emptyCol = emptyIndex % 3;
    return (rowIndex == emptyRow && (colIndex - emptyCol).abs() == 1) ||
        (colIndex == emptyCol && (rowIndex - emptyRow).abs() == 1);
  }
}