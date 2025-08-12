import 'package:audioplayers/audioplayers.dart';
import 'package:clones_desktop/domain/app_info.dart';
import 'package:clones_desktop/domain/models/demonstration/demonstration.dart';
import 'package:clones_desktop/domain/models/message/deleted_range.dart';
import 'package:clones_desktop/domain/models/message/message.dart';
import 'package:clones_desktop/domain/models/message/sft_message.dart';
import 'package:clones_desktop/domain/models/message/typing_message.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

enum RecordingState { off, starting, recording, stopping, saved }

@freezed
class TrainingSessionState with _$TrainingSessionState {
  const factory TrainingSessionState({
    String? prompt,
    String? poolId,
    Demonstration? recordedDemonstration,
    Demonstration? recordingDemonstration,
    @Default(false) bool recordingLoading,
    @Default(false) bool recordingProcessing,
    @Default(false) bool showUploadConfirmModal,
    @Default(false) bool showUploadBlock,
    String? currentRecordingId,
    @Default(false) bool isUploading,
    Size? originalWindowSize,
    @Default(false) bool loadingSftData,
    @Default(RecordingState.off) RecordingState recordingState,
    @Default([]) List<Message> chatMessages,
    @Default(null) TypingMessage? typingMessage,
    @Default(false) bool isWaitingForResponse,
    @Default(null) int? hoveredMessageIndex,
    @Default([]) List<DeletedRange> deletedRanges,
    @Default(null) List<SftMessage>? originalSftData,
    AppInfo? app,
    @Default(0) int scrollToBottomNonce,
    AudioPlayer? toneAudio,
    AudioPlayer? blipAudio,
  }) = _TrainingSessionState;
  const TrainingSessionState._();
}
