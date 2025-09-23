import 'package:flutter_riverpod/flutter_riverpod.dart';

final permissionsModalProvider =
    StateNotifierProvider<PermissionsModalNotifier, bool>((ref) {
  return PermissionsModalNotifier();
});

class PermissionsModalNotifier extends StateNotifier<bool> {
  PermissionsModalNotifier() : super(false);

  void show() {
    state = true;
  }

  void hide() {
    state = false;
  }
}
