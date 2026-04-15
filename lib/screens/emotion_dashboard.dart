import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../screens/recommendation_screen.dart';
import '../screens/library.dart';
import '../screens/settings.dart';
import 'inner_peace.dart';
import 'profile_screen.dart';
import '../services/auth_service.dart';

class HomeContent extends StatefulWidget {
  // ADDED: Accept userName and gender
  final String userName;
  final String gender;

  // Provide defaults so the screen doesn't crash if opened elsewhere
  const HomeContent({super.key, this.userName = "User", this.gender = ""});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  // Use the data passed from the widget
  String get userName => widget.userName;
  
  String profileImage = "https://via.placeholder.com/150";
  
  List<dynamic> journals = [];
  bool isLoading = true;
  int selectedEmojiIndex = 0;
  int _currentIndex = 0;

  final ApiService _apiService = ApiService();
  final Color kPrimaryGreen = const Color.fromARGB(255, 99, 235, 104);

  // ================= MOCK DATA FOR DEMO =================
  final List<Map<String, dynamic>> mockJournals = [
    {
      "id": 1,
      "content": "Feeling really energized after my morning meditation. The weather is perfect today!",
      "date": DateTime.now().toIso8601String(),
      "favorite": true
    },
    {
      "id": 2,
      "content": "Had a stressful meeting, but I managed to stay calm. Need to practice breathing more.",
      "date": DateTime.now().toIso8601String(),
      "favorite": false
    },
    {
      "id": 3,
      "content": "Grateful for my friends and family. We had a lovely dinner together tonight.",
      "date": DateTime.now().toIso8601String(),
      "favorite": false
    },
  ];

  final List<Map<String, String>> emojis = [
    {"icon": "😊", "label": "Great"},
    {"icon": "🙂", "label": "Stressed"},
    {"icon": "😐", "label": "Lonely"},
    {"icon": "😟", "label": "Sad"},
    {"icon": "😢", "label": "Confused"},
  ];

  final List<String> moodImages = [
    'https://images.pexels.com/photos/34950/pexels-photo.jpg',
    'https://images.pexels.com/photos/355465/pexels-photo-355465.jpeg',
    'https://images.pexels.com/photos/167699/pexels-photo-167699.jpeg',
    'https://images.pexels.com/photos/414171/pexels-photo-414171.jpeg',
    'https://images.pexels.com/photos/158607/cairn-fog-mystical-background-158607.jpeg',
  ];

  @override
  void initState() {
    super.initState();
    
    // 1. Set the profile icon based on the gender passed from the previous screen
    _setProfileIcon();
    
    // 2. Load mock data initially to show the UI immediately
    journals = mockJournals; 
    
    // 3. Try to fetch real data from API
    // Note: We pass updateProfile: false so we don't overwrite the name/gender we just set
    fetchData(updateProfile: false); 
  }

  // NEW: Function to set icon based on gender
  void _setProfileIcon() {
    if (widget.gender == 'Male') {
      profileImage = 'https://cdn-icons-png.flaticon.com/512/4140/4140051.png'; // Male Icon
    } else if (widget.gender == 'Female') {
      profileImage = 'https://cdn-icons-png.flaticon.com/512/4140/4140047.png'; // Female Icon
    } else {
      profileImage = 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png'; // Neutral Icon
    }
  }

