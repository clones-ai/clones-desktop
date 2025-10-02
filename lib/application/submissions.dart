import 'package:clones_desktop/domain/models/submission/pool_submission.dart';
import 'package:clones_desktop/domain/models/submission/submission_status.dart';
import 'package:clones_desktop/infrastructure/submissions.repository.dart';
import 'package:clones_desktop/utils/api_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'submissions.g.dart';

@riverpod
SubmissionsRepositoryImpl submissionsRepository(
  Ref ref,
) {
  final apiClient = ref.watch(apiClientProvider);
  return SubmissionsRepositoryImpl(apiClient);
}

@riverpod
Future<SubmissionStatus> getSubmissionStatus(
  Ref ref, {
  required String submissionId,
}) async {
  final submissionsRepository = ref.watch(submissionsRepositoryProvider);
  return submissionsRepository.getSubmissionStatus(submissionId: submissionId);
}

@riverpod
Future<List<SubmissionStatus>> listSubmissions(
  Ref ref,
) async {
  final submissionsRepository = ref.watch(submissionsRepositoryProvider);
  return submissionsRepository.listSubmissions();
}

@riverpod
Future<List<PoolSubmission>> getFactorySubmissions(
  Ref ref,
  String factoryAddress,
) async {
  final submissionsRepository = ref.watch(submissionsRepositoryProvider);
  return submissionsRepository.getFactorySubmissions(
    factoryAddress: factoryAddress,
  );
}

@riverpod
Future<String> getDemoFile(
  Ref ref, {
  required String submissionId,
  required String filename,
}) async {
  final submissionsRepository = ref.watch(submissionsRepositoryProvider);
  return submissionsRepository.getDemoFile(
    submissionId: submissionId,
    filename: filename,
  );
}

@riverpod
Future<String> getDemoFileAsBase64(
  Ref ref, {
  required String submissionId,
  required String filename,
}) async {
  final submissionsRepository = ref.watch(submissionsRepositoryProvider);
  return submissionsRepository.getDemoFileAsBase64(
    submissionId: submissionId,
    filename: filename,
  );
}
