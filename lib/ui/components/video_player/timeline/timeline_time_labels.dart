import 'package:clones_desktop/utils/format_time.dart';
import 'package:flutter/material.dart';

class TimelineTimeLabels extends StatelessWidget {
  const TimelineTimeLabels({
    required this.totalDuration,
    required this.timelineWidth,
    super.key,
  });

  final Duration totalDuration;
  final double timelineWidth;

  @override
  Widget build(BuildContext context) {
    final durationMs = totalDuration.inMilliseconds.toDouble();
    final theme = Theme.of(context);

    if (durationMs <= 0) return const SizedBox.shrink();

    // Calculate appropriate interval based on duration
    int intervalMs;
    if (durationMs < 30000) {
      // < 30 seconds: 5s intervals
      intervalMs = 5000;
    } else if (durationMs < 120000) {
      // < 2 minutes: 10s intervals
      intervalMs = 10000;
    } else if (durationMs < 300000) {
      // < 5 minutes: 30s intervals
      intervalMs = 30000;
    } else if (durationMs < 1800000) {
      // < 30 minutes: 1min intervals
      intervalMs = 60000;
    } else {
      // > 30 minutes: 5min intervals
      intervalMs = 300000;
    }

    final labels = <Widget>[];

    // Add time labels at intervals
    for (var timeMs = 0; timeMs <= durationMs; timeMs += intervalMs) {
      final position = (timeMs / durationMs) * timelineWidth;

      labels
        ..add(
          Positioned(
            left: position - 15, // Center the label
            bottom: 0,
            child: Container(
              width: 30,
              alignment: Alignment.center,
              child: Text(
                formatVideoTime(Duration(milliseconds: timeMs)),
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 10,
                  color: Colors.white60,
                ),
              ),
            ),
          ),
        )

        // Add tick marks
        ..add(
          Positioned(
            left: position,
            bottom: 20,
            child: Container(
              width: 1,
              height: 6,
              color: Colors.white30,
            ),
          ),
        );
    }

    return Stack(children: labels);
  }
}
