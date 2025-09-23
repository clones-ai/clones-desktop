import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

enum OnboardingStep {
  privacy,
  completed,
}

@freezed
class OnboardingDataState with _$OnboardingDataState {
  const factory OnboardingDataState({
    required bool privacyAccepted,
    required OnboardingStep currentStep,
  }) = _OnboardingDataState;
  const OnboardingDataState._();
}
