import 'package:flutter/material.dart';

class BreathingGameScreen extends StatelessWidget {
  const BreathingGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Breathing Game"),
        backgroundColor: Colors.green.shade700,
      ),
      backgroundColor: const Color(0xFFE8F5E9),
      body: const Center(
        child: Text(
          "Breathing Exercise Game Coming Soon!",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}