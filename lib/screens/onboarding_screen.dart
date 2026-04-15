import '../screens/terms_and _conditions.dart'; // Keep your import
import 'package:flutter/material.dart';

// Updated Color Palette to match the new Splash Screen
const Color kPrimaryGreen = Color.fromARGB(255, 88, 238, 93);
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
  
  late AnimationController _textController;
  late Animation<Offset> _textAnimation;

  @override
  void initState() {
    super.initState();
    // Animation for text sliding up
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _textAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _textController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
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
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),

              /// Skip Button (Top Right)
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
                      color: kPrimaryGreen,
                      fontWeight: FontWeight.w600,
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
                    // Restart animation on page change
                    _textController.reset();
                    _textController.forward();
                  },
                  children: [
                    /// PAGE 1
                    buildPage(
                      icon: Icons.sentiment_satisfied_alt_rounded,
                      iconBgColor: Colors.blue.shade50,
                      iconColor: Colors.blue.shade400,
                      title: "Emoti Connect",
                      description:
                          "Your emotion tracker for a healthier, more connected mind.",
                      imagePath: "assets/images/onboard1.jpg", // Optional local image
                    ),

                    /// PAGE 2
                    buildPage(
                      icon: Icons.track_changes_rounded,
                      iconBgColor: Colors.purple.shade50,
                      iconColor: Colors.purple.shade400,
                      title: "Track Your Feelings",
                      description:
                          "Understand your daily emotions and improve your mental wellbeing.",
                      imagePath: "assets/images/onboard2.png",
                    ),

                    /// PAGE 3
                    buildPage(
                      icon: Icons.self_improvement_rounded,
                      iconBgColor: Colors.orange.shade50,
                      iconColor: Colors.orange.shade400,
                      title: "Start Your Journey",
                      description:
                          "Build healthy habits and stay emotionally balanced every day.",
                      imagePath: "assets/images/onboard3.png",
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
                position: _textAnimation,
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryGreen,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shadowColor: kPrimaryGreen.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: nextPage,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          currentPage == 2 ? "Get Started" : "Next",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          currentPage == 2 ? Icons.check_rounded : Icons.arrow_forward_rounded,
                          size: 22,
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
    );
  }

  /// Dot Indicator
  Widget buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      height: 8,
      width: currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: currentPage == index ? kPrimaryGreen : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  /// Onboarding Page
  Widget buildPage({
    IconData? icon,
    Color? iconBgColor,
    Color? iconColor,
    required String title,
    required String description,
    String? imagePath, // Local asset path
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /// Illustration Section
        // Attempt to load local image, fallback to Icon if not found
        LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: constraints.maxWidth * 0.85,
              height: 300,
              decoration: BoxDecoration(
                color: kLightGreen,
                borderRadius: BorderRadius.circular(30),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Try to load the AssetImage
                    Image.asset(
                      imagePath ?? '',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback to Icon if image fails
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: iconBgColor ?? Colors.grey.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                icon ?? Icons.image,
                                size: 80,
                                color: iconColor ?? kPrimaryGreen,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Illustration",
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 40),

        /// Title & Description with Slide Animation
        SlideTransition(
          position: _textAnimation,
          child: Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: kDarkText,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}