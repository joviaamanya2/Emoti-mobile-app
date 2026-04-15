import 'package:flutter/material.dart';

class MemoryMatchScreen extends StatelessWidget {
  const MemoryMatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Memory Match"),
        backgroundColor: Colors.green.shade700,
      ),
      backgroundColor: const Color(0xFFE8F5E9),
      body: const Center(
        child: Text(
          "Memory Match Game Coming Soon!",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}