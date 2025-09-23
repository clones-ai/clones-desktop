import 'package:clones_desktop/domain/models/message/message.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:clones_desktop/ui/views/training_session/bloc/provider.dart';
import 'package:clones_desktop/ui/views/training_session/layouts/components/message_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadButton extends ConsumerWidget {
  const UploadButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trainingSession = ref.watch(trainingSessionNotifierProvider);

    const assistantMessage = MessageItem(
      message: Message(
        role: 'assistant',
        content:
            'Ready to submit your demonstration to get scored and earn Tokens?',
      ),
      index: -1,
    );

    final userActions = CardWidget(
      variant: CardVariant.secondary,
      padding: CardPadding.large,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          BtnPrimary(
            onTap: () async {
              final success = await ref
                  .read(trainingSessionNotifierProvider.notifier)
                  .deleteRecording();

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Recording deleted successfully'
                          : 'Failed to delete recording',
                    ),
                  ),
                );
              }
            },
            buttonText: "Don't like your recording? Click to delete it.",
            btnPrimaryType: BtnPrimaryType.outlinePrimary,
          ),
          const SizedBox(width: 16),
          BtnPrimary(
            onTap: trainingSession.isUploading ||
                    trainingSession.availableSftData.isEmpty
                ? null
                : () {
                    ref
                        .read(
                          trainingSessionNotifierProvider.notifier,
                        )
                        .uploadRecording(
                          trainingSession.currentRecordingId!,
                        );
                  },
            buttonText: trainingSession.isUploading
                ? 'Uploading...'
                : trainingSession.availableSftData.isEmpty
                    ? 'Cannot upload - all messages deleted'
                    : 'Upload Demonstration',
            isLoading: trainingSession.isUploading,
            isLocked: trainingSession.isUploading ||
                trainingSession.availableSftData.isEmpty,
          ),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        assistantMessage,
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerRight,
          child: userActions,
        ),
      ],
    );
  }
}
