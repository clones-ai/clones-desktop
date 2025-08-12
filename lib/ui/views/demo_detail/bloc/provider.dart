import 'dart:convert';
import 'dart:io';

import 'package:clones_desktop/application/recording.dart';
import 'package:clones_desktop/application/tauri_api.dart';
import 'package:clones_desktop/domain/models/message/deleted_range.dart';
import 'package:clones_desktop/domain/models/message/sft_message.dart';
import 'package:clones_desktop/domain/models/recording/recording_event.dart';
import 'package:clones_desktop/ui/views/demo_detail/bloc/state.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:video_player/video_player.dart';

part 'provider.g.dart';

@riverpod
class DemoDetailNotifier extends _$DemoDetailNotifier {
  @override
  DemoDetailState build() {
    ref.onDispose(() {
      state.videoController?.dispose();
    });
    return const DemoDetailState();
  }

  Future<void> loadRecording(String recordingId) async {
    state = state.copyWith(isLoading: true);
    try {
      final recordings = await ref.read(mergedRecordingsProvider.future);
      final recording =
          recordings.firstWhere((element) => element.id == recordingId);

      state = state.copyWith(
        isLoading: false,
        recording: recording,
      );

      // Now load other data
      await Future.wait([
        loadEvents(recordingId),
        loadSftData(recordingId),
        initializeVideoPlayer(recordingId),
      ]);
    } catch (e) {
      // TODO(reddwarf03): Handle error
    }
    state = state.copyWith(isLoading: false);
  }

