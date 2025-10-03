import 'package:clones_desktop/ui/views/demo_detail/bloc/state.dart';
import 'package:clones_desktop/ui/views/record_overlay/bloc/provider.dart';
import 'package:clones_desktop/ui/views/training_session/bloc/provider.dart';
import 'package:clones_desktop/ui/views/training_session/bloc/state.dart';
import 'package:clones_desktop/utils/format_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecordOverlayHeader extends ConsumerStatefulWidget {
  const RecordOverlayHeader({super.key});

  @override
  ConsumerState<RecordOverlayHeader> createState() =>
      _RecordOverlayHeaderState();
}

class _RecordOverlayHeaderState extends ConsumerState<RecordOverlayHeader>
    with TickerProviderStateMixin {
  late AnimationController _blinkController;
  late Animation<double> _blinkAnimation;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _blinkAnimation = Tween<double>(
      begin: 1,
      end: 0.3,
    ).animate(
      CurvedAnimation(
        parent: _blinkController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trainingSession = ref.watch(trainingSessionNotifierProvider);
    final recordOverlay = ref.watch(recordOverlayNotifierProvider);
    String statusText;
    Color statusColor;

    switch (trainingSession.recordingState) {
      case RecordingState.starting:
        statusText = 'Starting';
        statusColor = Colors.red;
        break;
      case RecordingState.recording:
        statusText = 'Recording';
        statusColor = Colors.red;
        break;
      case RecordingState.stopping:
        statusText = 'Stopping';
        statusColor = Colors.green;
        break;
      case RecordingState.off:
        statusText = 'Stopped';
        statusColor = Colors.grey;
        break;
      case RecordingState.saved:
        statusText = 'Saved';
        statusColor = Colors.green;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            statusText,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Spacer(),
          _buildTimer(context, recordOverlay.seconds),
          const SizedBox(width: 8),
          _buildIconButton(
            recordOverlay.isCollapsed
                ? Icons.keyboard_arrow_up
                : Icons.keyboard_arrow_down,
            ref.read(recordOverlayNotifierProvider.notifier).toggleCollapsed,
          ),
          _buildIconButton(
            recordOverlay.isLocked ? Icons.lock : Icons.lock_open,
            ref.read(recordOverlayNotifierProvider.notifier).toggleLocked,
          ),
        ],
      ),
    );
  }

  Widget _buildTimer(BuildContext context, int seconds) {
    final isWarning = seconds >= kMaxRecordingDuration - 15;

    // Start/stop blinking based on warning state
    if (isWarning && !_blinkController.isAnimating) {
      _blinkController.repeat(reverse: true);
    } else if (!isWarning && _blinkController.isAnimating) {
      _blinkController
        ..stop()
        ..reset();
    }

    if (isWarning) {
      return AnimatedBuilder(
        animation: _blinkAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _blinkAnimation.value,
            child: Text(
              formatTimeWithHours(seconds),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          );
        },
      );
    }

    return Text(
      formatTimeWithHours(seconds),
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: 24,
      height: 24,
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, color: Colors.white, size: 18),
        onPressed: onPressed,
      ),
    );
  }
}
