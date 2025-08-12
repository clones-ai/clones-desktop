import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:clones_desktop/ui/views/demo_detail/bloc/provider.dart';
import 'package:clones_desktop/utils/format_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

class DemoDetailVideoPreview extends ConsumerStatefulWidget {
  const DemoDetailVideoPreview({super.key, this.onExpand});
  final VoidCallback? onExpand;

  @override
  ConsumerState<DemoDetailVideoPreview> createState() =>
      _DemoDetailVideoPreviewState();
}

class _DemoDetailVideoPreviewState
    extends ConsumerState<DemoDetailVideoPreview> {
  Offset? _hoverPosition;
  RangeValues? _previewSegment;
  bool _isEditing = false;
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
    final state = ref.watch(demoDetailNotifierProvider);
    final videoController = state.videoController;

    final videoLoaded =
        videoController != null && videoController.value.isInitialized;

    final theme = Theme.of(context);

    // Avoid modifying providers during build: defer initialization
    if (videoLoaded && state.clipSegments.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref
              .read(demoDetailNotifierProvider.notifier)
              .initializeClipsFromDuration();
        }
      });
    }
    return CardWidget(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Video Preview',
                  style: theme.textTheme.titleMedium,
                ),
                if (widget.onExpand != null)
                  IconButton(
                    icon: const Icon(
                      Icons.fullscreen,
                      color: ClonesColors.secondary,
                    ),
                    onPressed: widget.onExpand,
                    tooltip: 'Fullscreen',
                  ),
              ],
            ),
            const SizedBox(height: 10),
            if (!videoLoaded)
              Text('No video found', style: theme.textTheme.bodyMedium)
            else
              MouseRegion(
                onHover: (event) =>
                    setState(() => _hoverPosition = event.localPosition),
                onExit: (_) => setState(() => _hoverPosition = null),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (state.isLoading)
                      const Center(
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            strokeWidth: 1,
                          ),
                        ),
                      )
                    else
                      Opacity(
                        opacity: _hoverPosition != null ||
                                videoController.value.isPlaying
                            ? 1
                            : 0.5,
                        child: AspectRatio(
                          aspectRatio: videoController.value.aspectRatio,
                          child: VideoPlayer(videoController),
                        ),
                      ),
                    if (videoLoaded && _hoverPosition != null && !_isEditing)
                      ValueListenableBuilder<VideoPlayerValue>(
                        valueListenable: videoController,
                        builder: (context, value, child) {
                          return IconButton(
                            icon: Icon(
                              value.isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                              size: 50,
                            ),
                            onPressed: () {
                              if (value.isPlaying) {
                                videoController.pause();
                              } else {
                                videoController.play();
                              }
                            },
                          );
                        },
                      ),
                  ],
                ),
              ),
            if (videoLoaded)
              _buildCustomTimeline(context, ref, videoController),
            if (videoLoaded)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Edit Mode',
                      style: theme.textTheme.labelMedium,
                    ),
                    const SizedBox(width: 8),
                    Switch(
                      value: _isEditing,
                      onChanged: (value) {
                        setState(() {
                          _isEditing = value;
                        });
                      },
                      activeColor: ClonesColors.primary,
                    ),
                    const SizedBox(width: 32),
                    if (_isEditing)
                      BtnPrimary(
                        onTap: ref
                            .read(demoDetailNotifierProvider.notifier)
                            .applyEdits,
                        icon: Icons.check,
                        buttonText: 'Apply Edits',
                        btnPrimaryType: BtnPrimaryType.outlinePrimary,
                        isLoading: state.isApplyingEdits,
                        isLocked: state.isApplyingEdits ||
                            (state.deletedSegments.isEmpty &&
                                state.clipSegments.isEmpty),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomTimeline(
    BuildContext context,
    WidgetRef ref,
    VideoPlayerController controller,
  ) {
    // Clips are initialized via a post-frame callback in build()
    final state = ref.watch(demoDetailNotifierProvider);
    final duration = controller.value.duration;
    final durationMs = duration.inMilliseconds.toDouble();

    return KeyboardListener(
      focusNode: _timelineFocus,
      onKeyEvent: (KeyEvent event) {
        if (event is! KeyDownEvent) return;
        final isCtrlOrCmd = HardwareKeyboard.instance.isControlPressed ||
            HardwareKeyboard.instance.isMetaPressed;
        final key = event.logicalKey;
        final notifier = ref.read(demoDetailNotifierProvider.notifier);
        final playheadMs = controller.value.position.inMilliseconds.toDouble();
        if (key == LogicalKeyboardKey.space) {
          if (controller.value.isPlaying) {
            controller.pause();
          } else {
            controller.play();
          }
        } else if (key == LogicalKeyboardKey.keyB ||
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
      },
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final timelineWidth = constraints.maxWidth;

            return GestureDetector(
              onTapUp: (details) {
                final clickPosition = details.localPosition.dx;
                final seekTime =
                    (clickPosition / timelineWidth * durationMs).round();
                controller.seekTo(Duration(milliseconds: seekTime));
                _timelineFocus.requestFocus();
                // Left-click selects the clip under the cursor (iMovie-like)
                final clips = ref.read(demoDetailNotifierProvider).clipSegments;
                final ms = clickPosition / timelineWidth * durationMs;
                final idx =
                    clips.indexWhere((c) => ms >= c.start && ms <= c.end);
                if (idx != -1) {
                  ref.read(demoDetailNotifierProvider.notifier).selectClip(idx);
                }
              },
              onHorizontalDragStart: _isEditing
                  ? (details) {
                      final clickTime =
                          details.localPosition.dx / timelineWidth * durationMs;
                      setState(() {
                        _previewSegment = RangeValues(clickTime, clickTime);
                      });
                    }
                  : null,
              onHorizontalDragUpdate: _isEditing
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
              onHorizontalDragEnd: _isEditing
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
              onSecondaryTapDown: (details) {
                // Remember where the context menu should open (global for accurate placement)
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
                  controller,
                  durationMs,
                  timelineWidth,
                );
              },
              child: MouseRegion(
                onHover: (event) =>
                    setState(() => _hoverPosition = event.localPosition),
                onExit: (_) => setState(() => _hoverPosition = null),
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    baseTrack(context),
                    progressBar(context, controller, timelineWidth),
                    eventMarkers(context, ref, controller, timelineWidth),
                    // Render committed deleted segments with handles
                    for (int i = 0; i < state.deletedSegments.length; i++)
                      ..._buildSegment(
                        i,
                        state.deletedSegments[i],
                        durationMs,
                        timelineWidth,
                        ref,
                        _isEditing,
                      ),

                    // Render clips (iMovie-like) as lighter bands on top
                    if (state.clipSegments.isNotEmpty)
                      ..._buildClipsOverlay(
                        context,
                        state.clipSegments,
                        state.selectedClipIndexes,
                        durationMs,
                        timelineWidth,
                      ),

                    // Render preview segment
                    if (_isEditing && _previewSegment != null)
                      _buildPreviewSegment(
                        _previewSegment!,
                        durationMs,
                        timelineWidth,
                      ),

                    hoverPositionLineAndTimeLabel(
                      context,
                      controller,
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

  Future<void> _openContextMenu(
    BuildContext context,
    WidgetRef ref,
    VideoPlayerController controller,
    double durationMs,
    double timelineWidth,
  ) async {
    final globalPos = _lastRightClickGlobal;
    if (globalPos == null) return;
    final clickTime = _lastRightClickTimeMs;

    final selectedTextStyle =
        Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white);
    final normalTextStyle =
        Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70);

    // Anchor the menu to the overlay so it's next to the cursor regardless of layout builders
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
        PopupMenuItem<int>(
          value: 100,
          height: 36,
          child: Row(
            children: [
              const Icon(Icons.play_arrow, size: 18, color: Colors.white70),
              const SizedBox(width: 8),
              Text('Play/Pause (Space)', style: selectedTextStyle),
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: 1,
          height: 36,
          child: Row(
            children: [
              const Icon(Icons.content_cut, size: 18, color: Colors.white70),
              const SizedBox(width: 8),
              Text('Split clip (B)', style: selectedTextStyle),
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: 2,
          height: 36,
          child: Row(
            children: [
              const Icon(Icons.delete_outline, size: 18, color: Colors.white70),
              const SizedBox(width: 8),
              Text('Delete (Del)', style: selectedTextStyle),
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: 3,
          height: 36,
          child: Row(
            children: [
              const Icon(Icons.content_copy, size: 18, color: Colors.white70),
              const SizedBox(width: 8),
              Text('Copy (Cmd/Ctrl+C)', style: normalTextStyle),
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: 4,
          height: 36,
          child: Row(
            children: [
              const Icon(Icons.content_paste, size: 18, color: Colors.white70),
              const SizedBox(width: 8),
              Text('Paste (Cmd/Ctrl+V)', style: normalTextStyle),
            ],
          ),
        ),
        const PopupMenuDivider(height: 8),
        PopupMenuItem<int>(
          value: 5,
          height: 36,
          child: Row(
            children: [
              const Icon(Icons.content_cut, size: 18, color: Colors.white70),
              const SizedBox(width: 8),
              Text('Trim to playhead (T)', style: normalTextStyle),
            ],
          ),
        ),
        const PopupMenuDivider(height: 4),
        PopupMenuItem<int>(
          value: 6,
          height: 36,
          child: Row(
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 18,
                color: Colors.white70,
              ),
              const SizedBox(width: 8),
              Text('Select this clip', style: normalTextStyle),
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: 7,
          height: 36,
          child: Row(
            children: [
              const Icon(
                Icons.radio_button_unchecked,
                size: 18,
                color: Colors.white70,
              ),
              const SizedBox(width: 8),
              Text('Clear selection', style: normalTextStyle),
            ],
          ),
        ),
      ],
      elevation: 0,
    ).then((value) {
      final notifier = ref.read(demoDetailNotifierProvider.notifier);
      if (value == 1) {
        // Split
        notifier.splitClipAt(clickTime);
      } else if (value == 2) {
        // Delete selected
        notifier.deleteSelectedClips();
      } else if (value == 3) {
        // Copy selected (single)
        notifier.copySelectedClips();
      } else if (value == 4) {
        // Paste at pointer
        notifier.pasteClipboardAt(clickTime);
      } else if (value == 5) {
        // Trim to playhead
        notifier.trimToPlayhead(clickTime);
      } else if (value == 6) {
        // Select this clip
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
    bool isEditing,
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

    if (isEditing) {
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
              ref
                  .read(demoDetailNotifierProvider.notifier)
                  .updateDeletedSegment(
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
              final newEnd = (segment.end +
                      (details.delta.dx / timelineWidth) * durationMs)
                  .clamp(segment.start, durationMs);
              ref
                  .read(demoDetailNotifierProvider.notifier)
                  .updateDeletedSegment(
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
    }
    return widgets;
  }

  Widget baseTrack(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget progressBar(
    BuildContext context,
    VideoPlayerController controller,
    double timelineWidth,
  ) {
    final durationMs = controller.value.duration.inMilliseconds.toDouble();
    if (durationMs > 0) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: (controller.value.position.inMilliseconds / durationMs) *
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

  Widget eventMarkers(
    BuildContext context,
    WidgetRef ref,
    VideoPlayerController controller,
    double timelineWidth,
  ) {
    final durationMs = controller.value.duration.inMilliseconds.toDouble();
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

  Widget hoverPositionLineAndTimeLabel(
    BuildContext context,
    VideoPlayerController controller,
    double timelineWidth,
  ) {
    final theme = Theme.of(context);
    final durationMs = controller.value.duration.inMilliseconds.toDouble();

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
              formatTimeMs(
                ((_hoverPosition!.dx / timelineWidth) * durationMs).toInt(),
              ),
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.white),
            ),
          ),
        ),
      );
    }
    return Stack(children: children);
  }
}
