// ignore_for_file: use_decorated_box

import 'dart:convert';

import 'package:clones_desktop/application/session/provider.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/domain/models/message/deleted_range.dart';
import 'package:clones_desktop/domain/models/message/sft_message.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/wallet_not_connected.dart';
import 'package:clones_desktop/ui/views/demo_detail/bloc/provider.dart';
import 'package:clones_desktop/utils/format_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

class EditorChatItem {
  EditorChatItem({
    required this.timestamp,
    required this.item,
    required this.type,
  });
  final int timestamp;
  final dynamic
      item; // Can be SftMessage, DeletedRange (start), or DeletedRange (end)
  final String type;
}

class DemoDetailEditor extends ConsumerWidget {
  const DemoDetailEditor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected =
        ref.watch(sessionNotifierProvider.select((s) => s.isConnected));
    final demoDetail = ref.watch(demoDetailNotifierProvider);

    final videoController = demoDetail.videoController;
    final startTime = demoDetail.startTime;
    final theme = Theme.of(context);

    if (isConnected == false) {
      return const WalletNotConnected();
    }

    if (demoDetail.sftMessages.isEmpty && demoDetail.privateRanges.isEmpty) {
      return Center(
        child: Text(
          'No editor data to display.',
          style: theme.textTheme.bodyMedium,
        ),
      );
    }

    final combinedData = <EditorChatItem>[];
    for (final msg in demoDetail.sftMessages) {
      combinedData.add(
        EditorChatItem(timestamp: msg.timestamp, item: msg, type: 'message'),
      );
    }
    for (final range in demoDetail.privateRanges) {
      combinedData
        ..add(
          EditorChatItem(
            timestamp: range.start,
            item: range,
            type: 'range_start',
          ),
        )
        ..add(
          EditorChatItem(timestamp: range.end, item: range, type: 'range_end'),
        );
    }
    combinedData.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    final privateRanges = demoDetail.privateRanges;

    return Column(
      children: [
        if (privateRanges.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            decoration: BoxDecoration(
              color: ClonesColors.secondaryText.withValues(alpha: 0.1),
              border: Border.all(
                color: ClonesColors.secondaryText.withValues(alpha: 0.3),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.visibility_off,
                      size: 16,
                      color: Colors.red.shade400,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${privateRanges.length} privacy ${privateRanges.length == 1 ? 'range' : 'ranges'} active',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _getPrivacyImpactText(privateRanges, demoDetail.sftMessages),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: combinedData.length,
            itemBuilder: (context, index) {
              final chatItem = combinedData[index];
              if (chatItem.type == 'message') {
                return _buildMessageCard(
                  context,
                  ref,
                  chatItem.item,
                  videoController,
                  startTime,
                );
              } else {
                return _buildRangeCard(
                  context,
                  ref,
                  chatItem.item,
                  chatItem.type,
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMessageCard(
    BuildContext context,
    WidgetRef ref,
    SftMessage message,
    VideoPlayerController? videoController,
    int startTime,
  ) {
    final demoDetail = ref.watch(demoDetailNotifierProvider);
    final submissionStatus = demoDetail.recording?.submission?.status;
    final theme = Theme.of(context);

    // Check if message is in a deleted zone
    // Convert absolute timestamp to relative (same as events do)
    final relativeTime = message.timestamp - startTime;
    var isInDeletedZone = false;

    try {
      // Only check if we have deleted history (clips are always initialized)
      if (demoDetail.deletedClipsHistory.isNotEmpty) {
        final notifier = ref.read(demoDetailNotifierProvider.notifier);

        final absoluteCheck =
            notifier.isPositionInDeletedZone(message.timestamp.toDouble());
        final relativeCheck = relativeTime >= 0 &&
            notifier.isPositionInDeletedZone(relativeTime.toDouble());

        // Use whichever works (prefer relative like events)
        isInDeletedZone = relativeTime >= 0 ? relativeCheck : absoluteCheck;
      }
    } catch (e) {
      // If there's an error, just don't mark as deleted
      debugPrint('❌ Error checking deleted zone for message: $e');
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: GestureDetector(
              onTap: () {
                if (videoController != null && startTime > 0) {
                  videoController.seekTo(Duration(milliseconds: relativeTime));
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isInDeletedZone
                      ? Colors.redAccent.withValues(alpha: 0.4)
                      : ClonesColors.secondaryText.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: isInDeletedZone
                      ? Border.all(color: Colors.redAccent)
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF000000).withAlpha(60),
                      blurRadius: 6,
                      offset: const Offset(
                        0,
                        3,
                      ),
                    ),
                  ],
                ),
                child: SelectableText(
                  formatTimeMs(message.timestamp),
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: Container(
              decoration: isInDeletedZone
                  ? BoxDecoration(
                      color: Colors.redAccent.withValues(alpha: 0.12),
                      border: Border.all(
                        color: Colors.redAccent.withValues(alpha: 0.3),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    )
                  : null,
              child: CardWidget(
                variant: CardVariant.secondary,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          message.role.toUpperCase(),
                          style: theme.textTheme.bodySmall,
                        ),
                        if (submissionStatus != 'completed')
                          IconButton(
                            icon: const Icon(
                              Icons.visibility_off_outlined,
                              size: 16,
                              color: ClonesColors.primary,
                            ),
                            tooltip: 'Add privacy range',
                            onPressed: () => ref
                                .read(demoDetailNotifierProvider.notifier)
                                .addPrivateRangeAroundMessage(message),
                          )
                        else
                          const SizedBox(
                            height: 30,
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (message.content is String)
                      Row(
                        children: [
                          Icon(
                            message.content.toLowerCase().contains('click')
                                ? Icons.ads_click
                                : message.content
                                        .toLowerCase()
                                        .contains('scroll')
                                    ? Icons.swap_vert
                                    : Icons.keyboard,
                            color: ClonesColors.tertiary,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SelectableText(
                              message.content
                                  .replaceAll('```python', '')
                                  .replaceAll('```', ''),
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        ],
                      )
                    else
                      Image.memory(
                        base64Decode(message.content['data']),
                        fit: BoxFit.contain,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRangeCard(
    BuildContext context,
    WidgetRef ref,
    DeletedRange range,
    String type,
  ) {
    final isStart = type == 'range_start';
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      color: Colors.blueGrey.shade800,
      child: ListTile(
        visualDensity: VisualDensity.compact,
        title: Text(
          isStart ? 'Privacy Start' : 'Privacy End',
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${(isStart ? range.start : range.end / 1000).toStringAsFixed(2)}s',
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          tooltip: 'Delete range',
          onPressed: () => ref
              .read(demoDetailNotifierProvider.notifier)
              .deletePrivateRange(range),
        ),
        // TODO(reddwarf03): Add up/down buttons
      ),
    );
  }

  String _getPrivacyImpactText(
    List<dynamic> privateRanges,
    List<dynamic> sftMessages,
  ) {
    if (privateRanges.isEmpty) return '';

    // Calculate total masked duration
    final totalMaskedMs = privateRanges.fold<int>(
      0,
      (sum, range) => sum + (range.end - range.start) as int,
    );
    final maskedSeconds = (totalMaskedMs / 1000).round();

    // Calculate masked messages
    final maskedMessages = sftMessages
        .where(
          (msg) => privateRanges.any(
            (range) =>
                msg.timestamp >= range.start && msg.timestamp <= range.end,
          ),
        )
        .length;

    if (maskedSeconds > 0) {
      return '~${maskedSeconds}s of content and $maskedMessages messages will be masked';
    } else {
      return '$maskedMessages messages will be masked';
    }
  }
}
