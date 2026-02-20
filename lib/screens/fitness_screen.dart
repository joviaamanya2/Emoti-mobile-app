import 'package:flutter/material.dart';

class FitnessScreen extends StatelessWidget {
  const FitnessScreen({super.key});

  final List<Map<String, dynamic>> tips = const [
    {"title": "5-min Morning Stretch", "icon": Icons.accessibility_new},
    {"title": "10-min Walk", "icon": Icons.directions_walk},
    {"title": "Yoga for Anxiety", "icon": Icons.self_improvement},
    {"title": "Quick Breathing", "icon": Icons.air},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mindful Fitness")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tips.length,
        itemBuilder: (context, index) {
          final tip = tips[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: Colors.green.shade700,
            child: ListTile(
              leading: Icon(tip["icon"], color: Colors.white, size: 32),
              title: Text(tip["title"], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${tip['title']} started!")),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
