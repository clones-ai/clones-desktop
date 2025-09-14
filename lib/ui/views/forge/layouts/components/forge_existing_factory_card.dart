import 'package:clones_desktop/application/factory.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/domain/models/factory/factory.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:clones_desktop/ui/components/factory_status_badge.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgeExistingFactoryCard extends ConsumerStatefulWidget {
  const ForgeExistingFactoryCard({
    super.key,
    required this.factory,
    required this.onTap,
  });

  final Factory factory;
  final VoidCallback onTap;

  @override
  ConsumerState<ForgeExistingFactoryCard> createState() =>
      _ForgeExistingFactoryCardState();
}

class _ForgeExistingFactoryCardState
    extends ConsumerState<ForgeExistingFactoryCard> {
  double? _balance;
  bool _isLoadingBalance = true;
  String? _balanceError;

  @override
  void initState() {
    super.initState();
    _loadBalance();
  }

  Future<void> _loadBalance() async {
    try {
      final balance = await ref.read(
        getFactoryBalanceProvider(
          poolAddress: widget.factory.poolAddress,
        ).future,
      );
      if (mounted) {
        setState(() {
          _balance = balance;
          _isLoadingBalance = false;
          _balanceError = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingBalance = false;
          _balanceError = 'Error loading balance';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CardWidget(
      padding: CardPadding.small,
      child: InkWell(
        onTap: widget.onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: FactoryStatusBadge(status: widget.factory.status),
            ),
            Text(
              widget.factory.name,
              style: theme.textTheme.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pool Balance:',
                  style: TextStyle(
                    color: ClonesColors.secondaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                _getBalanceText(),
              ],
            ),
            _demoProgress(
              context,
            ),
            const SizedBox(height: 8),
            _viewDetailsButton(),
          ],
        ),
      ),
    );
  }

  Widget _getBalanceText() {
    if (_isLoadingBalance) {
      return const SizedBox.square(
        dimension: 12,
        child: CircularProgressIndicator(
          strokeWidth: 0.5,
        ),
      );
    }

    final balanceValue = _balance ?? widget.factory.balance;

    final theme = Theme.of(context);
    return Text(
      _balanceError != null
          ? _balanceError.toString()
          : '$balanceValue ${widget.factory.token.symbol}',
      style: theme.textTheme.bodyMedium?.copyWith(
        color: balanceValue == 0 ? ClonesColors.error : ClonesColors.secondary,
      ),
    );
  }

  Widget _demoProgress(
    BuildContext context,
  ) {
    final pricePerDemo = widget.factory.pricePerDemo;
    final balance = _balance ?? widget.factory.balance;
    final possibleDemos = (pricePerDemo > 0)
        ? (Decimal.parse(
                  balance.toString(),
                ) /
                Decimal.parse(pricePerDemo.toString()))
            .toDouble()
            .floor()
        : 0;

    final demoPercentage = possibleDemos > 0
        ? (widget.factory.demonstrations / possibleDemos * 100).clamp(0, 100)
        : 0;

    if (pricePerDemo == 0) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                'Sessions completed',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: ClonesColors.secondaryText,
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '${widget.factory.demonstrations} / $possibleDemos',
              style: TextStyle(
                color: ClonesColors.secondaryText,
                fontSize: 12,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
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
            if (widget.factory.demonstrations >= possibleDemos)
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
    );
  }

  Widget _viewDetailsButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: BtnPrimary(
        widthExpanded: true,
        onTap: widget.onTap,
        buttonText: 'View Details',
      ),
    );
  }
}
