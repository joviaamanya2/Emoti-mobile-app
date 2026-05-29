import './terms_and _conditions.dart'; // FIXED: Removed space in filename
import 'package:flutter/material.dart';

// Color Palette
const Color kPrimaryGreen = Color.fromARGB(255, 88, 238, 93);
const Color kDarkGreen = Color.fromARGB(255, 50, 190, 55);
const Color kLightGreen = Color(0xFFE8F5E9);
const Color kBackground = Colors.white;
const Color kDarkText = Color(0xFF1F2937);

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _controller = PageController();
  int currentPage = 0;

  // Controller for Text Entrance
  late AnimationController _entryController;
  late Animation<Offset> _titleSlideAnimation;
  late Animation<Offset> _descSlideAnimation;

  // Controller for Floating Effect
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _titleSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryController, curve: Curves.easeOutBack));

    _descSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.8),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    ));

    _entryController.forward();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _entryController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  void nextPage() {
    if (currentPage == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const TermsAndConditionsScreen(),
        ),
      );
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: Stack(
        children: [

          // BACKGROUND BUBBLES
          _buildBackgroundBubble(0.1, -0.1, 120, Colors.green.withOpacity(0.05)),
          _buildBackgroundBubble(0.9, 0.2, 180, Colors.blue.withOpacity(0.03)),
          _buildBackgroundBubble(0.5, 0.8, 100, Colors.purple.withOpacity(0.04)),

          // MAIN CONTENT
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  /// Skip Button
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TermsAndConditionsScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Skip",
                        style: TextStyle(
                          color: kDarkGreen,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: PageView(
                      controller: _controller,
                      onPageChanged: (index) {
                        setState(() {
                          currentPage = index;
                        });
                        _entryController.reset();
                        _entryController.forward();
                      },
                      children: [
                        /// PAGE 1
                        buildPage(
                          imagePath: "assets/images/onboard1.jpg",
                          title: "Emoti Connect",
                          description:
                              "Your emotion tracker for a healthier, more connected mind.",
                        ),

                        /// PAGE 2
                        buildPage(
                          imagePath: "assets/images/onboard2.png",
                          title: "Track Your Feelings",
                          description:
                              "Understand your daily emotions and improve your mental wellbeing.",
                        ),

                        /// PAGE 3
                        buildPage(
                          imagePath: "assets/images/onboard3.png",
                          title: "Start Your Journey",
                          description:
                              "Build healthy habits and stay emotionally balanced every day.",
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// Dots Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (index) => buildDot(index),
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// Next Button
                  SlideTransition(
                    position: _descSlideAnimation,
                    child: GestureDetector(
                      onTap: nextPage,
                      child: Container(
                        width: double.infinity,
                        height: 65,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [kPrimaryGreen, kDarkGreen],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: kPrimaryGreen.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              currentPage == 2 ? "Get Started" : "Next",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 12),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (Widget child, Animation<double> animation) {
                                return ScaleTransition(scale: animation, child: child);
                              },
                              child: Icon(
                                currentPage == 2 ? Icons.check_rounded : Icons.arrow_forward_rounded,
                                key: ValueKey<bool>(currentPage == 2),
                                color: Colors.black,
                                size: 24,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundBubble(double top, double left, double size, Color color) {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        return Positioned(
          top: top * MediaQuery.of(context).size.height + (_floatAnimation.value * 0.5),
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

  Widget buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      height: 10,
      width: currentPage == index ? 30 : 10,
      decoration: BoxDecoration(
        color: currentPage == index ? kPrimaryGreen : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
        boxShadow: currentPage == index
            ? [BoxShadow(color: kPrimaryGreen.withOpacity(0.4), blurRadius: 5)]
            : [],
      ),
    );
  }

  Widget buildPage({
    required String title,
    required String description,
    required String imagePath,
  }) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(), // Prevent scrolling inside page
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          /// FLOATING IMAGE CARD
          AnimatedBuilder(
            animation: _floatController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _floatAnimation.value),
                child: child,
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              height: 320,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                  BoxShadow(
                    color: kPrimaryGreen.withOpacity(0.1),
                    blurRadius: 40,
                    spreadRadius: 5,
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // IMAGE ASSET
                    Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      // Error builder just in case image file is missing
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                              const SizedBox(height: 10),
                              Text(
                                "Image not found:\n$imagePath",
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 50),

          /// STAGGERED TEXT ANIMATIONS

          // Title
          SlideTransition(
            position: _titleSlideAnimation,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w800,
                color: kDarkText,
                height: 1.1,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Description
          SlideTransition(
            position: _descSlideAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}