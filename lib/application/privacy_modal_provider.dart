import 'package:flutter_riverpod/flutter_riverpod.dart';

final privacyModalProvider =
    StateNotifierProvider<PrivacyModalNotifier, bool>((ref) {
  return PrivacyModalNotifier();
});

class PrivacyModalNotifier extends StateNotifier<bool> {
  PrivacyModalNotifier() : super(false);

  void show() {
    state = true;
  }

  void hide() {
    state = false;
  }
}
