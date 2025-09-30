import 'package:clones_desktop/assets.dart';
import 'package:flutter/material.dart';

class TimelinePlayhead extends StatelessWidget {
  const TimelinePlayhead({
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

    if (durationMs <= 0) return const SizedBox.shrink();

    final currentMs = currentPosition.inMilliseconds.toDouble();
    final playheadPosition = (currentMs / durationMs) * timelineWidth;

    return Positioned(
      left: playheadPosition.clamp(0.0, timelineWidth),
      top: -10,
      bottom: -10,
      child: Container(
        width: 2,
        decoration: BoxDecoration(
          color: ClonesColors.primary,
          boxShadow: [
            BoxShadow(
              color: ClonesColors.primary.withValues(alpha: 0.3),
              blurRadius: 3,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // Playhead handle at the top
            Positioned(
              top: -5,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: ClonesColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
