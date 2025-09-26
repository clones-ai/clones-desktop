import 'package:clones_desktop/domain/models/update_info.dart';
import 'package:clones_desktop/infrastructure/tauri_api_client.dart';

class TauriUpdateRepositoryImpl {
  TauriUpdateRepositoryImpl(this._tauriClient);

  final TauriApiClient _tauriClient;

  Future<UpdateInfo?> checkForUpdate() async {
    try {
      final currentVersion = await _tauriClient.getAppVersion();
      final updateData = await _tauriClient.checkForUpdate();
      if (updateData == null) return null;

      // Convert Tauri update format to our UpdateInfo
      return UpdateInfo(
        version: updateData['version'] as String,
        currentVersion: currentVersion,
        uploadDate: DateTime.parse(updateData['date'] as String),
        files: {}, // Tauri handles file selection internally
      );
    } catch (e) {
      throw Exception('Failed to check for updates: $e');
    }
  }

  Future<void> downloadAndInstallUpdate() async {
    try {
      // Tauri updater handles download, signature verification, and installation
      await _tauriClient.installUpdate();
    } catch (e) {
      throw Exception('Failed to install update: $e');
    }
  }
}
