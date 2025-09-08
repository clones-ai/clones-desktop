import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:clones_desktop/application/factory.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/domain/app_info.dart';
import 'package:clones_desktop/domain/models/message/message.dart';
import 'package:clones_desktop/domain/models/message/typing_message.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:clones_desktop/ui/components/design_widget/dialog/dialog.dart';
import 'package:clones_desktop/ui/components/design_widget/message_box/message_box.dart';
import 'package:clones_desktop/ui/components/pfp.dart';
import 'package:clones_desktop/ui/components/recording_panel.dart';
import 'package:clones_desktop/ui/views/factory/layouts/factory_view.dart';
import 'package:clones_desktop/ui/views/training_session/bloc/provider.dart';
import 'package:clones_desktop/ui/views/training_session/layouts/components/base64_image_message.dart';
import 'package:clones_desktop/ui/views/training_session/layouts/components/record_panel.dart';
import 'package:clones_desktop/ui/views/training_session/layouts/components/typing_indicator.dart';
import 'package:clones_desktop/ui/views/training_session/layouts/components/upload_confirm_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

abstract class _ChatItem {}

class _SingleMessageItem extends _ChatItem {
  _SingleMessageItem(this.message, this.index);
  final Message message;
  final int index;
}

class _ReplayGroupItem extends _ChatItem {
  _ReplayGroupItem(this.items);
  final List<_SingleMessageItem> items;
}

class TrainingSessionView extends ConsumerStatefulWidget {
  const TrainingSessionView({
    super.key,
    this.prompt,
    this.appParam,
    this.poolId,
  });
  final String? prompt;
  final String? appParam;
  final String? poolId;

  static const String routeName = '/training_session';

  @override
  ConsumerState<TrainingSessionView> createState() =>
      _TrainingSessionViewState();
}

