import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/domain/models/message/message.dart';
import 'package:clones_desktop/ui/components/design_widget/message_box/message_box.dart';
import 'package:clones_desktop/ui/components/pfp.dart';
import 'package:clones_desktop/ui/views/training_session/layouts/components/message_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageItem extends ConsumerWidget {
  const MessageItem({
    super.key,
    required this.message,
    required this.index,
  });

  final Message message;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final isUser = message.role == 'user';
    if (message.type != MessageType.text) {
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

        return actionWidget;
      }
      if (message.type == MessageType.recording) {
        return const SizedBox.shrink();
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
