import 'dart:convert';
import 'dart:io';

import 'package:clones_desktop/application/recording.dart';
import 'package:clones_desktop/application/tauri_api.dart';
import 'package:clones_desktop/application/upload/provider.dart';
import 'package:clones_desktop/application/upload/state.dart';
import 'package:clones_desktop/domain/models/message/sft_message.dart';
import 'package:clones_desktop/domain/models/recording/recording_event.dart';
import 'package:clones_desktop/domain/models/video_clip.dart';
import 'package:clones_desktop/ui/components/video_player/video_source.dart';
import 'package:clones_desktop/ui/views/demo_detail/bloc/state.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@riverpod
class DemoDetailNotifier extends _$DemoDetailNotifier {
  File? _tempVideoFile;

  @override
  DemoDetailState build() {
    ref.onDispose(() {
      state.videoController?.dispose();
      // Clean up temporary file if it exists
      _tempVideoFile?.deleteSync();
    });
    return const DemoDetailState();
  }

  Future<void> loadRecording(String recordingId) async {
    state = state.copyWith(isLoading: true);
    try {
      var recordings = await ref.read(mergedRecordingsProvider.future);
      var recording =
          recordings.firstWhereOrNull((element) => element.id == recordingId);

      // If recording not found, refresh providers and try again
      if (recording == null) {
        ref
          ..invalidate(listRecordingsProvider)
          ..invalidate(mergedRecordingsProvider);
        recordings = await ref.read(mergedRecordingsProvider.future);
        recording =
            recordings.firstWhere((element) => element.id == recordingId);
      }

      state = state.copyWith(
        isLoading: false,
        recording: recording,
      );

      // Now load other data separately to avoid one failure stopping others
      await loadEvents(recordingId);
      await loadSftData(recordingId);
      await initializeVideoPlayer(recordingId);
    } catch (_) {}
    state = state.copyWith(isLoading: false);
  }

  Future<void> initializeVideoPlayer(String recordingId) async {
    try {
      final videoData = await ref.read(tauriApiClientProvider).getRecordingFile(
            recordingId: recordingId,
            filename: 'recording.mp4',
            asBase64: true,
          );

      // Create VideoSource for your custom video player system
      final videoSource = Base64VideoSource(videoData);

      // Don't create VideoPlayerController here - let VideoPlayer components handle it
      // Just store the videoSource for the components to use
      await state.videoController?.dispose();

      // Force a complete refresh by setting videoSource to null first
      state = state.copyWith(
        videoController: null,
        videoSource: null,
      );

      // Small delay to ensure UI detects the change
      await Future.delayed(const Duration(milliseconds: 100));

      state = state.copyWith(
        videoController: null, // No controller in DemoDetailNotifier
        videoSource: videoSource,
      );
    } catch (e) {
      debugPrint('Error: $e');
      // This is expected for recordings without video files
    }
  }

  Future<void> loadEvents(String recordingId) async {
    try {
      final eventsJsonl =
          await ref.read(tauriApiClientProvider).getRecordingFile(
                recordingId: recordingId,
                filename: 'input_log.jsonl',
              );
      final events = eventsJsonl
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .map((line) {
            try {
              return RecordingEvent.fromJson(jsonDecode(line));
            } catch (e) {
              return null;
            }
          })
          .where((item) => item != null)
          .cast<RecordingEvent>()
          .toList()

        // Sort events by time
        ..sort((a, b) => a.time.compareTo(b.time));

      final eventTypes = events.map((e) => e.event).toSet();
      final startTime = events.isNotEmpty ? events.first.time : 0;

      state = state.copyWith(
        events: events,
        eventTypes: eventTypes,
        enabledEventTypes: eventTypes,
        startTime: startTime,
      );
    } catch (e) {
      // It's okay if this fails, the file might not exist
      state = state.copyWith(
        events: [],
        eventTypes: {},
        enabledEventTypes: {},
        startTime: 0,
      );
    }
  }

  Future<void> loadSftData(String recordingId) async {
    state = state.copyWith(sftMessages: []);

    // Load SFT messages
    try {
      final sftJson = await ref.read(tauriApiClientProvider).getRecordingFile(
            recordingId: recordingId,
            filename: 'sft.json',
          );
      final List<dynamic> sftData = jsonDecode(sftJson);
      final sftMessages =
          sftData.map((data) => SftMessage.fromJson(data)).toList();
      state = state.copyWith(sftMessages: sftMessages);
    } catch (e) {
      // SFT file might not exist, continue with empty messages
    }
  }

