import 'package:clones_desktop/ui/components/video_player/timeline_widget.dart';
import 'package:clones_desktop/ui/components/video_player/video_player.dart';
import 'package:clones_desktop/ui/components/video_player/video_source.dart';
import 'package:clones_desktop/ui/components/video_player/video_state.dart';
import 'package:clones_desktop/ui/views/demo_detail/layouts/components/demo_video_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Specialized video player for demo detail view with AxTree overlay support
class DemoVideoPlayer extends ConsumerStatefulWidget {
  const DemoVideoPlayer({super.key, required this.source});

  final VideoSource source;

  @override
  ConsumerState<DemoVideoPlayer> createState() => _DemoVideoPlayerState();
}

class _DemoVideoPlayerState extends ConsumerState<DemoVideoPlayer> {
  late String _videoId;
  late Widget _videoPlayerWidget;

  @override
  void initState() {
    super.initState();
    _videoId = '${widget.source.hashCode}-${DateTime.now().microsecondsSinceEpoch}';
    _videoPlayerWidget = VideoPlayer(source: widget.source);
  }

  void _handlePlayPause() {
    final videoState = ref.read(videoStateNotifierProvider(_videoId));
    final notifier = ref.read(videoStateNotifierProvider(_videoId).notifier);
    
    if (videoState.isPlaying) {
      notifier.setPaused();
    } else {
      notifier.setPlaying();
    }
  }

  void _handleStop() {
    ref.read(videoStateNotifierProvider(_videoId).notifier).setStopped();
  }

  void _handleSeekBackward() {
    final videoState = ref.read(videoStateNotifierProvider(_videoId));
    final newPosition = videoState.currentPosition - const Duration(seconds: 10);
    final seekTo = newPosition < Duration.zero ? Duration.zero : newPosition;
    ref.read(videoStateNotifierProvider(_videoId).notifier).updatePosition(seekTo);
  }

  void _handleSeekForward() {
    final videoState = ref.read(videoStateNotifierProvider(_videoId));
    final newPosition = videoState.currentPosition + const Duration(seconds: 10);
    final maxPosition = videoState.totalDuration;
    final seekTo = newPosition > maxPosition ? maxPosition : newPosition;
    ref.read(videoStateNotifierProvider(_videoId).notifier).updatePosition(seekTo);
  }

  void _handleSeek(Duration position) {
    final seekTo = position < Duration.zero ? Duration.zero : position;
    ref.read(videoStateNotifierProvider(_videoId).notifier).updatePosition(seekTo);
  }

  void _handleSpeedChange(double speed) {
    ref.read(videoStateNotifierProvider(_videoId).notifier).setSpeed(speed);
  }

  @override
  Widget build(BuildContext context) {
    final videoState = ref.watch(videoStateNotifierProvider(_videoId));

    return KeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKeyEvent: (KeyEvent event) {
        if (event is! KeyDownEvent) return;
        final key = event.logicalKey;
        if (key == LogicalKeyboardKey.space) {
          _handlePlayPause();
        } else if (key == LogicalKeyboardKey.arrowLeft) {
          _handleSeekBackward();
        } else if (key == LogicalKeyboardKey.arrowRight) {
          _handleSeekForward();
        }
      },
      child: Column(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: videoState.hasError
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error,
                                size: 48,
                                color: Colors.red,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Video playback error',
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                videoState.errorMessage ?? 'Unknown error',
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : videoState.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _videoPlayerWidget,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TimelineWidget(
            videoId: _videoId,
            onSeek: _handleSeek,
          ),
          const SizedBox(height: 16),
          DemoVideoControls(
            videoId: _videoId,
            onPlayPause: _handlePlayPause,
            onStop: _handleStop,
            onSeekBackward: _handleSeekBackward,
            onSeekForward: _handleSeekForward,
            onSpeedChange: _handleSpeedChange,
          ),
        ],
      ),
    );
  }
}
