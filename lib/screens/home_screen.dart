import 'package:flutter/material.dart';
import 'emotion_dashboard.dart'; // Ensure this points to HomeContent

class GenderSelectionScreen extends StatefulWidget {
  // ADDED: Accept userName from Auth Screen
  final String userName;
  
  const GenderSelectionScreen({super.key, required this.userName});

  @override
  State<GenderSelectionScreen> createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen> {
  String? selectedGender;
  
  final Color kPrimaryGreen = const Color.fromARGB(255, 99, 235, 104);

  void _navigateToDashboard() {
    if (selectedGender != null) {
      // UPDATED: Pass userName and selectedGender to HomeContent
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeContent(
          userName: widget.userName,
          gender: selectedGender!,
        )), 
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an option to continue")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F8F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Title
              Text(
                "Choose your gender",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A2E1A),
                  fontFamily: 'Serif',
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Help us personalize your Emoti experience",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 50),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildGenderCard(
                    label: "Female",
                    icon: Icons.woman_outlined,
                  ),
                  _buildGenderCard(
                    label: "Male",
                    icon: Icons.man_outlined,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Center(
                child: _buildSmallOption("I'd rather not say"),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: selectedGender != null ? _navigateToDashboard : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryGreen,
                    disabledBackgroundColor: Colors.grey[300],
                    elevation: selectedGender != null ? 4 : 0,
                    shadowColor: kPrimaryGreen.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Next",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: selectedGender != null
                              ? Colors.black
                              : Colors.grey[500],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: selectedGender != null
                            ? Colors.black
                            : Colors.grey[500],
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderCard({required String label, required IconData icon}) {
    bool isSelected = selectedGender == label;
    return GestureDetector(
      onTap: () => setState(() => selectedGender = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 140,
        padding: const EdgeInsets.symmetric(vertical: 25),
        decoration: BoxDecoration(
          color: isSelected ? kPrimaryGreen.withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 5),
            )
          ],
          border: Border.all(
            color: isSelected ? kPrimaryGreen : Colors.grey.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isSelected
                    ? kPrimaryGreen.withOpacity(0.15)
                    : Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 40,
                color: isSelected ? kPrimaryGreen : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isSelected ? kPrimaryGreen : Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallOption(String label) {
    bool isSelected = selectedGender == label;
    return GestureDetector(
      onTap: () => setState(() => selectedGender = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? kPrimaryGreen : Colors.grey.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
             BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isSelected ? kPrimaryGreen : Colors.grey[700],
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}