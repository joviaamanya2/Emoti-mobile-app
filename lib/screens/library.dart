import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/fitness_screen.dart';
import 'videos.dart';
import '../screens/games_screen.dart';
import 'quotes_screen.dart';

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
        primaryColor: const Color(0xFF5CC6A9), // Wellness Green
        scaffoldBackgroundColor: const Color(0xFFFAFAFA),
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
  final List<String> _categories = ['All', 'Articles', 'Exercises', 'Journal'];
  
  static const String _journalsKey = 'saved_journals';

  final List<ArticleItem> _articles = [
    ArticleItem(
      title: 'Understanding Emotions',
      description: 'Learn how to identify and handle complex emotions effectively.',
      content:
          'Emotional intelligence is the ability to understand, use, and manage your own emotions in positive ways to relieve stress, communicate effectively, empathize with others, overcome challenges and defuse conflict.',
      thumbnailType: ThumbnailType.icon,
      iconData: Icons.psychology,
      iconBackgroundColor: const Color(0xFF2C3E50),
    ),
    ArticleItem(
      title: 'Common Challenges',
      description: 'Explore modern barriers like anxiety, stress, and how to overcome them.',
      content:
          'In our fast-paced world, anxiety and stress have become common companions. Understanding the triggers is the first step. Techniques such as cognitive behavioral therapy (CBT), mindfulness, and grounding exercises can significantly reduce the impact of these challenges.',
      thumbnailType: ThumbnailType.image,
      imageUrl:
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&q=80',
    ),
    ArticleItem(
      title: 'Daily Practices',
      description: 'Small habits and routines that can significantly improve your mental state.',
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
      screen: const GamesScreen(),
    ),
    ExerciseItem(
      title: 'Videos',
      subtitle: 'Guided sessions',
      icon: Icons.play_circle_outline_rounded,
      color: Colors.red.shade100,
      iconColor: Colors.red,
      screen: const VideosScreen(),
    ),
    ExerciseItem(
      title: 'Fitness',
      subtitle: 'Body & mind flow',
      icon: Icons.fitness_center_rounded,
      color: Colors.green.shade100,
      iconColor: Colors.green,
      screen: const FitnessScreen(),
    ),
    ExerciseItem(
      title: 'Daily Quotes',
      subtitle: 'Daily inspiration',
      icon: Icons.format_quote_rounded,
      color: Colors.purple.shade100,
      iconColor: Colors.purple,
      screen: const DailyWisdomScreen(),
    ),
  ];

  List<JournalEntry> journals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadJournals();
  }

  // Load journals from SharedPreferences
  Future<void> _loadJournals() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? journalsJson = prefs.getString(_journalsKey);
      
      if (journalsJson != null) {
        final List<dynamic> decoded = jsonDecode(journalsJson);
        setState(() {
          journals = decoded.map((item) => JournalEntry.fromJson(item)).toList();
        });
      }
    } catch (e) {
      debugPrint('Error loading journals: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Save journals to SharedPreferences
  Future<void> _saveJournals() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encoded = jsonEncode(journals.map((j) => j.toJson()).toList());
      await prefs.setString(_journalsKey, encoded);
    } catch (e) {
      debugPrint('Error saving journals: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Library", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87, size: 26),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF5CC6A9)))
          : Padding(
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
            await _saveJournals();
          }
        },
        icon: const Icon(Icons.create_rounded),
        label: const Text("New Entry"),
        backgroundColor: const Color(0xFF5CC6A9),
        elevation: 5,
      ),
    );
  }

  Widget _buildContentList() {
    switch (_selectedCategoryIndex) {
      case 0: // ALL
        return ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 100),
          children: [
            const Text("Featured Articles",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
            const SizedBox(height: 12),
            ..._articles.map((article) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _buildArticleCard(article),
                )),
            
            const SizedBox(height: 30),
            
            const Text("Exercises",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
            const SizedBox(height: 12),
            
            SizedBox(
              height: 220,
              child: _buildExercisesGrid(),
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Recent Journals",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
                Text("View All", style: TextStyle(color: Color(0xFF5CC6A9), fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            
            if (journals.isNotEmpty) ...[
               ...journals.reversed.take(3).map((journal) => Padding(
                     padding: const EdgeInsets.only(bottom: 16.0),
                     child: _journalCard(journal),
                   )),
            ] else ...[
               Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text("No journals yet. Tap + to write.", style: TextStyle(color: Colors.grey.shade400)),
                ),
              )
            ]
          ],
        );
      case 1: // Articles
        return _buildArticlesList();
      case 2: // Exercises
        return _buildExercisesList();
      case 3: // Journal
        return _buildJournalsList();
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
                    color: isSelected ? const Color(0xFF5CC6A9) : Colors.transparent,
                    width: 3,
                  ),
                ),
              ),
              child: Text(
                _categories[index],
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? const Color(0xFF5CC6A9) : Colors.grey,
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
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: _articles.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, index) => _buildArticleCard(_articles[index]),
    );
  }

  Widget _buildExercisesList() {
     return ListView(
       padding: const EdgeInsets.only(bottom: 100),
       children: [
          GridView.builder(
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
          ),
       ],
     );
  }

  Widget _buildArticleCard(ArticleItem article) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ArticleDetailScreen(article: article)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(12), child: _buildThumbnail(article)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(article.title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
                  const SizedBox(height: 6),
                  Text(article.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.3)),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ArticleDetailScreen(article: article)),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF5CC6A9),
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text('Read More', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
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
        child: Center(child: Icon(article.iconData ?? Icons.help_outline, color: Colors.white, size: 40)),
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
      physics: const BouncingScrollPhysics(),
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
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => exercise.screen)),
      child: Container(
        decoration: BoxDecoration(
          color: exercise.color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: exercise.color.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 5))
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.6), shape: BoxShape.circle),
              child: Icon(exercise.icon, size: 32, color: exercise.iconColor),
            ),
            const SizedBox(height: 12),
            Text(exercise.title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2C3E50))),
            const SizedBox(height: 4),
            Text(exercise.subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
          ],
        ),
      ),
    );
  }

  Widget _buildJournalsList() {
    if (journals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.book_outlined, size: 60, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text("No journals yet.", style: TextStyle(color: Colors.grey.shade500)),
          ],
        ),
      );
    }
    
    // Sort journals by date (newest first)
    final sortedJournals = List<JournalEntry>.from(journals.reversed);
    
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: sortedJournals.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, index) => _journalCard(sortedJournals[index]),
    );
  }

  Widget _journalCard(JournalEntry journal) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5CC6A9).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "${journal.date.day}/${journal.date.month}/${journal.date.year} ${_formatTime(journal.date)}",
                    style: TextStyle(fontSize: 11, color: const Color(0xFF5CC6A9), fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
                if (journal.favorite)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, size: 14, color: Colors.amber.shade700),
                        const SizedBox(width: 4),
                        Text("Favorite", style: TextStyle(fontSize: 10, color: Colors.amber.shade700, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(journal.text, maxLines: 4, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, height: 1.5)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _actionButton(Icons.star_border, "Favorite", journal.favorite ? Colors.amber : Colors.grey.shade500, () async {
                  setState(() => journal.favorite = !journal.favorite);
                  await _saveJournals();
                }, isSelected: journal.favorite, selectedIcon: Icons.star),
                const SizedBox(width: 8),
                _actionButton(Icons.share, "Share", Colors.grey.shade500, () => Share.share(journal.text)),
                const SizedBox(width: 8),
                _actionButton(Icons.edit, "Edit", const Color(0xFF5CC6A9), () async {
                  final edited = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => JournalEditor(entry: journal)),
                  );
                  if (edited != null && edited is JournalEntry) {
                    setState(() {
                      final index = journals.indexOf(journal);
                      if (index != -1) journals[index] = edited;
                    });
                    await _saveJournals();
                  } else if (edited == 'DELETE') {
                    setState(() => journals.remove(journal));
                    await _saveJournals();
                  }
                }),
                const SizedBox(width: 8),
                _actionButton(Icons.delete_outline, "Delete", Colors.red.shade400, () => _showDeleteDialog(journal), 
                  isSelected: false, selectedIcon: Icons.delete_outline),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(IconData icon, String tooltip, Color color, VoidCallback onTap, {bool isSelected = false, IconData? selectedIcon}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(isSelected ? (selectedIcon ?? icon) : icon, size: 18, color: color),
      ),
    );
  }

  void _showDeleteDialog(JournalEntry journal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Delete Journal?", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("This action cannot be undone. Are you sure you want to delete this journal entry?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              setState(() => journals.remove(journal));
              await _saveJournals();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Journal deleted"),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime date) {
    String hour = date.hour.toString().padLeft(2, '0');
    String minute = date.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
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

class JournalEntry {
  String text;
  bool favorite;
  final DateTime date;

  JournalEntry({required this.text, this.favorite = false}) : date = DateTime.now();

  // Constructor for loading from JSON (with specific date)
  JournalEntry.withDate({required this.text, required this.date, this.favorite = false});

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'favorite': favorite,
      'date': date.toIso8601String(),
    };
  }

  // Create from JSON
  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry.withDate(
      text: json['text'] ?? '',
      date: DateTime.parse(json['date']),
      favorite: json['favorite'] ?? false,
    );
  }
}

