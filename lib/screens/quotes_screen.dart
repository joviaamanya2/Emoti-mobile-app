import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart'; // For Clipboard
import 'dart:math';

// ---------------------------------------------------------
// 1. DATA MODELS & SERVICE (Mood Based)
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Quote && runtimeType == other.runtimeType && text == other.text;

  @override
  int get hashCode => text.hashCode;
}

class WisdomService {
  // Expanded Quote Bank based on MOODS
  static final List<Quote> _quoteBank = [
    // HAPPY
    Quote(
      text: "Happiness is not something ready made. It comes from your own actions.",
      author: "DALAI LAMA",
      relevantMoods: ['Happy', 'Wisdom'],
    ),
    Quote(
      text: "The more you praise and celebrate your life, the more there is in life to celebrate.",
      author: "OPRAH WINFREY",
      relevantMoods: ['Happy'],
    ),
    
    // LONELY
    Quote(
      text: "You are never too old to set another goal or to dream a new dream.",
      author: "C.S. LEWIS",
      relevantMoods: ['Lonely', 'Wisdom'],
    ),
    Quote(
      text: "Rock bottom became the solid foundation on which I rebuilt my life.",
      author: "J.K. ROWLING",
      relevantMoods: ['Lonely', 'Stressed'],
    ),
    Quote(
      text: "What lies behind us and what lies before us are tiny matters compared to what lies within us.",
      author: "RALPH WALDO EMERSON",
      relevantMoods: ['Lonely'],
    ),

    // WISDOM
    Quote(
      text: "This moment will pass.",
      author: "MARCUS AURELIUS",
      relevantMoods: ['Wisdom', 'Stressed'], // Marcus Aurelius fits Wisdom/Stoicism
    ),
    Quote(
      text: "We suffer more often in imagination than in reality.",
      author: "SENECA",
      relevantMoods: ['Wisdom', 'Stressed'],
    ),
    Quote(
      text: "The only true wisdom is in knowing you know nothing.",
      author: "SOCRATES",
      relevantMoods: ['Wisdom'],
    ),

    // STRESSED
    Quote(
      text: "It is not stress that kills us, it is our reaction to it.",
      author: "HANS SELYE",
      relevantMoods: ['Stressed', 'Wisdom'],
    ),
    Quote(
      text: "Do what you can, with what you have, where you are.",
      author: "THEODORE ROOSEVELT",
      relevantMoods: ['Stressed'],
    ),

    // NEUTRAL
    Quote(
      text: "Simplicity is the ultimate sophistication.",
      author: "LEONARDO DA VINCI",
      relevantMoods: ['Neutral', 'Wisdom'],
    ),
    Quote(
      text: "Act as if what you do makes a difference. It does.",
      author: "WILLIAM JAMES",
      relevantMoods: ['Neutral', 'Happy'],
    ),
  ];

  static final Set<String> _savedQuotesText = {};

  /// Get standard mood list for the UI
  static List<String> getAvailableMoods() {
    return ['All', 'Happy', 'Lonely', 'Wisdom', 'Stressed', 'Neutral'];
  }

  static bool isQuoteSaved(Quote quote) {
    return _savedQuotesText.contains(quote.text);
  }

  static bool toggleSaveQuote(Quote quote) {
    if (_savedQuotesText.contains(quote.text)) {
      _savedQuotesText.remove(quote.text);
      return false;
    } else {
      _savedQuotesText.add(quote.text);
      return true;
    }
  }

  /// Fetch quote based on Mood AND Date
  static Quote getDailyQuote(String? mood) {
    final now = DateTime.now();
    int dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;

    List<Quote> relevantQuotes = [];
    
    if (mood == null || mood == 'All') {
      relevantQuotes = _quoteBank;
    } else {
      relevantQuotes = _quoteBank.where((q) => 
        q.relevantMoods.contains(mood)
      ).toList();
    }

    if (relevantQuotes.isEmpty) {
      relevantQuotes = _quoteBank;
    }

    // Seed ensures the quote stays the same for the day/mood combo
    int seed = dayOfYear + (mood?.length ?? 0);
    Random random = Random(seed);
    
    return relevantQuotes[random.nextInt(relevantQuotes.length)];
  }
}

