import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/domain/models/leaderboard/stats_leader_board.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeaderboardsStatTotalTasks extends ConsumerWidget {
  const LeaderboardsStatTotalTasks({super.key, required this.stat});

  final LeaderboardStats stat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Expanded(
      child: CardWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: VMColors.containerIcon4.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.task_alt_outlined,
                color: VMColors.containerIcon4.withValues(alpha: 0.7),
                size: 20,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              stat.tasksCompleted.toString(),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'tasks completed',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
