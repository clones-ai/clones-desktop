import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/views/demo_detail/bloc/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DemoDetailVideoPreview extends ConsumerStatefulWidget {
  const DemoDetailVideoPreview({super.key, this.onExpand, this.videoWidget});
  final VoidCallback? onExpand;
  final Widget? videoWidget;

  @override
  ConsumerState<DemoDetailVideoPreview> createState() =>
      _DemoDetailVideoPreviewState();
}

class _DemoDetailVideoPreviewState
    extends ConsumerState<DemoDetailVideoPreview> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(demoDetailNotifierProvider);
    final videoSource = state.videoSource;

    final videoLoaded = videoSource != null;

    final theme = Theme.of(context);

    // Avoid modifying providers during build: defer initialization
    if (videoLoaded &&
        state.clipSegments.isEmpty &&
        state.videoController != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref
              .read(demoDetailNotifierProvider.notifier)
              .initializeClipsFromDuration();
        }
      });
    }

    return CardWidget(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Video Preview',
                  style: theme.textTheme.titleMedium,
                ),
                if (widget.onExpand != null)
                  IconButton(
                    icon: const Icon(
                      Icons.fullscreen,
                      color: ClonesColors.secondary,
                    ),
                    onPressed: widget.onExpand,
                    tooltip: 'Fullscreen',
                  ),
              ],
            ),
            const SizedBox(height: 10),
            if (widget.videoWidget == null)
              Text('No video found', style: theme.textTheme.bodyMedium)
            else
              MouseRegion(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (state.isLoading)
                      const Center(
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            strokeWidth: 1,
                          ),
                        ),
                      )
                    else
                      widget.videoWidget!,
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
