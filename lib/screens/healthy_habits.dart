import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Health Habits',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
        fontFamily: 'SF Pro Text', // Standard iOS font feel
      ),
      home: const HealthHabitsScreen(),
    );
  }
}

class HealthHabitsScreen extends StatefulWidget {
  const HealthHabitsScreen({super.key});

  @override
  State<HealthHabitsScreen> createState() => _HealthHabitsScreenState();
}

class _HealthHabitsScreenState extends State<HealthHabitsScreen> {
  // Checklist state
  Map<String, bool> checklist = {
    'Drink 8 glasses of water': true,
    'Exercise for 30 minutes': false,
    'Eat balanced meals': false,
    'Meditate for 10 minutes': true,
    'Sleep for 8 hours': false,
  };

  @override
  Widget build(BuildContext context) {
    // Calculate progress dynamically
    int completed = checklist.values.where((val) => val).length;
    double progress = completed / checklist.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Health Habits',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: IconButton(
                icon: const Icon(Icons.more_horiz_rounded, color: Colors.black),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            
            // 1. Modern Goal Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, const Color(0xFFE8F5E9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.green.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "+15% vs Yesterday",
                          style: TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      Text(
                        "${(progress * 100).toInt()}%",
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Daily Target",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  // Custom Smooth Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white,
                      valueColor: const AlwaysStoppedAnimation(Color(0xFF4CAF50)),
                      minHeight: 12,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    completed == checklist.length 
                        ? "All done! Amazing work today."
                        : "Keep going, you're doing great!",
                    style: const TextStyle(fontSize: 13, color: Colors.grey, height: 1.4),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 2. Checklist Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Today's Checklist",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.black87),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("Edit List", style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 3. List Items (Modernized)
            ...checklist.keys.map((item) {
              final isChecked = checklist[item]!;
              return _buildCoolChecklistItem(item, isChecked);
            }).toList(),

            const SizedBox(height: 30),

            // 4. Weekly Insight Card (Floating Style)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 5))],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.bar_chart_rounded, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Weekly Insight",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "You are 20% more active this week!",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Custom List Item Builder
  Widget _buildCoolChecklistItem(String title, bool isChecked) {
    final icon = _getIconData(title);
    final color = _getItemColor(title);

    return GestureDetector(
      onTap: () {
        setState(() {
          checklist[title] = !isChecked;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isChecked ? color.withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isChecked ? color : Colors.grey.shade200,
            width: isChecked ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isChecked ? 0.02 : 0.04),
              blurRadius: 15,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Row(
          children: [
            // Circular Checkbox Container
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isChecked ? color : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2),
              ),
              child: isChecked 
                  ? const Icon(Icons.check, color: Colors.white, size: 16) 
                  : null,
            ),
            const SizedBox(width: 16),
            // Icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            // Text
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: isChecked ? Colors.grey.shade600 : Colors.black87,
                  decoration: isChecked ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            // Arrow
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String item) {
    switch (item) {
      case 'Drink 8 glasses of water': return Icons.water_drop_rounded;
      case 'Exercise for 30 minutes': return Icons.directions_run_rounded;
      case 'Eat balanced meals': return Icons.restaurant_rounded;
      case 'Meditate for 10 minutes': return Icons.self_improvement_rounded;
      case 'Sleep for 8 hours': return Icons.bedtime_rounded;
      default: return Icons.circle;
    }
  }

  Color _getItemColor(String item) {
    switch (item) {
      case 'Drink 8 glasses of water': return const Color(0xFF29B6F6);
      case 'Exercise for 30 minutes': return const Color(0xFFFF7043);
      case 'Eat balanced meals': return const Color(0xFFEF5350);
      case 'Meditate for 10 minutes': return const Color(0xFFAB47BC);
      case 'Sleep for 8 hours': return const Color(0xFF5C6BC0);
      default: return Colors.grey;
    }
  }
}