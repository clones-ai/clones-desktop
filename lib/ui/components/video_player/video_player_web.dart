import 'dart:async';

import 'package:clones_desktop/ui/components/video_player/video_controller.dart';
import 'package:clones_desktop/ui/components/video_player/video_player_interface.dart';
import 'package:clones_desktop/ui/components/video_player/video_source.dart';
import 'package:clones_desktop/ui/components/video_player/video_state.dart';
import 'package:clones_desktop/ui/components/video_player/web_video_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VideoPlayer extends ConsumerStatefulWidget {
  const VideoPlayer({super.key, required this.source});

  final VideoSource source;

  @override
  ConsumerState<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends ConsumerVideoPlayerState<VideoPlayer>
    with VideoControllerMixin {
  late WebVideoControllerImpl _controller;
  late String _videoId;

  @override
  String get videoId => _videoId;

  @override
  void initState() {
    super.initState();
    // Generate unique video ID based on source and timestamp
    _videoId = '${widget.source.hashCode}-${DateTime.now().microsecondsSinceEpoch}';
    _controller = WebVideoControllerImpl(widget.source, ref, _videoId);
    // Delay initialization to after widget tree is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeVideo();
    });
  }

  Future<void> _initializeVideo() async {
    await safeExecute(
      () => _controller.initialize(),
      'initialize web video',
      ref,
      _videoId,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget buildVideoPlayer(BuildContext context) {
    return _controller.viewType != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black,
              child: HtmlElementView(viewType: _controller.viewType!),
            ),
          )
        : const SizedBox.shrink();
  }

  @override
  void videoPause() => safeExecute(() => _controller.pause(), 'pause', ref, _videoId);

  @override
  void videoPlay() => safeExecute(() => _controller.play(), 'play', ref, _videoId);

  @override
  void videoSeekBackward() {
    final currentPos = ref.read(videoStateNotifierProvider(_videoId)).currentPosition;
    final newPosition = currentPos - const Duration(seconds: 1);
    final seekTo = newPosition < Duration.zero ? Duration.zero : newPosition;
    safeExecute(() => _controller.seekTo(seekTo), 'seek backward', ref, _videoId);
  }

  @override
  void videoSeekForward() {
    final state = ref.read(videoStateNotifierProvider(_videoId));
    final newPosition = state.currentPosition + const Duration(seconds: 1);
    if (newPosition < state.totalDuration) {
      safeExecute(() => _controller.seekTo(newPosition), 'seek forward', ref, _videoId);
    }
  }

  @override
  void videoSeek(Duration position) {
    final state = ref.read(videoStateNotifierProvider(_videoId));
    Duration clampedPosition;
    if (position < Duration.zero) {
      clampedPosition = Duration.zero;
    } else if (position > state.totalDuration) {
      clampedPosition = state.totalDuration;
    } else {
      clampedPosition = position;
    }
    safeExecute(() => _controller.seekTo(clampedPosition), 'seek', ref, _videoId);
  }

  @override
  void videoSetSpeed(double speed) =>
      safeExecute(() => _controller.setSpeed(speed), 'set speed', ref, _videoId);

  @override
  void videoStop() => safeExecute(() => _controller.stop(), 'stop', ref, _videoId);
}
