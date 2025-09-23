import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/views/demo_detail/bloc/provider.dart';
import 'package:clones_desktop/ui/views/demo_detail/layouts/components/demo_detail_video_preview/widgets/timeline_widget.dart';
import 'package:clones_desktop/ui/views/demo_detail/layouts/components/demo_detail_video_preview/widgets/transport_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

class DemoDetailVideoPreview extends ConsumerStatefulWidget {
  const DemoDetailVideoPreview({super.key, this.onExpand});
  final VoidCallback? onExpand;

  @override
  ConsumerState<DemoDetailVideoPreview> createState() =>
      _DemoDetailVideoPreviewState();
}

class _DemoDetailVideoPreviewState
    extends ConsumerState<DemoDetailVideoPreview> {
  Offset? _hoverPosition;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(demoDetailNotifierProvider);
    final videoController = state.videoController;

    final videoLoaded =
        videoController != null && videoController.value.isInitialized;

    final theme = Theme.of(context);

    // Avoid modifying providers during build: defer initialization
    if (videoLoaded && state.clipSegments.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref
              .read(demoDetailNotifierProvider.notifier)
              .initializeClipsFromDuration();
        }
      });
    }

    return CardWidget(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Video Preview',
                  style: theme.textTheme.titleMedium,
                ),
                if (widget.onExpand != null)
                  IconButton(
                    icon: const Icon(
                      Icons.fullscreen,
                      color: ClonesColors.secondary,
                    ),
                    onPressed: widget.onExpand,
                    tooltip: 'Fullscreen',
                  ),
              ],
            ),
            const SizedBox(height: 10),
            if (!videoLoaded)
              Text('No video found', style: theme.textTheme.bodyMedium)
            else
              MouseRegion(
                onHover: (event) =>
                    setState(() => _hoverPosition = event.localPosition),
                onExit: (_) => setState(() => _hoverPosition = null),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (state.isLoading)
                      const Center(
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            strokeWidth: 1,
                          ),
                        ),
                      )
                    else
                      Opacity(
                        opacity: _hoverPosition != null ||
                                videoController.value.isPlaying
                            ? 1
                            : 0.5,
                        child: AspectRatio(
                          aspectRatio: videoController.value.aspectRatio,
                          child: VideoPlayer(videoController),
                        ),
                      ),
                    if (videoLoaded && _hoverPosition != null)
                      ValueListenableBuilder<VideoPlayerValue>(
                        valueListenable: videoController,
                        builder: (context, value, child) {
                          return IconButton(
                            icon: Icon(
                              value.isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                              size: 50,
                            ),
                            onPressed: () {
                              if (value.isPlaying) {
                                videoController.pause();
                              } else {
                                videoController.play();
                              }
                            },
                          );
                        },
                      ),
                  ],
                ),
              ),
            if (videoLoaded)
              TimelineWidget(controller: videoController),
            
            // Transport Controls
            if (videoLoaded) ...[
              const SizedBox(height: 16),
              _buildTransportControls(videoController),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTransportControls(VideoPlayerController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ValueListenableBuilder<VideoPlayerValue>(
        valueListenable: controller,
        builder: (context, value, child) {
          return TransportControls(
            isPlaying: value.isPlaying,
            isLoading: false,
            onPlayPause: () {
              if (value.isPlaying) {
                controller.pause();
              } else {
                controller.play();
              }
            },
            onStop: () {
              controller
                ..pause()
                ..seekTo(Duration.zero);
            },
            onSeekBackward: () => _seekBy(const Duration(seconds: -1)),
            onSeekForward: () => _seekBy(const Duration(seconds: 1)),
            onSpeedChange: (speed) => controller.setPlaybackSpeed(speed),
            currentSpeed: value.playbackSpeed,
            currentPosition: value.position,
            totalDuration: value.duration,
          );
        },
      ),
    );
  }

  void _seekBy(Duration delta) {
    final controller = ref.read(demoDetailNotifierProvider).videoController;
    if (controller != null) {
      final currentPosition = controller.value.position;
      final newPosition = currentPosition + delta;
      final clampedPosition = Duration(
        milliseconds: newPosition.inMilliseconds.clamp(
          0,
          controller.value.duration.inMilliseconds,
        ),
      );
      controller.seekTo(clampedPosition);
    }
  }

}
