import 'package:flutter/material.dart';
import 'auth_screen.dart';

// --- Brand Colors (Green Theme) ---
const Color kPrimaryGreen = Color(0xFF0EAD69);      // main green
const Color kDarkGreen = Color(0xFF064E3B);          // dark green
const Color kLightGreen = Color(0xFFE8F5E9);         // soft mint green
const Color kBlackColor = Colors.black;

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightGreen,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // --- PageView Section ---
              Expanded(
                child: PageView(
                  controller: _controller,
                  onPageChanged: (index) {
                    setState(() => isLastPage = index == 2);
                  },
                  children: [
                    buildPage(
                      image: 'assets/images/onboard1.jpg',
                      title: 'Emoti Connect',
                      description: 'Your emotional tracker.',
                    ),
                    buildPage(
                      image: 'assets/images/health.png',
                      title: 'Stay organised, healthy & mentally stable',
                      description: 'Your mental well-being is the foundation of your life.',
                    ),
                    buildPage(
                      image: 'assets/images/Get_started.png',
                      title: 'Ready for your daily mental health reminder?',
                      description: 'Emoti app is here for you.',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              // --- Bottom Navigation Controls ---
              Container(
                height: 70,
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.green.shade100)),
                ),
                child: isLastPage
                    ? _buildGetStartedButton(context)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Skip Button
                          TextButton(
                            onPressed: () => _controller.jumpToPage(2),
                            child: Text(
                              'Skip',
                              style: TextStyle(
                                color: kDarkGreen,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          // Dots Indicator
                          Row(
                            children: List.generate(
                              3,
                              (index) => buildDot(index: index),
                            ),
                          ),

                          // Next Button
                          TextButton(
                            onPressed: () => _controller.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            ),
                            child: Text(
                              'Next',
                              style: TextStyle(
                                color: kPrimaryGreen,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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

  // --- Get Started Button ---
  Widget _buildGetStartedButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryGreen,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          minimumSize: const Size(double.infinity, 55),
        ),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => LoginScreen()),
          );
        },
        child: const Text(
          'GET STARTED',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  // --- Page Indicator Dots ---
  Widget buildDot({required int index}) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double currentPage = _controller.hasClients ? _controller.page ?? 0 : 0;
        bool isActive = (currentPage.round() == index);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 5.0),
          height: 10.0,
          width: isActive ? 22.0 : 10.0,
          decoration: BoxDecoration(
            color: isActive ? kPrimaryGreen : Colors.green.shade200,
            borderRadius: BorderRadius.circular(5.0),
          ),
        );
      },
    );
  }

  // --- Onboarding Page Template ---
  Widget buildPage({
    required String image,
    required String title,
    required String description,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(image, height: 280),
        const SizedBox(height: 25),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: kDarkGreen,
          ),
        ),
        const SizedBox(height: 15),
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: kDarkGreen.withOpacity(0.7),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
