import 'package:clones_desktop/application/tauri_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'version_provider.g.dart';

@riverpod
Future<String> appVersion(Ref ref) async {
  final apiClient = ref.watch(tauriApiClientProvider);
  return apiClient.getAppVersion();
}
