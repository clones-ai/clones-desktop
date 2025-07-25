import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:clones_desktop/ui/views/demo_detail/bloc/provider.dart';
import 'package:clones_desktop/utils/format_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

enum _DragHandle { start, end, none }

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
  _DragHandle _draggedHandle = _DragHandle.none;
  bool _isHoveringStart = false;
  bool _isHoveringEnd = false;
  RangeValues? _localDragRange;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(demoDetailNotifierProvider);
    final videoController = state.videoController;

    final videoLoaded =
        videoController != null && videoController.value.isInitialized;

    final theme = Theme.of(context);

    return IntrinsicHeight(
      child: CardWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Video Preview',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            if (!videoLoaded)
              Text('No video found', style: theme.textTheme.bodyMedium)
            else
              Stack(
                alignment: Alignment.center,
                children: [
                  if (state.isLoading)
                    const Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          strokeWidth: 0.5,
                        ),
                      ),
                    )
                  else
                    Opacity(
                      opacity: videoController.value.isPlaying ? 1 : 0.5,
                      child: AspectRatio(
                        aspectRatio: videoController.value.aspectRatio,
                        child: VideoPlayer(videoController),
                      ),
                    ),
                  if (videoLoaded && _draggedHandle == _DragHandle.none)
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
            if (videoLoaded)
              _buildCustomTimeline(context, ref, videoController),
            if (videoLoaded && (_localDragRange ?? state.trimRange) != null)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Start: ${formatTimeMs((_localDragRange ?? state.trimRange)!.start.round())}',
                      style: theme.textTheme.bodyMedium,
                    ),
                    Text(
                      'End: ${formatTimeMs((_localDragRange ?? state.trimRange)!.end.round())}',
                      style: theme.textTheme.bodyMedium,
                    ),
                    BtnPrimary(
                      buttonText: 'Trim Video',
                      onTap: !state.isTrimming
                          ? () {
                              final currentRange =
                                  _localDragRange ?? state.trimRange;
                              if (currentRange != null) {
                                ref
                                    .read(demoDetailNotifierProvider.notifier)
                                    .trimRecording(
                                      currentRange.start / 1000.0,
                                      currentRange.end / 1000.0,
                                    );
                              }
                            }
                          : null,
                      isLoading: state.isTrimming,
                      isLocked: state.isTrimming,
                      btnPrimaryType: BtnPrimaryType.outlinePrimary,
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
    const handleTouchWidth = 50.0;

    final state = ref.watch(demoDetailNotifierProvider);
    final duration = controller.value.duration;
    final durationMs = duration.inMilliseconds.toDouble();

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final timelineWidth = constraints.maxWidth;
          final trimRange = _localDragRange ?? state.trimRange;

          return GestureDetector(
            onHorizontalDragStart: (details) {
              if (trimRange == null) return;
              final clickPosition = details.localPosition.dx;

              final startHandlePosition =
                  (trimRange.start / durationMs) * timelineWidth;
              final endHandlePosition =
                  (trimRange.end / durationMs) * timelineWidth;

              if ((clickPosition - startHandlePosition).abs() <
                  handleTouchWidth / 2) {
                setState(() {
                  _draggedHandle = _DragHandle.start;
                  _localDragRange = state.trimRange;
                });
              } else if ((clickPosition - endHandlePosition).abs() <
                  handleTouchWidth / 2) {
                setState(() {
                  _draggedHandle = _DragHandle.end;
                  _localDragRange = state.trimRange;
                });
              }
            },
            onHorizontalDragUpdate: (details) {
              if (_draggedHandle == _DragHandle.none ||
                  _localDragRange == null) {
                return;
              }
              setState(() {
                if (_draggedHandle == _DragHandle.start) {
                  final newStart = (_localDragRange!.start +
                          (details.delta.dx / timelineWidth) * durationMs)
                      .clamp(0.0, _localDragRange!.end);
                  _localDragRange = RangeValues(newStart, _localDragRange!.end);
                  controller.seekTo(Duration(milliseconds: newStart.round()));
                } else if (_draggedHandle == _DragHandle.end) {
                  final newEnd = (_localDragRange!.end +
                          (details.delta.dx / timelineWidth) * durationMs)
                      .clamp(_localDragRange!.start, durationMs);
                  _localDragRange = RangeValues(_localDragRange!.start, newEnd);
                  controller.seekTo(Duration(milliseconds: newEnd.round()));
                }
              });
            },
            onHorizontalDragEnd: (details) {
              if (_localDragRange != null) {
                ref
                    .read(demoDetailNotifierProvider.notifier)
                    .setTrimRange(_localDragRange!);
              }
              setState(() {
                _draggedHandle = _DragHandle.none;
                _localDragRange = null;
              });
            },
            child: MouseRegion(
              onHover: (event) {
                final clickPosition = event.localPosition.dx;
                setState(() {
                  _hoverPosition = event.localPosition;
                  if (trimRange != null) {
                    final startHandlePosition =
                        (trimRange.start / durationMs) * timelineWidth;
                    final endHandlePosition =
                        (trimRange.end / durationMs) * timelineWidth;
                    _isHoveringStart =
                        (clickPosition - startHandlePosition).abs() <
                            handleTouchWidth / 2;
                    _isHoveringEnd = (clickPosition - endHandlePosition).abs() <
                        handleTouchWidth / 2;
                  }
                });
              },
              onExit: (_) => setState(
                () {
                  _hoverPosition = null;
                },
              ),
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  baseTrack(context),
                  progressBar(context, controller, timelineWidth),
                  eventMarkers(context, ref, controller, timelineWidth),
                  trimOverlay(context, ref, controller, timelineWidth),
                  draggableHandles(context, ref, controller, timelineWidth),
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
    );
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

  Widget trimOverlay(
    BuildContext context,
    WidgetRef ref,
    VideoPlayerController controller,
    double timelineWidth,
  ) {
    final state = ref.watch(demoDetailNotifierProvider);
    final trimRange = _localDragRange ?? state.trimRange;
    final durationMs = controller.value.duration.inMilliseconds.toDouble();
    if (trimRange != null && durationMs > 0) {
      return Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: (trimRange.start / durationMs) * timelineWidth,
            child: Container(color: Colors.black.withValues(alpha: 0.5)),
          ),
          Positioned(
            left: (trimRange.end / durationMs) * timelineWidth,
            top: 0,
            bottom: 0,
            right: 0,
            child: Container(color: Colors.black.withValues(alpha: 0.5)),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget draggableHandles(
    BuildContext context,
    WidgetRef ref,
    VideoPlayerController controller,
    double timelineWidth,
  ) {
    const handleWidth = 8.0;
    final state = ref.watch(demoDetailNotifierProvider);
    final duration = controller.value.duration;
    final durationMs = duration.inMilliseconds.toDouble();
    final trimRange = _localDragRange ?? state.trimRange;
    if (trimRange != null && durationMs > 0) {
      return Stack(
        children: [
          Positioned(
            left: ((trimRange.start / durationMs) * timelineWidth) -
                (handleWidth / 2),
            top: 0,
            bottom: 0,
            child: Center(
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeLeftRight,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: handleWidth,
                  height:
                      _isHoveringStart || _draggedHandle == _DragHandle.start
                          ? 32
                          : 28,
                  decoration: BoxDecoration(
                    color: ClonesColors.primary,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 6),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: ((trimRange.end / durationMs) * timelineWidth) -
                (handleWidth / 2),
            top: 0,
            bottom: 0,
            child: Center(
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeLeftRight,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: handleWidth,
                  height: _isHoveringEnd || _draggedHandle == _DragHandle.end
                      ? 32
                      : 28,
                  decoration: BoxDecoration(
                    color: ClonesColors.primary,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 6),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
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

    if (_hoverPosition != null && _draggedHandle == _DragHandle.none) {
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
