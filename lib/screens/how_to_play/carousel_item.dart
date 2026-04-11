import 'package:codeshield/core/carousel_data.dart';
import 'package:codeshield/screens/how_to_play/carousel_menu.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class HowToPlayVideoItem extends StatefulWidget {
  final CarouselItemData data;
  final bool isActive;

  const HowToPlayVideoItem({
    super.key,
    required this.data,
    required this.isActive,
  });

  @override
  State<HowToPlayVideoItem> createState() => _HowToPlayVideoItemState();
}

class _HowToPlayVideoItemState extends State<HowToPlayVideoItem> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.data.videoPath == null) return;
    _controller = VideoPlayerController.asset(widget.data.videoPath!)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
          _controller?.setLooping(true);
        });
      });
  }

  @override
  void didUpdateWidget(covariant HowToPlayVideoItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isActive && (_controller?.value.isPlaying ?? false)) {
      _controller?.pause();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (!widget.isActive || !_isInitialized || _controller == null) return;

    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
      }
    });
  }

  Widget getVideoLayer() {
    if (_isInitialized) {
      return ClipRect(
        child: FittedBox(
          fit: .cover,
          child: SizedBox(
            width: _controller!.value.size.width,
            height: _controller!.value.size.height,
            child: VideoPlayer(_controller!),
          ),
        ),
      );
    } else if (widget.data.videoPath != null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    } else {
      return const Center(
        child: Icon(Icons.video_file_rounded, color: Colors.white24, size: 100),
      );
    }
  }

  List<Widget>? getPlayIndicator() {
    if (widget.isActive && _isInitialized && !_controller!.value.isPlaying) {
      return [
        Container(color: Colors.black.withValues(alpha: 0.4)),
        const Center(
          child: Icon(
            Icons.play_circle_outline,
            color: Colors.white70,
            size: 64.0,
          ),
        ),
      ];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final playIndicator = getPlayIndicator();

    final stack = Stack(
      fit: .expand,
      children: [getVideoLayer(), if (playIndicator != null) ...playIndicator],
    );

    return GestureDetector(
      onTap: _togglePlayPause,
      child: Container(
        width: frameWidth,
        margin: const .symmetric(horizontal: 5.0),
        clipBehavior: .antiAlias,
        decoration: BoxDecoration(
          color: widget.data.color,
          border: .all(color: Colors.white, width: 25.0),
        ),
        child: stack,
      ),
    );
  }
}
