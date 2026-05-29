import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:emoti_app/screens/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  // Main Animation Controller (for entrance effects)
  late AnimationController _controller;
  
  // Floating Animation Controller (for the logo breathing effect)
  late AnimationController _floatingController;

  // Animations
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation; // For text/button sliding up
  late Animation<double> _fadeAnimation;
  late Animation<double> _floatingOffset; // For the continuous float

  @override
  void initState() {
    super.initState();

    // 1. Main Entrance Animation (Runs once)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // 2. Floating Animation (Loops forever)
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true); // Makes it go up and down forever

    // --- ANIMATION DEFINITIONS ---

    // A. Logo: Elastic Scale
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    );

    // B. Text & Button: Slide Up + Fade In
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5), // Start from below
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
    ));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    // C. Logo Float
    _floatingOffset = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    // Start the entrance
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Clean transparent status bar
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        // Subtle Gradient Background for a "Calm" emotion vibe
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 204, 236, 240), // Very light cyan/white
                Color(0xFFFFFFFF), // Light gray
              ],
            ),
          ),
          child: Stack(
            children: [
              
              // BACKGROUND BUBBLES (For "Real Emotion" feel)
              _buildFloatingBubble(0.2, -0.2, 100, const Color.fromARGB(255, 58, 218, 63).withOpacity(0.05)),
              _buildFloatingBubble(0.8, 0.6, 150, Colors.blue.withOpacity(0.03)),
              _buildFloatingBubble(0.1, 0.8, 80, Colors.purple.withOpacity(0.05)),

              SafeArea(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        // 1. LOGO SECTION
                        AnimatedBuilder(
                          animation: _floatingController,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _floatingOffset.value),
                              child: ScaleTransition(
                                scale: _scaleAnimation,
                                child: child,
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(35),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24), // More rounded
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(255, 99, 235, 104).withOpacity(0.3),
                                  blurRadius: 30,
                                  offset: const Offset(0, 10),
                                )
                              ],
                            ),
                            child: Transform.rotate(
                              angle: -0.2, // Slight tilt
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 99, 235, 104),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                  Icons.sentiment_satisfied_alt_rounded, // "happy" icon
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 50),

                        // 2. TEXT SECTION 
                        SlideTransition(
                          position: _slideAnimation,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: Column(
                              children: [
                                const Text(
                                  "Emoti",
                                  style: TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.w900, 
                                    color: Colors.black87,
                                    letterSpacing: -1.0,
                                    height: 1.1,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "Master your mood, elevate your day.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18, 
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w600, 
                                    letterSpacing: 0.2,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 70),

                        // 3. BUTTON SECTION
                        SlideTransition(
                          position: _slideAnimation,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => const OnboardingScreen(),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      const begin = Offset(1.0, 0.0);
                                      const end = Offset.zero;
                                      const curve = Curves.easeInOutCubic;

                                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                      var offsetAnimation = animation.drive(tween);

                                      return SlideTransition(
                                        position: offsetAnimation,
                                        child: child,
                                      );
                                    },
                                    transitionDuration: const Duration(milliseconds: 400),
                                  ),
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                height: 64,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color.fromARGB(255, 99, 235, 104), 
                                      Color.fromARGB(255, 67, 201, 72), 
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color.fromARGB(255, 99, 235, 104).withOpacity(0.4),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    )
                                  ],
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Get Started",
                                      style: TextStyle(
                                        fontSize: 20, // Bigger Button Text
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(Icons.arrow_forward_rounded, color: Colors.black, size: 24),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 50),

                        // 4. FOOTER
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Text(
                            "FROM ANXIETY TO MINDFULNESS",
                            style: TextStyle(
                              fontSize: 12, // Slightly larger for readability
                              letterSpacing: 2.5,
                              color: const Color.fromARGB(255, 36, 32, 32),
                              fontWeight: FontWeight.w700, // Bold for contrast
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to create background animated bubbles
  Widget _buildFloatingBubble(double top, double left, double size, Color color) {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        return Positioned(
          top: top * MediaQuery.of(context).size.height + _floatingOffset.value * 0.5,
          left: left * MediaQuery.of(context).size.width,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}