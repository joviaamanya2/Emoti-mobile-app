import 'package:flutter/material.dart';
// Keeping your requested imports
import '../screens/fitness_screen.dart';
import 'videos.dart';
import '../screens/games_screen.dart';
import 'quotes_screen.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mental Health App',
      theme: ThemeData(
        primaryColor: const Color(0xFF4CAF50),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'SF Pro Display',
      ),
      home: const LibraryScreen(),
    );
  }
}

// --- LIBRARY SCREEN ---
class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  int _selectedCategoryIndex = 0;
  final List<String> _categories = ['All', 'Articles', 'Exercises', 'Bible'];

  // ===== Dynamic Bible Data =====
  late String _dailyVerse;
  late String _dailyVerseRef;
  String _selectedBibleVersion = 'KJV';

  // Bible Database Mock (for Daily Verse and Explorer)
  final Map<String, Map<String, String>> _bibleData = {
    'John 3:16': {
      'KJV': 'For God so loved the world, that he gave his only begotten Son, that whosoever believeth in him should not perish, but have everlasting life.',
      'NLT': 'For this is how God loved the world: He gave his one and only Son, so that everyone who believes in him will not perish but have eternal life.',
      'GNB': 'For God loved the world so much that he gave his only Son, so that everyone who believes in him may not die but have eternal life.',
      'MSG': 'This is how much God loved the world: He gave his Son, his one and only Son. And this is why: so that no one need be destroyed; by believing in him, anyone can have a whole and lasting life.'
    },
    'Psalm 23:1': {
      'KJV': 'The LORD is my shepherd; I shall not want.',
      'NLT': 'The LORD is my shepherd; I have all that I need.',
      'GNB': 'The LORD is my shepherd; I have everything I need.',
      'MSG': 'GOD, my shepherd! I don\'t need a thing.'
    },
    'Philippians 4:13': {
      'KJV': 'I can do all things through Christ which strengtheneth me.',
      'NLT': 'For I can do everything through Christ, who gives me strength.',
      'GNB': 'I have the strength to face all conditions by the power that Christ gives me.',
      'MSG': 'Whatever I have, wherever I am, I can make it through anything in the One who makes me who I am.'
    },
    'Jeremiah 29:11': {
      'KJV': 'For I know the thoughts that I think toward you, saith the LORD, thoughts of peace, and not of evil, to give you an expected end.',
      'NLT': 'For I know the plans I have for you,” says the LORD. “They are plans for good and not for disaster, to give you a future and a hope.',
      'GNB': 'I alone know the plans I have for you, plans to bring you prosperity and not disaster, plans to bring about the future you hope for.',
      'MSG': 'I know what I\'m doing. I have it all planned out—plans to take care of you, not abandon you, plans to give you the future you hope for.'
    },
    'Proverbs 3:5': {
      'KJV': 'Trust in the LORD with all thine heart; and lean not unto thine own understanding.',
      'NLT': 'Trust in the LORD with all your heart; do not depend on your own understanding.',
      'GNB': 'Trust in the LORD with all your heart. Never rely on what you think you know.',
      'MSG': 'Trust GOD from the bottom of your heart; don\'t try to figure out everything on your own.'
    }
  };

  final List<ArticleItem> _articles = [
    ArticleItem(
      title: 'Understanding Emotions',
      description:
          'Learn how to identify and handle complex emotions effectively.',
      content:
          'Emotional intelligence is the ability to understand, use, and manage your own emotions in positive ways to relieve stress, communicate effectively, empathize with others, overcome challenges and defuse conflict.',
      thumbnailType: ThumbnailType.icon,
      iconData: Icons.psychology,
      iconBackgroundColor: const Color(0xFF2C3E50),
    ),
    ArticleItem(
      title: 'Common Challenges',
      description:
          'Explore modern barriers like anxiety, stress, and how to overcome them.',
      content:
          'In our fast-paced world, anxiety and stress have become common companions. Understanding the triggers is the first step. Techniques such as cognitive behavioral therapy (CBT), mindfulness, and grounding exercises can significantly reduce the impact of these challenges.',
      thumbnailType: ThumbnailType.image,
      imageUrl:
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&q=80',
    ),
    ArticleItem(
      title: 'Daily Practices',
      description:
          'Small habits and routines that can significantly improve your mental state.',
      content:
          'Consistency is key. Small daily habits like drinking water, journaling for 5 minutes, practicing gratitude, and taking short walks can rewire your brain for positivity. Start small and build up gradually.',
      thumbnailType: ThumbnailType.image,
      imageUrl:
          'https://images.unsplash.com/photo-1483058712412-4245e9b90334?w=400&q=80',
    ),
  ];

  final List<ExerciseItem> _exercises = [
    ExerciseItem(
      title: 'Games',
      subtitle: 'Mindfulness & focus',
      icon: Icons.games_rounded,
      color: Colors.blue.shade100,
      iconColor: Colors.blue,
      screen: const GamesScreen(), // Ensure this file exists
    ),
    ExerciseItem(
      title: 'Videos',
      subtitle: 'Guided sessions',
      icon: Icons.play_circle_outline_rounded,
      color: Colors.red.shade100,
      iconColor: Colors.red,
      screen: const VideosScreen(), // Ensure this file exists
    ),
    ExerciseItem(
      title: 'Fitness',
      subtitle: 'Body & mind flow',
      icon: Icons.fitness_center_rounded,
      color: Colors.green.shade100,
      iconColor: Colors.green,
      screen: const FitnessScreen(), // Ensure this file exists
    ),
    ExerciseItem(
      title: 'Daily Quotes',
      subtitle: 'Daily inspiration',
      icon: Icons.format_quote_rounded,
      color: Colors.purple.shade100,
      iconColor: Colors.purple,
      screen: const DailyWisdomScreen(), // Ensure this file exists
    ),
  ];

  // ===== Journal Storage =====
  List<JournalEntry> journals = [];

  @override
  void initState() {
    super.initState();
    _updateDailyVerse();
  }

  void _updateDailyVerse() {
    // Change verse based on the day of the month
    int dayIndex = DateTime.now().day % _bibleData.length;
    String key = _bibleData.keys.elementAt(dayIndex);
    setState(() {
      _dailyVerseRef = key;
      _dailyVerse = _bibleData[key]![_selectedBibleVersion]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Library", style: TextStyle(color: Colors.black87)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87, size: 26),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildCategoryTabs(),
            const SizedBox(height: 24),
            Expanded(child: _buildContentList()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final newJournal = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const JournalEditor()),
          );
          if (newJournal != null && newJournal is JournalEntry) {
            setState(() => journals.add(newJournal));
          }
        },
        icon: const Icon(Icons.create),
        label: const Text("Create Journal"),
        backgroundColor: const Color(0xFF4CAF50),
      ),
    );
  }

  // ===== Widgets =====
  Widget _buildContentList() {
    switch (_selectedCategoryIndex) {
      case 0: // All
        return ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const Text("Featured Articles",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ..._articles.map(_buildArticleCard),
            const SizedBox(height: 24),
            const Text("Exercises",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildExercisesGrid(),
            const SizedBox(height: 24),
            if (journals.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Journal History",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("View All", style: TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 12),
              ...journals.map(_journalCard),
              const SizedBox(height: 80), // Padding for FAB
            ]
          ],
        );
      case 1: // Articles
        return _buildArticlesList();
      case 2: // Exercises
        return _buildExercisesGrid();
      case 3: // Bible
        return _buildBibleSection();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildCategoryTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_categories.length, (index) {
          bool isSelected = _selectedCategoryIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategoryIndex = index),
            child: Container(
              margin: const EdgeInsets.only(right: 24),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color:
                        isSelected ? const Color(0xFF4CAF50) : Colors.transparent,
                    width: 3,
                  ),
                ),
              ),
              child: Text(
                _categories[index],
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.black : Colors.grey,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildArticlesList() {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: _articles.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, index) => _buildArticleCard(_articles[index]),
    );
  }

  Widget _buildArticleCard(ArticleItem article) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ArticleDetailScreen(article: article)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _buildThumbnail(article)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(article.title,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87)),
                  const SizedBox(height: 6),
                  Text(article.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                          height: 1.3)),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  ArticleDetailScreen(article: article)),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF4CAF50),
                      ),
                      child: const Text('Read More', style: TextStyle(fontWeight: FontWeight.bold)),
                    )
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail(ArticleItem article) {
    if (article.thumbnailType == ThumbnailType.icon) {
      return Container(
        width: 80,
        height: 90,
        color: article.iconBackgroundColor ?? Colors.grey,
        child: Center(
            child: Icon(article.iconData ?? Icons.help_outline,
                color: Colors.white, size: 40)),
      );
    } else {
      return Image.network(
        article.imageUrl ?? '',
        width: 80,
        height: 90,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: 80,
          height: 90,
          color: Colors.grey.shade300,
          child: const Icon(Icons.broken_image, color: Colors.grey),
        ),
      );
    }
  }

  Widget _buildExercisesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _exercises.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (_, index) => _buildExerciseCard(_exercises[index]),
    );
  }

  Widget _buildExerciseCard(ExerciseItem exercise) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => exercise.screen),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: exercise.color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: Icon(exercise.icon, size: 32, color: exercise.iconColor),
            ),
            const SizedBox(height: 12),
            Text(exercise.title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87)),
            const SizedBox(height: 4),
            Text(exercise.subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
          ],
        ),
      ),
    );
  }

  // ===== Journal Card =====
  Widget _journalCard(JournalEntry journal) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(journal.favorite ? Icons.star : Icons.star_border, color: Colors.amber),
                  onPressed: () => setState(() => journal.favorite = !journal.favorite),
                  visualDensity: VisualDensity.compact,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.share, size: 20),
                  onPressed: () => Share.share(journal.text),
                  visualDensity: VisualDensity.compact,
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () async {
                    final edited = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => JournalEditor(entry: journal)),
                    );
                    if (edited != null && edited is JournalEntry) {
                      setState(() {
                        final index = journals.indexOf(journal);
                        if (index != -1) journals[index] = edited;
                      });
                    }
                  },
                  visualDensity: VisualDensity.compact,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                  onPressed: () => setState(() => journals.remove(journal)),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              journal.text,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  // ===== Bible Section =====
  Widget _buildBibleSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Daily Verse Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade100, Colors.orange.shade200],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.shade100.withOpacity(0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: Colors.deepOrange),
                    const SizedBox(width: 8),
                    Text("Daily Verse (${DateTime.now().day}/${DateTime.now().month})",
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                  ],
                ),
                const SizedBox(height: 16),
                Text(_dailyVerse,
                    style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic, height: 1.4)),
                const SizedBox(height: 12),
                Text(_dailyVerseRef,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54)),
              ],
            ),
          ),
          
          const SizedBox(height: 30),

          // Version Selector
          const Text("Select Version", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: ['KJV', 'NLT', 'GNB', 'MSG'].map((version) {
              bool isSelected = _selectedBibleVersion == version;
              return ChoiceChip(
                label: Text(version),
                selected: isSelected,
                onSelected: (bool selected) {
                  setState(() {
                    _selectedBibleVersion = version;
                    _updateDailyVerse(); // Update daily verse text based on version
                  });
                },
                selectedColor: const Color(0xFF4CAF50),
                labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
              );
            }).toList(),
          ),

          const SizedBox(height: 30),

          // Explorer
          const Text("Explore the Bible", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => BibleExplorerScreen(bibleData: _bibleData)),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.menu_book, color: Colors.blue, size: 30),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Search Scripture", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text("Read any verse, chapter, or book", style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, color: Colors.blue.shade300, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- BIBLE EXPLORER SCREEN ---
