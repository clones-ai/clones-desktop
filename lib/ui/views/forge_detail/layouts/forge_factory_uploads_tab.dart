import 'package:clones_desktop/application/submissions.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/domain/models/submission/pool_submission.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:clones_desktop/ui/components/modals/download_scripts_modal.dart';
import 'package:clones_desktop/ui/views/forge_detail/bloc/provider.dart';
import 'package:clones_desktop/ui/views/forge_detail/layouts/components/forge_factory_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

final _selectedSubmissionsProvider =
    StateProvider.autoDispose<Set<String>>((ref) => {});

class ForgeFactoryUploadsTab extends ConsumerWidget {
  const ForgeFactoryUploadsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pool = ref.watch(forgeDetailNotifierProvider).pool;
    if (pool == null) return const SizedBox.shrink();

    final submissionsAsync = ref.watch(getPoolSubmissionsProvider(pool.id));

    return submissionsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (submissions) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const ForgeFactoryHeader(),
              _PageHeader(submissions: submissions),
              const SizedBox(height: 24),
              _UploadsTable(submissions: submissions),
            ],
          ),
        );
      },
    );
  }
}

class _PageHeader extends ConsumerWidget {
  const _PageHeader({required this.submissions});
  final List<PoolSubmission> submissions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedSubmissions = ref.watch(_selectedSubmissionsProvider);
    final hasSelection = selectedSubmissions.isNotEmpty;

    VoidCallback? onTapCallback;
    if (hasSelection) {
      onTapCallback = () {
        final submissionsToExport = submissions
            .where((s) => selectedSubmissions.contains(s.id))
            .toList();
        showDialog(
          context: context,
          builder: (context) =>
              DownloadScriptsModal(submissions: submissionsToExport),
        );
      };
    } else {
      if (submissions.isEmpty) {
        onTapCallback = null;
      } else {
        onTapCallback = () {
          showDialog(
            context: context,
            builder: (context) =>
                DownloadScriptsModal(submissions: submissions),
          );
        };
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '3. Uploads',
              style: theme.textTheme.titleMedium,
            ),
            if (hasSelection) ...[
              const SizedBox(width: 8),
              Chip(
                label: Text('${selectedSubmissions.length} selected'),
                padding: const EdgeInsets.all(4),
                backgroundColor: ClonesColors.secondary.withOpacity(0.2),
                labelStyle: theme.textTheme.bodySmall
                    ?.copyWith(color: ClonesColors.secondary),
              ),
            ],
          ],
        ),
        BtnPrimary(
          buttonText: hasSelection ? 'Export Selected' : 'Export All Uploads',
          onTap: onTapCallback,
        ),
      ],
    );
  }
}

class _UploadsTable extends ConsumerWidget {
  const _UploadsTable({required this.submissions});
  final List<PoolSubmission> submissions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSubmissions = ref.watch(_selectedSubmissionsProvider);

    void onSelectAll(bool? selected) {
      final notifier = ref.read(_selectedSubmissionsProvider.notifier);
      if (selected == true) {
        notifier.state = submissions.map((s) => s.id).toSet();
      } else {
        notifier.state = {};
      }
    }