class _TrainingSessionViewState extends ConsumerState<TrainingSessionView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    Future(() async {
      if (widget.appParam != null) {
        try {
          final decodedParam = jsonDecode(_decodeComponent(widget.appParam!));

          final app = AppInfo.fromJson(decodedParam);
          ref.read(trainingSessionNotifierProvider.notifier).setApp(app);
        } catch (error) {
          debugPrint('Failed to parse app parameter: $error');
        }
      }
      if (widget.poolId != null) {
        final factory = await ref
            .read(getFactoryProvider(factoryId: widget.poolId!).future);
        ref.read(trainingSessionNotifierProvider.notifier).setFactory(factory);
      }
      if (widget.prompt != null) {
        ref
            .read(trainingSessionNotifierProvider.notifier)
            .setPrompt(widget.prompt);
      }
      await _initializeAudio();
      await ref.read(trainingSessionNotifierProvider.notifier).initialMessage();
    });
    super.initState();
  }

  List<_ChatItem> _processMessages(List<Message> messages) {
    final processed = <_ChatItem>[];
    var inReplayBlock = false;
    var currentReplayItems = <_SingleMessageItem>[];

    for (var i = 0; i < messages.length; i++) {
      final message = messages[i];

      if (message.type == MessageType.start) {
        inReplayBlock = true;
        continue;
      }

      if (message.type == MessageType.end) {
        inReplayBlock = false;
        if (currentReplayItems.isNotEmpty) {
          processed.add(_ReplayGroupItem(currentReplayItems));
        }
        currentReplayItems = [];
        continue;
      }

      final item = _SingleMessageItem(message, i);
      if (inReplayBlock) {
        currentReplayItems.add(item);
      } else {
        processed.add(item);
      }
    }

    if (currentReplayItems.isNotEmpty) {
      processed.add(_ReplayGroupItem(currentReplayItems));
    }

    return processed;
  }

  String _decodeComponent(String component) {
    try {
      return Uri.decodeComponent(component);
    } catch (e) {
      return component;
    }
  }

  Future<void> _initializeAudio() async {
    await ref
        .read(trainingSessionNotifierProvider.notifier)
        .setToneAudio('tone.wav');
    await ref
        .read(trainingSessionNotifierProvider.notifier)
        .setBlipAudio('blip.wav');
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    ref
      ..listen(
        trainingSessionNotifierProvider.select((s) => s.showUploadConfirmModal),
        (previous, next) {
          if (next) {
            showDialog<void>(
              context: context,
              barrierDismissible: false,
              useRootNavigator: false,
              builder: (BuildContext context) {
                return UploadConfirmModal(
                  onConfirm: () {
                    ref
                        .read(trainingSessionNotifierProvider.notifier)
                        .confirmAndUpload();
                  },
                );
              },
            ).then((_) {
              ref
                  .read(trainingSessionNotifierProvider.notifier)
                  .setShowUploadConfirmModal(false);
            });
          }
        },
      )
      ..listen(
        trainingSessionNotifierProvider.select((s) => s.scrollToBottomNonce),
        (previous, next) {
          if (previous != next) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_scrollController.hasClients) {
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              }
            });
          }
        },
      );

    final trainingSession = ref.watch(trainingSessionNotifierProvider);
    final processedItems = _processMessages(trainingSession.chatMessages);
    final showTypingIndicator = trainingSession.isWaitingForResponse &&
        trainingSession.typingMessage == null;
    final showStreamingMessage = trainingSession.typingMessage != null;
    final mediaQuery = MediaQuery.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomScrollView(
          controller: _scrollController,
          physics: const ClampingScrollPhysics(
            parent: RangeMaintainingScrollPhysics(),
          ),
          slivers: [
            SliverAppBar(
              pinned: true,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              centerTitle: true,
              titleTextStyle: theme.textTheme.titleMedium?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                letterSpacing: 0.5,
              ),
              title: const Text('Demonstration'),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    onPressed: () {
                      AppDialogs.showConfirmDialog(
                        context,
                        ref,
                        'Leave Demonstration Recording?',
                        'Are you sure you want to leave the recording of this demonstration ? Your progress will be lost.',
                        'Leave',
                        () {
                          context.go(FactoryView.routeName);
                        },
                      );
                    },
                    icon: Icon(
                      Icons.close,
                      color: ClonesColors.secondaryText,
                    ),
                  ),
                ),
              ],
              flexibleSpace: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = processedItems[index];
                    Widget child;

                    if (item is _ReplayGroupItem) {
                      child = _buildReplayGroup(item);
                    } else {
                      final single = item as _SingleMessageItem;
                      child = _buildMessageItem(single.message, single.index);
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: child,
                    );
                  },
                  childCount: processedItems.length,
                ),
              ),
            ),
            if (showStreamingMessage)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                sliver: SliverToBoxAdapter(
                  child: _buildStreamingMessage(trainingSession.typingMessage!),
                ),
              ),
            if (showTypingIndicator)
              const SliverPadding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                sliver: SliverToBoxAdapter(child: TypingIndicator()),
              ),
            if (trainingSession.showUploadBlock)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                sliver: SliverToBoxAdapter(child: _buildUploadButton()),
              ),
            if (trainingSession.recordingDemonstration != null)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15, top: 15),
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: mediaQuery.size.width * 0.7,
                              ),
                              child: const MessageBox(
                                messageBoxType: MessageBoxType.talkLeft,
                                content: RecordPanel(),
                              ),
                            ),
                          ),
                          const Positioned(
                            left: 0,
                            top: 0,
                            child: Pfp(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildMessageItem(Message message, int index) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final isUser = message.role == 'user';
    if (message.type != MessageType.text) {
      if (message.type == MessageType.image) {
        final base64 = message.content;
        return Base64ImageMessage(base64: base64);
      }

      if (message.type == MessageType.delete) {
        // TODO(reddwarf03): Add delete message
        return const Text('Deleted');
      }

      if (message.type == MessageType.action) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: mediaQuery.size.width * 0.7,
              ),
              child: MessageBox(
                messageBoxType: MessageBoxType.talkRight,
                content: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.content,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      message.content.toLowerCase().contains('click')
                          ? Icons.ads_click
                          : message.content.toLowerCase().contains('scroll')
                              ? Icons.swap_vert
                              : Icons.keyboard,
                      color: ClonesColors.tertiary,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }
      if (message.type == MessageType.recording) {
        final id = message.content;
        return RecordingPanel(recordingId: id);
      }
      if (message.type == MessageType.loading) {
        return const Center(
          child: CircularProgressIndicator(
            strokeWidth: 0.5,
          ),
        );
      }
      return Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Card(
          color: isUser ? ClonesColors.primary : ClonesColors.secondary,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              message.content,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ),
      );
    }

    final messageBubble = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment:
          isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 15),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: mediaQuery.size.width * 0.7,
                ),
                child: MessageBox(
                  messageBoxType: isUser
                      ? MessageBoxType.talkRight
                      : MessageBoxType.talkLeft,
                  content: _buildMessageContent(message),
                ),
              ),
            ),
            if (!isUser) const Pfp(),
          ],
        ),
      ],
    );

    return messageBubble;
  }

  Widget _buildReplayGroup(_ReplayGroupItem group) {
    final theme = Theme.of(context);
    return CardWidget(
      variant: CardVariant.secondary,
      padding: CardPadding.large,
      child: Column(
        children: [
          Text(
            'Demonstration Replay',
            style: theme.textTheme.titleSmall,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              children: group.items.map((item) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: item == group.items.last ? 0 : 20,
                  ),
                  child: _buildMessageItem(item.message, item.index),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageContent(Message message) {
    final theme = Theme.of(context);
    return SelectableText(
      message.content,
      style: theme.textTheme.bodyMedium,
    );
  }

  Widget _buildUploadButton() {
    final trainingSession = ref.watch(trainingSessionNotifierProvider);

    final assistantMessage = _buildMessageItem(
      const Message(
        role: 'assistant',
        content:
            'Ready to submit your demonstration to get scored and earn Tokens?',
      ),
      -1,
    );

    final userActions = CardWidget(
      variant: CardVariant.secondary,
      padding: CardPadding.large,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          BtnPrimary(
            onTap: () async {
              final success = await ref
                  .read(trainingSessionNotifierProvider.notifier)
                  .deleteRecording();

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Recording deleted successfully'
                          : 'Failed to delete recording',
                    ),
                  ),
                );
              }
            },
            buttonText: "Don't like your recording? Click to delete it.",
            btnPrimaryType: BtnPrimaryType.outlinePrimary,
          ),
          const SizedBox(width: 16),
          BtnPrimary(
            onTap: trainingSession.isUploading
                ? null
                : () {
                    ref
                        .read(
                          trainingSessionNotifierProvider.notifier,
                        )
                        .uploadRecording(
                          trainingSession.currentRecordingId!,
                        );
                  },
            buttonText: trainingSession.isUploading
                ? 'Uploading...'
                : 'Upload Demonstration',
            isLoading: trainingSession.isUploading,
            isLocked: trainingSession.isUploading,
          ),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        assistantMessage,
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerRight,
          child: userActions,
        ),
      ],
    );
  }

  Widget _buildStreamingMessage(TypingMessage typingMessage) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final messageBubble = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 15),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: mediaQuery.size.width * 0.7,
                ),
                child: MessageBox(
                  messageBoxType: MessageBoxType.talkLeft,
                  content: Text(
                    typingMessage.content,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
            const Positioned(
              left: 0,
              top: 0,
              child: Pfp(),
            ),
          ],
        ),
      ],
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [messageBubble],
    );
  }
}
