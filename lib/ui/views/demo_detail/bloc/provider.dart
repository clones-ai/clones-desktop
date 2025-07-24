import 'dart:convert';

import 'package:clones_desktop/application/recording.dart';
import 'package:clones_desktop/application/tauri_api.dart';
import 'package:clones_desktop/domain/models/message/deleted_range.dart';
import 'package:clones_desktop/domain/models/message/sft_message.dart';
import 'package:clones_desktop/domain/models/recording/recording_event.dart';
import 'package:clones_desktop/ui/views/demo_detail/bloc/state.dart';
import 'package:flutter/material.dart';
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
      final videoData = await ref.read(tauriApiClientProvider).getRecordingFile(
            recordingId: recordingId,
            filename: 'recording.mp4',
            asBase64: true,
          );

      // The string is a data URI: "data:video/mp4;base64,...."
      final parts = videoData.split(',');
      if (parts.length != 2) {
        throw Exception('Invalid Base64 data format');
      }
      final base64String = parts[1];
      final videoBytes = base64Decode(base64String);

      final videoUri = Uri.dataFromBytes(
        videoBytes,
        mimeType: 'video/mp4',
      );
      final controller = VideoPlayerController.networkUrl(videoUri);
      await controller.initialize();

      await state.videoController?.dispose();

      final newRange =
          RangeValues(0, controller.value.duration.inMilliseconds.toDouble());

      state = state.copyWith(videoController: controller, trimRange: newRange);
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

  void setTrimRange(RangeValues range) {
    state = state.copyWith(trimRange: range);
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

  Future<void> trimRecording(double startTime, double endTime) async {
    final recordingId = state.recording?.id;
    if (recordingId == null) return;
    state = state.copyWith(isTrimming: true);
    try {
      await ref.read(tauriApiClientProvider).trimRecording(
            recordingId,
            startTime,
            endTime,
          );
      await initializeVideoPlayer(recordingId);
      state = state.copyWith(isTrimming: false);
    } catch (e) {
      // TODO(reddwarf03): handle error
      state = state.copyWith(isTrimming: false);
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
