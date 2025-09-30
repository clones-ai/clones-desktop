import 'package:flutter/material.dart';

class TimelineBaseTrack extends StatelessWidget {
  const TimelineBaseTrack({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
