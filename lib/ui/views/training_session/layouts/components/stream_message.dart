import 'package:clones_desktop/domain/models/message/typing_message.dart';
import 'package:clones_desktop/ui/components/design_widget/message_box/message_box.dart';
import 'package:clones_desktop/ui/components/pfp.dart';
import 'package:flutter/material.dart';

class StreamMessage extends StatelessWidget {
  const StreamMessage({super.key, required this.typingMessage});
  final TypingMessage typingMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final messageBubble = Row(
      mainAxisSize: MainAxisSize.min,
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
                  messageBoxType: MessageBoxType.talkLeft,
                  content: Text(
                    typingMessage.content,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
            const Positioned(
              left: 0,
              top: 0,
              child: Pfp(),
            ),
          ],
        ),
      ],
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [messageBubble],
    );
  }
}
