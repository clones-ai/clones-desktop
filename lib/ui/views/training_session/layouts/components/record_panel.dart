import 'package:clones_desktop/application/token_price_provider.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:clones_desktop/ui/components/design_widget/text/app_text.dart';
import 'package:clones_desktop/ui/views/training_session/bloc/provider.dart';
import 'package:clones_desktop/ui/views/training_session/bloc/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecordPanel extends ConsumerStatefulWidget {
  const RecordPanel({
    super.key,
  });

  @override
  ConsumerState<RecordPanel> createState() => _RecordPanelState();
}

class _RecordPanelState extends ConsumerState<RecordPanel> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trainingSession = ref.watch(trainingSessionNotifierProvider);
    final recordingState = trainingSession.recordingState;
    final recordingLoading = trainingSession.recordingLoading;
    final tokenPrice = ref.watch(
      convertTokenPriceProvider(
        trainingSession.factory?.token.symbol ?? '',
        trainingSession.factory?.pricePerDemo ?? 0,
      ),
    );

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                right: trainingSession.factory?.token != null ? 100 : 0,
              ),
              child: Text(
                trainingSession.recordingDemonstration!.title,
                style: theme.textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 10),
            if (trainingSession.factory?.token != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Complete the task to get a reward.',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'Up to: ${trainingSession.factory?.pricePerDemo ?? 0} ${trainingSession.factory?.token.symbol ?? ''} ',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: ClonesColors.secondary,
                        ),
                      ),
                      tokenPrice.when(
                        data: (price) => Text(
                          '(\$${price.toStringAsFixed(2)})',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: ClonesColors.secondary,
                          ),
                        ),
                        error: (error, stackTrace) => const SizedBox.shrink(),
                        loading: () => const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ],
              )
            else
              Text(
                'Complete the task to get a reward.',
                style: theme.textTheme.bodyMedium,
              ),
            const SizedBox(height: 10),
            Text(
              'Your Objectives:',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            ...trainingSession.recordingDemonstration!.objectives.map(
              (obj) => Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ',
                      style: theme.textTheme.bodyMedium,
                    ),
                    Expanded(
                      child: AppText(
                        text: obj,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildActionButtons(recordingState, recordingLoading),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(
    RecordingState recordingState,
    bool recordingLoading,
  ) {
    if (recordingState == RecordingState.recording) {
      return Row(
        children: [
          BtnPrimary(
            onTap: () =>
                ref.read(trainingSessionNotifierProvider.notifier).giveUp(),
            btnPrimaryType: BtnPrimaryType.outlinePrimary,
            buttonText: 'Give Up',
          ),
          const SizedBox(width: 10),
          BtnPrimary(
            onTap: () => ref
                .read(trainingSessionNotifierProvider.notifier)
                .recordingComplete(),
            buttonText: 'Complete',
          ),
        ],
      );
    } else {
      return BtnPrimary(
        onTap: () =>
            ref.read(trainingSessionNotifierProvider.notifier).startRecording(),
        buttonText: 'Start Recording',
        isLoading: recordingLoading,
      );
    }
  }
}
