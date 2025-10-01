import 'package:clones_desktop/ui/components/video_player/video_player.dart';
import 'package:clones_desktop/ui/components/video_player/video_source.dart';
import 'package:flutter/material.dart';

/// A wrapper around VideoPlayer that exposes the videoId
class VideoPlayerWithId extends StatefulWidget {
  const VideoPlayerWithId({
    super.key, 
    required this.source,
    required this.onVideoIdAvailable,
  });

  final VideoSource source;
  final ValueChanged<String> onVideoIdAvailable;

  @override
  State<VideoPlayerWithId> createState() => _VideoPlayerWithIdState();
}

class _VideoPlayerWithIdState extends State<VideoPlayerWithId> {
  late String _videoId;

  @override
  void initState() {
    super.initState();
    // Generate the same videoId as VideoPlayer does
    _videoId = '${widget.source.hashCode}-${DateTime.now().microsecondsSinceEpoch}';
    
    // Notify parent of the videoId
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onVideoIdAvailable(_videoId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return VideoPlayer(source: widget.source);
  }
}
