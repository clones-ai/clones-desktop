import 'package:clones_desktop/domain/models/message/message.dart';
import 'package:flutter/material.dart';

class MessageContent extends StatelessWidget {
  const MessageContent({super.key, required this.message});
  final Message message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SelectableText(
      message.content,
      style: theme.textTheme.bodyMedium,
    );
  }
}