    return CardWidget(
      padding: CardPadding.none,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                dividerThickness: 0,
                headingRowColor: WidgetStateProperty.all(
                  ClonesColors.tertiary.withOpacity(0.1),
                ),
                columns: [
                  DataColumn(
                    label: Checkbox(
                      value: selectedSubmissions.length == submissions.length &&
                          submissions.isNotEmpty,
                      onChanged: onSelectAll,
                    ),
                  ),
                  const DataColumn(label: Text('Platform')),
                  const DataColumn(label: Text('Task')),
                  const DataColumn(label: Text('Status')),
                  const DataColumn(label: Text('Duration')),
                  const DataColumn(label: Text('Size')),
                  const DataColumn(label: Text('Date')),
                  const DataColumn(label: Text('Quality')),
                  const DataColumn(label: Text('Reward')),
                ],
                rows: submissions
                    .map(
                      (submission) => _buildDataRow(
                        submission,
                        context,
                        ref,
                        selectedSubmissions,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildDataRow(
    PoolSubmission submission,
    BuildContext context,
    WidgetRef ref,
    Set<String> selected,
  ) {
    final isSelected = selected.contains(submission.id);
    final theme = Theme.of(context);
    void onSelect(bool? selected) {
      final notifier = ref.read(_selectedSubmissionsProvider.notifier);
      if (selected == true) {
        notifier.state = {...notifier.state, submission.id};
      } else {
        notifier.state = {...notifier.state..remove(submission.id)};
      }
    }

    return DataRow(
      selected: isSelected,
      cells: [
        DataCell(
          Checkbox(
            value: isSelected,
            onChanged: onSelect,
            activeColor: ClonesColors.primary,
            checkColor: Colors.white,
            side: const BorderSide(color: ClonesColors.primaryText),
          ),
        ),
        DataCell(_PlatformCell(submission: submission)),
        DataCell(
          Text(
            _getTitle(submission),
            style: theme.textTheme.bodyMedium,
          ),
        ),
        DataCell(_StatusCell(submission: submission)),
        DataCell(
          Text(
            _formatDuration(submission),
            style: theme.textTheme.bodyMedium,
          ),
        ),
        DataCell(
          Text(
            _getTotalFileSize(submission),
            style: theme.textTheme.bodyMedium,
          ),
        ),
        DataCell(
          Text(
            _formatDate(submission.createdAt),
            style: theme.textTheme.bodyMedium,
          ),
        ),
        DataCell(_QualityCell(submission: submission)),
        DataCell(_RewardCell(submission: submission)),
      ],
    );
  }
}

String _formatDate(String dateStr) {
  try {
    final dt = DateTime.parse(dateStr);
    return DateFormat.yMMMd().format(dt);
  } catch (_) {
    return dateStr;
  }
}

String _getTitle(PoolSubmission submission) {
  if (submission.meta.demonstration.title.isNotEmpty) {
    return submission.meta.demonstration.title;
  } else if (submission.meta.demonstration.app.isNotEmpty) {
    return submission.meta.demonstration.app;
  }
  return 'Untitled Submission';
}

String _getTotalFileSize(PoolSubmission submission) {
  if (submission.files.isEmpty) {
    return '-';
  }
  final totalSize =
      submission.files.fold<int>(0, (prev, file) => prev + file.size);

  return '${(totalSize / (1024 * 1024)).toStringAsFixed(2)} MB';
}

String _formatDuration(PoolSubmission submission) {
  final seconds = submission.meta.durationSeconds;
  final minutes = seconds ~/ 60;
  final remainingSeconds = seconds % 60;
  return minutes > 0
      ? '${minutes}m ${remainingSeconds}s'
      : '${remainingSeconds}s';
}

class _PlatformCell extends StatelessWidget {
  const _PlatformCell({required this.submission});
  final PoolSubmission submission;

  IconData _getOSIcon(PoolSubmission submission) {
    final platform = submission.meta.platform.toLowerCase();
    if (platform.contains('windows')) return FontAwesomeIcons.desktop;
    if (platform.contains('mac') || platform.contains('darwin')) {
      return FontAwesomeIcons.laptop;
    }
    if (platform.contains('linux')) return FontAwesomeIcons.linux;
    return FontAwesomeIcons.question;
  }

  String _getOSName(PoolSubmission submission) {
    final platform = submission.meta.platform.toLowerCase();
    if (platform.contains('windows')) return 'Windows';
    if (platform.contains('mac') || platform.contains('darwin')) {
      return 'macOS';
    }
    if (platform.contains('linux')) return 'Linux';
    return 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        FaIcon(
          _getOSIcon(submission),
          size: 16,
          color: ClonesColors.secondaryText,
        ),
        const SizedBox(width: 8),
        Text(
          _getOSName(submission),
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _StatusCell extends StatelessWidget {
  const _StatusCell({required this.submission});
  final PoolSubmission submission;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color backgroundColor;
    Color textColor;

    switch (submission.status.toLowerCase()) {
      case 'completed':
        backgroundColor = const Color(0xFF10b981).withOpacity(0.2);
        textColor = const Color(0xFF10b981);
        break;
      case 'failed':
        backgroundColor = const Color(0xFFef4444).withOpacity(0.2);
        textColor = const Color(0xFFf87171);
        break;
      case 'pending':
        backgroundColor = const Color(0xFFf59e0b).withOpacity(0.2);
        textColor = const Color(0xFFfacc15);
        break;
      case 'processing':
        backgroundColor = const Color(0xFFf97316).withOpacity(0.2);
        textColor = const Color(0xFFfb923c);
        break;
      default:
        backgroundColor = Colors.grey.withOpacity(0.2);
        textColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        submission.status,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: textColor,
        ),
      ),
    );
  }
}

class _QualityCell extends StatelessWidget {
  const _QualityCell({required this.submission});
  final PoolSubmission submission;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final score = submission.gradeResult?.score;
    if (score == null) return const Text('-');

    Color color;
    if (score >= 50) {
      color = Colors.green;
    } else if (score >= 25) {
      color = Colors.orange;
    } else {
      color = Colors.red;
    }

    return Text(
      '${score.toStringAsFixed(0)}%',
      style: theme.textTheme.bodyMedium?.copyWith(
        color: color,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _RewardCell extends StatelessWidget {
  const _RewardCell({required this.submission});
  final PoolSubmission submission;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reward = submission.reward;
    if (reward != null && reward > 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          gradient: ClonesColors.gradientBtnPrimary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '$reward Tokens',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'FREE',
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}
