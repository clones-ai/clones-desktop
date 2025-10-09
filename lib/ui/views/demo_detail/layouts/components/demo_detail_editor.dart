// ignore_for_file: use_decorated_box

import 'dart:convert';
import 'dart:typed_data';

import 'package:clones_desktop/application/session/provider.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/domain/models/message/sft_message.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/wallet_not_connected.dart';
import 'package:clones_desktop/ui/views/demo_detail/bloc/provider.dart';
import 'package:clones_desktop/utils/format_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

// Widget with AutomaticKeepAliveClientMixin to avoid rebuilds on scroll
class _MessageCard extends StatefulWidget {
  const _MessageCard({
    required this.message,
    required this.videoController,
    required this.startTime,
    required this.isInDeletedZone,
    required this.messageIndex,
  });

  final SftMessage message;
  final VideoPlayerController? videoController;
  final int startTime;
  final bool isInDeletedZone;
  final int messageIndex;

  @override
  State<_MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<_MessageCard>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  void _showFullscreenImage(BuildContext context, Uint8List imageData) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Stack(
            children: [
              Center(
                child: InteractiveViewer(
                  child: Image.memory(
                    imageData,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    final theme = Theme.of(context);
    final relativeTime = widget.message.timestamp - widget.startTime;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: GestureDetector(
              onTap: () {
                if (widget.videoController != null && widget.startTime > 0) {
                  widget.videoController!
                      .seekTo(Duration(milliseconds: relativeTime));
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: widget.isInDeletedZone
                      ? Colors.redAccent.withValues(alpha: 0.4)
                      : ClonesColors.secondaryText.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: widget.isInDeletedZone
                      ? Border.all(color: Colors.redAccent)
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF000000).withAlpha(60),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: SelectableText(
                  formatTimeMs(widget.message.timestamp),
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: Container(
              decoration: widget.isInDeletedZone
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
                          widget.message.role.toUpperCase(),
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (widget.message.content is String)
                      Row(
                        children: [
                          Icon(
                            widget.message.content
                                    .toLowerCase()
                                    .contains('click')
                                ? Icons.ads_click
                                : widget.message.content
                                        .toLowerCase()
                                        .contains('scroll')
                                    ? Icons.swap_vert
                                    : widget.message.content
                                            .toLowerCase()
                                            .contains('app_focus')
                                        ? Icons.apps
                                        : Icons.keyboard,
                            color: ClonesColors.tertiary,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SelectableText(
                              widget.message.content
                                  .replaceAll('```python', '')
                                  .replaceAll('```', ''),
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        ],
                      )
                    else
                      () {
                        final imageData =
                            base64Decode(widget.message.content['data']);
                        return MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () =>
                                _showFullscreenImage(context, imageData),
                            child: Image.memory(
                              imageData,
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      }(),
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
    final demoDetail = ref.watch(
      demoDetailNotifierProvider.select(
        (state) => (
          sftMessages: state.sftMessages,
          videoController: state.videoController,
          startTime: state.startTime,
          deletedClipsHistory: state.deletedClipsHistory,
          isLoading: state.isLoading,
          recording: state.recording,
        ),
      ),
    );

    final videoController = demoDetail.videoController;
    final startTime = demoDetail.startTime;
    final theme = Theme.of(context);

    if (isConnected == false) {
      return const WalletNotConnected();
    }

    if (demoDetail.sftMessages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (demoDetail.isLoading)
              const CircularProgressIndicator(
                color: ClonesColors.primary,
                strokeWidth: 1,
              )
            else
              Icon(
                demoDetail.recording?.location == 'cloud'
                    ? Icons.cloud_outlined
                    : Icons.edit_off,
                size: 48,
                color: ClonesColors.secondaryText,
              ),
            const SizedBox(height: 16),
            Text(
              demoDetail.isLoading
                  ? 'Loading editor data...'
                  : demoDetail.recording?.location == 'cloud'
                      ? 'Editor data not available for cloud recordings'
                      : 'No editor data to display.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: ClonesColors.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Calculate messages in deleted zones locally
    final messagesInDeletedZones = <int>{};
    if (demoDetail.deletedClipsHistory.isNotEmpty &&
        demoDetail.sftMessages.isNotEmpty) {
      for (var i = 0; i < demoDetail.sftMessages.length; i++) {
        final msg = demoDetail.sftMessages[i];
        final relativeTime = msg.timestamp - demoDetail.startTime;

        var isInDeletedZone = false;
        for (final operation in demoDetail.deletedClipsHistory) {
          for (final clip in operation) {
            if (relativeTime >= clip.start && relativeTime <= clip.end) {
              messagesInDeletedZones.add(i);
              isInDeletedZone = true;
              break;
            }
          }
          if (isInDeletedZone) break;
        }
      }
    }

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
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 10,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: combinedData.length,
            itemBuilder: (context, index) {
              final chatItem = combinedData[index];
              return _MessageCard(
                message: chatItem.item,
                videoController: videoController,
                startTime: startTime,
                isInDeletedZone:
                    messagesInDeletedZones.contains(chatItem.messageIndex),
                messageIndex: chatItem.messageIndex!,
              );
            },
          ),
        ),
      ],
    );
  }
}