  void toggleEventType(String eventType) {
    final newEnabledTypes = Set<String>.from(state.enabledEventTypes);
    if (newEnabledTypes.contains(eventType)) {
      newEnabledTypes.remove(eventType);
    } else {
      newEnabledTypes.add(eventType);
    }
    state = state.copyWith(enabledEventTypes: newEnabledTypes);
  }

  // --- Video Editing Logic ---

  // Build clips from current video duration when first requested
  void initializeClips(Duration totalDuration) {
    if (state.clips.isNotEmpty) return;
    final durationMs = totalDuration.inMilliseconds.toDouble();
    if (durationMs <= 0) return;

    final initialClip = VideoClip.create(start: 0, end: durationMs);

    state = state.copyWith(
      clips: [initialClip],
      selectedClipIds: <String>{},
      // Keep legacy compatibility
      clipSegments: [RangeValues(0, durationMs)],
      selectedClipIndexes: <int>{},
    );
  }

  void selectClip(int index, {bool toggle = false, bool additive = false}) {
    if (index < 0 || index >= state.clips.length) return;

    final clipId = state.clips[index].id;
    final current = Set<String>.from(state.selectedClipIds);
    final currentIndexes = Set<int>.from(state.selectedClipIndexes);

    if (toggle) {
      if (current.contains(clipId)) {
        current.remove(clipId);
        currentIndexes.remove(index);
      } else {
        current.add(clipId);
        currentIndexes.add(index);
      }
    } else if (additive) {
      current.add(clipId);
      currentIndexes.add(index);
    } else {
      current
        ..clear()
        ..add(clipId);
      currentIndexes
        ..clear()
        ..add(index);
    }

    state = state.copyWith(
      selectedClipIds: current,
      selectedClipIndexes: currentIndexes, // Keep legacy
    );
  }

  void clearSelection() {
    if (state.selectedClipIds.isEmpty) return;
    state = state.copyWith(
      selectedClipIds: <String>{},
      selectedClipIndexes: <int>{}, // Keep legacy
    );
  }

  void splitClipAt(double positionMs) {
    final clips = [...state.clips];
    if (clips.isEmpty) {
      return;
    }

    // Find the clip that contains position
    final clipIndex = clips.indexWhere((c) => c.contains(positionMs));
    if (clipIndex == -1) return;

    final clip = clips[clipIndex];
    if (!clip.canSplitAt(positionMs)) return;

    // Split the clip
    final (leftClip, rightClip) = clip.splitAt(positionMs);

    // Replace the original clip with the two new clips
    clips
      ..removeAt(clipIndex)
      ..insertAll(clipIndex, [leftClip, rightClip]);

    state = state.copyWith(
      clips: clips,
      selectedClipIds: {rightClip.id}, // Select the right-side clip
      // Keep legacy compatibility
      clipSegments: clips.map((c) => c.toRangeValues()).toList(),
      selectedClipIndexes: {clipIndex + 1}, // Select right clip index
    );
  }

  void deleteSelectedClips() {
    if (state.selectedClipIds.isEmpty) return;

    // Save deleted clips for undo as a new operation
    final deletedClips = <VideoClip>[];
    final remaining = <VideoClip>[];

    for (final clip in state.clips) {
      if (state.selectedClipIds.contains(clip.id)) {
        deletedClips.add(clip);
      } else {
        remaining.add(clip);
      }
    }

    // Add this deletion operation to the history stack
    final newHistory = [...state.deletedClipsHistory, deletedClips];

    state = state.copyWith(
      clips: remaining,
      selectedClipIds: <String>{},
      deletedClipsHistory: newHistory,
      // Keep legacy for compatibility
      clipSegments: remaining.map((c) => c.toRangeValues()).toList(),
      selectedClipIndexes: <int>{},
    );
  }

  void undoDelete(double clickTimeMs) {
    if (state.deletedClipsHistory.isEmpty) return;

    // Find which deletion operation contains the clicked position
    int operationIndex = -1;
    for (var i = 0; i < state.deletedClipsHistory.length; i++) {
      final operation = state.deletedClipsHistory[i];
      if (operation.any((clip) => clip.contains(clickTimeMs))) {
        operationIndex = i;
        break;
      }
    }

    if (operationIndex == -1) return;

    // Restore only the clips from this specific operation
    final clipsToRestore = state.deletedClipsHistory[operationIndex];
    final restoredClips = [...state.clips, ...clipsToRestore]
      ..sort((a, b) => a.start.compareTo(b.start));

    // Remove this operation from history
    final newHistory = [...state.deletedClipsHistory]..removeAt(operationIndex);

    state = state.copyWith(
      clips: restoredClips,
      deletedClipsHistory: newHistory,
      // Keep legacy for compatibility
      clipSegments: restoredClips.map((c) => c.toRangeValues()).toList(),
    );
  }

