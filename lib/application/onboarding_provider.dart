import 'package:clones_desktop/application/permissions.dart';
import 'package:clones_desktop/application/permissions_modal_provider.dart';
import 'package:clones_desktop/application/privacy.dart';
import 'package:clones_desktop/application/privacy_modal_provider.dart';
import 'package:clones_desktop/application/tauri_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum OnboardingStep {
  privacy,
  permissions,
  completed,
}

class OnboardingState {
  const OnboardingState({
    required this.currentStep,
    required this.isInitialized,
  });

  final OnboardingStep currentStep;
  final bool isInitialized;

  OnboardingState copyWith({
    OnboardingStep? currentStep,
    bool? isInitialized,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier(ref);
});

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier(this._ref)
      : super(
          const OnboardingState(
            currentStep: OnboardingStep.privacy,
            isInitialized: false,
          ),
        ) {
    _initialize();
  }

  final Ref _ref;

  Future<void> _initialize() async {
    try {
      // Check if privacy has been accepted
      final privacyAccepted = await _ref.read(isPrivacyAcceptedProvider.future);

      if (!privacyAccepted) {
        // Show privacy modal and stay on privacy step
        _ref.read(privacyModalProvider.notifier).show();
        state = state.copyWith(
          currentStep: OnboardingStep.privacy,
          isInitialized: true,
        );
      } else {
        // Check permissions if we're on macOS
        await _checkPermissions();
      }
    } catch (e) {
      // On error, start from privacy
      _ref.read(privacyModalProvider.notifier).show();
      state = state.copyWith(
        currentStep: OnboardingStep.privacy,
        isInitialized: true,
      );
    }
  }

  Future<void> _checkPermissions() async {
    try {
      final platform = await _ref.read(tauriApiClientProvider).getPlatform();
      final isMacOS = platform == 'macos';

      if (!isMacOS) {
        // Skip permissions on non-macOS
        state = state.copyWith(
          currentStep: OnboardingStep.completed,
          isInitialized: true,
        );
        return;
      }

      // Check current permissions
      await _ref.read(permissionsNotifierProvider.notifier).checkPermissions();
      final permissionsState = _ref.read(permissionsNotifierProvider);

      if (!permissionsState.accessibilityGranted ||
          !permissionsState.screenRecordingGranted) {
        // Show permissions modal
        _ref.read(permissionsModalProvider.notifier).show();
        state = state.copyWith(
          currentStep: OnboardingStep.permissions,
          isInitialized: true,
        );
      } else {
        // All permissions granted, onboarding completed
        state = state.copyWith(
          currentStep: OnboardingStep.completed,
          isInitialized: true,
        );
      }
    } catch (e) {
      // On error, skip permissions
      state = state.copyWith(
        currentStep: OnboardingStep.completed,
        isInitialized: true,
      );
    }
  }

  Future<void> onPrivacyAccepted() async {
    // Privacy was accepted, move to permissions
    _ref.read(privacyModalProvider.notifier).hide();
    await _checkPermissions();
  }

  void onPermissionsCompleted() {
    // Permissions completed, finish onboarding
    _ref.read(permissionsModalProvider.notifier).hide();
    state = state.copyWith(currentStep: OnboardingStep.completed);
  }

  void reset() {
    state = const OnboardingState(
      currentStep: OnboardingStep.privacy,
      isInitialized: false,
    );
    _initialize();
  }
}
