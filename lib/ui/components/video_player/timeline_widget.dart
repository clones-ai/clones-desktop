import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:clones_desktop/ui/components/video_player/timeline/timeline_base_track.dart';
import 'package:clones_desktop/ui/components/video_player/timeline/timeline_context_menu_item.dart';
import 'package:clones_desktop/ui/components/video_player/timeline/timeline_editing_elements.dart';
import 'package:clones_desktop/ui/components/video_player/timeline/timeline_event_markers.dart';
import 'package:clones_desktop/ui/components/video_player/timeline/timeline_hover_indicator.dart';
import 'package:clones_desktop/ui/components/video_player/timeline/timeline_playhead.dart';
import 'package:clones_desktop/ui/components/video_player/timeline/timeline_progress_bar.dart';
import 'package:clones_desktop/ui/components/video_player/timeline/timeline_time_labels.dart';
import 'package:clones_desktop/ui/components/video_player/video_state.dart';
import 'package:clones_desktop/ui/views/demo_detail/bloc/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimelineWidget extends ConsumerStatefulWidget {
  const TimelineWidget({
    required this.videoId,
    this.onSeek,
    super.key,
  });

  final String videoId;
  final void Function(Duration)? onSeek;

  @override
  ConsumerState<TimelineWidget> createState() => _TimelineWidgetState();
}

class _TimelineWidgetState extends ConsumerState<TimelineWidget> {
  Offset? _hoverPosition;
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
    final demoDetail = ref.watch(demoDetailNotifierProvider);
    final canEdit = demoDetail.recording?.submission?.status != 'completed';

    if (!canEdit) {
      return CardWidget(
        variant: CardVariant.transparent,
        child: _buildCustomTimeline(context, ref),
      );
    }

