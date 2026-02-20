import 'package:flutter/material.dart';

class CounselorsScreen extends StatelessWidget {
  const CounselorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Counselors"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Talk to a professional",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              "Connect with certified counselors for emotional support "
              "and mental wellness guidance.",
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
            SizedBox(height: 24),
            Center(
              child: Icon(Icons.support_agent,
                  size: 120, color: Colors.green),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                "Coming Soon 💚",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
