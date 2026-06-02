import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'library.dart'; // your existing library screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Feel Happier',
      theme: ThemeData(
        primaryColor: const Color(0xFF00A884),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: const FeelHappierScreen(),
    );
  }
}

// ========================= MAIN SCREEN =========================
class FeelHappierScreen extends StatefulWidget {
  const FeelHappierScreen({super.key});

  @override
  State<FeelHappierScreen> createState() => _FeelHappierScreenState();
}

class _FeelHappierScreenState extends State<FeelHappierScreen> {
  int _currentIndex = 0;

  final List<MoodAction> _actions = [
    MoodAction(
      icon: Icons.menu_book_rounded,
      title: 'Gratitude Journal',
      description: 'Write 3 things you\'re grateful for',
      color: const Color(0xFFFFF3E0),
      iconColor: const Color(0xFFF57C00),
    ),
    MoodAction(
      icon: Icons.favorite_rounded,
      title: 'Connect with Love',
      description: 'Call or WhatsApp your loved ones',
      color: const Color(0xFFE8F5E9),
      iconColor: const Color(0xFF00A884),
    ),
    MoodAction(
      icon: Icons.park_rounded,
      title: 'Nature Break',
      description: 'Find a nature spot near you',
      color: const Color(0xFFF1F8E9),
      iconColor: const Color(0xFF558B2F),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 320,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF1B5E20),
                    const Color(0xFF2E7D32),
                    const Color(0xFF388E3C),
                    const Color(0xFF43A047).withOpacity(0.9),
                  ],
                ),
                image: DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1585320806297-9794b3e4eeae?auto=format&fit=crop&w=800&q=80',
                  ),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Color(0xFF1B5E20).withOpacity(0.55),
                    BlendMode.darken,
                  ),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.25)),
                              ),
                              child: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: Colors.white,
                                  size: 18),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.2)),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.science_rounded,
                                    color: Colors.white, size: 14),
                                SizedBox(width: 6),
                                Text('Science-backed',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('Boost Your Mood',
                            style: TextStyle(
                                color: Color(0xFFA5D6A7),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.8)),
                      ),
                      const SizedBox(height: 12),
                      const Text('Feel Happier',
                          style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.15,
                              letterSpacing: -0.5)),
                      const SizedBox(height: 8),
                      const Text(
                          'Small actions, backed by research,\nthat can lift your day',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                              height: 1.5,
                              fontWeight: FontWeight.w400)),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 280,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFFAFAFA),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 28),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Suggested for you',
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1A1A2E))),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      physics: const BouncingScrollPhysics(),
                      itemCount: _actions.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom:
                                  index < _actions.length - 1 ? 12 : 0),
                          child: _buildActionCard(_actions[index]),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).padding.bottom + 85),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 75,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 20,
                offset: const Offset(0, 10))
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i),
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: const Color(0xFF00A884),
            unselectedItemColor: const Color(0xFFBDC3C7),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined, size: 28), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.chat_bubble_outline_rounded, size: 28),
                  label: 'Connect'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.add_circle_outline_rounded, size: 28),
                  label: 'AK'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline_rounded, size: 28),
                  label: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(MoodAction action) {
    return GestureDetector(
      onTap: () {
        if (action.title == 'Connect with Love') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const ConnectWithLoveScreen()));
        } else if (action.title == 'Nature Break') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const NatureBreakScreen()));
        } else if (action.title == 'Gratitude Journal') {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LibraryScreen()));
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 14,
                offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: action.color,
                shape: BoxShape.circle,
              ),
              child: Icon(action.icon,
                  color: action.iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(action.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Color(0xFF1A1A2E))),
                  const SizedBox(height: 4),
                  Text(action.description,
                      style: const TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 13)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6), shape: BoxShape.circle),
              child: const Icon(Icons.arrow_forward_ios_rounded,
                  color: Color(0xFF9CA3AF), size: 14),
            ),
          ],
        ),
      ),
    );
  }
}

// ========================= NATURE BREAK SCREEN =========================
class NatureBreakScreen extends StatelessWidget {
  const NatureBreakScreen({super.key});

