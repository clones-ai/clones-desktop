import 'package:clones_desktop/application/tauri_api.dart';
import 'package:clones_desktop/domain/models/update_info.dart';
import 'package:clones_desktop/infrastructure/tauri_update.repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_modal_provider.freezed.dart';

@freezed
class UpdateModalState with _$UpdateModalState {
  const factory UpdateModalState({
    @Default(false) bool isVisible,
    UpdateInfo? updateInfo,
    @Default(UpdateStatus.idle) UpdateStatus status,
    @Default(0) int downloadProgress,
    @Default(0) int totalBytes,
    String? error,
    String? downloadedFilePath,
  }) = _UpdateModalState;
}

enum UpdateStatus {
  idle,
  checking,
  available,
  downloading,
  installing,
  completed,
  error,
}

final updateRepositoryProvider = Provider<TauriUpdateRepositoryImpl>((ref) {
  return TauriUpdateRepositoryImpl(ref.read(tauriApiClientProvider));
});

final updateModalProvider =
    StateNotifierProvider<UpdateModalNotifier, UpdateModalState>((ref) {
  return UpdateModalNotifier(ref.read(updateRepositoryProvider));
});

class UpdateModalNotifier extends StateNotifier<UpdateModalState> {
  UpdateModalNotifier(this._repository) : super(const UpdateModalState());

  final TauriUpdateRepositoryImpl _repository;

  void show() {
    state = state.copyWith(isVisible: true);
  }

  void hide() {
    state = state.copyWith(isVisible: false);
  }

  Future<void> checkForUpdate() async {
    state = state.copyWith(status: UpdateStatus.checking, error: null);

    try {
      final updateInfo = await _repository.checkForUpdate();
      if (updateInfo != null) {
        state = state.copyWith(
          status: UpdateStatus.available,
          updateInfo: updateInfo,
          isVisible: true,
        );
      } else {
        state = state.copyWith(status: UpdateStatus.idle);
      }
    } catch (e) {
      state = state.copyWith(
        status: UpdateStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> downloadAndInstallUpdate() async {
    final updateInfo = state.updateInfo;
    if (updateInfo == null) return;

    // Tauri updater handles everything securely
    state = state.copyWith(status: UpdateStatus.downloading);

    try {
      await _repository.downloadAndInstallUpdate();
      state = state.copyWith(status: UpdateStatus.completed);
    } catch (e) {
      state = state.copyWith(
        status: UpdateStatus.error,
        error: e.toString(),
      );
    }
  }
}
