import 'package:clones_desktop/application/factory.dart';
import 'package:clones_desktop/application/session/provider.dart';
import 'package:clones_desktop/application/tauri_api.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/domain/models/submission/claim_authorization.dart';
import 'package:clones_desktop/domain/models/submission/grade_result.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:clones_desktop/ui/components/design_widget/message_box/message_box.dart';
import 'package:clones_desktop/ui/components/wallet_not_connected.dart';
import 'package:clones_desktop/ui/views/demo_detail/bloc/provider.dart';
import 'package:clones_desktop/utils/env.dart';
import 'package:clones_desktop/utils/format_address.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DemoDetailRewards extends ConsumerWidget {
  const DemoDetailRewards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected =
        ref.watch(sessionNotifierProvider.select((s) => s.isConnected));
    if (isConnected == false) {
      return const WalletNotConnected();
    }

    final recording = ref.watch(demoDetailNotifierProvider).recording;
    final submission = recording?.submission;
    final poolId = recording?.demonstration?.poolId;

    if (submission == null || poolId == null) {
      return const SizedBox.shrink();
    }

    final factoryAsync = ref.watch(getFactoryProvider(factoryId: poolId));

    return factoryAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(
          strokeWidth: 0.5,
        ),
      ),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
      data: (factory) {
        final tokenSymbol = factory.token.symbol;

        final theme = Theme.of(context);
        final score =
            submission.gradeResult?.score ?? submission.clampedScore ?? 0;
        final maxReward = submission.maxReward ?? 0;
        final reward = submission.reward ?? 0;

        return Column(
          children: [
            CardWidget(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rewards',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Earned:',
                        style: theme.textTheme.bodyMedium,
                      ),
                      Text(
                        '$reward \$$tokenSymbol',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: ClonesColors.getScoreColor(score),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Max Reward:',
                        style: theme.textTheme.bodyMedium,
                      ),
                      Text(
                        '$maxReward \$$tokenSymbol',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: ClonesColors.getScoreColor(100),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  LinearProgressIndicator(
                    value: maxReward > 0 ? reward / maxReward : 0,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  const SizedBox(height: 20),
                  if (submission.gradeResult?.reasoningSystem != null &&
                      submission.gradeResult!.reasoningSystem.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: MessageBox(
                        messageBoxType: MessageBoxType.info,
                        content: Text(
                          submission.gradeResult?.reasoningSystem ?? '',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  if (submission.claimAuthorization != null)
                    _buildClaimAuthorizationSection(
                      context,
                      ref,
                      submission.claimAuthorization!,
                      tokenSymbol,
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildClaimAuthorizationSection(
    BuildContext context,
    WidgetRef ref,
    ClaimAuthorization claimAuth,
    String tokenSymbol,
  ) {
    final theme = Theme.of(context);

    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pool Address:',
              style: theme.textTheme.bodyMedium,
            ),
            InkWell(
              onTap: () async {
                try {
                  await ref.read(tauriApiClientProvider).openExternalUrl(
                        '${Env.baseScanBaseUrl}/address/${claimAuth.poolAddress}',
                      );
                } catch (e) {
                  debugPrint('Failed to open external URL: $e');
                }
              },
              child: Row(
                children: [
                  Text(
                    claimAuth.poolAddress.shortAddress(),
                    style: TextStyle(
                      fontFamily: 'monospace',
                      color: ClonesColors.secondaryText,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.open_in_new,
                    color: ClonesColors.secondaryText,
                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: BtnPrimary(
            widthExpanded: true,
            btnPrimaryType: BtnPrimaryType.outlinePrimary,
            buttonText: 'Claim Reward',
            onTap: () =>
                _handleClaimReward(context, ref, claimAuth, tokenSymbol),
          ),
        ),
      ],
    );
  }

  void _handleClaimReward(
    BuildContext context,
    WidgetRef ref,
    ClaimAuthorization claimAuth,
    String tokenSymbol,
  ) {
    // TODO(dev): Implement claim reward functionality via payWithSig contract call
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Claim functionality not yet implemented'),
      ),
    );
  }
}
