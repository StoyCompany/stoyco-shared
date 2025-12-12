import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class LoopVideoPlayer extends StatefulWidget {
  final String url; // Puede ser de red o asset

  const LoopVideoPlayer({super.key, required this.url});

  @override
  State<LoopVideoPlayer> createState() => _LoopVideoPlayerState();
}

class _LoopVideoPlayerState extends State<LoopVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));

    _controller.initialize().then((_) {
      _controller.setLooping(true);
      _controller.setVolume(0);
      _controller.play();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.value.isInitialized) {
      return FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _controller.value.size.width,
          height: _controller.value.size.height,
          child: VideoPlayer(_controller),
        ),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}