  // UPDATED fetchData to allow optional profile updates
  void fetchData({bool updateProfile = true}) async {
    try {
      final user = await _apiService.getUser();
      final journalData = await _apiService.getJournals();
      if (!mounted) return;

      setState(() {
        // Only update name/image from API if requested.
        // Since we just set them based on Signup/Gender selection, we keep them as is.
        if (updateProfile) {
           // userName = user['name'] ?? "User"; 
        }
        
        // If the API specifically returns a profile image URL, use it.
        // Otherwise, we keep the gender icon we set in _setProfileIcon.
        final imageUrl = user['profile_image'] ?? '';
        if (imageUrl.isNotEmpty) {
             profileImage = imageUrl.startsWith('http')
                ? imageUrl
                : 'http://127.0.0.1:8000/$imageUrl';
        }

        if (journalData.isNotEmpty) {
          journals = journalData;
        }
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      print("Error fetching data: $e");
      setState(() => isLoading = false);
    }
  }

  // ================= DAILY JOURNALS LOGIC =================
  List get todayJournals {
    if (journals.isEmpty) return [];
    
    final now = DateTime.now();
    List todayEntries = journals.where((j) {
      try {
        String? dateStr = j['created_at'] ?? j['date'];
        if (dateStr == null) return false;
        final date = DateTime.parse(dateStr);
        return date.day == now.day && 
               date.month == now.month && 
               date.year == now.year;
      } catch (e) {
        return false;
      }
    }).toList();

    // If no today entries, show the latest ones for demo purposes
    if (todayEntries.isEmpty && journals.isNotEmpty) {
      return journals.take(3).toList();
    }
    
    return todayEntries;
  }

  void handleMoodSelection(int index) {
    setState(() {
      selectedEmojiIndex = index;
    });
    HapticFeedback.lightImpact();
  }

  void onTabTapped(int index) {
    setState(() => _currentIndex = index);

    switch (index) {
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const RecommendationsScreen()));
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const LibraryScreen()));
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
        break;
    }
  }

  void toggleFavorite(int index) {
    setState(() {
      journals[index]['favorite'] = !(journals[index]['favorite'] ?? false);
    });
  }

  void deleteJournal(int index) {
    setState(() {
      journals.removeAt(index);
    });
  }

  void editJournal(int index) {
    TextEditingController controller =
        TextEditingController(text: journals[index]['content']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Journal"),
        content: TextField(
          controller: controller,
          maxLines: 5,
          decoration: const InputDecoration(hintText: "Enter content"),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              setState(() {
                journals[index]['content'] = controller.text;
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: kPrimaryGreen),
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9F8F6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ================= HEADER =================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Hello,",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userName, // Uses the name passed from Gender Screen
                        style: const TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const ProfileScreen()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: kPrimaryGreen, width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 26,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: NetworkImage(profileImage), // Uses gender icon
                        onBackgroundImageError: (_, __) {
                          setState(() =>
                              profileImage = "https://via.placeholder.com/150");
                        },
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// ================= MOOD CARD =================
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.03),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How are you feeling today?',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(emojis.length, (index) {
                        bool isSelected = selectedEmojiIndex == index;

                        return GestureDetector(
                          onTap: () => handleMoodSelection(index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8), 
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? kPrimaryGreen.withOpacity(0.1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? kPrimaryGreen : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  emojis[index]["icon"]!,
                                  style: TextStyle(
                                      fontSize: 24, 
                                      color: isSelected
                                          ? kPrimaryGreen
                                          : Colors.black54),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  emojis[index]["label"]!,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? kPrimaryGreen
                                        : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// ================= DAILY SESSION =================
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: Container(
                  key: ValueKey<int>(selectedEmojiIndex),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(.06), blurRadius: 20)
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Image.network(
                              moodImages[selectedEmojiIndex],
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 200,
                                  color: Colors.grey[200],
                                  child: const Center(child: Icon(Icons.image, size: 50)),
                                );
                              },
                            ),
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.3),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Finding Inner Peace',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'A guided session to help you relax.',
                                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const InnerPeaceSessionScreen()),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kPrimaryGreen,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: const Text('Start Session', style: TextStyle(fontWeight: FontWeight.w600)),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// ================= RECENT JOURNALS =================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Recent Journals',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const LibraryScreen()));
                    },
                    child: Text("See All", style: TextStyle(color: kPrimaryGreen, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              SizedBox(
                height: 180,
                child: todayJournals.isEmpty
                    ? Center(
                        child: Text(
                          "No journals yet today.\nTap + to write one.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: todayJournals.length,
                        itemBuilder: (context, index) {
                          final j = todayJournals[index];
                          int mainIndex = journals.indexOf(j);
                          
                          return Container(
                            width: 260,
                            margin: const EdgeInsets.only(right: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(.04),
                                    blurRadius: 12)
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: kPrimaryGreen.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "Today",
                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: kPrimaryGreen),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Expanded(
                                    child: Text(
                                      j['content'] ?? "Empty journal...",
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500, fontSize: 14, color: Colors.black87, height: 1.4),
                                    ),
                                  ),
                                  const Spacer(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                            iconSize: 20,
                                            icon: Icon(
                                              j['favorite'] == true
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: Colors.red,
                                            ),
                                            onPressed: () => toggleFavorite(mainIndex),
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                          ),
                                          const SizedBox(width: 12),
                                          IconButton(
                                            iconSize: 20,
                                            icon: const Icon(Icons.edit, color: Colors.blue),
                                            onPressed: () => editJournal(mainIndex),
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        iconSize: 20,
                                        icon: const Icon(Icons.delete_outline, color: Colors.grey),
                                        onPressed: () => deleteJournal(mainIndex),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),

              const SizedBox(height: 24),

              /// ================= RECOMMENDATIONS BUTTON =================
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const RecommendationsScreen()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: kPrimaryGreen),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: Icon(Icons.recommend, color: kPrimaryGreen),
                  label: Text(
                    'View Recommendations',
                    style: TextStyle(color: kPrimaryGreen, fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),

      /// ================= BOTTOM NAV BAR =================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        selectedItemColor: kPrimaryGreen,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 10,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.recommend), label: 'Recommendations'),
          BottomNavigationBarItem(
              icon: Icon(Icons.library_add), label: 'Library'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}