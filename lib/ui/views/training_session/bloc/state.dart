import 'package:clones_desktop/domain/app_info.dart';
import 'package:clones_desktop/domain/models/demonstration/demonstration.dart';
import 'package:clones_desktop/domain/models/factory/factory.dart';
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
    Factory? factory,
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
    @Default([]) List<SftMessage> availableSftData,
    AppInfo? app,
    @Default(0) int scrollToBottomNonce,
  }) = _TrainingSessionState;
  const TrainingSessionState._();
}

@freezed
class ReplayGroupItem with _$ReplayGroupItem implements ChatItem {
  const factory ReplayGroupItem({
    required List<SingleMessageItem> messages,
  }) = _ReplayGroupItem;
}

@freezed
class SingleMessageItem with _$SingleMessageItem implements ChatItem {
  const factory SingleMessageItem({
    required Message message,
    required int index,
  }) = _SingleMessageItem;
}

abstract class ChatItem {}
