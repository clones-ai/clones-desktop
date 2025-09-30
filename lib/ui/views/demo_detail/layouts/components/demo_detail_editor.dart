// ignore_for_file: use_decorated_box

import 'dart:convert';

import 'package:clones_desktop/application/session/provider.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/domain/models/message/sft_message.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/wallet_not_connected.dart';
import 'package:clones_desktop/ui/views/demo_detail/bloc/provider.dart';
import 'package:clones_desktop/ui/views/demo_detail/bloc/state.dart';
import 'package:clones_desktop/utils/format_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

class EditorChatItem {
  EditorChatItem({
    required this.timestamp,
    required this.item,
    required this.type,
    this.messageIndex,
  });
  final int timestamp;
  final dynamic item; // Can be SftMessage
  final String type;
  final int?
      messageIndex; // Original index in sftMessages list (for memoization)
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

    if (demoDetail.sftMessages.isEmpty) {
      return Center(
        child: Text(
          'No editor data to display.',
          style: theme.textTheme.bodyMedium,
        ),
      );
    }

    // Get memoized set of messages in deleted zones
    final messagesInDeletedZones = demoDetail.sftMessagesInDeletedZones;
    debugPrint('📝 Editor: messagesInDeletedZones = $messagesInDeletedZones');

    final combinedData = <EditorChatItem>[];
    for (var i = 0; i < demoDetail.sftMessages.length; i++) {
      final msg = demoDetail.sftMessages[i];
      combinedData.add(
        EditorChatItem(
          timestamp: msg.timestamp,
          item: msg,
          type: 'message',
          messageIndex: i,
        ),
      );
    }
    combinedData.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            'This editor section lists structured notes of what happened during the demo. The Clones Quality Agent will use them to evaluate and score the quality of the recording.',
            style: theme.textTheme.bodySmall,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: combinedData.length,
            itemBuilder: (context, index) {
              final chatItem = combinedData[index];
              return _buildMessageCard(
                context,
                ref,
                chatItem.item,
                videoController,
                startTime,
                messagesInDeletedZones,
                chatItem.messageIndex!,
              );
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
    Set<int> messagesInDeletedZones,
    int messageIndex,
  ) {
    final theme = Theme.of(context);

    // Use memoized deleted zone check (computed once per state change)
    final relativeTime = message.timestamp - startTime;
    final isInDeletedZone = messagesInDeletedZones.contains(messageIndex);

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
                        const SizedBox(height: 30),
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
}
