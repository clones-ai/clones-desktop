import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/video_player/video_state.dart';
import 'package:clones_desktop/ui/views/demo_detail/bloc/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DemoVideoControls extends ConsumerWidget {
  const DemoVideoControls({
    super.key,
    required this.videoId,
    required this.onPlayPause,
    required this.onStop,
    required this.onSeekBackward,
    required this.onSeekForward,
    required this.onSpeedChange,
    this.showSpeedControls = true,
  });

  final String videoId;
  final VoidCallback onPlayPause;
  final VoidCallback onStop;
  final VoidCallback onSeekBackward;
  final VoidCallback onSeekForward;
  final ValueChanged<double> onSpeedChange;
  final bool showSpeedControls;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoState = ref.watch(videoStateNotifierProvider(videoId));
    final demoDetail = ref.watch(demoDetailNotifierProvider);
    final hasAxTreeEvents = demoDetail.events.any((e) => e.event == 'axtree');

    return CardWidget(
      variant: CardVariant.secondary,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Speed controls and AxTree toggle (left side)
            Row(
              children: [
                if (showSpeedControls) ...[
                  _SpeedButton(
                    speed: videoState.currentSpeed,
                    onSpeedChange: onSpeedChange,
                  ),
                  const SizedBox(width: 16),
                ],
                // AxTree overlay toggle
                if (hasAxTreeEvents) ...[
                  _AxTreeToggleButton(
                    isEnabled: demoDetail.showAxTreeOverlay,
                    onToggle: () {
                      ref.read(demoDetailNotifierProvider.notifier).toggleAxTreeOverlay();
                    },
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
                  icon: videoState.isLoading
                      ? Icons.hourglass_empty
                      : (videoState.isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: videoState.isLoading ? null : onPlayPause,
                  tooltip: videoState.isPlaying ? 'Pause (Space)' : 'Play (Space)',
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
            _TimeIndicator(videoId: videoId),
          ],
        ),
      ),
    );
  }
}

class _AxTreeToggleButton extends StatelessWidget {
  const _AxTreeToggleButton({
    required this.isEnabled,
    required this.onToggle,
  });

  final bool isEnabled;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: isEnabled ? 'Hide AxTree overlay' : 'Show AxTree overlay',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onToggle,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isEnabled 
                  ? ClonesColors.tertiary.withValues(alpha: 0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isEnabled 
                    ? ClonesColors.tertiary
                    : ClonesColors.tertiary.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.account_tree,
              size: 20,
              color: isEnabled 
                  ? ClonesColors.tertiary
                  : ClonesColors.tertiary.withValues(alpha: 0.7),
            ),
          ),
        ),
      ),
    );
  }
}

class _SpeedButton extends StatelessWidget {
  const _SpeedButton({
    required this.speed,
    required this.onSpeedChange,
  });

  final double speed;
  final ValueChanged<double> onSpeedChange;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<double>(
      initialValue: speed,
      onSelected: onSpeedChange,
      tooltip: 'Playback speed',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: ClonesColors.tertiary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: ClonesColors.tertiary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Text(
          '${speed}x',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: ClonesColors.tertiary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      itemBuilder: (context) => [
        const PopupMenuItem(value: 0.25, child: Text('0.25x')),
        const PopupMenuItem(value: 0.5, child: Text('0.5x')),
        const PopupMenuItem(value: 0.75, child: Text('0.75x')),
        const PopupMenuItem(value: 1.0, child: Text('1x')),
        const PopupMenuItem(value: 1.25, child: Text('1.25x')),
        const PopupMenuItem(value: 1.5, child: Text('1.5x')),
        const PopupMenuItem(value: 2.0, child: Text('2x')),
      ],
    );
  }
}

class _TransportButton extends StatelessWidget {
  const _TransportButton({
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.isPrimary = false,
    this.size = 24,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final bool isPrimary;
  final double size;

  @override
  Widget build(BuildContext context) {
    final widget = Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(size / 2),
        onTap: onPressed,
        child: Container(
          width: size + 16,
          height: size + 16,
          decoration: BoxDecoration(
            color: isPrimary
                ? ClonesColors.primary.withValues(alpha: 0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(size / 2),
            border: isPrimary
                ? Border.all(color: ClonesColors.primary, width: 1)
                : null,
          ),
          child: Icon(
            icon,
            size: size,
            color: onPressed != null
                ? (isPrimary ? ClonesColors.primary : ClonesColors.tertiary)
                : ClonesColors.tertiary.withValues(alpha: 0.5),
          ),
        ),
      ),
    );

    return tooltip != null
        ? Tooltip(message: tooltip!, child: widget)
        : widget;
  }
}

String _formatDuration(Duration duration) {
  final minutes = duration.inMinutes;
  final seconds = duration.inSeconds % 60;
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}

class _TimeIndicator extends ConsumerWidget {
  const _TimeIndicator({required this.videoId});

  final String videoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoState = ref.watch(videoStateNotifierProvider(videoId));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: ClonesColors.tertiary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: ClonesColors.tertiary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        '${_formatDuration(videoState.currentPosition)} / ${_formatDuration(videoState.totalDuration)}',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: ClonesColors.tertiary,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}
