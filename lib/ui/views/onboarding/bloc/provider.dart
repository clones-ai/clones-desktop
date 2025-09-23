import 'package:clones_desktop/application/privacy.dart';
import 'package:clones_desktop/ui/views/onboarding/bloc/state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@riverpod
class OnboardingNotifier extends _$OnboardingNotifier {
  @override
  OnboardingDataState build() {
    return const OnboardingDataState(
      privacyAccepted: false,
      currentStep: OnboardingStep.privacy,
    );
  }

  void acceptPrivacy() {
    state = state.copyWith(privacyAccepted: true);
    ref.read(acceptPrivacyProvider);
  }

  void rejectPrivacy() {
    state = state.copyWith(privacyAccepted: false);
    ref.read(rejectPrivacyProvider);
  }

  void nextStep() {
    switch (state.currentStep) {
      case OnboardingStep.privacy:
        if (state.privacyAccepted) {
          state = state.copyWith(currentStep: OnboardingStep.completed);
        }
        break;
      case OnboardingStep.completed:
        break;
    }
  }
}
