import 'package:clones_desktop/domain/models/message/deleted_range.dart';
import 'package:clones_desktop/domain/models/message/sft_message.dart';
import 'package:clones_desktop/domain/models/recording/api_recording.dart';
import 'package:clones_desktop/domain/models/recording/recording_event.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:video_player/video_player.dart';

part 'state.freezed.dart';

@freezed
class DemoDetailState with _$DemoDetailState {
  const factory DemoDetailState({
    @Default(false) bool isLoading,
    ApiRecording? recording,
    @Default([]) List<RecordingEvent> events,
    @Default([]) List<SftMessage> sftMessages,
    @Default([]) List<DeletedRange> privateRanges,
    @Default({}) Set<String> eventTypes,
    @Default({}) Set<String> enabledEventTypes,
    @Default(0) int startTime,
    @JsonKey(includeIfNull: false) VideoPlayerController? videoController,

    // Video editing
    @Default([]) List<RangeValues> deletedSegments,
    @Default([]) List<RangeValues> clipSegments,
    @Default({}) Set<int> selectedClipIndexes,
    @JsonKey(includeIfNull: false) RangeValues? clipboardClip,
    @Default(false) bool isApplyingEdits,

    // New states for button handling
    @Default(false) bool isProcessing,
    @Default(false) bool isExporting,
    @Default(false) bool isUploading,
    String? exportPath,
    String? exportError,
    String? uploadError,
  }) = _DemoDetailState;
  const DemoDetailState._();
}
