import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/views/forge_detail/bloc/provider.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgeFactoryGeneralTabStatSessionCompleted extends ConsumerWidget {
  const ForgeFactoryGeneralTabStatSessionCompleted({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forgeDetail = ref.watch(forgeDetailNotifierProvider);

    if (forgeDetail.factory == null) return const SizedBox.shrink();

    final pricePerDemo = forgeDetail.factory!.pricePerDemo;
    final possibleDemos = (pricePerDemo > 0)
        ? (Decimal.parse(
                  forgeDetail.factory!.balance.toString(),
                ) /
                Decimal.parse(pricePerDemo.toString()))
            .toDouble()
            .floor()
        : 0;

    final demoPercentage = possibleDemos > 0
        ? (forgeDetail.factory!.demonstrations / possibleDemos * 100)
            .clamp(0, 100)
        : 0;

    if (pricePerDemo == 0) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);

    return Expanded(
      child: CardWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ClonesColors.containerIcon5.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.lightbulb_outline,
                color: ClonesColors.containerIcon5.withValues(alpha: 0.7),
                size: 20,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${forgeDetail.factory!.demonstrations} / $possibleDemos',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Sessions completed',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 10),
            if (possibleDemos == 0)
              Text(
                'You need to fund your factory',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: ClonesColors.error),
              )
            else
              Stack(
                children: [
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          ClonesColors.primary.withValues(alpha: 0.3),
                          ClonesColors.secondary.withValues(alpha: 0.3),
                          ClonesColors.tertiary.withValues(alpha: 0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  if (forgeDetail.factory!.demonstrations >= possibleDemos)
                    FractionallySizedBox(
                      widthFactor: demoPercentage / 100,
                      child: Container(
                        height: 5,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              ClonesColors.rewardInfo.withValues(alpha: 0.3),
                              ClonesColors.rewardInfo,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    )
                  else
                    FractionallySizedBox(
                      widthFactor: demoPercentage / 100,
                      child: Container(
                        height: 5,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              ClonesColors.secondary.withValues(alpha: 0.3),
                              ClonesColors.secondary,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
