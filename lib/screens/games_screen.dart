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
      'rating': 4.0,
      'image':
          'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80',
    },
  ];

  final List<Map<String, dynamic>> libraryFavorites = [
    {
      'title': 'Zen Puzzles',
      'description': 'Focus and alignment',
      'category': 'Relaxing',
      'icon': Icons.spa,
    },
    {
      'title': 'Pattern Path',
      'description': 'Memory strengthening',
      'category': 'Cognitive',
      'icon': Icons.lightbulb,
    },
    {
      'title': 'Bubble Flow',
      'description': 'Stress relief bubbles',
      'category': 'Relaxing',
      'icon': Icons.bubble_chart,
    },
    {
      'title': 'Focus Eye',
      'description': 'Attention training',
      'category': 'Focus',
      'icon': Icons.remove_red_eye,
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Games'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      // ADDED: SingleChildScrollView to make the whole screen scrollable
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search games',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
            ),
            const SizedBox(height: 16),
            // Categories
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = category == selectedCategory;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.green : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          category,
                          style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            const Text('Daily Recommendations',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            SizedBox(
              height: 140,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: filteredDaily.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final item = filteredDaily[index];
                  return GestureDetector(
                    onTap: () => openGame(item['title']),
                    child: Container(
                      width: 220,
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  item['image'],
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: Colors.grey.shade200,
                                    child: const Icon(Icons.image, size: 40),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(item['title'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(height: 4),
                            Text(item['description'],
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey.shade700)),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(item['duration'],
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade700)),
                                GestureDetector(
                                  onTap: () => openGame(item['title']),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      'Play',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Library Favorites',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                TextButton(
                  onPressed: () {},
                  child: const Text('See all'),
                ),
              ],
            ),
            // CHANGED: Removed Expanded and added shrinkWrap to allow scrolling within the main column
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredFavorites.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.5,
              ),
              itemBuilder: (context, index) {
                final item = filteredFavorites[index];
                return GestureDetector(
                  onTap: () => openGame(item['title']),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Icon(item['icon'], color: Colors.green, size: 32),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['title'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                              const SizedBox(height: 4),
                              Text(item['description'],
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20) // Extra padding at bottom
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.library_books), label: 'Library'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
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
  // --- Mood Match State ---
  int moodScore = 0;
  int moodLevel = 1;
  List<Color> moodColors = [];
  Color? targetMoodColor;

  // --- Zen Puzzle State ---
  List<int> puzzleNumbers = [];
  int emptyIndex = 8;

  // --- Bubble Flow State ---
  List<bool> bubbles = [];
  int bubbleScore = 0;
  int bubbleTime = 15;
  Timer? bubbleTimer;

  // --- Pattern Path State (New) ---
  List<int> patternSequence = [];
  List<Color> patternTiles = []; // To show highlighted state
  int playerStep = 0;
  bool isShowingPattern = false;
  int patternScore = 0;

  // --- Focus Eye State (New) ---
  int focusScore = 0;
  int focusLevel = 1;
  int correctTileIndex = 0;
  Color baseColor = Colors.blue;
  Color diffColor = Colors.blue;
  int gridSize = 2; // Starts 2x2

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    if (widget.gameTitle == 'Mood Match') {
      _initMoodMatch();
    } else if (widget.gameTitle == 'Zen Puzzles') {
      _initZenPuzzle();
    } else if (widget.gameTitle == 'Bubble Flow') {
      _initBubbleFlow();
    } else if (widget.gameTitle == 'Pattern Path') {
      _initPatternPath();
    } else if (widget.gameTitle == 'Focus Eye') {
      _initFocusEye();
    }
  }

  // --- Init Methods ---
  void _initMoodMatch() {
    moodColors = List.generate(moodLevel + 3, (index) => Colors.primaries[Random().nextInt(Colors.primaries.length)]);
    targetMoodColor = moodColors[Random().nextInt(moodColors.length)];
  }

  void _initZenPuzzle() {
    puzzleNumbers = List.generate(9, (index) => index == 8 ? 0 : index + 1);
    // Simple shuffle for demo (might not be solvable in complex scenarios but works for basic UX)
    puzzleNumbers.shuffle(); 
    emptyIndex = puzzleNumbers.indexOf(0);
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
    _nextPatternLevel();
  }

  void _initFocusEye() {
    _generateFocusLevel();
  }

  void _generateFocusLevel() {
    // Grid size increases every 3 levels
    gridSize = 2 + (focusLevel ~/ 3);
    int totalTiles = gridSize * gridSize;
    
    correctTileIndex = Random().nextInt(totalTiles);
    
    // Pick a random base color
    baseColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    
    // Create a slightly different color
    diffColor = baseColor.withOpacity(0.7); // Make it lighter/darker
  }

  // --- Game Logic Methods ---

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
      setState(() {
        patternTiles[index] = Colors.yellow;
      });
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      setState(() {
        patternTiles[index] = Colors.grey.shade300;
      });
      await Future.delayed(const Duration(milliseconds: 200));
    }

    if (mounted) {
      setState(() {
        isShowingPattern = false;
      });
    }
  }

  void _handlePatternTap(int index) {
    if (isShowingPattern) return;

    if (index == patternSequence[playerStep]) {
      // Correct
      setState(() {
        patternTiles[index] = Colors.green;
        playerStep++;
      });
      
      if (playerStep == patternSequence.length) {
        // Level complete
        patternScore++;
        Future.delayed(const Duration(milliseconds: 500), () {
           if (mounted) _nextPatternLevel();
        });
      }
    } else {
      // Wrong
      setState(() {
        patternTiles[index] = Colors.red;
      });
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
             patternSequence = [];
             patternScore = 0;
             _nextPatternLevel();
          });
        }
      });
    }
  }

  // Focus Eye Logic
  void _handleFocusTap(int index) {
    if (index == correctTileIndex) {
      setState(() {
        focusScore++;
        focusLevel++;
        _generateFocusLevel();
      });
    } else {
      // Optional: Penalty or shake effect
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
    String title = '';
    String content = '';

    switch (widget.gameTitle) {
      case 'Mood Match':
        title = 'How to Play Mood Match';
        content = 'Look at the target color at the top. Tap the matching color from the grid below. Levels get harder with more colors!';
        break;
      case 'Zen Puzzles':
        title = 'How to Play Zen Puzzles';
        content = 'Tap the tiles adjacent to the empty space to slide them. Arrange the numbers in order (1 to 8) with the empty space at the end.';
        break;
      case 'Bubble Flow':
        title = 'How to Play Bubble Flow';
        content = 'Pop as many bubbles as you can before time runs out! Tap the blue circles to score points.';
        break;
      case 'Pattern Path':
        title = 'How to Play Pattern Path';
        content = 'Watch the sequence of yellow tiles carefully. Once the sequence finishes, tap the tiles in the exact same order. Test your memory!';
        break;
      case 'Focus Eye':
        title = 'How to Play Focus Eye';
        content = 'Find the "Odd One Out". One tile is a slightly different shade than the others. Tap it to advance to the next level.';
        break;
      default:
        title = 'Game Info';
        content = 'Enjoy the game!';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gameTitle),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showHelp,
          )
        ],
      ),
      body: _buildGameContent(),
    );
  }

  Widget _buildGameContent() {
    switch (widget.gameTitle) {
      case 'Mood Match':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Level $moodLevel', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: targetMoodColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black26)
                )),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
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
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: c,
                        borderRadius: BorderRadius.circular(12),
                      )),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Text('Score: $moodScore', style: const TextStyle(fontSize: 20)),
          ],
        );

      case 'Zen Puzzles':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Slide Puzzle', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            AspectRatio(
              aspectRatio: 1,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 9,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
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
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: puzzleNumbers[index] == 0 ? Colors.grey.shade300 : Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          puzzleNumbers[index] == 0 ? '' : '${puzzleNumbers[index]}',
                          style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Time: $bubbleTime s', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 10),
            Text('Score: $bubbleScore', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              itemCount: bubbles.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (bubbles[index] && bubbleTime > 0) {
                      setState(() {
                        bubbles[index] = false;
                        bubbleScore++;
                      });
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: bubbles[index] ? Colors.blue : Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
            if (bubbleTime == 0)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _initBubbleFlow();
                    });
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text("Play Again"),
                ),
              )
          ],
        );

      case 'Pattern Path':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Score: $patternScore', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 10),
            Text(isShowingPattern ? 'Watch carefully...' : 'Your turn!', style: const TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 20),
            AspectRatio(
              aspectRatio: 1,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10),
                itemCount: 9,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _handlePatternTap(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: patternTiles[index],
                        borderRadius: BorderRadius.circular(8),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Level $focusLevel', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 10),
            Text('Score: $focusScore', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 40),
            SizedBox(
              width: 300,
              height: 300,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridSize,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: gridSize * gridSize,
                itemBuilder: (context, index) {
                  bool isDiff = index == correctTileIndex;
                  return GestureDetector(
                    onTap: () => _handleFocusTap(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDiff ? diffColor : baseColor,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(2, 2),
                          )
                        ]
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        );

      default:
        return Center(
            child: Text('🎮 ${widget.gameTitle}\nGame coming soon!',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20)));
    }
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