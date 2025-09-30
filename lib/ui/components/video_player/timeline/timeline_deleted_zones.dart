import 'package:clones_desktop/domain/models/video_clip.dart';
import 'package:flutter/material.dart';

class TimelineDeletedZones extends StatelessWidget {
  const TimelineDeletedZones({
    required this.deletedClipsHistory,
    required this.durationMs,
    required this.timelineWidth,
    super.key,
  });

  final List<List<VideoClip>> deletedClipsHistory;
  final double durationMs;
  final double timelineWidth;

  @override
  Widget build(BuildContext context) {
    // Flatten all deleted clips from all operations
    final allDeletedClips = <VideoClip>[];
    for (final operation in deletedClipsHistory) {
      allDeletedClips.addAll(operation);
    }

    if (allDeletedClips.isEmpty) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: allDeletedClips.map((clip) {
        final left = (clip.start / durationMs) * timelineWidth;
        final right = timelineWidth - (clip.end / durationMs) * timelineWidth;

        return Positioned(
          left: left,
          right: right,
          top: -8,
          bottom: -8,
          child: DecoratedBox(
            decoration: BoxDecoration(
              // Red/orange tint to show deleted zones
              color: Colors.redAccent.withValues(alpha: 0.12),
              border: Border.all(
                color: Colors.redAccent.withValues(alpha: 0.3),
              ),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }).toList(),
    );
  }
}
