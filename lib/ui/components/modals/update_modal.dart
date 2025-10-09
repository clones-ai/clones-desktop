import 'dart:ui';

import 'package:clones_desktop/application/update_modal_provider.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:clones_desktop/utils/format_file_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateModal extends ConsumerWidget {
  const UpdateModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updateState = ref.watch(updateModalProvider);
    final updateNotifier = ref.read(updateModalProvider.notifier);
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

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
              width: mediaQuery.size.width * 0.5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(theme, updateState),
                  const SizedBox(height: 24),
                  _buildContent(context, theme, updateState),
                  const SizedBox(height: 24),
                  _buildActions(updateState, updateNotifier),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(ThemeData theme, UpdateModalState state) {
    IconData icon;
    Color iconColor;
    String title;

    switch (state.status) {
      case UpdateStatus.checking:
        icon = Icons.search;
        iconColor = Colors.blue;
        title = 'Checking for Updates';
        break;
      case UpdateStatus.available:
        icon = Icons.system_update;
        iconColor = Colors.green;
        title = 'New Update Available!';
        break;
      case UpdateStatus.downloading:
        icon = Icons.download;
        iconColor = Colors.blue;
        title = 'Downloading Update';
        break;
      case UpdateStatus.installing:
        icon = Icons.install_desktop;
        iconColor = Colors.orange;
        title = 'Installing Update';
        break;
      case UpdateStatus.completed:
        icon = Icons.check_circle;
        iconColor = Colors.green;
        title = 'Update Completed';
        break;
      case UpdateStatus.error:
        icon = Icons.error;
        iconColor = Colors.red;
        title = 'Update Failed';
        break;
      case UpdateStatus.idle:
        icon = Icons.system_update;
        iconColor = Colors.grey;
        title = 'Update';
    }

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(
    BuildContext context,
    ThemeData theme,
    UpdateModalState state,
  ) {
    switch (state.status) {
      case UpdateStatus.checking:
        return const Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Checking for available updates...'),
          ],
        );

      case UpdateStatus.available:
        return _buildAvailableContent(theme, state);

      case UpdateStatus.downloading:
        return _buildDownloadingContent(theme, state);

      case UpdateStatus.installing:
        return const Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Installing update... Please wait.'),
            SizedBox(height: 8),
            Text(
              'The installer will open automatically when ready.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        );

      case UpdateStatus.completed:
        return Column(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 48),
            const SizedBox(height: 16),
            Text(
              'Update downloaded and installer opened!',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Please follow the installer instructions to complete the update.',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        );

      case UpdateStatus.error:
        return Column(
          children: [
            const Icon(Icons.error, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text('Failed to update', style: theme.textTheme.bodyMedium),
            if (state.error != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  state.error!,
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.red),
                ),
              ),
            ],
          ],
        );

      case UpdateStatus.idle:
        return const SizedBox.shrink();
    }
  }

  Widget _buildAvailableContent(ThemeData theme, UpdateModalState state) {
    final updateInfo = state.updateInfo;
    if (updateInfo == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Version ${updateInfo.version} is now available.',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'You are currently running version ${updateInfo.currentVersion}.',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: ClonesColors.tertiary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.security,
                size: 20,
                color: ClonesColors.containerIcon5,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Secure Update via Tauri',
                      style: theme.textTheme.bodyMedium,
                    ),
                    Text(
                      'Cryptographically signed and verified',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDownloadingContent(ThemeData theme, UpdateModalState state) {
    final progress =
        (state.downloadProgress / state.totalBytes).clamp(0.0, 1.0);

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: ClonesColors.tertiary.withValues(alpha: 0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(
              ClonesColors.containerIcon5,
            ),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${(progress * 100).toStringAsFixed(1)}%',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${formatFileSize(state.downloadProgress)} / ${formatFileSize(state.totalBytes)}',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Downloading update...',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildActions(UpdateModalState state, UpdateModalNotifier notifier) {
    switch (state.status) {
      case UpdateStatus.available:
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            BtnPrimary(
              buttonText: 'Later',
              onTap: () => notifier.hide(),
              btnPrimaryType: BtnPrimaryType.outlinePrimary,
            ),
            const SizedBox(width: 10),
            BtnPrimary(
              buttonText: 'Update Now',
              onTap: () => notifier.downloadAndInstallUpdate(),
              widthExpanded: true,
            ),
          ],
        );

      case UpdateStatus.completed:
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 100,
              child: BtnPrimary(
                buttonText: 'Close',
                btnPrimaryType: BtnPrimaryType.outlinePrimary,
                onTap: () => notifier.hide(),
                widthExpanded: true,
              ),
            ),
          ],
        );

      case UpdateStatus.error:
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 100,
              child: BtnPrimary(
                buttonText: 'Close',
                onTap: () => notifier.hide(),
                btnPrimaryType: BtnPrimaryType.outlinePrimary,
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 120,
              child: BtnPrimary(
                buttonText: 'Retry',
                onTap: () => notifier.downloadAndInstallUpdate(),
                widthExpanded: true,
              ),
            ),
          ],
        );

      case UpdateStatus.downloading:
      case UpdateStatus.installing:
        return const SizedBox.shrink();

      case UpdateStatus.checking:
      case UpdateStatus.idle:
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 100,
              child: BtnPrimary(
                buttonText: 'Close',
                onTap: () => notifier.hide(),
                widthExpanded: true,
              ),
            ),
          ],
        );
    }
  }
}
