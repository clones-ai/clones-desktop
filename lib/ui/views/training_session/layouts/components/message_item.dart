import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/domain/models/message/message.dart';
import 'package:clones_desktop/ui/components/design_widget/message_box/message_box.dart';
import 'package:clones_desktop/ui/components/pfp.dart';
import 'package:clones_desktop/ui/components/recording_panel.dart';
import 'package:clones_desktop/ui/views/training_session/bloc/provider.dart';
import 'package:clones_desktop/ui/views/training_session/layouts/components/base64_image_message.dart';
import 'package:clones_desktop/ui/views/training_session/layouts/components/message_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageItem extends ConsumerWidget {
  const MessageItem({
    super.key,
    required this.message,
    required this.index,
    this.showDeleteButton = false,
  });

  final Message message;
  final int index;
  final bool showDeleteButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final isUser = message.role == 'user';
    if (message.type != MessageType.text) {
      if (message.type == MessageType.image) {
        final base64 = message.content;
        final imageWidget = Base64ImageMessage(base64: base64);

        // Add delete button for images in replay groups
        if (showDeleteButton && !isUser && message.timestamp != null) {
          return Stack(
            children: [
              imageWidget,
              Positioned(
                top: 0,
                right: 0,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: InkWell(
                    onTap: () => ref
                        .read(trainingSessionNotifierProvider.notifier)
                        .handleDeleteMessage(index, message),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: ClonesColors.deleteButton,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        return imageWidget;
      }

      if (message.type == MessageType.delete) {
        // Parse count from message content: "---startTime endTime count"
        final content = message.content.substring(3);
        final parts = content.trim().split(' ');
        final count = parts.length >= 3 ? int.tryParse(parts[2]) ?? 1 : 1;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            border: Border.all(color: Colors.red.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.visibility_off,
                size: 16,
                color: Colors.red.shade600,
              ),
              const SizedBox(width: 8),
              Text(
                '$count message${count > 1 ? 's' : ''} deleted',
                style: TextStyle(
                  color: Colors.red.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => ref
                    .read(trainingSessionNotifierProvider.notifier)
                    .undoDelete(index),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.shade600,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Restore',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }

      if (message.type == MessageType.action) {
        final actionWidget = Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: mediaQuery.size.width * 0.7,
              ),
              child: MessageBox(
                messageBoxType: MessageBoxType.talkRight,
                content: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.content,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      message.content.toLowerCase().contains('click')
                          ? Icons.ads_click
                          : message.content.toLowerCase().contains('scroll')
                              ? Icons.swap_vert
                              : Icons.keyboard,
                      color: ClonesColors.tertiary,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );

        // Add delete button for actions in replay groups
        if (showDeleteButton && !isUser && message.timestamp != null) {
          return Stack(
            children: [
              actionWidget,
              Positioned(
                top: 0,
                right: 0,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: InkWell(
                    onTap: () => ref
                        .read(trainingSessionNotifierProvider.notifier)
                        .handleDeleteMessage(index, message),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red.shade600,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        return actionWidget;
      }
      if (message.type == MessageType.recording) {
        final id = message.content;
        return RecordingPanel(recordingId: id);
      }
      if (message.type == MessageType.loading) {
        return const Center(
          child: CircularProgressIndicator(
            strokeWidth: 0.5,
          ),
        );
      }
      return Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Card(
          color: isUser ? ClonesColors.primary : ClonesColors.secondary,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              message.content,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ),
      );
    }

    final messageBubble = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment:
          isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 15),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: mediaQuery.size.width * 0.7,
                ),
                child: MessageBox(
                  messageBoxType: isUser
                      ? MessageBoxType.talkRight
                      : MessageBoxType.talkLeft,
                  content: MessageContent(message: message),
                ),
              ),
            ),
            if (!isUser) const Pfp(),
          ],
        ),
      ],
    );

    return messageBubble;
  }
}
