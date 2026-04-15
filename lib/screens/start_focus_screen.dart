import 'package:flutter/material.dart';
import 'dart:async';

class StartFocusScreen extends StatefulWidget {
  final Function onCompleted;

  const StartFocusScreen({super.key, required this.onCompleted});

  @override
  State<StartFocusScreen> createState() => _StartFocusScreenState();
}

class _StartFocusScreenState extends State<StartFocusScreen> {
  int time = 600;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (time == 0) {
        widget.onCompleted();
        Navigator.pop(context);
      } else {
        setState(() => time--);
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Focus')),
      body: Center(
        child: Text("$time sec",
            style: const TextStyle(fontSize: 30)),
      ),
    );
  }
}