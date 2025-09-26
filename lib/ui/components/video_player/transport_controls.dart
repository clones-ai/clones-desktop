import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/utils/format_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransportControls extends ConsumerWidget {
  const TransportControls({
    super.key,
    required this.isPlaying,
    required this.isLoading,
    required this.onPlayPause,
    required this.onStop,
    required this.onSeekBackward,
    required this.onSeekForward,
    required this.onSpeedChange,
    this.currentSpeed = 1.0,
    this.showSpeedControls = true,
    this.currentPosition,
    this.totalDuration,
  });

  final bool isPlaying;
  final bool isLoading;
  final VoidCallback onPlayPause;
  final VoidCallback onStop;
  final VoidCallback onSeekBackward;
  final VoidCallback onSeekForward;
  final ValueChanged<double> onSpeedChange;
  final double currentSpeed;
  final bool showSpeedControls;
  final Duration? currentPosition;
  final Duration? totalDuration;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CardWidget(
      variant: CardVariant.secondary,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Speed controls (left side)
            Row(
              children: [
                if (showSpeedControls) ...[
                  _SpeedButton(
                    speed: currentSpeed,
                    onSpeedChange: onSpeedChange,
                  ),
                  const SizedBox(width: 16),
                ],
              ],
            ),

            // Main transport controls (center)
            Row(
              children: [
                _TransportButton(
                  icon: Icons.skip_previous,
                  onPressed: onSeekBackward,
                  tooltip: 'Previous frame (←)',
                  size: 28,
                ),
                const SizedBox(width: 8),
                _TransportButton(
                  icon: isLoading
                      ? Icons.hourglass_empty
                      : (isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: isLoading ? null : onPlayPause,
                  tooltip: isPlaying ? 'Pause (Space)' : 'Play (Space)',
                  isPrimary: true,
                  size: 36,
                ),
                const SizedBox(width: 8),
                _TransportButton(
                  icon: Icons.stop,
                  onPressed: onStop,
                  tooltip: 'Stop',
                  size: 28,
                ),
                const SizedBox(width: 8),
                _TransportButton(
                  icon: Icons.skip_next,
                  onPressed: onSeekForward,
                  tooltip: 'Next frame (→)',
                  size: 28,
                ),
              ],
            ),

            // Time indicator (right side)
            if (currentPosition != null && totalDuration != null)
              _TimeIndicator(
                currentPosition: currentPosition!,
                totalDuration: totalDuration!,
              )
            else
              const SizedBox(width: 80), // Placeholder to maintain layout
          ],
        ),
      ),
    );
  }
}

class _TransportButton extends StatelessWidget {
  const _TransportButton({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    this.isPrimary = false,
    this.size = 24,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String tooltip;
  final bool isPrimary;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(isPrimary ? 24 : 20),
        child: Container(
          width: isPrimary ? 48 : 40,
          height: isPrimary ? 48 : 40,
          decoration: BoxDecoration(
            color: isPrimary ? ClonesColors.secondary : Colors.transparent,
            borderRadius: BorderRadius.circular(isPrimary ? 24 : 20),
            border: isPrimary
                ? null
                : Border.all(
                    color: ClonesColors.primary.withValues(alpha: 0.2),
                  ),
          ),
          child: Icon(
            icon,
            size: size,
            color: isPrimary
                ? ClonesColors.primaryText.withValues(alpha: 0.8)
                : (onPressed != null
                    ? ClonesColors.secondary
                    : ClonesColors.primaryText.withValues(alpha: 0.6)),
          ),
        ),
      ),
    );
  }
}

class _SpeedButton extends StatefulWidget {
  const _SpeedButton({
    required this.speed,
    required this.onSpeedChange,
  });

  final double speed;
  final ValueChanged<double> onSpeedChange;

  @override
  State<_SpeedButton> createState() => __SpeedButtonState();
}

class __SpeedButtonState extends State<_SpeedButton> {
  static const speeds = [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopupMenuButton<double>(
      onSelected: widget.onSpeedChange,
      itemBuilder: (context) => speeds.map((speed) {
        final isSelected = (speed - widget.speed).abs() < 0.01;
        return PopupMenuItem<double>(
          value: speed,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSelected)
                const Icon(Icons.check, size: 16, color: ClonesColors.primary)
              else
                const SizedBox(width: 16),
              const SizedBox(width: 8),
              Text(
                '${speed}x',
                style: TextStyle(
                  color: isSelected ? ClonesColors.primary : null,
                  fontWeight: isSelected ? FontWeight.w600 : null,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border:
              Border.all(color: ClonesColors.primary.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${widget.speed}x',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: ClonesColors.primaryText.withValues(alpha: 0.8),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeIndicator extends StatelessWidget {
  const _TimeIndicator({
    required this.currentPosition,
    required this.totalDuration,
  });

  final Duration currentPosition;
  final Duration totalDuration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '${formatVideoTime(currentPosition)} / ${formatVideoTime(totalDuration)}',
        style: theme.textTheme.bodySmall?.copyWith(
          fontFamily: 'monospace',
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }
}