class BibleExplorerScreen extends StatefulWidget {
  final Map<String, Map<String, String>> bibleData;
  const BibleExplorerScreen({super.key, required this.bibleData});

  @override
  State<BibleExplorerScreen> createState() => _BibleExplorerScreenState();
}

class _BibleExplorerScreenState extends State<BibleExplorerScreen> {
  String _selectedVersion = 'KJV';

  // Lists for dropdowns
  final List<String> _books = [
    'Genesis', 'Exodus', 'Leviticus', 'Numbers', 'Deuteronomy',
    'Joshua', 'Judges', 'Ruth', '1 Samuel', '2 Samuel',
    '1 Kings', '2 Kings', '1 Chronicles', '2 Chronicles',
    'Ezra', 'Nehemiah', 'Esther', 'Job', 'Psalm', 'Proverbs',
    'Ecclesiastes', 'Song of Solomon', 'Isaiah', 'Jeremiah',
    'Lamentations', 'Ezekiel', 'Daniel', 'Hosea', 'Joel',
    'Amos', 'Obadiah', 'Jonah', 'Micah', 'Nahum',
    'Habakkuk', 'Zephaniah', 'Haggai', 'Zechariah', 'Malachi',
    'Matthew', 'Mark', 'Luke', 'John', 'Acts', 'Romans',
    '1 Corinthians', '2 Corinthians', 'Galatians', 'Ephesians',
    'Philippians', 'Colossians', '1 Thessalonians', '2 Thessalonians',
    '1 Timothy', '2 Timothy', 'Titus', 'Philemon', 'Hebrews',
    'James', '1 Peter', '2 Peter', '1 John', '2 John', '3 John',
    'Jude', 'Revelation'
  ];