// --- ARTICLE DETAIL SCREEN ---
class ArticleDetailScreen extends StatelessWidget {
  final ArticleItem article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            if (article.thumbnailType == ThumbnailType.image && article.imageUrl != null)
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
            Text(article.title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
            const SizedBox(height: 12),
            Text(article.description, style: TextStyle(fontSize: 18, color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
            const SizedBox(height: 24),
            const Text("Details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(_generateDetailedContent(article.description), style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87)),
          ],
        ),
      ),
    );
  }

  String _generateDetailedContent(String description) {
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
             "- **Grounding:** Use the 5-4-3-2-1 technique to snap back to reality during panic.\n"
             "- **Routine:** Establish a consistent sleep schedule. Lack of sleep exacerbates anxiety and stress.\n"
             "- **Digital Detox:** Allocate specific times to unplug from social media to reduce comparison fatigue.\n\n"
             "Remember, resilience is like a muscle; it strengthens with exercise.";
    } else {
      return "This article focuses on improving your overall well-being. \n\n"
             "Take time to reflect on the information provided. Mental health is a journey, not a destination. "
             "Be patient with yourself and celebrate small victories along the way.";
    }
  }
}

// --- JOURNAL EDITOR ---
class JournalEditor extends StatefulWidget {
  final JournalEntry? entry;
  const JournalEditor({super.key, this.entry});

