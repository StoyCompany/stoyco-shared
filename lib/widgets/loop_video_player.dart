import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Callback type for checking if radio is playing
typedef IsRadioPlayingCallback = bool Function();

/// Callback type for getting the radio playing stream
typedef RadioPlayingStreamCallback = Stream<bool> Function();

class LoopVideoPlayer extends StatefulWidget {
  final String url;
  
  /// Optional callback to check if radio is currently playing
  /// If provided, video will pause when radio is playing
  final IsRadioPlayingCallback? isRadioPlaying;
  
  /// Optional stream to listen for radio playing state changes
  /// If provided, video will automatically pause/play based on radio state
  final RadioPlayingStreamCallback? radioPlayingStream;

  const LoopVideoPlayer({
    super.key,
    required this.url,
    this.isRadioPlaying,
    this.radioPlayingStream,
  });

  @override
  State<LoopVideoPlayer> createState() => _LoopVideoPlayerState();
}

class _LoopVideoPlayerState extends State<LoopVideoPlayer> {
  late VideoPlayerController _controller;
  StreamSubscription<bool>? _radioSubscription;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));

    await _controller.initialize();
    _controller.setLooping(true);
    _controller.setVolume(0);
    
    final isRadioPlaying = widget.isRadioPlaying?.call() ?? false;
    
    if (!isRadioPlaying) {
      _controller.play();
    }
    
    _setupRadioListener();
    
    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  void _setupRadioListener() {
    if (widget.radioPlayingStream != null) {
      _radioSubscription = widget.radioPlayingStream!().listen((isRadioPlaying) {
        if (!mounted) return;
        
        if (isRadioPlaying) {
          _controller.pause();
        } else {
          _controller.play();
        }
      });
    }
  }

  @override
  void dispose() {
    _radioSubscription?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitialized && _controller.value.isInitialized) {
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
