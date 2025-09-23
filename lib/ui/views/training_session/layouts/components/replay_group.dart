import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/views/training_session/bloc/state.dart';
import 'package:clones_desktop/ui/views/training_session/layouts/components/message_item.dart';
import 'package:flutter/material.dart';

class ReplayGroup extends StatelessWidget {
  const ReplayGroup({super.key, required this.group});
  final ReplayGroupItem group;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CardWidget(
      variant: CardVariant.secondary,
      padding: CardPadding.large,
      child: Column(
        children: [
          Text(
            'Demonstration Replay',
            style: theme.textTheme.titleSmall,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              children: group.messages.map((message) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: message == group.messages.last ? 0 : 20,
                  ),
                  child: MessageItem(
                    message: message.message,
                    index: message.index,
                    showDeleteButton: true,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
