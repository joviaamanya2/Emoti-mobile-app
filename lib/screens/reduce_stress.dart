import 'dart:async';
import 'package:flutter/material.dart';

// ================= SESSION MODEL =================
class StressSession {
  final String title;
  final String description;
  final int minutes;
  final IconData icon;

  StressSession({
    required this.title,
    required this.description,
    required this.minutes,
    required this.icon,
  });
}

class ReduceStressScreen extends StatefulWidget {
  const ReduceStressScreen({super.key});

  @override
  State<ReduceStressScreen> createState() => _ReduceStressScreenState();
}

class _ReduceStressScreenState extends State<ReduceStressScreen>
    with TickerProviderStateMixin {
  
  // Colors: Calming Green Theme
  final Color kPrimaryGreen = const Color(0xFF4CAF50);
  final Color kSoftGreen = const Color(0xFFE8F5E9);
  final Color kDeepGreen = const Color(0xFF2E7D32);

  // Timer Logic
  Timer? _sessionTimer;
  int _remainingSeconds = 5 * 60; 
  int _totalSeconds = 5 * 60;
  bool _isSessionRunning = false;

  // Breathing Animation Logic
  late AnimationController _breatheController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  
  // 4-4-4-4 Box Breathing Logic
  String _breathPhase = "Inhale";

  // Data: Now exactly 2 Sessions
  late List<StressSession> _sessions;
  int _selectedSessionIndex = 0; 

  // Data: Tips Section
  final List<Map<String, dynamic>> _tips = [
    {
      "icon": Icons.visibility_off,
      "title": "Soft Gaze",
      "desc": "Lower your eyes or close them gently to reduce visual distractions.",
    },
    {
      "icon": Icons.accessibility_new,
      "title": "Posture Check",
      "desc": "Keep your spine straight. This allows your lungs to expand fully.",
    },
    {
      "icon": Icons.self_improvement,
      "title": "Let Go",
      "desc": "With every exhale, imagine tension leaving your shoulders and jaw.",
    },
  ];

  @override
  void initState() {
    super.initState();
    
    _sessions = [
      StressSession(
        title: "Box Breathing",
        description: "5 min - 4-4-4-4 Rhythm", // FIX: Changed bullet to dash to prevent clipping
        minutes: 5,
        icon: Icons.grid_view_rounded,
      ),
      StressSession(
        title: "Deep Zen",
        description: "10 min - Total Relax", // FIX: Changed bullet to dash
        minutes: 10,
        icon: Icons.spa_rounded,
      ),
    ];

    _breatheController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16), 
    )..repeat(); 

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _breatheController, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.5).animate(_breatheController);

    _breatheController.addListener(() {
      final double val = _breatheController.value; 
      setState(() {
        if (val <= 0.25) {
          _breathPhase = "Inhale";
        } else if (val <= 0.50) {
          _breathPhase = "Hold";
        } else if (val <= 0.75) {
          _breathPhase = "Exhale";
        } else {
          _breathPhase = "Hold";
        }
      });
    });

    _breatheController.forward();
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    _breatheController.dispose();
    super.dispose();
  }

  // ================= TIMER LOGIC =================

  void _toggleSession() {
    if (_isSessionRunning) {
      _pauseSession();
    } else {
      _startSession();
    }
  }

  void _startSession() {
    if (_remainingSeconds <= 0) return;
    
    if (_breatheController.isAnimating) {
      // It's already running
    } else {
      _breatheController.repeat();
    }

    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        _completeSession();
      }
    });

    setState(() => _isSessionRunning = true);
  }

  void _pauseSession() {
    _sessionTimer?.cancel();
    _breatheController.stop(); 
    setState(() => _isSessionRunning = false);
  }

  void _resetSession() {
    _sessionTimer?.cancel();
    _breatheController.reset();
    _breatheController.repeat(); 
    setState(() {
      _remainingSeconds = _totalSeconds;
      _isSessionRunning = false;
    });
  }

  void _completeSession() {
    _sessionTimer?.cancel();
    _breatheController.stop();
    setState(() => _isSessionRunning = false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.self_improvement, color: kPrimaryGreen, size: 30),
            const SizedBox(width: 10),
            const Text("Session Complete!"),
          ],
        ),
        content: const Text("You've taken a step towards a calmer mind."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Done", style: TextStyle(color: kPrimaryGreen, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  void _setSession(int index) {
    _sessionTimer?.cancel();
    final session = _sessions[index];
    setState(() {
      _selectedSessionIndex = index;
      _totalSeconds = session.minutes * 60;
      _remainingSeconds = _totalSeconds;
      _isSessionRunning = false;
    });
    _breatheController.reset();
    _breatheController.repeat();
  }

  String get _timerText {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  double get _progress => _remainingSeconds / _totalSeconds;

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9), 
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // APPBAR
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Text(
                      "Reduce Stress",
                      style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w900, fontSize: 22),
                    ),
                  ],
                ),
              ),

              // SESSION SELECTOR (2 CARDS)
              SizedBox(
                height: 120, // FIX: Increased height from 110 to 120 to give text breathing room
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _sessions.length,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemBuilder: (context, index) {
                    final session = _sessions[index];
                    bool isSelected = _selectedSessionIndex == index;
                    
                    return GestureDetector(
                      onTap: () => _setSession(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 140,
                        margin: const EdgeInsets.only(right: 15),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14), // FIX: Adjusted padding
                        decoration: BoxDecoration(
                          color: isSelected ? kPrimaryGreen.withOpacity(0.1) : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? kPrimaryGreen : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected ? kPrimaryGreen.withOpacity(0.15) : Colors.black.withOpacity(0.03),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min, // FIX: Prevents unbounded height errors and text clipping
                          children: [
                            Icon(session.icon, color: isSelected ? kPrimaryGreen : Colors.grey, size: 28),
                            const SizedBox(height: 10),
                            // FIX: Isolated Title Text with safe emoji rendering
                            Text(
                              session.title,
                              textAlign: TextAlign.center,
                              maxLines: 2, // FIX: Allows 2 lines in case of emoji wrapping
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                color: isSelected ? kPrimaryGreen : Colors.grey.shade700,
                                fontFamily: 'Segoe UI Emoji', // FIX: Prevents emoji clipping
                                height: 1.3, // FIX: Gives safe vertical space to prevent cut-offs
                              ),
                            ),
                            const SizedBox(height: 4),
                            // FIX: Isolated Subtitle Text with safe rendering
                            Text(
                              session.description,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Colors.grey.shade500,
                                fontFamily: 'Segoe UI Emoji', // FIX: Prevents bullet point clipping
                                height: 1.2, 
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // ================= BREATHING VISUALIZER =================
              SizedBox(
                height: 260,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Ripple 1 (Outer)
                      AnimatedBuilder(
                        animation: _scaleAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Opacity(
                              opacity: 0.3,
                              child: Container(
                                width: 300,
                                height: 300,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: kSoftGreen.withOpacity(0.6),
                                  boxShadow: [
                                    BoxShadow(
                                      color: kPrimaryGreen.withOpacity(0.1),
                                      blurRadius: 30,
                                      spreadRadius: 10,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      // Ripple 2 (Inner)
                      AnimatedBuilder(
                        animation: _scaleAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _scaleAnimation.value * 0.8,
                            child: Opacity(
                              opacity: 0.6,
                              child: Container(
                                width: 260,
                                height: 260,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: kPrimaryGreen.withOpacity(0.2),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      // Main Circle (The Breath)
                      AnimatedBuilder(
                        animation: _scaleAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                gradient: RadialGradient(
                                  colors: [kPrimaryGreen, kDeepGreen],
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: kPrimaryGreen.withOpacity(0.4),
                                    blurRadius: 40,
                                    spreadRadius: 5,
                                  )
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  _breathPhase,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // CONTROLS & TIMER
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    Text(
                      _timerText,
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: Colors.grey.shade800,
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Session Progress",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade500,
                        letterSpacing: 1,
                      ),
                    ),

                    const SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: _progress,
                        minHeight: 8,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation(kPrimaryGreen),
                      ),
                    ),

                    const SizedBox(height: 30),

                    GestureDetector(
                      onTap: _toggleSession,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: kPrimaryGreen,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: kPrimaryGreen.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))
                          ],
                        ),
                        child: Icon(
                          _isSessionRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextButton(
                      onPressed: _resetSession,
                      child: Text(
                        "Reset Session",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ================= PRO TIPS SECTION (LOWER CARDS) =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pro Tips",
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 15),
                    
                    ..._tips.map((tip) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: kSoftGreen,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              tip['icon'] as IconData,
                              color: kPrimaryGreen,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tip['title'] as String,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  tip['desc'] as String,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade700,
                                    height: 1.3,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )).toList(),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}