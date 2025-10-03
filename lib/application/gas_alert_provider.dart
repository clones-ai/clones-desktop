import 'package:clones_desktop/domain/models/factory/gas.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// State for gas alerts
class GasAlertState {
  const GasAlertState({
    this.currentAlert,
    this.isVisible = false,
    this.gasPriceAdvice,
  });

  final GasAnalysis? currentAlert;
  final bool isVisible;
  final GasPriceAdvice? gasPriceAdvice;

  GasAlertState copyWith({
    GasAnalysis? currentAlert,
    bool? isVisible,
    GasPriceAdvice? gasPriceAdvice,
  }) {
    return GasAlertState(
      currentAlert: currentAlert,
      isVisible: isVisible ?? (currentAlert != null),
      gasPriceAdvice: gasPriceAdvice,
    );
  }
}

// Provider for gas alert state
final gasAlertProvider =
    StateNotifierProvider<GasAlertNotifier, GasAlertState>((ref) {
  return GasAlertNotifier();
});

class GasAlertNotifier extends StateNotifier<GasAlertState> {
  GasAlertNotifier() : super(const GasAlertState());

  // Display gas alert
  void showGasAlert(GasAnalysis gasAnalysis) {
    state = state.copyWith(
      currentAlert: gasAnalysis,
      isVisible: true,
    );
  }

  // Hide current alert
  void hideAlert() {
    state = state.copyWith(
      isVisible: false,
    );
  }
}
