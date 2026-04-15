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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Back to previous screen
          },
        ),
        title: const Text(
          'Health Habits',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Today's Goal Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "TODAY'S GOAL",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "80% Complete",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "+15% from yesterday",
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: 0.8,
                    color: Colors.green,
                    backgroundColor: Colors.grey[300],
                    minHeight: 8,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Great job! You're almost at your daily target.",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Daily Checklist
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Daily Checklist",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("Edit List"),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                children: checklist.keys.map((item) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: Checkbox(
                        value: checklist[item],
                        onChanged: (val) {
                          setState(() {
                            checklist[item] = val!;
                          });
                        },
                      ),
                      title: Text(item),
                      subtitle: Text(_getSubtitle(item)),
                      trailing: _getTrailingIcon(item),
                    ),
                  );
                }).toList(),
              ),
            ),
            // Weekly Insight
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Weekly Insight\nYou are 20% more active than last week! Keeping your routine helps stabilize your mood swings.",
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getSubtitle(String item) {
    switch (item) {
      case 'Drink 8 glasses of water':
        return "Essential for hydration";
      case 'Exercise for 30 minutes':
        return "Daily physical activity";
      case 'Eat balanced meals':
        return "3 nutritious portions";
      case 'Meditate for 10 minutes':
        return "Mental health break";
      case 'Sleep for 8 hours':
        return "Restorative rest";
      default:
        return "";
    }
  }

  Widget? _getTrailingIcon(String item) {
    switch (item) {
      case 'Drink 8 glasses of water':
        return const Icon(Icons.local_drink, color: Colors.blue);
      case 'Exercise for 30 minutes':
        return const Icon(Icons.fitness_center, color: Colors.orange);
      case 'Eat balanced meals':
        return const Icon(Icons.restaurant, color: Colors.red);
      case 'Meditate for 10 minutes':
        return const Icon(Icons.self_improvement, color: Colors.purple);
      case 'Sleep for 8 hours':
        return const Icon(Icons.bedtime, color: Colors.indigo);
      default:
        return null;
    }
  }
}