// ---------------------------------------------------------
// 2. DAILY WISDOM SCREEN (TOP FILTERS & MOODS)
// ---------------------------------------------------------

class DailyWisdomScreen extends StatefulWidget {
  final String? currentMood;

  const DailyWisdomScreen({super.key, this.currentMood});

  @override
  State<DailyWisdomScreen> createState() => _DailyWisdomScreenState();
}

class _DailyWisdomScreenState extends State<DailyWisdomScreen> {
  late Quote _currentQuote;
  late String _selectedMood;
  bool _isSaved = false;
  
  // Fixed list of moods for the UI
  final List<String> _moods = WisdomService.getAvailableMoods();

  @override
  void initState() {
    super.initState();
    // Default to passed mood or 'All'
    _selectedMood = _moods.contains(widget.currentMood) 
        ? widget.currentMood! 
        : 'All';
    _loadDailyQuote();
  }

  void _loadDailyQuote() {
    _currentQuote = WisdomService.getDailyQuote(_selectedMood);
    _isSaved = WisdomService.isQuoteSaved(_currentQuote);
    if (mounted) setState(() {});
  }

  void _toggleSave() {
    bool newState = WisdomService.toggleSaveQuote(_currentQuote);
    setState(() {
      _isSaved = newState;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isSaved ? "Saved to Favourites" : "Removed from Favourites"),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareContent() {
    final String textToShare = '"${_currentQuote.text}" — ${_currentQuote.author}';
    Share.share(textToShare, subject: 'Daily Wisdom');
  }

  void _copyContent() {
    Clipboard.setData(ClipboardData(text: '"${_currentQuote.text}" — ${_currentQuote.author}'));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Copied to clipboard"),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _onMoodChanged(String newMood) {
    setState(() {
      _selectedMood = newMood;
    });
    _loadDailyQuote();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateString = "${now.day} ${_getMonthName(now.month)}, ${now.year}";

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF1F8E9), Color(0xFFFFFFFF)], 
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Row(
                  children: [
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

              // --- TOP MOOD FILTERS (Moved from bottom) ---
              // This is the new "Search" mechanism
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 14.0, bottom: 8.0),
                      child: Text(
                        "Choose categories?",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50, // Fixed height for horizontal list
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        itemCount: _moods.length,
                        itemBuilder: (context, index) {
                          final mood = _moods[index];
                          final isSelected = mood == _selectedMood;
                          
                          return Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: FilterChip(
                              label: Text(mood),
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : Colors.grey.shade700,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                              selected: isSelected,
                              onSelected: (bool selected) {
                                if (selected) _onMoodChanged(mood);
                              },
                              selectedColor: const Color(0xFF4CAF50),
                              checkmarkColor: Colors.white,
                              backgroundColor: Colors.grey.shade100,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: isSelected ? Colors.transparent : Colors.grey.shade300,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // --- Quote Card ---
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
                        color: Colors.green.withOpacity(0.15),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
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
                      Text(
                        '"${_currentQuote.text}"',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          height: 1.6,
                          color: Color(0xFF2C3E50),
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Serif',
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 24),
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

              // --- Action Buttons (Save, Copy, Share) ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                      icon: _isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color: _isSaved ? const Color(0xFF4CAF50) : Colors.grey,
                      label: "Save",
                      onTap: _toggleSave,
                    ),
                    _buildActionButton(
                      icon: Icons.copy,
                      color: Colors.black87,
                      label: "Copy",
                      onTap: _copyContent, // Added "More" feature
                    ),
                    _buildActionButton(
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

  Widget _buildActionButton({
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