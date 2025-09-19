import 'package:clones_desktop/domain/models/factory/gas.dart';
import 'package:clones_desktop/utils/format_num.dart';
import 'package:flutter/material.dart';

/// Smart gas alert widget that warns users when gas costs are too high
class GasAlertWidget extends StatelessWidget {
  const GasAlertWidget({
    super.key,
    required this.gasAnalysis,
    this.onDismiss,
    this.onProceed,
    this.showProceedButton = true,
  });
  final GasAnalysis gasAnalysis;
  final VoidCallback? onDismiss;
  final VoidCallback? onProceed;
  final bool showProceedButton;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    Color backgroundColor;
    Color borderColor;
    IconData alertIcon;

    // Determine alert level based on gas cost vs reward
    if (gasAnalysis.gasCostVsReward > 50) {
      backgroundColor = isDarkMode
          ? Colors.red.shade900.withValues(alpha: 0.3)
          : Colors.red.shade50;
      borderColor = Colors.red.shade400;
      alertIcon = Icons.error;
    } else if (gasAnalysis.gasCostVsReward > 25) {
      backgroundColor = isDarkMode
          ? Colors.orange.shade900.withValues(alpha: 0.3)
          : Colors.orange.shade50;
      borderColor = Colors.orange.shade400;
      alertIcon = Icons.warning;
    } else if (gasAnalysis.gasCostVsReward > 10) {
      backgroundColor = isDarkMode
          ? Colors.yellow.shade900.withValues(alpha: 0.3)
          : Colors.yellow.shade50;
      borderColor = Colors.yellow.shade600;
      alertIcon = Icons.info;
    } else {
      backgroundColor = isDarkMode
          ? Colors.green.shade900.withValues(alpha: 0.3)
          : Colors.green.shade50;
      borderColor = Colors.green.shade400;
      alertIcon = Icons.check_circle;
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                alertIcon,
                color: borderColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Gas Cost Analysis',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: borderColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (onDismiss != null)
                IconButton(
                  icon: Icon(Icons.close, size: 20, color: borderColor),
                  onPressed: onDismiss,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Gas cost details
          _buildDetailRow(
            context,
            'Estimated Gas Cost:',
            '\$${gasAnalysis.estimatedGas.totalGasCostUsd.toStringAsFixedLowValue(2, 5)}',
          ),
          _buildDetailRow(
            context,
            'Net Reward:',
            '\$${gasAnalysis.netRewardUsd.toStringAsFixedLowValue(2, 5)}',
          ),
          _buildDetailRow(
            context,
            'Gas vs Reward:',
            '${gasAnalysis.gasCostVsReward.toStringAsFixed(1)}%',
            isHighlight: gasAnalysis.shouldWarn,
          ),

          const SizedBox(height: 12),

          // Recommendation text
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.black26 : Colors.white70,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              gasAnalysis.recommendation,
              style: theme.textTheme.bodyMedium?.copyWith(
                color:
                    theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
              ),
            ),
          ),

          if (showProceedButton) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (gasAnalysis.shouldWarn) ...[
                  TextButton(
                    onPressed: onDismiss,
                    child: Text(
                      'Wait for Better Prices',
                      style: TextStyle(color: borderColor),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                ElevatedButton(
                  onPressed: onProceed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        gasAnalysis.shouldWarn ? borderColor : Colors.green,
                  ),
                  child: Text(
                    gasAnalysis.shouldWarn ? 'Proceed Anyway' : 'Proceed',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    bool isHighlight = false,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium,
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
              color: isHighlight ? Colors.red : null,
            ),
          ),
        ],
      ),
    );
  }
}

/// Gas price monitoring widget for real-time gas price tracking
class GasPriceMonitorWidget extends StatefulWidget {
  const GasPriceMonitorWidget({
    super.key,
    this.gasPriceAdvice,
    this.onRefresh,
    this.isLoading = false,
  });
  final GasPriceAdvice? gasPriceAdvice;
  final VoidCallback? onRefresh;
  final bool isLoading;

  @override
  State<GasPriceMonitorWidget> createState() => _GasPriceMonitorWidgetState();
}

class _GasPriceMonitorWidgetState extends State<GasPriceMonitorWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    if (widget.gasPriceAdvice == null && !widget.isLoading) {
      return const SizedBox.shrink();
    }

    Color getGasPriceColor(String level) {
      switch (level) {
        case 'low':
          return Colors.green;
        case 'medium':
          return Colors.yellow;
        case 'high':
          return Colors.orange;
        case 'very-high':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    String getGasPriceEmoji(String level) {
      switch (level) {
        case 'low':
          return '🟢';
        case 'medium':
          return '🟡';
        case 'high':
          return '🟠';
        case 'very-high':
          return '🔴';
        default:
          return '⚪';
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: widget.isLoading
          ? const Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 0.5),
                ),
                SizedBox(width: 12),
                Text('Checking gas prices...'),
              ],
            )
          : Row(
              children: [
                Text(
                  getGasPriceEmoji(widget.gasPriceAdvice!.gasPriceLevel),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gas: ${widget.gasPriceAdvice!.gasPriceGwei.toStringAsFixed(2)} Gwei',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: getGasPriceColor(
                            widget.gasPriceAdvice!.gasPriceLevel,
                          ),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (widget.gasPriceAdvice!.suggestedWaitTime != null)
                        Text(
                          widget.gasPriceAdvice!.suggestedWaitTime!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.textTheme.bodySmall?.color
                                ?.withValues(alpha: 0.7),
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, size: 16),
                  onPressed: widget.onRefresh,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
    );
  }
}
