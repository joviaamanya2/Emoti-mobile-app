import 'package:flutter/material.dart';

class ColorCalmScreen extends StatelessWidget {
  const ColorCalmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Color Calm"),
        backgroundColor: Colors.green.shade700,
      ),
      backgroundColor: const Color(0xFFE8F5E9),
      body: const Center(
        child: Text(
          "Color Calm Game Coming Soon!",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}