  void mergeAdjacentClips() {
    if (state.clipSegments.isEmpty) return;
    final sorted = [...state.clipSegments]
      ..sort((a, b) => a.start.compareTo(b.start));
    final merged = <RangeValues>[sorted.first];
    for (var i = 1; i < sorted.length; i++) {
      final last = merged.last;
      final cur = sorted[i];
      if (cur.start <= last.end + 1) {
        merged[merged.length - 1] = RangeValues(last.start, cur.end);
      } else {
        merged.add(cur);
      }
    }
    state = state.copyWith(clipSegments: merged);
  }

  // --- Deleted Zone Helpers (for skip logic) ---

  /// Check if a position is in a deleted zone
  bool isPositionInDeletedZone(double positionMs) {
    return state.deletedClipsHistory
        .expand((operation) => operation)
        .any((clip) => clip.contains(positionMs));
  }

  /// Find the next valid (non-deleted) position after the given position
  /// Returns null if there's no valid position after (end of video)
  double? getNextValidPosition(double positionMs) {
    if (state.clips.isEmpty) return null;

    // Find the first clip that starts after the current position
    final nextClip =
        state.clips.where((clip) => clip.start > positionMs).fold<VideoClip?>(
              null,
              (min, clip) => min == null || clip.start < min.start ? clip : min,
            );

    return nextClip?.start;
  }

  /// Adjust a seek position to avoid deleted zones
  /// If the position is in a deleted zone, move to the start of the next valid clip
  double adjustSeekPositionToValidZone(double positionMs) {
    if (!isPositionInDeletedZone(positionMs)) {
      return positionMs;
    }

    // Position is in a deleted zone, find the next valid position
    final nextValid = getNextValidPosition(positionMs);
    if (nextValid != null) {
      return nextValid;
    }

    // No valid position after, go to the start of the last valid clip
    if (state.clips.isNotEmpty) {
      return state.clips.last.start;
    }

    return positionMs; // Fallback
  }

  // Clipboard operations for clips
  void cutSelectedClips() {
    if (state.selectedClipIndexes.isEmpty) return;
    // Only support single-clip cut for now
    final idx = state.selectedClipIndexes.first;
    if (idx < 0 || idx >= state.clipSegments.length) return;
    final clip = state.clipSegments[idx];
    final remaining = [...state.clipSegments]..removeAt(idx);
    state = state.copyWith(
      clipSegments: remaining,
      selectedClipIndexes: <int>{},
      clipboardClip: VideoClip.fromRangeValues(clip),
    );
  }

  void copySelectedClips() {
    if (state.selectedClipIndexes.isEmpty) return;
    final idx = state.selectedClipIndexes.first;
    if (idx < 0 || idx >= state.clipSegments.length) return;
    final clip = state.clipSegments[idx];
    state = state.copyWith(clipboardClip: VideoClip.fromRangeValues(clip));
  }

  void pasteClipboardAt(double positionMs) {
    final clip = state.clipboardClip;
    if (clip == null) return;
    // Paste will insert a clip of same duration, starting at positionMs
    final duration = clip.end - clip.start;
    final newStart = positionMs;
    final newEnd = positionMs + duration;
    if (newEnd <= newStart) return;
    final newClip = RangeValues(newStart, newEnd);
    final clips = [...state.clipSegments, newClip]
      ..sort((a, b) => a.start.compareTo(b.start));
    state = state.copyWith(clipSegments: clips);
  }

  void trimToPlayhead(double positionMs) {
    // For all selected clips, trim their end to playhead if playhead inside clip
    if (state.selectedClipIndexes.isEmpty) return;
    final clips = [...state.clipSegments];
    final selected = state.selectedClipIndexes;
    for (final idx in selected) {
      if (idx < 0 || idx >= clips.length) continue;
      final c = clips[idx];
      if (positionMs > c.start && positionMs < c.end) {
        clips[idx] = RangeValues(c.start, positionMs);
      }
    }
    state = state.copyWith(clipSegments: clips);
  }

