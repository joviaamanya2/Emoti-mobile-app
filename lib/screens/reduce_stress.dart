import 'dart:async';
import 'package:flutter/material.dart';

class ReduceStressScreen extends StatefulWidget {
  const ReduceStressScreen({super.key});

  @override
  State<ReduceStressScreen> createState() => _ReduceStressScreenState();
}

class _ReduceStressScreenState extends State<ReduceStressScreen>
    with SingleTickerProviderStateMixin {
  int totalSeconds = 300; // 5 minutes
  int remainingSeconds = 300;

  bool isRunning = false;
  late Timer timer;

  late AnimationController _controller;
  late Animation<double> _animation;

  String phase = "Inhale";

  @override
  void initState() {
    super.initState();

    // 🔵 Breathing animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 80, end: 120).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Switch inhale/exhale
    _controller.addStatusListener((status) {
      setState(() {
        phase = status == AnimationStatus.forward ? "Inhale" : "Exhale";
      });
    });
  }

  void startTimer() {
    if (isRunning) return;

    isRunning = true;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        timer.cancel();
        isRunning = false;
      }
    });
  }

  void pauseTimer() {
    if (!isRunning) return;
    timer.cancel();
    isRunning = false;
  }

  void resetTimer() {
    timer.cancel();
    setState(() {
      remainingSeconds = totalSeconds;
      isRunning = false;
    });
  }

  String get minutes =>
      (remainingSeconds ~/ 60).toString().padLeft(2, '0');
  String get seconds =>
      (remainingSeconds % 60).toString().padLeft(2, '0');

  double get progress =>
      1 - (remainingSeconds / totalSeconds);

  @override
  void dispose() {
    _controller.dispose();
    if (isRunning) timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,

      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Reduce Stress',
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // 🔵 Animated Breathing Circle
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Container(
                  width: _animation.value * 2,
                  height: _animation.value * 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green.withOpacity(0.2),
                  ),
                  child: Center(
                    child: Container(
                      width: _animation.value,
                      height: _animation.value,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                      child: const Icon(Icons.air,
                          color: Colors.white, size: 30),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            Text(
              'Take a Deep Breath',
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            Text(
              'Focus on your rhythm',
              style: TextStyle(color: Colors.grey.shade600),
            ),

            const SizedBox(height: 20),

            // ⏱ TIMER
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                timeBox(minutes, 'MINUTES'),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(':', style: TextStyle(fontSize: 18)),
                ),
                timeBox(seconds, 'SECONDS'),
              ],
            ),

            const SizedBox(height: 20),

            // 🌬 STATUS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$phase...',
                  style: const TextStyle(color: Colors.green),
                ),
                const Text('5s cycle',
                    style: TextStyle(color: Colors.grey)),
              ],
            ),

            const SizedBox(height: 10),

            // 📊 PROGRESS
            LinearProgressIndicator(
              value: progress,
              color: Colors.green,
              backgroundColor: Colors.grey.shade300,
              minHeight: 6,
            ),

            const SizedBox(height: 20),

            // 🎮 CONTROLS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                circleButton(Icons.refresh, resetTimer),

                GestureDetector(
                  onTap: isRunning ? pauseTimer : startTimer,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    child: Icon(
                      isRunning ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                    ),
                  ),
                ),

                circleButton(Icons.stop, pauseTimer),
              ],
            ),

            const SizedBox(height: 25),

            // Tips (same as before)
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Relaxation Tips',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget timeBox(String value, String label) {
    return Column(
      children: [
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(value,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(fontSize: 10, color: Colors.grey))
      ],
    );
  }

  Widget circleButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.shade300,
        ),
        child: Icon(icon, color: Colors.black),
      ),
    );
  }
}