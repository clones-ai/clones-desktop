import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:clones_desktop/ui/components/design_widget/message_box/message_box.dart';
import 'package:clones_desktop/ui/views/demo_detail/layouts/demo_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RecordingPanel extends StatelessWidget {
  const RecordingPanel({
    super.key,
    required this.recordingId,
  });

  final String recordingId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, top: 15),
          child: MessageBox(
            messageBoxType: MessageBoxType.talkRight,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Recording saved!',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(width: 20),
                BtnPrimary(
                  onTap: () {
                    context.push(
                      DemoDetailView.routeName,
                      extra: recordingId,
                    );
                  },
                  buttonText: 'View details',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