    return CardWidget(
      variant: CardVariant.secondary,
      child: Column(
        children: [
          _buildCustomTimeline(context, ref),
          if (canEdit && demoDetail.clips.length > 1)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: BtnPrimary(
                onTap: ref.read(demoDetailNotifierProvider.notifier).applyEdits,
                icon: Icons.check,
                buttonText: 'Apply Edits',
                btnPrimaryType: BtnPrimaryType.outlinePrimary,
                isLoading: demoDetail.isApplyingEdits,
                isLocked: demoDetail.isApplyingEdits,
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
    final demoDetail = ref.watch(demoDetailNotifierProvider);
    final canEdit = demoDetail.recording?.submission?.status != 'completed';

    // Initialize clips if they are empty (defer to avoid modifying provider during build)
    if (canEdit && demoDetail.clips.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref
              .read(demoDetailNotifierProvider.notifier)
              .initializeClips(videoState.totalDuration);
        }
      });
    }

    final duration = videoState.totalDuration;
    final durationMs = duration.inMilliseconds.toDouble();

    return KeyboardListener(
      focusNode: _timelineFocus,
      onKeyEvent: (KeyEvent event) {
        if (event is! KeyDownEvent) return;
        final key = event.logicalKey;

        if (canEdit) {
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
          } else if (isCtrlOrCmd && key == LogicalKeyboardKey.keyZ) {
            // Undo at current playhead position
            notifier.undoDelete(playheadMs);
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
                if (canEdit) {
                  final clips = ref.read(demoDetailNotifierProvider).clips;
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
              onSecondaryTapDown: canEdit
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
                onEnter: (_) => _timelineFocus.requestFocus(),
                onHover: (event) =>
                    setState(() => _hoverPosition = event.localPosition),
                onExit: (_) => setState(() => _hoverPosition = null),
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    TimelineTimeLabels(
                      totalDuration: videoState.totalDuration,
                      timelineWidth: timelineWidth,
                    ),
                    const TimelineBaseTrack(),
                    TimelineProgressBar(
                      currentPosition: videoState.currentPosition,
                      totalDuration: videoState.totalDuration,
                      timelineWidth: timelineWidth,
                    ),
                    if (canEdit)
                      TimelineEventMarkers(
                        videoId: widget.videoId,
                        timelineWidth: timelineWidth,
                      ),
                    TimelinePlayhead(
                      currentPosition: videoState.currentPosition,
                      totalDuration: videoState.totalDuration,
                      timelineWidth: timelineWidth,
                    ),

                    // Render editing elements if enabled
                    if (canEdit)
                      TimelineEditingElements(
                        durationMs: durationMs,
                        timelineWidth: timelineWidth,
                      ),

                    TimelineHoverIndicator(
                      hoverPosition: _hoverPosition,
                      totalDuration: videoState.totalDuration,
                      timelineWidth: timelineWidth,
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
    double durationMs,
    double timelineWidth,
  ) async {
    final globalPos = _lastRightClickGlobal;
    if (globalPos == null) return;
    final clickTime = _lastRightClickTimeMs;

    final state = ref.read(demoDetailNotifierProvider);
    final clips = state.clips;
    final selectedClips = state.selectedClipIds;
    final deletedClips = state.deletedClipsHistory;

    // Find which clip (if any) was clicked
    final clickedClipIndex = clips.indexWhere((c) => c.contains(clickTime));
    final clickedClip = clickedClipIndex != -1 ? clips[clickedClipIndex] : null;

    // Check if we clicked on a deleted clip zone (any operation's deleted clips)
    final clickedOnDeletedZone = deletedClips.isNotEmpty &&
        deletedClips
            .any((operation) => operation.any((dc) => dc.contains(clickTime)));

    // Check if we're in the middle of a clip (not at the edges)
    final canSplit = clickedClip != null && clickedClip.canSplitAt(clickTime);

    final hasSelection = selectedClips.isNotEmpty;

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

    // Build menu items dynamically based on context
    final menuItems = <PopupMenuEntry<int>>[
      // Always show play/pause
      PopupMenuItem<int>(
        value: 100,
        height: 36,
        child: TimelineContextMenuItem(
          icon: Icons.play_arrow,
          text: 'Play/Pause (Space)',
          textStyle: textStyle,
        ),
      ),
      const PopupMenuDivider(height: 8),
      // Split - only if in middle of a clip
      if (canSplit)
        PopupMenuItem<int>(
          value: 1,
          height: 36,
          child: TimelineContextMenuItem(
            icon: Icons.content_cut,
            text: 'Split clip (B)',
            textStyle: textStyle,
          ),
        ),
      // Delete - only if clips are selected
      if (hasSelection)
        PopupMenuItem<int>(
          value: 2,
          height: 36,
          child: TimelineContextMenuItem(
            icon: Icons.delete_outline,
            text: 'Delete (Del)',
            textStyle: textStyle,
          ),
        ),
      // Undo - only if we clicked on a deleted clip zone
      if (clickedOnDeletedZone) ...[
        const PopupMenuDivider(height: 8),
        PopupMenuItem<int>(
          value: 9,
          height: 36,
          child: TimelineContextMenuItem(
            icon: Icons.undo,
            text: 'Undo delete (Cmd/Ctrl+Z)',
            textStyle: textStyle,
          ),
        ),
      ],
      // Selection options
      if (clickedClipIndex != -1 || hasSelection) ...[
        const PopupMenuDivider(height: 4),
        // Select this clip - only if we clicked on a clip that is NOT already selected
        if (clickedClipIndex != -1 && !selectedClips.contains(clickedClip!.id))
          PopupMenuItem<int>(
            value: 6,
            height: 36,
            child: TimelineContextMenuItem(
              icon: Icons.check_circle_outline,
              text: 'Select this clip',
              textStyle: textStyle,
            ),
          ),
        // Clear selection - only if something is selected
        if (hasSelection)
          PopupMenuItem<int>(
            value: 7,
            height: 36,
            child: TimelineContextMenuItem(
              icon: Icons.radio_button_unchecked,
              text: 'Clear selection',
              textStyle: textStyle,
            ),
          ),
      ],
    ];

    await showMenu<int>(
      context: context,
      position: positionRect,
      useRootNavigator: true,
      color: Colors.black.withValues(alpha: 0.92),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Colors.white24, width: 0.5),
      ),
      items: menuItems,
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
      } else if (value == 9) {
        notifier.undoDelete(clickTime);
      } else if (value == 6) {
        final clips = ref.read(demoDetailNotifierProvider).clips;
        final idx = clips.indexWhere((c) => c.contains(clickTime));
        if (idx != -1) {
          notifier.selectClip(idx);
        }
      } else if (value == 7) {
        notifier.clearSelection();
      }
    });
  }
}
