import 'package:flutter/material.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  final List<Map<String, dynamic>> games = const [
    {"title": "Memory Match", "icon": Icons.memory},
    {"title": "Mood Puzzle", "icon": Icons.extension},
    {"title": "Color Calm", "icon": Icons.palette},
    {"title": "Breathing Game", "icon": Icons.air},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mindfulness Games")),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: games.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.1,
        ),
        itemBuilder: (context, index) {
          final game = games[index];
          return InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${game['title']} tapped!")),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.blueAccent, Colors.lightBlueAccent]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2,2))],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(game["icon"], size: 48, color: Colors.white),
                  const SizedBox(height: 12),
                  Text(game["title"], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
