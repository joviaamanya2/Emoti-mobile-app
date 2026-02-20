import 'package:flutter/material.dart';

class QuotesScreen extends StatelessWidget {
  const QuotesScreen({super.key});

  final List<String> quotes = const [
    "You are doing the best you can.",
    "It’s okay to rest.",
    "Your feelings are valid.",
    "This moment will pass.",
    "Breathe deeply and let go.",
    "Small steps count too.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daily Quotes")),
      body: PageView.builder(
        itemCount: quotes.length,
        itemBuilder: (_, i) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Card(
                color: Colors.indigo.shade400,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    quotes[i],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
