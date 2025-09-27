import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:clones_desktop/ui/components/video_player/video_state.dart';
import 'package:clones_desktop/ui/views/demo_detail/bloc/provider.dart';
import 'package:clones_desktop/utils/format_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimelineWidget extends ConsumerStatefulWidget {
  const TimelineWidget({
    required this.videoId,
    this.enableEditing = false,
    this.onSeek,
    super.key,
  });

  final String videoId;
  final bool enableEditing;
  final void Function(Duration)? onSeek;

  @override
  ConsumerState<TimelineWidget> createState() => _TimelineWidgetState();
}

class _TimelineWidgetState extends ConsumerState<TimelineWidget> {
  Offset? _hoverPosition;
  RangeValues? _previewSegment;
  Offset? _lastRightClickGlobal;
  double _lastRightClickTimeMs = 0;
  final FocusNode _timelineFocus = FocusNode(debugLabel: 'timeline');

  @override
  void dispose() {
    _timelineFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enableEditing) {
      return CardWidget(
        variant: CardVariant.transparent,
        child: _buildCustomTimeline(context, ref),
      );
    }

    // With editing enabled, show additional controls
    final state = ref.watch(demoDetailNotifierProvider);
    final canEdit = state.recording?.submission?.status != 'completed';

    return CardWidget(
      variant: CardVariant.secondary,
      child: Column(
        children: [
          _buildCustomTimeline(context, ref),
          if (canEdit &&
              (state.deletedSegments.isNotEmpty ||
                  state.clipSegments.isNotEmpty))
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: BtnPrimary(
                onTap: ref.read(demoDetailNotifierProvider.notifier).applyEdits,
                icon: Icons.check,
                buttonText: 'Apply Edits',
                btnPrimaryType: BtnPrimaryType.outlinePrimary,
                isLoading: state.isApplyingEdits,
                isLocked: state.isApplyingEdits,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCustomTimeline(
    BuildContext context,
    WidgetRef ref,
  ) {
    final videoState = ref.watch(videoStateNotifierProvider(widget.videoId));

    final duration = videoState.totalDuration;
    final durationMs = duration.inMilliseconds.toDouble();

    return KeyboardListener(
      focusNode: _timelineFocus,
      onKeyEvent: (KeyEvent event) {
        if (event is! KeyDownEvent) return;
        final key = event.logicalKey;
        final videoStateNotifier =
            ref.read(videoStateNotifierProvider(widget.videoId).notifier);

        if (key == LogicalKeyboardKey.space) {
          if (videoState.isPlaying) {
            videoStateNotifier.setPaused();
          } else {
            videoStateNotifier.setPlaying();
          }
        } else if (widget.enableEditing) {
          // Only allow editing shortcuts if editing is enabled
          final isCtrlOrCmd = HardwareKeyboard.instance.isControlPressed ||
              HardwareKeyboard.instance.isMetaPressed;
          final notifier = ref.read(demoDetailNotifierProvider.notifier);
          final playheadMs =
              videoState.currentPosition.inMilliseconds.toDouble();

          if (key == LogicalKeyboardKey.keyB ||
              (isCtrlOrCmd && key == LogicalKeyboardKey.keyB)) {
            notifier.splitClipAt(playheadMs);
          } else if (key == LogicalKeyboardKey.delete ||
              key == LogicalKeyboardKey.backspace) {
            notifier.deleteSelectedClips();
          } else if (isCtrlOrCmd && key == LogicalKeyboardKey.keyX) {
            notifier.cutSelectedClips();
          } else if (isCtrlOrCmd && key == LogicalKeyboardKey.keyC) {
            notifier.copySelectedClips();
          } else if (isCtrlOrCmd && key == LogicalKeyboardKey.keyV) {
            notifier.pasteClipboardAt(playheadMs);
          } else if (key == LogicalKeyboardKey.keyT ||
              (isCtrlOrCmd && key == LogicalKeyboardKey.keyT)) {
            notifier.trimToPlayhead(playheadMs);
          }
        }
      },
      child: Container(
        height: 80, // Increased height to accommodate time labels
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final timelineWidth = constraints.maxWidth;

            return GestureDetector(
              onTapUp: (details) {
                final clickPosition = details.localPosition.dx;
                final seekTime =
                    (clickPosition / timelineWidth * durationMs).round();
                final seekDuration = Duration(milliseconds: seekTime);
                if (widget.onSeek != null) {
                  widget.onSeek!(seekDuration);
                } else {
                  // Fallback - just update position state
                  ref
                      .read(videoStateNotifierProvider(widget.videoId).notifier)
                      .updatePosition(seekDuration);
                }
                _timelineFocus.requestFocus();

                // Left-click selects the clip under the cursor (iMovie-like) - only if editing is enabled
                if (widget.enableEditing) {
                  final clips =
                      ref.read(demoDetailNotifierProvider).clipSegments;
                  final ms = clickPosition / timelineWidth * durationMs;
                  final idx =
                      clips.indexWhere((c) => ms >= c.start && ms <= c.end);
                  if (idx != -1) {
                    ref
                        .read(demoDetailNotifierProvider.notifier)
                        .selectClip(idx);
                  }
                }
              },
              onHorizontalDragStart: widget.enableEditing
                  ? (details) {
                      final clickTime =
                          details.localPosition.dx / timelineWidth * durationMs;
                      setState(() {
                        _previewSegment = RangeValues(clickTime, clickTime);
                      });
                    }
                  : null,
              onHorizontalDragUpdate: widget.enableEditing
                  ? (details) {
                      if (_previewSegment == null) return;
                      final dragEnd = (details.localPosition.dx /
                              timelineWidth *
                              durationMs)
                          .clamp(0.0, durationMs);
                      setState(() {
                        _previewSegment =
                            RangeValues(_previewSegment!.start, dragEnd);
                      });
                    }
                  : null,
              onHorizontalDragEnd: widget.enableEditing
                  ? (_) {
                      if (_previewSegment != null) {
                        final start =
                            _previewSegment!.start < _previewSegment!.end
                                ? _previewSegment!.start
                                : _previewSegment!.end;
                        final end =
                            _previewSegment!.start < _previewSegment!.end
                                ? _previewSegment!.end
                                : _previewSegment!.start;
                        if ((end - start) > 100) {
                          ref
                              .read(demoDetailNotifierProvider.notifier)
                              .addDeletedSegment(RangeValues(start, end));
                        }
                      }
                      setState(() => _previewSegment = null);
                    }
                  : null,
              onSecondaryTapDown: widget.enableEditing
                  ? (details) {
                      // Remember where the context menu should open
                      final global = details.globalPosition;
                      setState(() => _lastRightClickGlobal = global);

                      // Compute playhead time at click
                      final box = context.findRenderObject() as RenderBox?;
                      final local = box?.globalToLocal(global);
                      if (local != null) {
                        _lastRightClickTimeMs =
                            (local.dx / timelineWidth * durationMs)
                                .clamp(0.0, durationMs);
                      }
                      _timelineFocus.requestFocus();
                      _openContextMenu(
                        context,
                        ref,
                        durationMs,
                        timelineWidth,
                      );
                    }
                  : null,
              child: MouseRegion(
                onHover: (event) =>
                    setState(() => _hoverPosition = event.localPosition),
                onExit: (_) => setState(() => _hoverPosition = null),
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    _buildTimeLabels(context, videoState, timelineWidth),
                    _buildBaseTrack(context),
                    _buildProgressBar(context, videoState, timelineWidth),
                    if (widget.enableEditing)
                      _buildEventMarkers(context, ref, timelineWidth),
                    _buildPlayhead(context, videoState, timelineWidth),

                    // Render editing elements if enabled
                    if (widget.enableEditing)
                      ..._buildEditingElements(
                          context, ref, durationMs, timelineWidth),

                    _buildHoverPositionLineAndTimeLabel(
                      context,
                      videoState,
                      timelineWidth,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTimeLabels(
    BuildContext context,
    VideoState videoState,
    double timelineWidth,
  ) {
    final durationMs = videoState.totalDuration.inMilliseconds.toDouble();
    final theme = Theme.of(context);

    if (durationMs <= 0) return const SizedBox.shrink();

    // Calculate appropriate interval based on duration
    int intervalMs;
    if (durationMs < 30000) {
      // < 30 seconds: 5s intervals
      intervalMs = 5000;
    } else if (durationMs < 120000) {
      // < 2 minutes: 10s intervals
      intervalMs = 10000;
    } else if (durationMs < 300000) {
      // < 5 minutes: 30s intervals
      intervalMs = 30000;
    } else if (durationMs < 1800000) {
      // < 30 minutes: 1min intervals
      intervalMs = 60000;
    } else {
      // > 30 minutes: 5min intervals
      intervalMs = 300000;
    }

    final labels = <Widget>[];

    // Add time labels at intervals
    for (var timeMs = 0; timeMs <= durationMs; timeMs += intervalMs) {
      final position = (timeMs / durationMs) * timelineWidth;

      labels
        ..add(
          Positioned(
            left: position - 15, // Center the label
            bottom: 0,
            child: Container(
              width: 30,
              alignment: Alignment.center,
              child: Text(
                formatVideoTime(Duration(milliseconds: timeMs)),
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 10,
                  color: Colors.white60,
                ),
              ),
            ),
          ),
        )

        // Add tick marks
        ..add(
          Positioned(
            left: position,
            bottom: 20,
            child: Container(
              width: 1,
              height: 6,
              color: Colors.white30,
            ),
          ),
        );
    }

    return Stack(children: labels);
  }

  Widget _buildBaseTrack(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildProgressBar(
    BuildContext context,
    VideoState videoState,
    double timelineWidth,
  ) {
    final durationMs = videoState.totalDuration.inMilliseconds.toDouble();
    if (durationMs > 0) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: (videoState.currentPosition.inMilliseconds / durationMs) *
              timelineWidth,
          height: 4,
          decoration: BoxDecoration(
            color: ClonesColors.secondary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildHoverPositionLineAndTimeLabel(
    BuildContext context,
    VideoState videoState,
    double timelineWidth,
  ) {
    final theme = Theme.of(context);
    final durationMs = videoState.totalDuration.inMilliseconds.toDouble();

    final children = <Widget>[];

    if (_hoverPosition != null) {
      children.add(
        Positioned(
          left: _hoverPosition!.dx.clamp(0, timelineWidth),
          top: 0,
          bottom: 0,
          child: Container(
            width: 2,
            color: ClonesColors.primary.withValues(alpha: 0.8),
          ),
        ),
      );
    }
    if (_hoverPosition != null && durationMs > 0) {
      children.add(
        Positioned(
          top: -25,
          left: (_hoverPosition!.dx - 20).clamp(0.0, timelineWidth - 40),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              formatVideoTime(
                Duration(
                  milliseconds:
                      ((_hoverPosition!.dx / timelineWidth) * durationMs)
                          .toInt(),
                ),
              ),
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.white),
            ),
          ),
        ),
      );
    }
    return Stack(children: children);
  }

  Widget _buildPlayhead(
    BuildContext context,
    VideoState videoState,
    double timelineWidth,
  ) {
    final durationMs = videoState.totalDuration.inMilliseconds.toDouble();

    if (durationMs <= 0) return const SizedBox.shrink();

    final currentMs = videoState.currentPosition.inMilliseconds.toDouble();
    final playheadPosition = (currentMs / durationMs) * timelineWidth;

    return Positioned(
      left: playheadPosition.clamp(0.0, timelineWidth),
      top: -10,
      bottom: -10,
      child: Container(
        width: 2,
        decoration: BoxDecoration(
          color: ClonesColors.primary,
          boxShadow: [
            BoxShadow(
              color: ClonesColors.primary.withValues(alpha: 0.3),
              blurRadius: 3,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // Playhead handle at the top
            Positioned(
              top: -5,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: ClonesColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventMarkers(
    BuildContext context,
    WidgetRef ref,
    double timelineWidth,
  ) {
    final videoState = ref.watch(videoStateNotifierProvider(widget.videoId));
    final durationMs = videoState.totalDuration.inMilliseconds.toDouble();
    final events = ref.watch(demoDetailNotifierProvider).events;
    final enabledEventTypes =
        ref.watch(demoDetailNotifierProvider).enabledEventTypes;
    final startTime = ref.watch(demoDetailNotifierProvider).startTime;

    if (durationMs > 0) {
      return Stack(
        children: events
            .where(
              (event) =>
                  enabledEventTypes.contains(event.event) &&
                  (event.time - startTime) <= durationMs,
            )
            .map(
              (event) => Positioned(
                left: ((event.time - startTime) / durationMs) * timelineWidth,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: ClonesColors.getEventTypeColor(event.event),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      );
    }
    return const SizedBox.shrink();
  }

  List<Widget> _buildEditingElements(
    BuildContext context,
    WidgetRef ref,
    double durationMs,
    double timelineWidth,
  ) {
    final state = ref.watch(demoDetailNotifierProvider);
    final widgets = <Widget>[];

    // Render committed deleted segments with handles
    for (int i = 0; i < state.deletedSegments.length; i++) {
      widgets.addAll(_buildSegment(
        i,
        state.deletedSegments[i],
        durationMs,
        timelineWidth,
        ref,
      ));
    }

    // Render clips (iMovie-like) as lighter bands on top
    if (state.clipSegments.isNotEmpty) {
      widgets.addAll(_buildClipsOverlay(
        context,
        state.clipSegments,
        state.selectedClipIndexes,
        durationMs,
        timelineWidth,
      ));
    }

    // Render preview segment
    if (_previewSegment != null) {
      widgets.add(_buildPreviewSegment(
        _previewSegment!,
        durationMs,
        timelineWidth,
      ));
    }

    return widgets;
  }

  List<Widget> _buildClipsOverlay(
    BuildContext context,
    List<RangeValues> clips,
    Set<int> selected,
    double durationMs,
    double timelineWidth,
  ) {
    final widgets = <Widget>[];
    for (var i = 0; i < clips.length; i++) {
      final clip = clips[i];
      final left = (clip.start / durationMs) * timelineWidth;
      final right = timelineWidth - (clip.end / durationMs) * timelineWidth;
      final isSelected = selected.contains(i);
      widgets.add(
        Positioned(
          left: left,
          right: right,
          top: -8,
          bottom: -8,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.lightBlueAccent.withValues(alpha: 0.25)
                  : Colors.white.withValues(alpha: 0.08),
              border: Border.all(
                color: isSelected ? Colors.lightBlueAccent : Colors.white24,
                width: isSelected ? 1.5 : 1,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      );
    }
    return widgets;
  }

  Widget _buildPreviewSegment(
    RangeValues segment,
    double durationMs,
    double timelineWidth,
  ) {
    final start = segment.start < segment.end ? segment.start : segment.end;
    final end = segment.start < segment.end ? segment.end : segment.start;
    return Positioned(
      left: (start / durationMs) * timelineWidth,
      right: timelineWidth - (end / durationMs) * timelineWidth,
      top: 0,
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.3),
          border: Border.symmetric(
            vertical: BorderSide(
              color: Colors.yellowAccent.withValues(alpha: 0.7),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSegment(
    int index,
    RangeValues segment,
    double durationMs,
    double timelineWidth,
    WidgetRef ref,
  ) {
    const handleWidth = 8.0;
    const touchWidth = 20.0;

    final widgets = <Widget>[
      // Main segment body
      Positioned(
        left: (segment.start / durationMs) * timelineWidth,
        right: timelineWidth - (segment.end / durationMs) * timelineWidth,
        top: 0,
        bottom: 0,
        child: Container(
          color: Colors.black.withValues(alpha: 0.5),
        ),
      ),
    ];

    widgets.addAll([
      // Start handle
      Positioned(
        left: (segment.start / durationMs) * timelineWidth - touchWidth / 2,
        top: 0,
        bottom: 0,
        width: touchWidth,
        child: GestureDetector(
          onHorizontalDragUpdate: (details) {
            final newStart = (segment.start +
                    (details.delta.dx / timelineWidth) * durationMs)
                .clamp(0.0, segment.end);
            ref.read(demoDetailNotifierProvider.notifier).updateDeletedSegment(
                  index,
                  RangeValues(newStart, segment.end),
                );
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.resizeLeftRight,
            child: Center(
              child: Container(
                width: handleWidth,
                color: Colors.yellowAccent,
              ),
            ),
          ),
        ),
      ),
      // End handle
      Positioned(
        left: (segment.end / durationMs) * timelineWidth - touchWidth / 2,
        top: 0,
        bottom: 0,
        width: touchWidth,
        child: GestureDetector(
          onHorizontalDragUpdate: (details) {
            final newEnd =
                (segment.end + (details.delta.dx / timelineWidth) * durationMs)
                    .clamp(segment.start, durationMs);
            ref.read(demoDetailNotifierProvider.notifier).updateDeletedSegment(
                  index,
                  RangeValues(segment.start, newEnd),
                );
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.resizeLeftRight,
            child: Center(
              child: Container(
                width: handleWidth,
                color: Colors.yellowAccent,
              ),
            ),
          ),
        ),
      ),
      // Delete button
      Positioned(
        left: (segment.start / durationMs) * timelineWidth + 2,
        top: 2,
        child: InkWell(
          onTap: () => ref
              .read(demoDetailNotifierProvider.notifier)
              .removeDeletedSegment(index),
          child: const Icon(Icons.close, color: Colors.white, size: 14),
        ),
      ),
    ]);
    return widgets;
  }

  Future<void> _openContextMenu(
    BuildContext context,
    WidgetRef ref,
    double durationMs,
    double timelineWidth,
  ) async {
    final globalPos = _lastRightClickGlobal;
    if (globalPos == null) return;
    final clickTime = _lastRightClickTimeMs;

    final textStyle =
        Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white);

    // Anchor the menu to the overlay
    final overlayBox =
        Overlay.of(context).context.findRenderObject()! as RenderBox;
    final positionRect = RelativeRect.fromLTRB(
      globalPos.dx,
      globalPos.dy,
      overlayBox.size.width - globalPos.dx,
      overlayBox.size.height - globalPos.dy,
    );

    await showMenu<int>(
      context: context,
      position: positionRect,
      useRootNavigator: true,
      color: Colors.black.withValues(alpha: 0.92),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Colors.white24, width: 0.5),
      ),
      items: [
        // Always show play/pause
        PopupMenuItem<int>(
          value: 100,
          height: 36,
          child: _ContextMenuItem(
            icon: Icons.play_arrow,
            text: 'Play/Pause (Space)',
            textStyle: textStyle,
          ),
        ),
        // Show editing options
        PopupMenuItem<int>(
          value: 1,
          height: 36,
          child: _ContextMenuItem(
            icon: Icons.content_cut,
            text: 'Split clip (B)',
            textStyle: textStyle,
          ),
        ),
        PopupMenuItem<int>(
          value: 2,
          height: 36,
          child: _ContextMenuItem(
            icon: Icons.delete_outline,
            text: 'Delete (Del)',
            textStyle: textStyle,
          ),
        ),
        PopupMenuItem<int>(
          value: 3,
          height: 36,
          child: _ContextMenuItem(
            icon: Icons.content_copy,
            text: 'Copy (Cmd/Ctrl+C)',
            textStyle: textStyle,
          ),
        ),
        PopupMenuItem<int>(
          value: 4,
          height: 36,
          child: _ContextMenuItem(
            icon: Icons.content_paste,
            text: 'Paste (Cmd/Ctrl+V)',
            textStyle: textStyle,
          ),
        ),
        const PopupMenuDivider(height: 8),
        PopupMenuItem<int>(
          value: 5,
          height: 36,
          child: _ContextMenuItem(
            icon: Icons.content_cut,
            text: 'Trim to playhead (T)',
            textStyle: textStyle,
          ),
        ),
        const PopupMenuDivider(height: 4),
        PopupMenuItem<int>(
          value: 6,
          height: 36,
          child: _ContextMenuItem(
            icon: Icons.check_circle_outline,
            text: 'Select this clip',
            textStyle: textStyle,
          ),
        ),
        PopupMenuItem<int>(
          value: 7,
          height: 36,
          child: _ContextMenuItem(
            icon: Icons.radio_button_unchecked,
            text: 'Clear selection',
            textStyle: textStyle,
          ),
        ),
      ],
      elevation: 0,
    ).then((value) {
      final notifier = ref.read(demoDetailNotifierProvider.notifier);
      final videoStateNotifier =
          ref.read(videoStateNotifierProvider(widget.videoId).notifier);

      if (value == 100) {
        // Play/Pause
        final videoState = ref.read(videoStateNotifierProvider(widget.videoId));
        if (videoState.isPlaying) {
          videoStateNotifier.setPaused();
        } else {
          videoStateNotifier.setPlaying();
        }
      } else if (value == 1) {
        notifier.splitClipAt(clickTime);
      } else if (value == 2) {
        notifier.deleteSelectedClips();
      } else if (value == 3) {
        notifier.copySelectedClips();
      } else if (value == 4) {
        notifier.pasteClipboardAt(clickTime);
      } else if (value == 5) {
        notifier.trimToPlayhead(clickTime);
      } else if (value == 6) {
        final clips = ref.read(demoDetailNotifierProvider).clipSegments;
        final idx =
            clips.indexWhere((c) => clickTime >= c.start && clickTime <= c.end);
        if (idx != -1) {
          notifier.selectClip(idx);
        }
      } else if (value == 7) {
        notifier.clearSelection();
      }
    });
  }
}

class _ContextMenuItem extends StatefulWidget {
  const _ContextMenuItem({
    required this.icon,
    required this.text,
    this.textStyle,
  });

  final IconData icon;
  final String text;
  final TextStyle? textStyle;

  @override
  State<_ContextMenuItem> createState() => _ContextMenuItemState();
}

class _ContextMenuItemState extends State<_ContextMenuItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: _isHovered
              ? Colors.grey.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(
              widget.icon,
              size: 18,
              color: _isHovered ? Colors.white : Colors.white70,
            ),
            const SizedBox(width: 8),
            Text(
              widget.text,
              style: widget.textStyle?.copyWith(
                color: _isHovered ? Colors.white : widget.textStyle?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
