import 'package:emoti_app/screens/auth_screen.dart';
import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  State<TermsAndConditionsScreen> createState() => _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  bool _isAccepted = false;

  // Navigation function
  void _acceptAndContinue() {
    if (_isAccepted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Your requested Light Green Theme Color
    final Color kPrimaryGreen = const Color.fromARGB(255, 89, 219, 72);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F8F6), // Matches your light theme
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black54, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              "Terms and Conditions",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A2E1A),
                fontFamily: 'Serif', // Fallback for Google Fonts
              ),
            ),
            const SizedBox(height: 8),
            
            // Subtitle
            Text(
              "Please review these terms carefully before proceeding.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),

            // Scrollable Terms Content
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader("1. Welcome to Emoti"),
                      _buildSectionText(
                        "Welcome to Emoti. By using our application, you agree to be bound by these terms of service and all applicable laws and regulations. If you do not agree with any of these terms, you are prohibited from using or accessing this application.",
                      ),
                      
                      const SizedBox(height: 20),
                      _buildSectionHeader("2. Not Medical Advice"),
                      _buildSectionText(
                        "The content provided by Emoti is for informational and educational purposes only. It is not intended to be a substitute for professional medical advice, diagnosis, or treatment. Always seek the advice of your physician or other qualified health provider with any questions you may have regarding a medical condition.",
                      ),

                      const SizedBox(height: 20),
                      _buildSectionHeader("3. User Responsibilities"),
                      _buildSectionText(
                        "You are responsible for maintaining the confidentiality of your account and for all activities that occur under your account. You agree to use the service only for lawful purposes and in a way that does not infringe the rights of others.",
                      ),

                      const SizedBox(height: 20),
                      _buildSectionHeader("4. Privacy Policy"),
                      _buildSectionText(
                        "Your privacy is important to us. Our Privacy Policy explains how we collect, use, and protect your personal information when you use our service. By using Emoti, you consent to the collection and use of your information as described in our Privacy Policy.",
                      ),

                      const SizedBox(height: 20),
                      _buildSectionHeader("5. Limitation of Liability"),
                      _buildSectionText(
                        "Emoti and its developers shall not be liable for any indirect, incidental, special, consequential, or punitive damages resulting from your use of or inability to use the service.",
                      ),
                      
                      const SizedBox(height: 24),
                      Center(
                        child: Text(
                          "LAST UPDATED: OCT 2023",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[400],
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Checkbox & Action
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isAccepted = !_isAccepted;
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: _isAccepted ? kPrimaryGreen : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: _isAccepted ? kPrimaryGreen : Colors.grey[400]!,
                            width: 1.5,
                          ),
                        ),
                        child: _isAccepted 
                            ? const Icon(Icons.check, size: 16, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "I agree to the terms",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Accept Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isAccepted ? _acceptAndContinue : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryGreen, // Your requested green
                  disabledBackgroundColor: Colors.grey[300],
                  elevation: _isAccepted ? 4 : 0,
                  shadowColor: kPrimaryGreen.withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Accept and Continue",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _isAccepted ? Colors.black : Colors.grey[500],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_rounded, 
                      color: _isAccepted ? Colors.black : Colors.grey[500],
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20), // Padding for bottom safe area
          ],
        ),
      ),
    );
  }

  // Helper widget for Section Headers
  Widget _buildSectionHeader(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1A2E1A),
      ),
    );
  }

  // Helper widget for Section Text
  Widget _buildSectionText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey[700],
        height: 1.6,
      ),
    );
  }
}