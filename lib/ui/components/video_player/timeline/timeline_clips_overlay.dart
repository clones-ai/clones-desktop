import 'package:clones_desktop/domain/models/video_clip.dart';
import 'package:flutter/material.dart';

class TimelineClipsOverlay extends StatelessWidget {
  const TimelineClipsOverlay({
    required this.clips,
    required this.selectedIds,
    required this.durationMs,
    required this.timelineWidth,
    super.key,
  });

  final List<VideoClip> clips;
  final Set<String> selectedIds;
  final double durationMs;
  final double timelineWidth;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: clips.map((clip) {
        final left = (clip.start / durationMs) * timelineWidth;
        final right = timelineWidth - (clip.end / durationMs) * timelineWidth;
        final isSelected = selectedIds.contains(clip.id);
        
        return Positioned(
          left: left,
          right: right,
          top: -8,
          bottom: -8,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.lightBlueAccent.withValues(alpha: 0.25)
                  : Colors.white.withValues(alpha: 0.08),
              border: Border.all(
                color: isSelected ? Colors.lightBlueAccent : Colors.white24,
                width: isSelected ? 1.5 : 1,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }).toList(),
    );
  }
}
