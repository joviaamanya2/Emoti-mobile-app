import 'package:flutter/material.dart';
import 'emotion_dashboard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  String selectedGender = "";
  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE8F5E9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Emoti",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.close, color: Colors.black),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fade,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),

              const Text(
                "Choose your\ngender",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildGenderCard(
                    label: "Female",
                    imagePath: "assets/images/female.jpg",
                    isSelected: selectedGender == "female",
                    onTap: () {
                      setState(() => selectedGender = "female");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EmotionDashboard(),
                        ),
                      );
                    },
                  ),
                  _buildGenderCard(
                    label: "Male",
                    imagePath: "assets/images/male.jpg",
                    isSelected: selectedGender == "male",
                    onTap: () {
                      setState(() => selectedGender = "male");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EmotionDashboard(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const Spacer(),

              GestureDetector(
                onTap: () {
                  if (selectedGender.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EmotionDashboard(),
                      ),
                    );
                  }
                },
                child: Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Colors.green, Colors.lightGreen],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.4),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.arrow_forward,
                      color: Colors.white, size: 30),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _progressDot(active: true),
                  _progressDot(active: false),
                  _progressDot(active: false),
                  _progressDot(active: false),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // 🔥 UPDATED CARD WITH GREEN HOVER & CLICK EFFECT
  Widget _buildGenderCard({
    required String label,
    required String imagePath,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(25),
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        hoverColor: Colors.green.withOpacity(0.12),
        splashColor: Colors.green.withOpacity(0.25),
        highlightColor: Colors.green.withOpacity(0.15),
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(MaterialState.hovered)) {
              return Colors.green.withOpacity(0.12);
            }
            if (states.contains(MaterialState.pressed)) {
              return Colors.green.withOpacity(0.25);
            }
            return null;
          },
        ),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          width: 155,
          height: 260,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: isSelected
                ? const LinearGradient(
                    colors: [Colors.green, Colors.lightGreen],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : const LinearGradient(
                    colors: [Colors.white, Colors.grey],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? Colors.green.withOpacity(0.4)
                    : Colors.black12,
                blurRadius: 15,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 95,
                height: 95,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.white : Colors.black12,
                    width: 3,
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                label,
                style: TextStyle(
                  fontSize: 20,
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _progressDot({required bool active}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: active ? 30 : 20,
      height: 6,
      decoration: BoxDecoration(
        color: active ? Colors.green : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
