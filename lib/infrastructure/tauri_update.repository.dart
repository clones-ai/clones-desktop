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
      DateTime? uploadDate;
      try {
        final dateStr = updateData['date'] as String?;
        if (dateStr != null) {
          // Handle Tauri's date format: "2025-10-09 15:43:16.0 +00:00:00"
          // Convert to ISO format for DateTime.parse()
          final cleanDate = dateStr
              .replaceFirst(' ', 'T')           // Replace space with T
              .replaceFirst('.0 ', '.000')      // Fix milliseconds
              .replaceFirst('+00:00:00', 'Z');  // Convert timezone
          uploadDate = DateTime.parse(cleanDate);
        }
      } catch (e) {
        // Fallback to current time if date parsing fails
        uploadDate = DateTime.now();
      }
      
      return UpdateInfo(
        version: updateData['version'] as String,
        currentVersion: currentVersion,
        uploadDate: uploadDate ?? DateTime.now(),
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
