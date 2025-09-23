import 'dart:ui';

import 'package:clones_desktop/application/onboarding_provider.dart';
import 'package:clones_desktop/application/permissions.dart';
import 'package:clones_desktop/application/permissions_modal_provider.dart';
import 'package:clones_desktop/application/tauri_api.dart';
import 'package:clones_desktop/domain/models/permissions.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class PermissionsModal extends ConsumerStatefulWidget {
  const PermissionsModal({super.key});

  @override
  ConsumerState<PermissionsModal> createState() => _PermissionsModalState();
}

class _PermissionsModalState extends ConsumerState<PermissionsModal> {
  bool _isMacOS = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _checkPlatformAndPermissions();
  }

  Future<void> _checkPlatformAndPermissions() async {
    try {
      final platform = await ref.read(tauriApiClientProvider).getPlatform();
      _isMacOS = platform == 'macos';

      if (!_isMacOS) {
        // Skip permissions modal on non-macOS
        if (mounted) {
          ref.read(permissionsModalProvider.notifier).hide();
          ref.read(onboardingProvider.notifier).onPermissionsCompleted();
        }
        return;
      }

      // Check current permissions
      await ref.read(permissionsNotifierProvider.notifier).checkPermissions();

      // If permissions are already granted, auto-close modal
      final permissionsState = ref.read(permissionsNotifierProvider);
      if (permissionsState.allPermissionsGranted) {
        if (mounted) {
          ref.read(permissionsModalProvider.notifier).hide();
          ref.read(onboardingProvider.notifier).onPermissionsCompleted();
        }
        return;
      }

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      debugPrint('Error checking platform: $e');
    }
  }

  Future<void> _openSystemPreferences(String type) async {
    try {
      String url;
      if (type == 'accessibility') {
        url =
            'x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility';
      } else {
        url =
            'x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture';
      }

      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      }
    } catch (e) {
      debugPrint('Error opening system preferences: $e');
    }
  }

  Future<void> _restartApp() async {
    try {
      if (mounted) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Restart Required'),
            content: const Text(
              'Please restart the application for the permission changes to take effect.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  SystemNavigator.pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      debugPrint('Error restarting app: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final permissionsState = ref.watch(permissionsNotifierProvider);
    final mediaQuery = MediaQuery.of(context);

    if (!_isInitialized || !_isMacOS) {
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
                width: mediaQuery.size.width * 0.6,
                height: mediaQuery.size.height * 0.8,
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
        ],
      );
    }

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
              width: mediaQuery.size.width * 0.7,
              height: mediaQuery.size.height * 0.85,
              child: Column(
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Almost Done!',
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'To use all features of Clones Desktop, we need the following permissions:',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Permissions Cards
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Accessibility Permission
                          _buildPermissionCard(
                            title: '1. Accessibility Permission',
                            description:
                                "This allows Clones to understand what's on your screen and provide relevant assistance.",
                            status: permissionsState.accessibilityStatus,
                            onRequest: () => ref
                                .read(permissionsNotifierProvider.notifier)
                                .requestAccessibilityPermission(),
                            onOpenSettings: () =>
                                _openSystemPreferences('accessibility'),
                            theme: theme,
                          ),

                          const SizedBox(height: 16),

                          // Screen Recording Permission
                          _buildPermissionCard(
                            title: '2. Screen Recording Permission',
                            description:
                                'This allows Clones to record your screen for training and assistance purposes.',
                            status: permissionsState.screenRecordingStatus,
                            onRequest: () => ref
                                .read(permissionsNotifierProvider.notifier)
                                .requestScreenRecordingPermission(),
                            onOpenSettings: () =>
                                _openSystemPreferences('screen'),
                            theme: theme,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          ref.read(permissionsModalProvider.notifier).hide();
                          ref
                              .read(onboardingProvider.notifier)
                              .onPermissionsCompleted();
                        },
                        child: const Text('Skip for now'),
                      ),
                      SizedBox(
                        width: 250,
                        child: BtnPrimary(
                          buttonText: _getButtonText(permissionsState),
                          widthExpanded: true,
                          isLocked: !_canContinue(permissionsState),
                          onTap: _canContinue(permissionsState)
                              ? () {
                                  if (permissionsState.anyRestartRequired) {
                                    _restartApp();
                                  } else {
                                    ref
                                        .read(permissionsModalProvider.notifier)
                                        .hide();
                                    ref
                                        .read(onboardingProvider.notifier)
                                        .onPermissionsCompleted();
                                  }
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getButtonText(PermissionsData state) {
    if (state.anyRestartRequired) {
      return 'Restart Application';
    } else if (state.allPermissionsGranted) {
      return 'Continue';
    } else {
      return 'Please Grant All Permissions';
    }
  }

  bool _canContinue(PermissionsData state) {
    return state.allPermissionsGranted || state.anyRestartRequired;
  }

  Widget _buildPermissionCard({
    required String title,
    required String description,
    required PermissionStatus status,
    required VoidCallback onRequest,
    required VoidCallback onOpenSettings,
    required ThemeData theme,
  }) {
    return CardWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              _buildStatusBadge(status),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),

          // Instructions based on status
          _buildInstructions(status, theme),

          const SizedBox(height: 16),

          // Action buttons
          _buildActionButtons(status, onRequest, onOpenSettings),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(PermissionStatus status) {
    Color color;
    String text;
    IconData? icon;

    switch (status) {
      case PermissionStatus.granted:
        color = Colors.green;
        text = 'Granted';
        icon = Icons.check_circle;
        break;
      case PermissionStatus.denied:
        color = Colors.red;
        text = 'Denied';
        icon = Icons.cancel;
        break;
      case PermissionStatus.pending:
        color = Colors.orange;
        text = 'Pending';
        icon = Icons.pending;
        break;
      case PermissionStatus.restartRequired:
        color = Colors.blue;
        text = 'Restart Required';
        icon = Icons.restart_alt;
        break;
      case PermissionStatus.unknown:
        color = Colors.grey;
        text = 'Unknown';
        icon = Icons.help;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructions(PermissionStatus status, ThemeData theme) {
    String instructions;
    Color backgroundColor;

    switch (status) {
      case PermissionStatus.denied:
        instructions =
            '💡 Click "Grant Permission" below and a system dialog will appear. Please click "Allow" to enable this feature.';
        backgroundColor = Colors.blue.withValues(alpha: 0.1);
        break;
      case PermissionStatus.pending:
        instructions = '⏳ Waiting for your response in the system dialog...';
        backgroundColor = Colors.orange.withValues(alpha: 0.1);
        break;
      case PermissionStatus.restartRequired:
        instructions =
            '✅ Permission granted! Please restart the app for changes to take effect.';
        backgroundColor = Colors.green.withValues(alpha: 0.1);
        break;
      case PermissionStatus.granted:
        instructions =
            '✅ This permission is already granted and working properly.';
        backgroundColor = Colors.green.withValues(alpha: 0.1);
        break;
      default:
        return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
      ),
      child: Text(
        instructions,
        style: theme.textTheme.bodySmall?.copyWith(
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildActionButtons(
    PermissionStatus status,
    VoidCallback onRequest,
    VoidCallback onOpenSettings,
  ) {
    switch (status) {
      case PermissionStatus.denied:
        return Row(
          children: [
            Expanded(
              child: BtnPrimary(
                buttonText: 'Grant Permission',
                onTap: onRequest,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: BtnPrimary(
                buttonText: 'Open Settings',
                btnPrimaryType: BtnPrimaryType.outlinePrimary,
                onTap: onOpenSettings,
              ),
            ),
          ],
        );
      case PermissionStatus.pending:
        return const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 8),
            Text('Waiting for system response...'),
          ],
        );
      case PermissionStatus.restartRequired:
      case PermissionStatus.granted:
        return const SizedBox.shrink();
      default:
        return BtnPrimary(
          buttonText: 'Check Permission',
          onTap: onRequest,
        );
    }
  }
}
