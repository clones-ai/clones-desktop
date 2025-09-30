import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:clones_desktop/application/submissions.dart';
import 'package:clones_desktop/application/tauri_api.dart';
import 'package:clones_desktop/application/upload/provider.dart';
import 'package:clones_desktop/application/upload/state.dart';
import 'package:clones_desktop/domain/models/api/api_error.dart';
import 'package:clones_desktop/domain/models/demonstration/demonstration.dart';
import 'package:clones_desktop/domain/models/demonstration/demonstration_reward.dart';
import 'package:clones_desktop/domain/models/message/message.dart';
import 'package:clones_desktop/domain/models/message/sft_message.dart';
import 'package:clones_desktop/domain/models/message/typing_message.dart';
import 'package:clones_desktop/ui/views/record_overlay/bloc/state.dart';
import 'package:clones_desktop/ui/views/training_session/bloc/setters.dart';
import 'package:clones_desktop/ui/views/training_session/bloc/state.dart';
import 'package:clones_desktop/utils/env.dart';
import 'package:clones_desktop/utils/window_alignment.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@riverpod
class TrainingSessionNotifier extends _$TrainingSessionNotifier
    with TrainingSessionSetters {
  TrainingSessionNotifier();

  @override
  TrainingSessionState build() {
    return const TrainingSessionState();
  }

  Future<void> startRecording() async {
    try {
      setRecordingLoading(true);
      if (state.recordingState == RecordingState.off) {
        final originalSize =
            await ref.read(tauriApiClientProvider).getWindowSize();
        state = state.copyWith(
          originalWindowSize: Size(
            originalSize.width,
            originalSize.height,
          ),
        );

        if (kIsWeb) {
          unawaited(
            ref.read(tauriApiClientProvider).resizeWindow(
                  kRecordOverlaySize.width,
                  kRecordOverlaySize.height,
                ),
          );
          unawaited(
            ref.read(tauriApiClientProvider).setWindowPosition(
                  WindowAlignment.topRight,
                ),
          );
        }

        await ref
            .read(tauriApiClientProvider)
            .startRecording(demonstration: state.recordingDemonstration);
        setRecordingState(RecordingState.recording);
      }
    } catch (error) {
      debugPrint('Recording error: $error');
    } finally {
      setRecordingLoading(false);
    }
  }

  Future<void> typeMessage(
    String content,
    int messageIndex, {
    bool delay = true,
  }) async {
    try {
      if (content.isEmpty) return;
      if (delay) await Future.delayed(const Duration(milliseconds: 300));

      const baseDelay = 1000 / 15 / 2;
      const chunkSize = 2;

      for (var i = 0; i <= content.length; i += chunkSize) {
        setTypingMessage(
          TypingMessage(
            content: content.substring(0, i),
            target: content,
            messageIndex: messageIndex,
          ),
        );

        final variation = baseDelay * (0.8 + Random().nextDouble() * 0.4);

        // TODO(reddwarf03): To fix
        /* 
         final isBlip = i % 4 == 0 || (i > 0 && content[i - 1] == ' ');
        if (isBlip) {
          await _toneAudio.seek(Duration.zero);
          await _toneAudio.resume();
        }*/

        triggerScrollToBottom();
        if (delay) {
          await Future.delayed(Duration(milliseconds: variation.toInt()));
        }
      }

      setTypingMessage(null);
    } catch (e) {
      debugPrint('Error typing message: $e');
    }
  }

  Future<void> addMessage(
    Message msg, {
    bool audio = true,
    bool delay = true,
  }) async {
    final messageIndex = state.chatMessages.length;
    final isText = msg.type == MessageType.text;

    if (msg.role == 'assistant' && isText) {
      await typeMessage(
        msg.content,
        messageIndex,
        delay: delay,
      );

      setChatMessages([
        ...state.chatMessages,
        msg,
      ]);
      triggerScrollToBottom();
    } else {
      if (audio) {
        // TODO(reddwarf03): To check
        // await state.blipAudio!.seek(Duration.zero);
        // await state.blipAudio!.resume();
      }

      setChatMessages([
        ...state.chatMessages,
        msg,
      ]);
      triggerScrollToBottom();
    }
  }

  Future<List<SftMessage>?> loadSftData() async {
    setLoadingSftData(true);
    try {
      final sftString = await ref.read(tauriApiClientProvider).getRecordingFile(
            recordingId: state.currentRecordingId!,
            filename: 'sft.json',
          );
      final List<dynamic> sftJson = jsonDecode(sftString);
      return sftJson.map((json) => SftMessage.fromJson(json)).toList();
    } catch (error) {
      debugPrint('Failed to load SFT data: $error');
      return null;
    } finally {
      setLoadingSftData(false);
    }
  }

  Future<void> demonstrationData(Demonstration demonstration) async {
    if (demonstration.content.isNotEmpty) {
      await addMessage(generateAssistantMessage(demonstration.content));
    }

    if (demonstration.title.isNotEmpty &&
        demonstration.app.isNotEmpty &&
        demonstration.objectives.isNotEmpty) {
      final currentDemonstration = Demonstration(
        title: demonstration.title,
        app: demonstration.app,
        iconUrl: demonstration.iconUrl,
        objectives: demonstration.objectives,
        content: demonstration.content,
        poolId: state.factory?.id,
        reward: DemonstrationReward(
          time: 0,
          maxReward: state.factory?.pricePerDemo ?? 0,
          token: state.factory?.token,
        ),
        taskId: state.app?.taskId,
      );

      if (state.factory?.id != null) {
        try {
          // TODO: `getRewardProvider` is deprecated. The new on-chain system does not have a
          // direct equivalent for pre-calculating rewards. The backend now generates
          // EIP-712 signatures for claims based on user performance. This logic
          // needs to be re-evaluated and adapted to the new claim-based system.
          // final taskId = state.app?.taskId;
          //
          // final rewardInfo = await ref.read(
          //   getRewardProvider(poolId: state.poolId!, taskId: taskId).future,
          // );
          // currentDemonstration = currentDemonstration.copyWith(
          //   poolId: state.poolId,
          //   reward: DemonstrationReward(
          //     time: rewardInfo.time,
          //     maxReward: rewardInfo.maxReward,
          //   ),
          //   taskId: state.app!.taskId,
          // );

          await addMessage(
            generateUserMessage("I'll show you how to do this task."),
          );
        } catch (error) {
          await addMessage(
            generateAssistantMessage(
              'Failed to get task reward info.\nWARNING: This demonstration will not provide rewards.',
            ),
          );
          debugPrint('Failed to get reward info: $error');
        }
      }
      setRecordingDemonstration(currentDemonstration);
    }
  }

  Future<void> toolCall(Map<String, dynamic> toolCall) async {
    try {
      final functionName = toolCall['function']?['name'];
      final arguments = toolCall['function']?['arguments'];
      if (functionName == null || arguments == null) return;

      switch (functionName) {
        case 'generate_demonstration':
        case 'validate_task_request':
          final _demonstrationData = jsonDecode(arguments);
          final _demonstration = Demonstration.fromJson(_demonstrationData);
          await demonstrationData(_demonstration);
          break;
        default:
          debugPrint('Unknown tool call: $functionName');
      }
    } catch (error) {
      debugPrint('Failed to handle tool call: $error');
      await addMessage(
        generateAssistantMessage(
          'I encountered an error processing the tool call. Please try again.',
        ),
      );
    }
  }

  List<Message> _sftToChatMessages(List<SftMessage> sftMessages) {
    final chatMessages = <Message>[];
    for (final msg in sftMessages) {
      if (msg.role == 'user' &&
          msg.content is Map &&
          msg.content['type'] == 'image') {
        chatMessages.add(
          generateAssistantMessage(
            msg.content['data'],
            type: MessageType.image,
            timestamp: msg.timestamp,
          ),
        );
      } else if (msg.role == 'assistant') {
        dynamic content = msg.content;
        var typeMessage = MessageType.text;
        if (content is String && content.contains('```python')) {
          final match = RegExp(r'```python\s*\n(.*?)\n```', dotAll: true)
              .firstMatch(content);
          if (match != null && match.group(1) != null) {
            content = match.group(1)!.trim();
            typeMessage = MessageType.action;
          }
        } else if (msg.content is! String) {
          content = jsonEncode(msg.content);
        }
        chatMessages.add(
          generateAssistantMessage(
            content,
            timestamp: msg.timestamp,
            type: typeMessage,
          ),
        );
      }
    }
    return chatMessages;
  }

  Future<void> removeMessage() async {
    // Remove the last message from the chatMessages array
    if (state.chatMessages.isNotEmpty) {
      setChatMessages(
        state.chatMessages.sublist(0, state.chatMessages.length - 1),
      );
      triggerScrollToBottom();
    }
  }


  Future<void> handleDeleteMessage(int index, Message msg) async {
    if (msg.timestamp == null || state.originalSftData == null) {
      return;
    }

    // Find previous and next messages in originalSftData
    final sortedMessages = [...state.originalSftData!]
      ..sort((a, b) => a.timestamp - b.timestamp)
      ..where((msg) => msg.role == 'assistant');
    final currentIndex =
        sortedMessages.indexWhere((m) => m.timestamp == msg.timestamp);

    int startTimestamp;
    int endTimestamp;

    // Calculate start timestamp by averaging with previous message if available
    if (currentIndex > 0) {
      final prevMsg = sortedMessages[currentIndex - 1];
      startTimestamp = (prevMsg.timestamp + msg.timestamp!) ~/ 2;
    } else {
      // No previous message, use fallback
      startTimestamp = msg.timestamp! - 5000;
    }

    // Calculate end timestamp by averaging with next message if available
    if (currentIndex < sortedMessages.length - 1) {
      final nextMsg = sortedMessages[currentIndex + 1];
      endTimestamp = (msg.timestamp! + nextMsg.timestamp) ~/ 2;
    } else {
      // No next message, use fallback
      endTimestamp = msg.timestamp! + 5000;
    }

    final count = state.originalSftData!
        .where(
          (m) => m.timestamp >= startTimestamp && m.timestamp <= endTimestamp,
        )
        .length;
    setDeletedRanges([
      ...state.deletedRanges,
      {
        'start': startTimestamp,
        'end': endTimestamp,
        'count': count,
      },
    ]);

    // Update available SFT data
    _updateAvailableSftData();

    setChatMessages([
      ...state.chatMessages.sublist(0, index),
      generateUserMessage(
        '---$startTimestamp $endTimestamp $count',
        type: MessageType.delete,
      ),
      ...state.chatMessages.sublist(index + 1),
    ]);
  }

  Future<void> undoDelete(int? clickedMessageIndex) async {
    // Parse the start, end, and count from the delete message
    if (clickedMessageIndex != null && state.originalSftData != null) {
      final deleteMsg = state.chatMessages[clickedMessageIndex];
      if (deleteMsg.type == MessageType.delete) {
        final content = deleteMsg.content.substring(3);
        final parts = content.trim().split(' ').map(int.parse).toList();
        final start = parts[0];
        final end = parts[1];

        // Remove the range from deletedRanges
        setDeletedRanges(
          state.deletedRanges.where((r) => r['start'] != start).toList(),
        );

        // Update available SFT data
        _updateAvailableSftData();

        // Find messages in originalSftData that fall within this time range
        final messagesToRestore = state.originalSftData!.where(
          (msg) => msg.timestamp >= start && msg.timestamp <= end,
        );

        // Create new messages to insert
        final newMessages = _sftToChatMessages(messagesToRestore.toList());

        // Replace the delete message with the restored messages
        setChatMessages([
          ...state.chatMessages.sublist(0, clickedMessageIndex),
          ...newMessages,
          ...state.chatMessages.sublist(clickedMessageIndex + 1),
        ]);
      }
    }
  }

  void _updateAvailableSftData() {
    if (state.originalSftData == null) {
      setAvailableSftData([]);
      return;
    }

    // Filter out deleted messages for UI display
    final available = state.originalSftData!.where((msg) {
      return !state.deletedRanges.any(
        (range) => msg.timestamp >= range['start'] && msg.timestamp <= range['end'],
      );
    }).toList();

    setAvailableSftData(available);
  }

  Future<void> recordingComplete() async {
    if (state.recordingLoading || state.recordingProcessing) {
      return;
    }

    setRecordingLoading(true);
    setRecordingProcessing(true);
    setRecordedDemonstration(state.recordingDemonstration);
    setRecordingDemonstration(null);

    await addMessage(
      generateUserMessage(
        'Saving recording...',
        type: MessageType.loading,
      ),
    );

    setRecordingLoading(false);
    if (state.recordingState == RecordingState.recording) {
      try {
        if (state.originalWindowSize != null) {
          unawaited(
            ref.read(tauriApiClientProvider).resizeWindow(
                  state.originalWindowSize!.width,
                  state.originalWindowSize!.height,
                ),
          );
          unawaited(
            ref.read(tauriApiClientProvider).setWindowPosition(
                  WindowAlignment.topCenter,
                ),
          );
        }
        final recordingId =
            await ref.read(tauriApiClientProvider).stopRecording('done');

        setCurrentRecordingId(recordingId);
        setRecordingState(RecordingState.off);
      } catch (e) {
        debugPrint('Error stopping recording: $e');
      }
    }

    await removeMessage();

    // Try to load SFT data
    if (state.currentRecordingId != null) {
      // show replaying status
      await addMessage(
        generateUserMessage(
          'Replaying recording...',
          type: MessageType.loading,
        ),
      );

      // process the recording after stopping
      try {
        await ref
            .read(tauriApiClientProvider)
            .processRecording(state.currentRecordingId!);
      } catch (processError) {
        debugPrint('Failed to automatically process recording: $processError');
      }

      final sftData = await loadSftData();
      await removeMessage();

      if (sftData != null && sftData.isNotEmpty) {
        // Store original SFT data for filtering
        setOriginalSftData([...sftData]);

        // Initialize available SFT data
        _updateAvailableSftData();

        // Add styled start replay message
        await addMessage(
          generateAssistantMessage(
            '--- demonstration replay ---',
            type: MessageType.start,
          ),
          audio: false,
          delay: false,
        );

        // Process SFT messages properly alternating between VM (assistant) and user
        final replayMessages = _sftToChatMessages(sftData);
        setChatMessages([...state.chatMessages, ...replayMessages]);
        triggerScrollToBottom();

        // Add end replay message
        await addMessage(
          generateAssistantMessage(
            '--- end of replay ---',
            type: MessageType.end,
          ),
          delay: false,
        );
        await addMessage(
          generateUserMessage('I completed the task! 🎉'),
        );
        await addMessage(
          generateAssistantMessage('Great job completing the task!'),
        );
      } else {
        await addMessage(
          generateUserMessage(
            state.currentRecordingId!,
            type: MessageType.recording,
          ),
        );
        await addMessage(
          generateUserMessage('I completed the task! 🎉'),
        );
        await addMessage(
          generateAssistantMessage('Great job completing the task!'),
        );
      }
    }

    await addMessage(
      generateAssistantMessage(
        "Review your demonstration before uploading. You can hover over messages to delete any sections containing sensitive information. Once you're ready, upload to get scored or do it later from the history page.",
      ),
    );
    setShowUploadBlock(true);

    setRecordingProcessing(false);
    triggerScrollToBottom();
  }

  Future<void> giveUp() async {
    if (state.recordingState == RecordingState.recording) {
      try {
        if (state.originalWindowSize != null) {
          unawaited(
            ref.read(tauriApiClientProvider).resizeWindow(
                  state.originalWindowSize!.width,
                  state.originalWindowSize!.height,
                ),
          );
          unawaited(
            ref.read(tauriApiClientProvider).setWindowPosition(
                  WindowAlignment.topCenter,
                ),
          );
        }

        final recordingId =
            await ref.read(tauriApiClientProvider).stopRecording('fail');

        setRecordingDemonstration(null);
        setRecordingState(RecordingState.off);
        
        // Mark that user has given up to skip confirmation on close
        state = state.copyWith(hasGivenUp: true);

        await addMessage(
          Message(
            role: 'user',
            content: recordingId,
            type: MessageType.recording,
          ),
        );

        await addMessage(
          generateUserMessage('I’ve stopped this task.'),
        );
        await addMessage(
          generateAssistantMessage(
            'This task has been stopped. Feel free to choose a different one.',
          ),
        );
      } catch (e) {
        debugPrint('Error stopping recording: $e');
        return;
      }
    }
  }

  Future<void> assistantResponse(Map<String, dynamic> response) async {
    try {
      final message = response['data'];
      final _toolCall = message['tool_calls']?[0];

      if (_toolCall != null) {
        await toolCall(_toolCall);
      } else if (message['role'] == 'assistant' &&
          message['content'] is String) {
        await addMessage(
          Message(
            role: message['role'],
            content: message['content'],
          ),
        );
      }
    } catch (error) {
      debugPrint('Failed to handle assistant response: $error');
      await addMessage(
        generateAssistantMessage(
          'I encountered an error processing the response. Please try again.',
        ),
      );
    }
  }

  Future<void> initialMessage() async {
    setIsWaitingForResponse(true);

    try {
      final response = await http.post(
        Uri.parse('${Env.apiBackendUrl}/api/v1/forge/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'messages': [],
          'task_prompt': state.prompt ?? 'anything keep it simple',
          'app': state.app?.toJson(),
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        await assistantResponse(responseData);
      } else {
        throw Exception('Failed to get initial message: ${response.body}');
      }
    } catch (e) {
      debugPrint('Failed to get initial message: $e');
      await addMessage(
        generateAssistantMessage(
          "I'm sorry, I encountered an error starting our conversation. Please try again.",
        ),
      );
    } finally {
      setIsWaitingForResponse(false);
    }
  }

  Future<bool> deleteRecording() async {
    if (state.currentRecordingId == null) return false;

    try {
      final deleted = await ref
          .read(tauriApiClientProvider)
          .deleteRecording(state.currentRecordingId!);

      if (deleted.isNotEmpty) {
        final messages = state.chatMessages
            .where((m) => m.type != MessageType.uploadButton)
            .toList()
          ..add(
            generateAssistantMessage(
              'The recording has been deleted.',
            ),
          );

        setChatMessages(messages);
        triggerScrollToBottom();

        setCurrentRecordingId(null);
        setRecordedDemonstration(null);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting recording: $e');
      return false;
    } finally {
      setShowUploadBlock(false);
    }
  }

  void handleHover(int index) => setHoveredMessageIndex(index);

  void handleHoverEnd() => setHoveredMessageIndex(null);

  Future<void> uploadRecording(String recordingId) async {
    setIsUploading(true);
    setShowUploadBlock(false);

    try {
      final demonstrationTitle = state.recordingDemonstration?.title ??
          state.recordedDemonstration?.title ??
          'Unknown';

      await addMessage(
        generateAssistantMessage(
          'Your demonstration is being processed. This may take a while. Feel free to complete more tasks or come back later when it is done processing!',
        ),
      );

      late ProviderSubscription<Map<String, UploadTaskState>> sub;
      sub = ref.listen<Map<String, UploadTaskState>>(uploadQueueProvider,
          (previous, next) async {
        final uploadState = next[recordingId];
        if (uploadState == null) return;

        if (uploadState.uploadStatus == UploadStatus.done) {
          sub.close();
          setIsUploading(false);
          await addMessage(
            generateAssistantMessage(
              'Your demonstration was successfully uploaded!',
            ),
          );

          if (uploadState.submissionId != null) {
            try {
              final submissionDetails = await ref.read(
                getSubmissionStatusProvider(
                  submissionId: uploadState.submissionId!,
                ).future,
              );
              await addMessage(
                generateAssistantMessage(
                  'You scored ${submissionDetails.clampedScore}% on this task.',
                ),
              );

              if (submissionDetails.gradeResult != null) {
                await addMessage(
                  generateAssistantMessage(
                    'Feedback:\n${submissionDetails.gradeResult!.summary}',
                  ),
                );
              }
            } catch (e) {
              debugPrint('Failed to get submission details: $e');
            }
          }
        } else if (uploadState.uploadStatus == UploadStatus.error) {
          sub.close();
          setIsUploading(false);
          await addMessage(
            generateAssistantMessage(
              'There was an error processing your demonstration: ${uploadState.error ?? 'Unknown error'}',
            ),
          );
        }
      });

      final poolId = state.recordingDemonstration?.poolId ??
          state.recordedDemonstration?.poolId ??
          '';

      await ref.read(uploadQueueProvider.notifier).upload(
            recordingId,
            poolId,
            demonstrationTitle,
          );
    } on Exception catch (e) {
      if (e.toString().contains('Upload data is not allowed')) {
        setShowUploadConfirmModal(true);
        setIsUploading(false);
        return;
      }
      debugPrint('Error in upload process: $e');
      await addMessage(
        generateAssistantMessage(
          e is ApiError
              ? e.message
              : 'There was an error starting the upload: $e',
        ),
      );
      setIsUploading(false);
    } finally {
      setShowUploadBlock(false);
    }
  }

  Future<void> confirmAndUpload() async {
    if (state.currentRecordingId != null) {
      await uploadRecording(state.currentRecordingId!);
    }
  }
}
