import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/domain/models/recording/recording_event.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/video_player/axtree_overlay.dart';
import 'package:clones_desktop/ui/components/video_player/video_state.dart';
import 'package:clones_desktop/ui/views/demo_detail/bloc/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DemoDetailVideoPreview extends ConsumerStatefulWidget {
  const DemoDetailVideoPreview({
    super.key,
    this.onExpand,
    this.videoWidget,
    this.videoId,
  });
  final VoidCallback? onExpand;
  final Widget? videoWidget;
  final String? videoId;

  @override
  ConsumerState<DemoDetailVideoPreview> createState() =>
      _DemoDetailVideoPreviewState();
}

class _DemoDetailVideoPreviewState
    extends ConsumerState<DemoDetailVideoPreview> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(demoDetailNotifierProvider);

    final theme = Theme.of(context);

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
                Row(
                  children: [
                    // TODO: Add AxTree toggle button
                    /*  // AxTree toggle button
                    if (_hasAxTreeEvents())
                      IconButton(
                        icon: Icon(
                          Icons.account_tree,
                          color: state.showAxTreeOverlay 
                              ? ClonesColors.tertiary 
                              : ClonesColors.tertiary.withValues(alpha: 0.5),
                        ),
                        onPressed: () {
                          ref.read(demoDetailNotifierProvider.notifier).toggleAxTreeOverlay();
                        },
                        tooltip: state.showAxTreeOverlay ? 'Hide AxTree overlay' : 'Show AxTree overlay',
                      ),*/
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
              ],
            ),
            const SizedBox(height: 10),
            if (widget.videoWidget == null)
              Text('No video found', style: theme.textTheme.bodyMedium)
            else
              MouseRegion(
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
                      _buildVideoWithOverlay(),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  bool _hasAxTreeEvents() {
    final state = ref.read(demoDetailNotifierProvider);
    return state.events.any((e) => e.event == 'axtree');
  }

  Widget _buildVideoWithOverlay() {
    if (widget.videoWidget == null) {
      return const SizedBox.shrink();
    }

    final state = ref.watch(demoDetailNotifierProvider);

    // If AxTree overlay is disabled or no AxTree events, just return the original video
    if (!state.showAxTreeOverlay || !_hasAxTreeEvents()) {
      return widget.videoWidget!;
    }

    // Find current AxTree event based on video position
    final currentAxTreeEvent = _getCurrentAxTreeEvent();

    if (currentAxTreeEvent == null) {
      return widget.videoWidget!;
    }

    // Get video dimensions (we'll use a standard size for now)
    const videoSize = Size(1200, 675); // 16:9 aspect ratio
    const recordingResolution =
        Size(1920, 1080); // Typical recording resolution

    return Stack(
      children: [
        widget.videoWidget!,
        Positioned.fill(
          child: IgnorePointer(
            child: ColoredBox(
              color: Colors.red.withValues(
                  alpha: 0.3), // Debug: Red overlay to see if it's working
              child: AxTreeOverlay(
                axTreeEvent: currentAxTreeEvent,
                videoSize: videoSize,
                recordingResolution: recordingResolution,
              ),
            ),
          ),
        ),
      ],
    );
  }

  RecordingEvent? _getCurrentAxTreeEvent() {
    final state = ref.read(demoDetailNotifierProvider);
    final videoId = widget.videoId;

    if (videoId == null) {
      return null;
    }

    // Get current video position
    final videoState = ref.read(videoStateNotifierProvider(videoId));
    final currentTimeMs = videoState.currentPosition.inMilliseconds;

    final axTreeEvents =
        state.events.where((e) => e.event == 'axtree').toList();

    if (axTreeEvents.isEmpty) return null;

    // If we have AxTree events, let's check if they use absolute timestamps
    final firstEvent = axTreeEvents.first;
    final isAbsoluteTimestamp =
        firstEvent.time > 1000000000000; // > year 2001 in ms

    if (isAbsoluteTimestamp) {
      // For now, just return the first AxTree event for testing
      // TODO: We need to convert absolute timestamps to relative ones
      return firstEvent;
    }

    // Original logic for relative timestamps
    RecordingEvent? currentEvent;
    for (final event in axTreeEvents) {
      if (event.time <= currentTimeMs) {
        if (currentEvent == null || event.time > currentEvent.time) {
          currentEvent = event;
        }
      }
    }

    return currentEvent;
  }
}