  Future<void> initializeVideoPlayer(String recordingId) async {
    try {
      // 1. Fetch the video as a Base64 string
      final videoData = await ref.read(tauriApiClientProvider).getRecordingFile(
            recordingId: recordingId,
            filename: 'recording.mp4',
            asBase64: true,
          );

      // 2. Decode the Base64 string
      // The string is a data URI: "data:video/mp4;base64,...."
      final parts = videoData.split(',');
      if (parts.length != 2) {
        throw Exception('Invalid Base64 data format');
      }
      final base64String = parts[1];
      final videoBytes = base64Decode(base64String);

      // 3. Save to a temporary file
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/$recordingId.mp4');
      await tempFile.writeAsBytes(videoBytes);

      // 4. Use the temporary file with the VideoPlayerController
      final controller = VideoPlayerController.file(tempFile);
      await controller.initialize();

      // Clean up the old controller if it exists
      await state.videoController?.dispose();

      state = state.copyWith(videoController: controller);

      // Optional: Delete the file when the controller is disposed
      controller.addListener(() {
        if (controller.value.isInitialized == false) {
          final exists = tempFile.existsSync();
          if (exists) {
            tempFile.deleteSync();
          }
        }
      });
    } catch (e, s) {
      debugPrint('Failed to initialize video player: $e');
      debugPrint(s.toString());
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
    state = state.copyWith(sftMessages: [], privateRanges: []);
    try {
      // Load SFT messages
      final sftJson = await ref.read(tauriApiClientProvider).getRecordingFile(
            recordingId: recordingId,
            filename: 'sft.json',
          );
      final List<dynamic> sftData = jsonDecode(sftJson);
      final sftMessages =
          sftData.map((data) => SftMessage.fromJson(data)).toList();
      state = state.copyWith(sftMessages: sftMessages);
      // Load private ranges
      final rangesJson =
          await ref.read(tauriApiClientProvider).getRecordingFile(
                recordingId: recordingId,
                filename: 'private_ranges.json',
              );
      final List<dynamic> rangesData = jsonDecode(rangesJson);
      final privateRanges =
          rangesData.map((data) => DeletedRange.fromJson(data)).toList();

      state = state.copyWith(
        sftMessages: sftMessages,
        privateRanges: privateRanges,
      );
      _applyMasking();
    } catch (e) {
      // It's okay if these files don't exist
    }
  }

  void _applyMasking() {
    final updatedMessages = state.sftMessages.map((message) {
      return message.copyWith(
        masked: state.privateRanges.any(
          (range) =>
              message.timestamp >= range.start &&
              message.timestamp <= range.end,
        ),
      );
    }).toList();
    state = state.copyWith(sftMessages: updatedMessages);
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
  void addDeletedSegment(RangeValues segment) {
    final newSegments = [...state.deletedSegments, segment];
    _updateDeletedSegments(newSegments);
  }

  void updateDeletedSegment(int index, RangeValues segment) {
    final newSegments = [...state.deletedSegments];
    newSegments[index] = segment;
    _updateDeletedSegments(newSegments);
  }

  void removeDeletedSegment(int index) {
    final newSegments = [...state.deletedSegments]..removeAt(index);
    state = state.copyWith(deletedSegments: newSegments);
  }

  void _updateDeletedSegments(List<RangeValues> segments) {
    // Sort by start time
    segments.sort((a, b) => a.start.compareTo(b.start));

    // Merge overlapping segments
    if (segments.isEmpty) {
      state = state.copyWith(deletedSegments: []);
      return;
    }

    final merged = <RangeValues>[segments.first];
    for (var i = 1; i < segments.length; i++) {
      final last = merged.last;
      final current = segments[i];
      if (current.start < last.end) {
        final newEnd = last.end > current.end ? last.end : current.end;
        merged[merged.length - 1] = RangeValues(last.start, newEnd);
      } else {
        merged.add(current);
      }
    }
    state = state.copyWith(deletedSegments: merged);
  }

  // Build clips from current video duration when first requested
  void initializeClipsFromDuration() {
    if (state.videoController == null) return;
    if (state.clipSegments.isNotEmpty) return;
    final durationMs =
        state.videoController!.value.duration.inMilliseconds.toDouble();
    if (durationMs <= 0) return;
    state = state.copyWith(
      clipSegments: [RangeValues(0, durationMs)],
      selectedClipIndexes: <int>{},
    );
  }

  void selectClip(int index, {bool toggle = false, bool additive = false}) {
    if (index < 0 || index >= state.clipSegments.length) return;
    final current = Set<int>.from(state.selectedClipIndexes);
    if (toggle) {
      if (current.contains(index)) {
        current.remove(index);
      } else {
        current.add(index);
      }
    } else if (additive) {
      current.add(index);
    } else {
      current
        ..clear()
        ..add(index);
    }
    state = state.copyWith(selectedClipIndexes: current);
  }

  void clearSelection() {
    if (state.selectedClipIndexes.isEmpty) return;
    state = state.copyWith(selectedClipIndexes: <int>{});
  }

  void splitClipAt(double positionMs) {
    // Ensure clips are initialized
    initializeClipsFromDuration();
    final clips = [...state.clipSegments];
    if (clips.isEmpty) return;
    // Find the clip that contains position
    final idx =
        clips.indexWhere((c) => positionMs > c.start && positionMs < c.end);
    if (idx == -1) return;
    final clip = clips[idx];
    // Avoid tiny splits
    if ((positionMs - clip.start) < 50 || (clip.end - positionMs) < 50) return;
    clips
      ..removeAt(idx)
      ..insertAll(idx, [
        RangeValues(clip.start, positionMs),
        RangeValues(positionMs, clip.end)
      ]);
    state = state.copyWith(clipSegments: clips);
    // Select the right-side clip after split
    state = state.copyWith(selectedClipIndexes: {idx + 1});
  }

  void deleteSelectedClips() {
    if (state.selectedClipIndexes.isEmpty) return;
    final indexes = state.selectedClipIndexes.toList()..sort();
    final remaining = <RangeValues>[];
    for (var i = 0; i < state.clipSegments.length; i++) {
      if (!indexes.contains(i)) remaining.add(state.clipSegments[i]);
    }
    state =
        state.copyWith(clipSegments: remaining, selectedClipIndexes: <int>{});
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
      clipboardClip: clip,
    );
  }

  void copySelectedClips() {
    if (state.selectedClipIndexes.isEmpty) return;
    final idx = state.selectedClipIndexes.first;
    if (idx < 0 || idx >= state.clipSegments.length) return;
    final clip = state.clipSegments[idx];
    state = state.copyWith(clipboardClip: clip);
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
    if (recordingId == null || state.videoController == null) return;

    state = state.copyWith(isApplyingEdits: true);

    // Prefer explicit clipSegments over deletedSegments
    final keep = state.clipSegments.isNotEmpty
        ? (state.clipSegments
            .map((r) => RangeValues(
                  r.start.clamp(
                      0.0,
                      state.videoController!.value.duration.inMilliseconds
                          .toDouble()),
                  r.end.clamp(
                      0.0,
                      state.videoController!.value.duration.inMilliseconds
                          .toDouble()),
                ))
            .toList())
        : _invertDeletedToKeep();

    final segmentsToKeep = keep
        .map((r) => {
              'start': r.start / 1000.0,
              'end': r.end / 1000.0,
            })
        .toList();

    try {
      await ref
          .read(tauriApiClientProvider)
          .applyEdits(recordingId, segmentsToKeep);
      await initializeVideoPlayer(recordingId);
      state = state.copyWith(
        isApplyingEdits: false,
        deletedSegments: [],
        clipSegments: [],
        selectedClipIndexes: <int>{},
      );
    } catch (e) {
      // TODO(reddwarf03): handle error
      state = state.copyWith(isApplyingEdits: false);
    }
  }

  List<RangeValues> _invertDeletedToKeep() {
    final duration =
        state.videoController!.value.duration.inMilliseconds.toDouble();
    final segmentsToKeep = <RangeValues>[];
    double lastEndTime = 0;
    final sortedDeleted = [...state.deletedSegments]
      ..sort((a, b) => a.start.compareTo(b.start));
    for (final deletedSegment in sortedDeleted) {
      if (deletedSegment.start > lastEndTime) {
        segmentsToKeep.add(RangeValues(lastEndTime, deletedSegment.start));
      }
      lastEndTime = deletedSegment.end;
    }
    if (lastEndTime < duration) {
      segmentsToKeep.add(RangeValues(lastEndTime, duration));
    }
    return segmentsToKeep;
  }

  // --- SFT Editor Logic ---

  void addPrivateRangeAroundMessage(SftMessage message) {
    // Logic from Svelte to find previous and next message timestamps
    final messages = state.sftMessages
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    final currentIndex =
        messages.indexWhere((m) => m.timestamp == message.timestamp);

    if (currentIndex == -1) return;

    var startTimestamp = 0;
    if (currentIndex > 0) {
      final prevMessage = messages[currentIndex - 1];
      startTimestamp =
          ((prevMessage.timestamp + message.timestamp) / 2).floor();
    }

    var endTimestamp = message.timestamp + 1000;
    if (currentIndex < messages.length - 1) {
      final nextMessage = messages[currentIndex + 1];
      endTimestamp = ((message.timestamp + nextMessage.timestamp) / 2).floor();
    }

    final newRange =
        DeletedRange(start: startTimestamp, end: endTimestamp, count: 1);
    final updatedRanges = [...state.privateRanges, newRange];

    state = state.copyWith(privateRanges: updatedRanges);
    _applyMasking();
    _savePrivateRanges();
  }

  void deletePrivateRange(DeletedRange range) {
    final updatedRanges = state.privateRanges
        .where((r) => r.start != range.start || r.end != range.end)
        .toList();
    state = state.copyWith(privateRanges: updatedRanges);
    _applyMasking();
    _savePrivateRanges();
  }

  Future<void> _savePrivateRanges() async {
    final recordingId = state.recording?.id;
    if (recordingId == null) return;

    try {
      await ref.read(tauriApiClientProvider).writeRecordingFile(
            recordingId: recordingId,
            filename: 'private_ranges.json',
            content:
                jsonEncode(state.privateRanges.map((r) => r.toJson()).toList()),
          );
    } catch (e) {
      // TODO(reddwarf03): handle error
    }
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

  Future<void> exportRecording() async {
    final recordingId = state.recording?.id;
    if (recordingId == null || state.isExporting) return;

    state =
        state.copyWith(isExporting: true, exportError: null, exportPath: null);
    try {
      final path =
          await ref.read(tauriApiClientProvider).exportRecording(recordingId);
      state = state.copyWith(exportPath: path);
    } catch (e) {
      state = state.copyWith(exportError: e.toString());
    } finally {
      state = state.copyWith(isExporting: false);
    }
  }

  Future<void> uploadRecording() async {
    final recordingId = state.recording?.id;
    if (recordingId == null || state.isUploading) return;

    state = state.copyWith(isUploading: true, uploadError: null);
    try {
      // TODO(reddwarf03): Implement actual upload logic
      await Future.delayed(const Duration(seconds: 2));
      // final result = await ref.read(tauriApiClientProvider).uploadRecording(recordingId);
      // state = state.copyWith(recording: state.recording?.copyWith(submission: result));
    } catch (e) {
      state = state.copyWith(uploadError: e.toString());
    } finally {
      state = state.copyWith(isUploading: false);
    }
  }
}
