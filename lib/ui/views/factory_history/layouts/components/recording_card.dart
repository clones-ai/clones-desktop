import 'package:clones_desktop/application/recording.dart';
import 'package:clones_desktop/application/tauri_api.dart';
import 'package:clones_desktop/application/upload/provider.dart';
import 'package:clones_desktop/application/upload/state.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/domain/models/recording/api_recording.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:clones_desktop/ui/components/design_widget/dialog/dialog.dart';
import 'package:clones_desktop/ui/components/memory_image_tauri.dart';
import 'package:clones_desktop/ui/components/score_indicator.dart';
import 'package:clones_desktop/ui/views/demo_detail/layouts/demo_detail_view.dart';
import 'package:clones_desktop/utils/format_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class RecordingCard extends ConsumerWidget {
  const RecordingCard({super.key, required this.recording});

  final ApiRecording recording;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uploadQueue = ref.watch(uploadQueueProvider);
    final uploadItem = uploadQueue[recording.id];

    final maxReward = recording.demonstration?.reward?.maxReward ??
        recording.submission?.meta.demonstration.reward?.maxReward ??
        0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          context.push(DemoDetailView.routeName, extra: recording.id);
        },
        child: CardWidget(
          padding: CardPadding.none,
          variant: CardVariant.secondary,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _buildIcon(context),
                const SizedBox(width: 10),
                Expanded(child: _buildTitleAndMeta(context)),
                _buildStatus(context, uploadItem),
                _buildActions(context, ref, uploadItem, maxReward),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    final iconUrl = recording.demonstration?.iconUrl ??
        recording.submission?.meta.demonstration.iconUrl;
    return SizedBox(
      width: 32,
      height: 32,
      child: iconUrl != null
          ? MemoryImageTauri(
              imageUrl: iconUrl,
              width: 32,
              height: 32,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.apps,
                color: ClonesColors.primaryText,
                size: 24,
              ),
            )
          : Icon(Icons.apps, color: ClonesColors.secondaryText),
    );
  }

  Widget _buildTitleAndMeta(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          recording.title,
          style: theme.textTheme.titleMedium,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.schedule, size: 12, color: ClonesColors.secondaryText),
            const SizedBox(width: 4),
            Text(
              formatDurationFromSeconds(recording.durationSeconds),
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.calendar_today,
              size: 12,
              color: ClonesColors.secondaryText,
            ),
            const SizedBox(width: 4),
            Text(
              '${DateFormat.yMd().format(DateTime.parse(recording.timestamp))} ${DateFormat.jm().format(DateTime.parse(recording.timestamp))}',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(width: 8),
            Icon(
              recording.location == 'local'
                  ? Icons.folder_outlined
                  : Icons.cloud_outlined,
              size: 12,
              color: ClonesColors.secondaryText,
            ),
            const SizedBox(width: 4),
            Text(
              recording.location == 'local' ? 'Local' : 'Cloud',
              style: theme.textTheme.bodySmall?.copyWith(
                color: ClonesColors.secondaryText,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatus(BuildContext context, UploadTaskState? uploadItem) {
    final status = recording.submission?.status ?? recording.status;

    if (uploadItem?.uploadStatus == UploadStatus.error || status == 'failed') {
      return _statusChip(
        context,
        'Upload Failed',
        Icons.error_outline,
        Colors.red,
      );
    }
    if (status == 'processing' ||
        status == 'pending' ||
        uploadItem?.uploadStatus == UploadStatus.processing) {
      return _statusChip(
        context,
        'Processing',
        Icons.info_outline,
        Colors.orange,
      );
    }
    if (uploadItem?.uploadStatus == UploadStatus.uploading) {
      return _statusChip(context, 'Uploading', Icons.upload_file, Colors.blue);
    }

    if (recording.submission?.clampedScore != null) {
      return _ratingDisplay(
        context,
        recording.submission!.clampedScore!.toDouble(),
      );
    }
    if ((recording.durationSeconds) < 1) {
      return _statusChip(
        context,
        'Recording Error',
        Icons.error_outline,
        Colors.red,
      );
    }
    if (recording.submission?.gradeResult?.score != null) {
      return _ratingDisplay(
        context,
        recording.submission!.gradeResult!.score.toDouble(),
      );
    }
    if (recording.submission != null) {
      return _ratingDisplay(context, 0);
    }

    return const SizedBox.shrink();
  }

  Widget _statusChip(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Icon(icon, color: color.withValues(alpha: 0.8), size: 16),
          const SizedBox(width: 5),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ratingDisplay(BuildContext context, double score) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ScoreIndicator(
        score: score,
        size: 60,
        strokeWidth: 6,
        label: 'Score',
      ),
    );
  }

  Widget _buildActions(
    BuildContext context,
    WidgetRef ref,
    UploadTaskState? uploadItem,
    double maxReward,
  ) {
    final isUploading = uploadItem?.uploadStatus == UploadStatus.processing ||
        uploadItem?.uploadStatus == UploadStatus.uploading ||
        uploadItem?.uploadStatus == UploadStatus.zipping;
    final isCompleted = uploadItem?.uploadStatus == UploadStatus.done;
    const isQueued = false; // Not in UploadStatus enum
    final theme = Theme.of(context);
    return Row(
      children: [
        if (recording.status == 'completed' &&
            recording.submission == null &&
            !isCompleted)
          BtnPrimary(
            onTap: isUploading || isQueued
                ? null
                : () {
                    ref.read(uploadQueueProvider.notifier).upload(
                          recording.id,
                          recording.demonstration?.poolId ?? '',
                          recording.title,
                        );
                  },
            isLoading: isUploading,
            icon: Icons.upload,
            btnPrimaryType: BtnPrimaryType.outlinePrimary,
            buttonText: isUploading
                ? 'Uploading...'
                : isQueued
                    ? 'Queued'
                    : maxReward > 0
                        ? 'Upload for ${maxReward.toStringAsFixed(2)} Tokens'
                        : 'Upload Recording',
          ),
        if (recording.location == 'local')
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: ClonesColors.secondaryText),
            color: Colors.black.withValues(alpha: 0.9),
            onSelected: (value) async {
              switch (value) {
                case 'open_folder':
                  await ref
                      .read(tauriApiClientProvider)
                      .openRecordingFolder(recording.id);
                  break;
                case 'export_zip':
                  final result = await ref
                      .read(tauriApiClientProvider)
                      .exportRecording(recording.id);
                  if (result.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Record exported successfully',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Failed to export recording',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    );
                  }

                  break;
                case 'delete':
                  await AppDialogs.showConfirmDialog(
                    context,
                    ref,
                    'Confirm Deletion',
                    'Are you sure you want to delete this record?',
                    'Delete',
                    () async {
                      await ref
                          .read(tauriApiClientProvider)
                          .deleteRecording(recording.id);
                      ref.invalidate(mergedRecordingsProvider);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Record deleted successfully',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      );
                    },
                  );

                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'open_folder',
                child: ListTile(
                  leading:
                      Icon(Icons.folder, color: ClonesColors.secondaryText),
                  title: Text(
                    'Open Folder',
                    style: TextStyle(color: ClonesColors.secondaryText),
                  ),
                ),
              ),
              PopupMenuItem<String>(
                value: 'export_zip',
                child: ListTile(
                  leading:
                      Icon(Icons.archive, color: ClonesColors.secondaryText),
                  title: Text(
                    'Export Zip',
                    style: TextStyle(color: ClonesColors.secondaryText),
                  ),
                ),
              ),
              if (recording.submission == null)
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete, color: Colors.red),
                    title: Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
