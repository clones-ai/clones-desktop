import 'package:clones_desktop/ui/views/forge/bloc/state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@riverpod
class ForgeNotifier extends _$ForgeNotifier {
  ForgeNotifier();

  @override
  ForgeState build() {
    return const ForgeState();
  }

  void setShowGenerateFactoryModal(bool show) {
    state = state.copyWith(showGenerateFactoryModal: show);
  }
}
