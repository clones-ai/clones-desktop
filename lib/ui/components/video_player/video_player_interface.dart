import 'package:clones_desktop/ui/components/video_player/transport_controls.dart';
import 'package:clones_desktop/ui/components/video_player/video_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class ConsumerVideoPlayerState<T extends ConsumerStatefulWidget>
    extends ConsumerState<T> {
  @protected
  String get videoId;
  @protected
  void videoPlay();
  @protected
  void videoPause();
  @protected
  void videoStop();
  @protected
  void videoSeekBackward();
  @protected
  void videoSeekForward();
  @protected
  void videoSetSpeed(double speed);
  @protected
  Widget buildVideoPlayer(BuildContext context);

  void _handlePlayPause() {
    final isPlaying = ref.read(videoStateNotifierProvider(videoId)).isPlaying;
    if (isPlaying) {
      videoPause();
    } else {
      videoPlay();
    }
  }

  void _handleStop() {
    videoStop();
  }

  void _handleSeekBackward() {
    videoSeekBackward();
  }

  void _handleSeekForward() {
    videoSeekForward();
  }

  void _handleSpeedChange(double speed) {
    videoSetSpeed(speed);
  }

  @override
  Widget build(BuildContext context) {
    final videoState = ref.watch(videoStateNotifierProvider(videoId));

    return Column(
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
                            const Icon(Icons.error,
                                size: 48, color: Colors.red),
                            const SizedBox(height: 16),
                            Text(
                              'Erreur de lecture vidéo',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              videoState.errorMessage ?? 'Erreur inconnue',
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : videoState.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : buildVideoPlayer(context),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const SizedBox(height: 16),
        TransportControls(
          videoId: videoId,
          onPlayPause: _handlePlayPause,
          onStop: _handleStop,
          onSeekBackward: _handleSeekBackward,
          onSeekForward: _handleSeekForward,
          onSpeedChange: _handleSpeedChange,
        ),
      ],
    );
  }
}
