import 'dart:ui';
import 'package:clones_desktop/application/session/provider.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/wallet_not_connected.dart';
import 'package:clones_desktop/ui/views/demo_detail/bloc/provider.dart';
import 'package:clones_desktop/ui/views/demo_detail/layouts/components/demo_detail_editor.dart';
import 'package:clones_desktop/ui/views/demo_detail/layouts/components/demo_detail_events.dart';
import 'package:clones_desktop/ui/views/demo_detail/layouts/components/demo_detail_footer.dart';
import 'package:clones_desktop/ui/views/demo_detail/layouts/components/demo_detail_infos.dart';
import 'package:clones_desktop/ui/views/demo_detail/layouts/components/demo_detail_rewards.dart';
import 'package:clones_desktop/ui/views/demo_detail/layouts/components/demo_detail_steps.dart';
import 'package:clones_desktop/ui/views/demo_detail/layouts/components/demo_detail_submission_result.dart';
import 'package:clones_desktop/ui/views/demo_detail/layouts/components/demo_detail_video_preview.dart';
import 'package:clones_desktop/ui/views/demo_detail/layouts/components/pre_upload_messages.dart';
import 'package:clones_desktop/ui/views/training_session/layouts/components/upload_confirm_modal.dart';
import 'package:clones_desktop/ui/views/training_session/layouts/training_session_view.dart';
import 'package:clones_desktop/utils/breakpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DemoDetailView extends ConsumerStatefulWidget {
  const DemoDetailView({super.key, this.recordingId, this.trainingParams});

  static const String routeName = '/demo-detail';

  final String? recordingId;
  final Map<String, dynamic>? trainingParams;

  @override
  ConsumerState<DemoDetailView> createState() => _DemoDetailViewState();
}

class _DemoDetailViewState extends ConsumerState<DemoDetailView> {
  bool _editorFullscreen = false;

  @override
  void initState() {
    super.initState();

    // Set modal state immediately if no recordingId
    if (widget.recordingId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(demoDetailNotifierProvider.notifier)
            .setShowTrainingSessionModal(true);
      });
    }

    Future.delayed(Duration.zero, () async {
      if (widget.recordingId != null) {
        await ref
            .read(demoDetailNotifierProvider.notifier)
            .loadRecording(widget.recordingId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      demoDetailNotifierProvider.select((s) => s.showUploadConfirmModal),
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
                      .read(demoDetailNotifierProvider.notifier)
                      .confirmUploadPermission();
                },
              );
            },
          );
        }
      },
    );

    final isConnected =
        ref.watch(sessionNotifierProvider.select((s) => s.isConnected));
    if (isConnected == false) {
      return const WalletNotConnected();
    }

    final demoDetail = ref.watch(demoDetailNotifierProvider);

    if (demoDetail.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 0.5,
        ),
      );
    }

    if (demoDetail.recording == null && widget.recordingId != null) {
      return const Center(child: Text('Recording not found'));
    }

    final submission =
        ref.watch(demoDetailNotifierProvider).recording?.submission;
    final demoDetailState = ref.watch(demoDetailNotifierProvider);

    final showTrainingSessionModal = demoDetailState.showTrainingSessionModal;
    final recording = demoDetailState.recording;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Expanded(
                    child: Builder(
                      builder: (context) {
                            if (constraints.maxWidth > Breakpoints.desktop) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 9,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const DemoDetailInfos(),
                                        const SizedBox(height: 20),
                                        Expanded(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 5,
                                                child: DemoDetailVideoPreview(
                                                  onExpand: () => setState(
                                                    () => _editorFullscreen =
                                                        true,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 20),
                                              Expanded(
                                                flex: 4,
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      if (submission == null &&
                                                          recording != null &&
                                                          !showTrainingSessionModal)
                                                        CardWidget(
                                                          child: SizedBox(
                                                            width:
                                                                MediaQuery.of(
                                                              context,
                                                            ).size.width,
                                                            child:
                                                                const PreUploadMessages(),
                                                          ),
                                                        )
                                                      else
                                                        const DemoDetailSubmissionResult(),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      if (submission !=
                                                          null) ...[
                                                        const DemoDetailSteps(),
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                      ],
                                                      if (submission !=
                                                          null) ...[
                                                        const DemoDetailRewards(),
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                      ],
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    flex: 3,
                                    child: _buildEditorTabs(),
                                  ),
                                ],
                              );
                            }
                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  const DemoDetailInfos(),
                                  const SizedBox(height: 20),
                                  DemoDetailVideoPreview(
                                    onExpand: () => setState(
                                      () => _editorFullscreen = true,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const DemoDetailSteps(),
                                  const SizedBox(height: 20),
                                  if (submission == null &&
                                      recording != null &&
                                      !showTrainingSessionModal)
                                    CardWidget(
                                      child: SizedBox(
                                        width: MediaQuery.of(
                                          context,
                                        ).size.width,
                                        child: const PreUploadMessages(),
                                      ),
                                    )
                                  else
                                    const DemoDetailSubmissionResult(),
                                  const SizedBox(height: 20),
                                  const DemoDetailRewards(),
                                  const SizedBox(height: 20),
                                  _buildEditorTabs(),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      const DemoDetailFooter(),
                    ],
                  ),
                ),
            _buildFullscreenOverlay(constraints),
            if (ref.watch(demoDetailNotifierProvider).showTrainingSessionModal)
              _buildTrainingSessionModal(),
          ],
        );
      },
    );
  }

  Widget _buildEditorTabs() {
    return CardWidget(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              labelColor: ClonesColors.secondary,
              unselectedLabelColor: ClonesColors.secondaryText,
              dividerColor: ClonesColors.secondary,
              tabs: const [
                Tab(text: 'Editor'),
                Tab(text: 'Events'),
              ],
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  DemoDetailEditor(),
                  DemoDetailEvents(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullscreenOverlay(BoxConstraints constraints) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
      top: 0,
      left: _editorFullscreen ? 0 : constraints.maxWidth,
      width: constraints.maxWidth,
      height: constraints.maxHeight,
      child: IgnorePointer(
        ignoring: !_editorFullscreen,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: _editorFullscreen ? 1.0 : 0.0,
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.3),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.close_fullscreen,
                              color: ClonesColors.secondary,
                              size: 32,
                            ),
                            tooltip: 'Close',
                            onPressed: () =>
                                setState(() => _editorFullscreen = false),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(
                              flex: 2,
                              child: DemoDetailVideoPreview(),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: _buildEditorTabs(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrainingSessionModal() {
    return Stack(
      children: [
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              color: Colors.black.withValues(alpha: 0.5),
            ),
          ),
        ),
        Center(
          child: CardWidget(
            padding: CardPadding.large,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                children: [
                  Expanded(
                    child: TrainingSessionView(
                      prompt: widget.trainingParams?['prompt'],
                      appParam: widget.trainingParams?['appParam'],
                      poolId: widget.trainingParams?['poolId'],
                      onRecordingCompleted: (recordingId) async {
                        await ref
                            .read(demoDetailNotifierProvider.notifier)
                            .onDemoRecordingCompleted(recordingId);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
