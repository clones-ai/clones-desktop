import 'package:riverpod/riverpod.dart';
import 'package:viralmind_flutter/domain/app_info.dart';
import 'package:viralmind_flutter/domain/models/message/deleted_range.dart';
import 'package:viralmind_flutter/domain/models/message/message.dart';
import 'package:viralmind_flutter/domain/models/message/sft_message.dart';
import 'package:viralmind_flutter/domain/models/message/typing_message.dart';
import 'package:viralmind_flutter/domain/models/quest/quest.dart';
import 'package:viralmind_flutter/ui/views/training_session/bloc/state.dart';

mixin TrainingSessionSetters on AutoDisposeNotifier<TrainingSessionState> {
  void setPrompt(String? prompt) {
    state = state.copyWith(prompt: prompt);
  }

  void setPoolId(String? poolId) {
    state = state.copyWith(poolId: poolId);
  }

  void setCurrentQuest(Quest? quest) {
    state = state.copyWith(currentQuest: quest);
  }

  void setActiveQuest(Quest? quest) {
    state = state.copyWith(activeQuest: quest);
  }

  void setRecordingLoading(bool recordingLoading) {
    state = state.copyWith(recordingLoading: recordingLoading);
  }

  void setRecordingProcessing(bool recordingProcessing) {
    state = state.copyWith(recordingProcessing: recordingProcessing);
  }

  void setShowUploadConfirmModal(bool showUploadConfirmModal) {
    state = state.copyWith(showUploadConfirmModal: showUploadConfirmModal);
  }

  void setCurrentRecordingId(String? currentRecordingId) {
    state = state.copyWith(currentRecordingId: currentRecordingId);
  }

  void setIsUploading(bool isUploading) {
    state = state.copyWith(isUploading: isUploading);
  }

  void setLoadingSftData(bool loadingSftData) {
    state = state.copyWith(loadingSftData: loadingSftData);
  }

  void setRecordingState(RecordingState recordingState) {
    state = state.copyWith(recordingState: recordingState);
  }

  void setChatMessages(List<Message> chatMessages) {
    state = state.copyWith(chatMessages: chatMessages);
  }

  void setTypingMessage(TypingMessage? typingMessage) {
    state = state.copyWith(typingMessage: typingMessage);
  }

  void setIsWaitingForResponse(bool isWaitingForResponse) {
    state = state.copyWith(isWaitingForResponse: isWaitingForResponse);
  }

  void setHoveredMessageIndex(int? hoveredMessageIndex) {
    state = state.copyWith(hoveredMessageIndex: hoveredMessageIndex);
  }

  void setDeletedRanges(List<DeletedRange> deletedRanges) {
    state = state.copyWith(deletedRanges: deletedRanges);
  }

  void setOriginalSftData(List<SftMessage>? originalSftData) {
    state = state.copyWith(originalSftData: originalSftData);
  }

  void setApp(AppInfo? app) {
    state = state.copyWith(app: app);
  }

  void triggerScrollToBottom() {
    state = state.copyWith(scrollToBottomNonce: state.scrollToBottomNonce + 1);
  }
}