  String? _selectedBook = 'John';
  String? _selectedChapter = '3';
  String? _selectedVerse = '16';

  String _resultText = "";
  bool _isLoading = false;

  List<String> _getChapters(String book) {
    // For demo: maximum 50 chapters
    return List.generate(50, (i) => '${i + 1}');
  }

  List<String> _getVerses(String book, String chapter) {
    // For demo: maximum 50 verses
    return List.generate(50, (i) => '${i + 1}');
  }

  void _searchVerse() {
    setState(() {
      _isLoading = true;
      _resultText = "";
    });

    // Simulate network delay
    Future.delayed(const Duration(milliseconds: 500), () {
      String query = "${_selectedBook?.trim()} ${_selectedChapter?.trim()}:${_selectedVerse?.trim()}";

      if (widget.bibleData.containsKey(query)) {
        setState(() {
          _resultText = widget.bibleData[query]![_selectedVersion] ??
              "Version not available for this verse in demo.";
          _isLoading = false;
        });
      } else {
        setState(() {
          _resultText =
              "Verse '$query' not found in the demo database. Try John 3:16, Psalm 23:1, Phil 4:13, Jer 29:11, or Proverbs 3:5.";
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bible Explorer"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Version Selector
            const Text("Version", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'KJV', label: Text('KJV')),
                ButtonSegment(value: 'NLT', label: Text('NLT')),
                ButtonSegment(value: 'GNB', label: Text('GNB')),
                ButtonSegment(value: 'MSG', label: Text('MSG')),
              ],
              selected: {_selectedVersion},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _selectedVersion = newSelection.first;
                  if (_resultText.isNotEmpty) _searchVerse();
                });
              },
            ),
            const SizedBox(height: 24),

            // Dropdowns for Book, Chapter, Verse
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedBook,
                    decoration: const InputDecoration(
                      labelText: "Book",
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    ),
                    items: _books.map((book) => DropdownMenuItem(value: book, child: Text(book))).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedBook = value;
                        _selectedChapter = '1';
                        _selectedVerse = '1';
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedChapter,
                    decoration: const InputDecoration(
                      labelText: "Chapter",
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    ),
                    items: _getChapters(_selectedBook!).map((chap) => DropdownMenuItem(value: chap, child: Text(chap))).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedChapter = value;
                        _selectedVerse = '1';
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedVerse,
                    decoration: const InputDecoration(
                      labelText: "Verse",
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    ),
                    items: _getVerses(_selectedBook!, _selectedChapter!).map((verse) => DropdownMenuItem(value: verse, child: Text(verse))).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedVerse = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Search Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _searchVerse,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text("Read Scripture", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 30),

            // Result
            if (_resultText.isNotEmpty) ...[
              const Divider(),
              const SizedBox(height: 16),
              Text(
                _resultText,
                style: const TextStyle(fontSize: 18, height: 1.5, fontStyle: FontStyle.italic),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

// --- DATA MODELS ---
enum ThumbnailType { icon, image }

class ArticleItem {
  final String title;
  final String description;
  final String content;
  final ThumbnailType thumbnailType;
  final IconData? iconData;
  final Color? iconBackgroundColor;
  final String? imageUrl;

  ArticleItem({
    required this.title,
    required this.description,
    required this.content,
    required this.thumbnailType,
    this.iconData,
    this.iconBackgroundColor,
    this.imageUrl,
  });
}

class ExerciseItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color iconColor;
  final Widget screen;

  ExerciseItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.screen,
  });
}

// --- ARTICLE DETAIL SCREEN ---
class ArticleDetailScreen extends StatelessWidget {
  final ArticleItem article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.thumbnailType == ThumbnailType.image &&
                article.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  article.imageUrl!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 180,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.broken_image, size: 50),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            Text(
              article.title,
              style: const TextStyle(
                  fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Text(
              article.description,
              style: TextStyle(fontSize: 18, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 24),
            const Text("Details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(
              _generateDetailedContent(article.description),
              style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  String _generateDetailedContent(String description) {
    // Dynamic content generation based on keywords
    String lowerDesc = description.toLowerCase();
    
    if (lowerDesc.contains("emotions")) {
      return "Emotional intelligence is a critical skill that involves recognizing and understanding your own emotions and those of others. \n\n"
             "1. **Self-Awareness:** Pay attention to how you feel in different situations. Naming your emotions can reduce their intensity.\n"
             "2. **Self-Regulation:** Once you identify an emotion, find healthy ways to express it. Deep breathing and counting to ten are simple yet effective techniques.\n"
             "3. **Motivation:** Use your emotions to drive you towards your goals. Positive emotions can boost productivity.\n"
             "4. **Empathy:** Understanding how others feel can improve your relationships and communication skills.\n\n"
             "By practicing these steps daily, you create a more balanced mental state.";
    } else if (lowerDesc.contains("challenges") || lowerDesc.contains("anxiety")) {
      return "Modern life is filled with stressors, from work pressure to social media comparisons. Overcoming these challenges requires a proactive approach.\n\n"
             "**Coping Strategies:**\n"
             "- **Grounding:** Use the 5-4-3-2-1 technique (acknowledge 5 things you see, 4 you feel, etc.) to snap back to reality during panic.\n"
             "- **Routine:** Establish a consistent sleep schedule. Lack of sleep exacerbates anxiety and stress.\n"
             "- **Digital Detox:** Allocate specific times to unplug from social media to reduce comparison fatigue.\n"
             "- **Professional Help:** There is no shame in seeking therapy. Cognitive Behavioral Therapy (CBT) is highly effective for anxiety.\n\n"
             "Remember, resilience is like a muscle; it strengthens with exercise.";
    } else if (lowerDesc.contains("daily practices") || lowerDesc.contains("habits")) {
      return "Success in mental health is not about giant leaps, but small, consistent steps. Here are expanded practices to incorporate:\n\n"
             "**1. Morning Mindfulness:**\n"
             "Spend the first 5 minutes of your day not checking your phone, but stretching or breathing. Set a positive intention.\n\n"
             "**2. Gratitude Journaling:**\n"
             "Write down three things you are grateful for every night. This shifts the brain's focus from what is lacking to what is abundant.\n\n"
             "**3. Physical Movement:**\n"
             "You don't need a gym. A 15-minute walk raises endorphins, which are natural mood lifters.\n\n"
             "**4. Healthy Fueling:**\n"
             "Reduce sugar and processed foods. A healthy gut contributes to a healthy mind (the gut-brain axis).\n\n"
             "Start with one habit and master it before adding another.";
    } else {
      return "This article focuses on improving your overall well-being. \n\n"
             "Take time to reflect on the information provided. Mental health is a journey, not a destination. "
             "Be patient with yourself and celebrate small victories along the way.";
    }
  }
}

// ===== Journal Model & Editor =====
class JournalEntry {
  String text;
  bool favorite;
  final DateTime date;

  JournalEntry({required this.text, this.favorite = false}) : date = DateTime.now();
}

class JournalEditor extends StatefulWidget {
  final JournalEntry? entry;
  const JournalEditor({super.key, this.entry});

  @override
  State<JournalEditor> createState() => _JournalEditorState();
}

class _JournalEditorState extends State<JournalEditor> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.entry?.text ?? "");
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entry == null ? "New Journal" : "Edit Journal"),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        actions: [
          if (widget.entry != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // Logic handled in parent, but if we wanted to delete here we would pop a result
                Navigator.pop(context, 'DELETE');
              },
            )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: const TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                  hintText: "Write your thoughts here...",
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_controller.text.trim().isNotEmpty) {
                    Navigator.pop(
                        context,
                        JournalEntry(text: _controller.text.trim(), favorite: widget.entry?.favorite ?? false));
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    padding: const EdgeInsets.symmetric(vertical: 16)),
                child: const Text("Save Entry", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}