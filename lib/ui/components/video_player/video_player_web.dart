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

  @override
  void initState() {
    super.initState();
    _controller = WebVideoControllerImpl(widget.source, ref);
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
  void videoPause() => safeExecute(() => _controller.pause(), 'pause', ref);

  @override
  void videoPlay() => safeExecute(() => _controller.play(), 'play', ref);

  @override
  void videoSeekBackward() {
    final currentPos = ref.read(videoStateNotifierProvider).currentPosition;
    final newPosition = currentPos - const Duration(seconds: 1);
    final seekTo = newPosition < Duration.zero ? Duration.zero : newPosition;
    safeExecute(() => _controller.seekTo(seekTo), 'seek backward', ref);
  }

  @override
  void videoSeekForward() {
    final state = ref.read(videoStateNotifierProvider);
    final newPosition = state.currentPosition + const Duration(seconds: 1);
    if (newPosition < state.totalDuration) {
      safeExecute(() => _controller.seekTo(newPosition), 'seek forward', ref);
    }
  }

  @override
  void videoSetSpeed(double speed) =>
      safeExecute(() => _controller.setSpeed(speed), 'set speed', ref);

  @override
  void videoStop() => safeExecute(() => _controller.stop(), 'stop', ref);
}
