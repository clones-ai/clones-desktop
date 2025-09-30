import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/ui/components/video_player/video_state.dart';
import 'package:clones_desktop/ui/views/demo_detail/bloc/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimelineEventMarkers extends ConsumerWidget {
  const TimelineEventMarkers({
    required this.videoId,
    required this.timelineWidth,
    super.key,
  });

  final String videoId;
  final double timelineWidth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoState = ref.watch(videoStateNotifierProvider(videoId));
    final durationMs = videoState.totalDuration.inMilliseconds.toDouble();
    final events = ref.watch(demoDetailNotifierProvider).events;
    final enabledEventTypes =
        ref.watch(demoDetailNotifierProvider).enabledEventTypes;
    final startTime = ref.watch(demoDetailNotifierProvider).startTime;

    if (durationMs > 0) {
      return Stack(
        children: events
            .where(
              (event) =>
                  enabledEventTypes.contains(event.event) &&
                  (event.time - startTime) <= durationMs,
            )
            .map(
              (event) => Positioned(
                left: ((event.time - startTime) / durationMs) * timelineWidth,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: ClonesColors.getEventTypeColor(event.event),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      );
    }
    return const SizedBox.shrink();
  }
}
