import 'dart:async';
import 'package:flutter/material.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {

  /// ---------------- TIMER STATE ----------------
  int totalSeconds = 25 * 60;
  int remainingSeconds = 25 * 60;
  Timer? timer;
  bool isRunning = false;

  String sessionMode = "Deep Work";

  /// Mindfulness Tips (Dynamic)
  final List<Map<String, dynamic>> tips = [
    {
      "icon": Icons.notifications_off,
      "title": "Mute Notifications",
      "subtitle": "Reduce digital distractions"
    },
    {
      "icon": Icons.water_drop,
      "title": "Hydration Break",
      "subtitle": "Keep your brain fueled"
    },
    {
      "icon": Icons.headphones,
      "title": "Lo-Fi Soundscapes",
      "subtitle": "Ambient noise for concentration"
    },
    {
      "icon": Icons.self_improvement,
      "title": "Breathing Pause",
      "subtitle": "Take slow mindful breaths"
    },
  ];

  /// ---------------- TIMER FUNCTIONS ----------------

  void startTimer() {
    if (isRunning) return;

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainingSeconds > 0) {
        setState(() => remainingSeconds--);
      } else {
        timer?.cancel();
        setState(() => isRunning = false);
      }
    });

    setState(() => isRunning = true);
  }

  void pauseTimer() {
    timer?.cancel();
    setState(() => isRunning = false);
  }

  void resetTimer() {
    timer?.cancel();
    setState(() {
      remainingSeconds = totalSeconds;
      isRunning = false;
    });
  }

  /// ---------------- HELPERS ----------------

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  void setMinutes(int minutes) {
    setState(() {
      totalSeconds = minutes * 60;
      remainingSeconds = totalSeconds;
    });
  }

  /// ---------------- UI COMPONENTS ----------------

  Widget timeBox(int minutes, bool active) {
    return GestureDetector(
      onTap: () => setMinutes(minutes),
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: active ? Colors.green : Colors.green.shade50,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              "$minutes",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: active ? Colors.white : Colors.black,
              ),
            ),
            Text(
              "Minutes",
              style: TextStyle(
                fontSize: 12,
                color: active ? Colors.white : Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget taskTile(Map<String, dynamic> tip) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black.withOpacity(.05),
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.green.shade100,
            child: Icon(tip["icon"], color: Colors.green),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip["title"],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  tip["subtitle"],
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                )
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16)
        ],
      ),
    );
  }

  /// ---------------- BUILD ----------------

  @override
  Widget build(BuildContext context) {
    double progress =
        remainingSeconds / totalSeconds; // mindfulness progress

    return Scaffold(
      backgroundColor: const Color(0xffF4F7F5),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Mindful Focus",
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// ---------------- CIRCULAR TIMER ----------------
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 220,
                  width: 220,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8,
                    backgroundColor: Colors.green.shade100,
                    valueColor:
                        const AlwaysStoppedAnimation(Colors.green),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      formatTime(remainingSeconds),
                      style: const TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(sessionMode,
                        style: const TextStyle(color: Colors.grey)),
                  ],
                )
              ],
            ),

            const SizedBox(height: 25),

            /// ---------------- TIME SELECTOR ----------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                timeBox(15, totalSeconds == 15 * 60),
                timeBox(25, totalSeconds == 25 * 60),
                timeBox(45, totalSeconds == 45 * 60),
              ],
            ),

            const SizedBox(height: 25),

            /// ---------------- BUTTONS ----------------
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: startTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      padding:
                          const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text("Start Focus"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: pauseTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                    ),
                    child: const Text(
                      "Pause",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),

            TextButton(
              onPressed: resetTimer,
              child: const Text("Reset Session"),
            ),

            const SizedBox(height: 20),

            /// ---------------- TIPS ----------------
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Mindfulness Tips",
                style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),

            const SizedBox(height: 12),

            ...tips.map(taskTile).toList(),
          ],
        ),
      ),
    );
  }
}