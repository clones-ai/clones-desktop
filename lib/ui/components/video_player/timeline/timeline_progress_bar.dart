import 'package:clones_desktop/assets.dart';
import 'package:flutter/material.dart';

class TimelineProgressBar extends StatelessWidget {
  const TimelineProgressBar({
    required this.currentPosition,
    required this.totalDuration,
    required this.timelineWidth,
    super.key,
  });

  final Duration currentPosition;
  final Duration totalDuration;
  final double timelineWidth;

  @override
  Widget build(BuildContext context) {
    final durationMs = totalDuration.inMilliseconds.toDouble();
    if (durationMs > 0) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: (currentPosition.inMilliseconds / durationMs) * timelineWidth,
          height: 4,
          decoration: BoxDecoration(
            color: ClonesColors.secondary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
