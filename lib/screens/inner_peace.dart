import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class InnerPeaceSessionScreen extends StatefulWidget {
  const InnerPeaceSessionScreen({super.key});

  @override
  State<InnerPeaceSessionScreen> createState() => _InnerPeaceSessionScreenState();
}

class _InnerPeaceSessionScreenState extends State<InnerPeaceSessionScreen> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4', // sample video
    )
      ..initialize().then((_) {
        _chewieController = ChewieController(
          videoPlayerController: _videoController,
          autoPlay: false,
          looping: false,
          allowedScreenSleep: false,
          showControls: true,
          materialProgressColors: ChewieProgressColors(
            playedColor: Colors.green,
            handleColor: Colors.greenAccent,
            bufferedColor: Colors.grey,
            backgroundColor: Colors.black26,
          ),
        );
        setState(() {
          isLoading = false;
        });
      });
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Inner Peace Session'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Chewie(controller: _chewieController!),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Relax, breathe, and follow along with this session to find your inner peace. '
                    'Take a moment to disconnect and focus on your well-being.',
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
    );
  }
}