  Future<void> applyEdits() async {
    final recordingId = state.recording?.id;
    if (recordingId == null || state.videoSource == null) {
      return;
    }

    // Check if there are clips to apply
    if (state.clipSegments.isEmpty) {
      return;
    }

    state = state.copyWith(isApplyingEdits: true);

    final segmentsToKeep = state.clipSegments
        .map(
          (r) => {
            'start': r.start / 1000.0,
            'end': r.end / 1000.0,
          },
        )
        .toList();

    try {
      await ref
          .read(tauriApiClientProvider)
          .applyEdits(recordingId, segmentsToKeep);
      await initializeVideoPlayer(recordingId);
      state = state.copyWith(
        isApplyingEdits: false,
        clipSegments: [],
        selectedClipIndexes: <int>{},
      );
    } catch (e) {
      state = state.copyWith(isApplyingEdits: false);
    }
  }

  // --- Modal Management ---

  void setShowTrainingSessionModal(bool show) {
    state = state.copyWith(showTrainingSessionModal: show);
  }

  void setShowUploadConfirmModal(bool show) {
    state = state.copyWith(showUploadConfirmModal: show);
  }

  Future<void> confirmUploadPermission() async {
    try {
      await ref.read(uploadQueueProvider.notifier).setUploadDataAllowed(true);
      state = state.copyWith(showUploadConfirmModal: false);
      // Retry the upload
      await uploadRecording();
    } catch (e) {
      state = state.copyWith(
        uploadError: e.toString(),
        showUploadConfirmModal: false,
      );
    }
  }

  Future<void> onDemoRecordingCompleted(String recordingId) async {
    // Close modal and load the new recording
    state = state.copyWith(showTrainingSessionModal: false);

    // Invalidate recording providers to force refresh
    ref
      ..invalidate(listRecordingsProvider)
      ..invalidate(mergedRecordingsProvider);

    // Small delay to ensure files are written to disk
    await Future.delayed(const Duration(milliseconds: 100));
    await loadRecording(recordingId);
  }

  // --- Button Actions ---

  Future<void> openRecordingFolder() async {
    final recordingId = state.recording?.id;
    if (recordingId == null) return;
    await ref.read(tauriApiClientProvider).openRecordingFolder(recordingId);
  }

  Future<void> processRecording() async {
    final recordingId = state.recording?.id;
    if (recordingId == null || state.isProcessing) return;

    state = state.copyWith(isProcessing: true);
    try {
      await ref.read(tauriApiClientProvider).processRecording(recordingId);
      // After processing, we might need to reload some data, e.g., sft.json
      await loadSftData(recordingId);
    } catch (e) {
      // TODO(reddwarf03): handle error
    } finally {
      state = state.copyWith(isProcessing: false);
    }
  }

  Future<void> uploadRecording() async {
    final recordingId = state.recording?.id;
    if (recordingId == null || state.isUploading) return;

    state = state.copyWith(isUploading: true, uploadError: null);

    try {
      final demonstrationTitle = state.recording?.title ?? 'Unknown';

      late ProviderSubscription<Map<String, UploadTaskState>> sub;
      sub = ref.listen<Map<String, UploadTaskState>>(uploadQueueProvider,
          (previous, next) async {
        final uploadState = next[recordingId];
        if (uploadState == null) return;

        if (uploadState.uploadStatus == UploadStatus.done) {
          sub.close();
          state = state.copyWith(isUploading: false);

          // Invalidate recording providers to force refresh of cached data
          ref
            ..invalidate(listRecordingsProvider)
            ..invalidate(mergedRecordingsProvider);

          // Reload recording to get updated submission data
          await loadRecording(recordingId);
        } else if (uploadState.uploadStatus == UploadStatus.error) {
          sub.close();
          state = state.copyWith(
            isUploading: false,
            uploadError: uploadState.error ?? 'Upload failed',
          );
        }
      });

      // Start the upload by calling the upload method
      // We need to find the poolId from the recording's demonstration
      final poolId = state.recording?.demonstration?.poolId ?? 'unknown';
      await ref.read(uploadQueueProvider.notifier).upload(
            recordingId,
            poolId,
            demonstrationTitle,
          );
    } catch (e) {
      if (e.toString().contains('Upload data is not allowed')) {
        state = state.copyWith(
          showUploadConfirmModal: true,
          isUploading: false,
        );
        return;
      }
      state = state.copyWith(
        isUploading: false,
        uploadError: e.toString(),
      );
    }
  }
}
