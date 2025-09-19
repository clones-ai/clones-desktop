import 'package:clones_desktop/application/token_price_provider.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/views/forge_detail/bloc/provider.dart';
import 'package:clones_desktop/utils/format_num.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgeFactoryGeneralTabStatDemoPrice extends ConsumerWidget {
  const ForgeFactoryGeneralTabStatDemoPrice({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final factory = ref.watch(forgeDetailNotifierProvider).factory;
    if (factory == null) {
      return const SizedBox.shrink();
    }

    final priceUSD = ref.watch(
        convertTokenPriceProvider(factory.token.symbol, factory.pricePerDemo));
    final theme = Theme.of(context);
    return Expanded(
      child: CardWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ClonesColors.containerIcon1.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.card_giftcard,
                    color: ClonesColors.containerIcon1.withValues(alpha: 0.7),
                    size: 20,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: ClonesColors.containerIcon1.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    factory.token.symbol,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: ClonesColors.containerIcon1.withValues(alpha: 0.7),
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '${formatNumberWithSeparator(factory.pricePerDemo)} ${factory.token.symbol}',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            priceUSD.when(
              data: (price) => Text(
                '(\$${price.toStringAsFixedLowValue(2, 5)})',
                style: theme.textTheme.bodySmall,
              ),
              error: (error, stackTrace) => const SizedBox.shrink(),
              loading: () => const SizedBox.shrink(),
            ),
            const SizedBox(height: 5),
            Text(
              'per demonstration',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
