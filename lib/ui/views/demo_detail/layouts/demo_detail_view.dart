import 'dart:ui';
import 'package:clones_desktop/application/session/provider.dart';
import 'package:clones_desktop/application/tauri_api.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:clones_desktop/ui/components/wallet_not_connected.dart';
import 'package:clones_desktop/ui/views/demo_detail/bloc/provider.dart';
import 'package:clones_desktop/ui/views/demo_detail/layouts/components/demo_detail_editor.dart';
import 'package:clones_desktop/ui/views/demo_detail/layouts/components/demo_detail_events.dart';
import 'package:clones_desktop/ui/views/demo_detail/layouts/components/demo_detail_infos.dart';
import 'package:clones_desktop/ui/views/demo_detail/layouts/components/demo_detail_rewards.dart';
import 'package:clones_desktop/ui/views/demo_detail/layouts/components/demo_detail_steps.dart';
import 'package:clones_desktop/ui/views/demo_detail/layouts/components/demo_detail_submission_result.dart';
import 'package:clones_desktop/ui/views/demo_detail/layouts/components/demo_detail_video_preview.dart';
import 'package:clones_desktop/utils/breakpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DemoDetailView extends ConsumerStatefulWidget {
  const DemoDetailView({super.key, required this.recordingId});

  static const String routeName = '/demo-detail';

  final String recordingId;

  @override
  ConsumerState<DemoDetailView> createState() => _DemoDetailViewState();
}

class _DemoDetailViewState extends ConsumerState<DemoDetailView> {
  String platformOpenFileExplorerName = '';
  bool _editorFullscreen = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await ref
          .read(demoDetailNotifierProvider.notifier)
          .loadRecording(widget.recordingId);

      final platformName = await _getPlatformOpenFileExplorerName(ref);
      setState(() {
        platformOpenFileExplorerName = platformName;
      });
    });
  }

  Future<String> _getPlatformOpenFileExplorerName(WidgetRef ref) async {
    final platform = await ref.read(tauriApiClientProvider).getPlatform();
    debugPrint('platform: $platform');
    if (platform == 'macos') {
      return 'Finder';
    } else if (platform == 'windows') {
      return 'Explorer';
    }
    return 'Files';
  }

  Widget _buildFooter(BuildContext context, WidgetRef ref) {
    final walletAddress =
        ref.watch(sessionNotifierProvider.select((s) => s.address));

    final demoDetail = ref.watch(demoDetailNotifierProvider);
    final recording = demoDetail.recording;
    final submission = recording?.submission;
    final demoDetailNotifier = ref.watch(demoDetailNotifierProvider.notifier);
    return Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        BtnPrimary(
          btnPrimaryType: BtnPrimaryType.outlinePrimary,
          buttonText: 'Open in $platformOpenFileExplorerName',
          onTap: demoDetailNotifier.openRecordingFolder,
        ),
        if (recording != null && recording.status == 'completed') ...[
          if (demoDetail.sftMessages.isEmpty)
            BtnPrimary(
              btnPrimaryType: BtnPrimaryType.outlinePrimary,
              onTap: demoDetailNotifier.processRecording,
              isLoading: demoDetail.isProcessing,
              buttonText: 'Process',
            ),
          BtnPrimary(
            btnPrimaryType: BtnPrimaryType.outlinePrimary,
            onTap: demoDetailNotifier.exportRecording,
            isLoading: demoDetail.isExporting,
            buttonText: 'Export Zip',
          ),
          BtnPrimary(
            onTap: demoDetailNotifier.uploadRecording,
            isLoading: demoDetail.isUploading,
            isLocked: walletAddress == null ||
                submission?.status == 'completed' ||
                (submission != null && submission.status != 'failed'),
            buttonText: submission?.status == 'completed'
                ? '✓ Uploaded'
                : submission?.status == 'failed'
                    ? 'Failed'
                    : submission != null
                        ? 'Processing...'
                        : 'Upload',
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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

    if (demoDetail.recording == null) {
      return const Center(child: Text('Recording not found'));
    }
    final submission =
        ref.watch(demoDetailNotifierProvider).recording?.submission;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth > Breakpoints.desktop) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 9,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                () => _editorFullscreen = true,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          Expanded(
                                            flex: 4,
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  const DemoDetailSubmissionResult(),
                                                  const SizedBox(height: 20),
                                                  if (submission != null) ...[
                                                    const DemoDetailSteps(),
                                                    const SizedBox(height: 20),
                                                  ],
                                                  if (submission != null) ...[
                                                    const DemoDetailRewards(),
                                                    const SizedBox(height: 20),
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
                                onExpand: () =>
                                    setState(() => _editorFullscreen = true),
                              ),
                              const SizedBox(height: 20),
                              const DemoDetailSteps(),
                              const SizedBox(height: 20),
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
                  _buildFooter(context, ref),
                ],
              ),
            ),
            _buildFullscreenOverlay(constraints),
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
            const SizedBox(
              height: 400,
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
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 3,
                        child: CardWidget(
                          child: DefaultTabController(
                            length: 2,
                            child: Column(
                              children: [
                                TabBar(
                                  labelColor: ClonesColors.secondary,
                                  unselectedLabelColor:
                                      ClonesColors.secondaryText,
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
}