  @override
  State<JournalEditor> createState() => _JournalEditorState();
}

class _JournalEditorState extends State<JournalEditor> {
  late TextEditingController _controller;
  bool _isSaving = false;

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
    final isEditing = widget.entry != null;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit Journal" : "New Journal"),
        backgroundColor: const Color(0xFF5CC6A9),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: "Delete",
              onPressed: () => _showDeleteConfirmDialog(),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (isEditing)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF5CC6A9).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.edit_calendar, color: const Color(0xFF5CC6A9), size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "Last edited: ${widget.entry!.date.day}/${widget.entry!.date.month}/${widget.entry!.date.year}",
                      style: TextStyle(color: const Color(0xFF5CC6A9), fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: const TextStyle(fontSize: 16, height: 1.5),
                decoration: InputDecoration(
                  hintText: "Write your thoughts here...",
                  border: const OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF5CC6A9), width: 2),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveEntry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5CC6A9),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isSaving
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(isEditing ? Icons.check : Icons.save, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text(isEditing ? "Update Entry" : "Save Entry", 
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Delete Journal?", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context, 'DELETE'); // Return DELETE to previous screen
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _saveEntry() {
    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please write something before saving"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    
    // Simulate a small delay for better UX
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pop(
        context,
        JournalEntry.withDate(
          text: _controller.text.trim(),
          date: widget.entry?.date ?? DateTime.now(),
          favorite: widget.entry?.favorite ?? false,
        ),
      );
    });
  }
}