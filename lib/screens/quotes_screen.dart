import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:math';

// ---------------------------------------------------------
// 1. DATA MODELS & SERVICE
// ---------------------------------------------------------

class Quote {
  final String text;
  final String author;
  final List<String> relevantMoods;

  Quote({
    required this.text,
    required this.author,
    required this.relevantMoods,
  });
  
  // Helper to check equality based on text
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Quote && runtimeType == other.runtimeType && text == other.text;

  @override
  int get hashCode => text.hashCode;
}

class WisdomService {
  // Expanded Quote Bank
  static final List<Quote> _quoteBank = [
    // Great / Good
    Quote(
      text: "The more you praise and celebrate your life, the more there is in life to celebrate.",
      author: "OPRAH WINFREY",
      relevantMoods: ['Great', 'Good'],
    ),
    Quote(
      text: "Happiness is not something ready made. It comes from your own actions.",
      author: "DALAI LAMA",
      relevantMoods: ['Great', 'Good'],
    ),
    Quote(
      text: "Act as if what you do makes a difference. It does.",
      author: "WILLIAM JAMES",
      relevantMoods: ['Great', 'Good'],
    ),
    Quote(
      text: "What lies behind us and what lies before us are tiny matters compared to what lies within us.",
      author: "RALPH WALDO EMERSON",
      relevantMoods: ['Great', 'Good'],
    ),
    
    // Neutral
    Quote(
      text: "This moment will pass.",
      author: "MARCUS AURELIUS",
      relevantMoods: ['Neutral'],
    ),
    Quote(
      text: "The only way to do great work is to love what you do.",
      author: "STEVE JOBS",
      relevantMoods: ['Neutral'],
    ),
    Quote(
      text: "Simplicity is the ultimate sophistication.",
      author: "LEONARDO DA VINCI",
      relevantMoods: ['Neutral'],
    ),
    Quote(
      text: "Do what you can, with what you have, where you are.",
      author: "THEODORE ROOSEVELT",
      relevantMoods: ['Neutral'],
    ),

    // Low / Bad
    Quote(
      text: "Even the darkest night will end and the sun will rise.",
      author: "VICTOR HUGO",
      relevantMoods: ['Low', 'Bad'],
    ),
    Quote(
      text: "You are allowed to be both a masterpiece and a work in progress simultaneously.",
      author: "SOPHIA BUSH",
      relevantMoods: ['Low', 'Bad'],
    ),
    Quote(
      text: "Fall seven times, stand up eight.",
      author: "JAPANESE PROVERB",
      relevantMoods: ['Low', 'Bad'],
    ),
    Quote(
      text: "Rock bottom became the solid foundation on which I rebuilt my life.",
      author: "J.K. ROWLING",
      relevantMoods: ['Low', 'Bad'],
    ),
    Quote(
      text: "Healing takes time, and asking for help is a courageous step.",
      author: "MARISCHEL HERNANDEZ",
      relevantMoods: ['Low', 'Bad'],
    ),
  ];

  // In-memory storage for saved quotes (persists for the app session)
  static final Set<String> _savedQuotesText = {};

  /// Check if a quote is saved
  static bool isQuoteSaved(Quote quote) {
    return _savedQuotesText.contains(quote.text);
  }

  /// Toggle save state
  static bool toggleSaveQuote(Quote quote) {
    if (_savedQuotesText.contains(quote.text)) {
      _savedQuotesText.remove(quote.text);
      return false; // Removed
    } else {
      _savedQuotesText.add(quote.text);
      return true; // Added
    }
  }

  /// Logic: Fetch quote based on Mood AND Date
  static Quote getDailyQuote(String? mood) {
    final now = DateTime.now();
    
    // 1. Determine Seed based on Date
    // Using day of year ensures the quote changes daily but stays same for the whole day
    int dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    
    // 2. Filter by Mood
    String targetMood = mood ?? 'Neutral';
    List<Quote> relevantQuotes = _quoteBank.where((q) => 
      q.relevantMoods.contains(targetMood)
    ).toList();

    // Fallback if no specific mood quotes found
    if (relevantQuotes.isEmpty) {
      relevantQuotes = _quoteBank;
    }

    // 3. Use the day of year + random seed based on date to pick a quote consistently for that day
    // We add the mood length to the seed so different moods get different quotes on the same day
    int seed = dayOfYear + targetMood.length;
    Random random = Random(seed);
    
    return relevantQuotes[random.nextInt(relevantQuotes.length)];
  }
}

// ---------------------------------------------------------
// 2. REDESIGNED DAILY WISDOM SCREEN
// ---------------------------------------------------------

class DailyWisdomScreen extends StatefulWidget {
  final String? currentMood;

  const DailyWisdomScreen({super.key, this.currentMood});

  @override
  State<DailyWisdomScreen> createState() => _DailyWisdomScreenState();
}

class _DailyWisdomScreenState extends State<DailyWisdomScreen> {
  late Quote _currentQuote;
  bool _isSaved = false;
  bool _isSharing = false;

  @override
  void initState() {
    super.initState();
    _loadDailyQuote();
  }

  void _loadDailyQuote() {
    // Fetch based on mood and date
    _currentQuote = WisdomService.getDailyQuote(widget.currentMood);
    // Check if it's already saved
    _isSaved = WisdomService.isQuoteSaved(_currentQuote);
  }

  void _toggleSave() {
    bool newState = WisdomService.toggleSaveQuote(_currentQuote);
    setState(() {
      _isSaved = newState;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isSaved ? "Saved to your collection" : "Removed from collection"),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareContent() {
    final String textToShare = '"${_currentQuote.text}" — ${_currentQuote.author}';
    
    // Use share_plus for actual sharing (WhatsApp, SMS, Twitter, etc.)
    Share.share(
      textToShare,
      subject: 'Daily Wisdom from Wellness App',
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get today's date string
    final now = DateTime.now();
    final dateString = "${now.day} ${_getMonthName(now.month)}, ${now.year}";

    return Scaffold(
      // Professional Wellness Background: Subtle Gradient
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF1F8E9), Color(0xFFFFFFFF)], // Very pale green to white
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Row(
                  children: [
                    // Back Button
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const Spacer(),
                    // Date Display
                    Text(
                      dateString,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // Quote Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.1),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      // Decorative Icon
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.format_quote,
                          color: Color(0xFF4CAF50),
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Quote Text
                      Text(
                        '"${_currentQuote.text}"',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          height: 1.6,
                          color: Color(0xFF2C3E50),
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Serif', // Elegant font
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Author
                      Text(
                        _currentQuote.author,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2.0,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(flex: 3),

              // Action Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionCircle(
                      icon: _isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color: _isSaved ? const Color(0xFF4CAF50) : Colors.grey,
                      label: "Save",
                      onTap: _toggleSave,
                    ),
                    _buildActionCircle(
                      icon: Icons.share_rounded,
                      color: Colors.black87,
                      label: "Share",
                      onTap: _shareContent,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCircle({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return months[month - 1];
  }
}