  Future<void> _openMaps(String query) async {
    final url = Uri.parse(
        'https://www.google.com/maps/search/${Uri.encodeComponent(query)}');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        title: const Text("Nature Break",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18)),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Take a moment to connect with nature',
                style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(16)),
                        child: const Icon(Icons.eco_rounded,
                            color: Color(0xFF388E3C), size: 30),
                      ),
                      const SizedBox(width: 18),
                      const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('🌿', style: TextStyle(fontSize: 26)),
                            SizedBox(height: 4),
                            Text('Nature Break',
                                style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF1A1A2E))),
                          ]),
                    ],
                  ),
                  const SizedBox(height: 22),
                  const Divider(color: Color(0xFFF3F4F6)),
                  const SizedBox(height: 18),
                  const Text(
                      'Taking a break in nature is one of the most powerful ways to reset your mind. Research shows that just 20 minutes outdoors can significantly reduce cortisol levels and improve your mood.',
                      style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF374151),
                          height: 1.75)),
                  const SizedBox(height: 22),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: const Color(0xFF388E3C).withOpacity(0.15)),
                    ),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                            child: const Icon(Icons.science_rounded,
                                color: Color(0xFF388E3C), size: 16),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                              child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                Text('Why it works',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF1A1A2E))),
                                SizedBox(height: 6),
                                Text(
                                    'Any exposure to natural elements triggers a measurable drop in stress hormones within minutes.',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF388E3C),
                                        height: 1.6,
                                        fontWeight: FontWeight.w600)),
                              ])),
                        ]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text('Try these activities',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E))),
            const SizedBox(height: 6),
            const Text('Pick one or more to try right now',
                style: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF))),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 2))
                ],
              ),
              child: Column(
                children: [
                  _activityRow('Step outside for 10 minutes', 0),
                  _activityRow('Find any green space nearby', 1),
                  _activityRow('Take slow, deep breaths outdoors', 2),
                  _activityRow('Look up at the sky for a minute', 3),
                  _activityRow('Stretch your body in fresh air', 4),
                  _activityRow('Walk barefoot on grass if possible', 5,
                      isLast: true),
                ],
              ),
            ),
            const SizedBox(height: 36),
            GestureDetector(
              onTap: () => _openMaps('parks near me'),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: const Color(0xFF388E3C),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xFF388E3C).withOpacity(0.3),
                        blurRadius: 14,
                        offset: const Offset(0, 6))
                  ],
                ),
                child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map_rounded, color: Colors.white, size: 24),
                      SizedBox(width: 12),
                      Text('Find Parks on Maps',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w700)),
                    ]),
              ),
            ),
            const SizedBox(height: 14),
            Center(
                child: Text('Opens Google Maps to find nearby parks',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade400,
                        height: 1.5))),
          ],
        ),
      ),
    );
  }

  Widget _activityRow(String text, int index, {bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
        borderRadius: isLast
            ? const BorderRadius.only(
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18))
            : null,
      ),
      child: Row(children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              shape: BoxShape.circle,
              border: Border.all(
                  color: const Color(0xFF388E3C).withOpacity(0.2))),
          alignment: Alignment.center,
          child: Text('${index + 1}',
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF388E3C))),
        ),
        const SizedBox(width: 16),
        Expanded(
            child: Text(text,
                style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF1F2937),
                    fontWeight: FontWeight.w500,
                    height: 1.4))),
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE5E7EB))),
          child: const Icon(Icons.check_rounded,
              color: Color(0xFF388E3C), size: 16),
        ),
      ]),
    );
  }
}

// ========================= CONNECT WITH LOVE SCREEN =========================
class ConnectWithLoveScreen extends StatelessWidget {
  const ConnectWithLoveScreen({super.key});

  static const String _phone = "1234567890";

  Future<void> _launchWhatsApp() async {
    final url = Uri.parse(
        "https://wa.me/$_phone?text=${Uri.encodeComponent('Hey, just thinking of you! 💖')}");
    try {
      if (await canLaunchUrl(url))
        await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  Future<void> _launchCall() async {
    final url = Uri.parse("tel:$_phone");
    try {
      if (await canLaunchUrl(url)) await launchUrl(url);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF00A884);
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: green,
        title: const Text("Connect with Love",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18)),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 4))
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [green.withOpacity(0.15), Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: green.withOpacity(0.25), width: 2),
                  ),
                  child: const Icon(Icons.favorite_rounded,
                      color: green, size: 44),
                ),
                const SizedBox(height: 28),
                const Text("Loved One",
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A2E))),
                const SizedBox(height: 10),
                const Text("Reach out when you need support",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Color(0xFF6B7280))),
                const SizedBox(height: 36),
                Row(children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _launchCall,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                              color: const Color(0xFF86EFAC), width: 1.5),
                        ),
                        child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.call_rounded,
                                  color: Color(0xFF16A34A), size: 22),
                              SizedBox(width: 10),
                              Text("Call",
                                  style: TextStyle(
                                      color: Color(0xFF16A34A),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700)),
                            ]),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: _launchWhatsApp,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCF8C6),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                              color: const Color(0xFF86EFAC), width: 1.5),
                        ),
                        child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.chat_rounded,
                                  color: Color(0xFF00A884), size: 22),
                              SizedBox(width: 10),
                              Text("WhatsApp",
                                  style: TextStyle(
                                      color: Color(0xFF00A884),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700)),
                            ]),
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ========================= MODEL =========================
class MoodAction {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final Color iconColor;
  MoodAction(
      {required this.icon,
      required this.title,
      required this.description,
      required this.color,
      required this.iconColor});
}