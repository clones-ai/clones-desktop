import 'dart:typed_data';

import 'package:clones_desktop/application/tauri_api.dart';
import 'package:clones_desktop/domain/models/upload/upload_metadata.dart';
import 'package:clones_desktop/domain/models/upload/upload_progress.dart';
import 'package:clones_desktop/infrastructure/upload.repository.dart';
import 'package:clones_desktop/utils/api_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'upload.g.dart';

@riverpod
UploadRepositoryImpl uploadRepository(Ref ref) {
  return UploadRepositoryImpl(ref.watch(apiClientProvider));
}

@riverpod
Future<bool> isUploadDataAllowed(Ref ref) async {
  final apiClient = ref.watch(tauriApiClientProvider);
  return apiClient.getUploadDataAllowed();
}

@riverpod
Future<Uint8List> getRecordingZip(
  Ref ref,
  String recordingId,
) async {
  final apiClient = ref.watch(tauriApiClientProvider);
  return apiClient.getRecordingZip(recordingId);
}


@riverpod
Future<Map<String, dynamic>> initUpload(
  Ref ref,
  UploadMetadata metadata,
  int totalChunks,
) async {
  final uploadRepository = ref.watch(uploadRepositoryProvider);
  return uploadRepository.initUpload(
    metadata: metadata,
    totalChunks: totalChunks,
  );
}

@riverpod
Future<UploadProgress> uploadChunk(
  Ref ref, {
  required String uploadId,
  required Uint8List chunk,
  required int chunkIndex,
}) async {
  final uploadRepository = ref.watch(uploadRepositoryProvider);
  return uploadRepository.uploadChunk(
    uploadId: uploadId,
    chunk: chunk,
    chunkIndex: chunkIndex,
  );
}

@riverpod
Future<Map<String, dynamic>> getUploadStatus(
  Ref ref,
  String uploadId,
) async {
  final uploadRepository = ref.watch(uploadRepositoryProvider);
  return uploadRepository.getUploadStatus(uploadId);
}

@riverpod
Future<Map<String, dynamic>> completeUpload(
  Ref ref,
  String uploadId,
) async {
  final uploadRepository = ref.watch(uploadRepositoryProvider);
  return uploadRepository.completeUpload(uploadId);
}

@riverpod
Future<Map<String, dynamic>> cancelUpload(
  Ref ref,
  String uploadId,
) async {
  final uploadRepository = ref.watch(uploadRepositoryProvider);
  return uploadRepository.cancelUpload(uploadId);
}
