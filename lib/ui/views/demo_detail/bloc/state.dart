import 'package:clones_desktop/domain/models/message/deleted_range.dart';
import 'package:clones_desktop/domain/models/message/sft_message.dart';
import 'package:clones_desktop/domain/models/recording/api_recording.dart';
import 'package:clones_desktop/domain/models/recording/recording_event.dart';
import 'package:clones_desktop/domain/models/video_clip.dart';
import 'package:clones_desktop/ui/components/video_player/video_source.dart';
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
    @JsonKey(includeIfNull: false) VideoSource? videoSource,
    @Default(false) bool showTrainingSessionModal,

    // Video editing
    @Default([]) List<VideoClip> clips,
    @Default({}) Set<String> selectedClipIds,
    @JsonKey(includeIfNull: false) VideoClip? clipboardClip,
    // Each deletion operation is stored as a separate list of clips
    @Default([]) List<List<VideoClip>> deletedClipsHistory,
    
    // Legacy support for RangeValues (deprecated)
    @Default([]) List<RangeValues> clipSegments,
    @Default({}) Set<int> selectedClipIndexes,
    @Default(false) bool isApplyingEdits,

    // New states for button handling
    @Default(false) bool isProcessing,
    @Default(false) bool isExporting,
    @Default(false) bool isUploading,
    @Default(false) bool showUploadConfirmModal,
    String? exportPath,
    String? exportError,
    String? uploadError,
  }) = _DemoDetailState;
  const DemoDetailState._();
}
