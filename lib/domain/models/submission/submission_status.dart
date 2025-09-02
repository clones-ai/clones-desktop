// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:clones_desktop/domain/models/submission/claim_authorization.dart';
import 'package:clones_desktop/domain/models/submission/grade_result.dart';
import 'package:clones_desktop/domain/models/submission/submission_file.dart';
import 'package:clones_desktop/domain/models/submission/submission_meta.dart';

part 'submission_status.freezed.dart';
part 'submission_status.g.dart';

@freezed
class SubmissionStatus with _$SubmissionStatus {
  const factory SubmissionStatus({
    @JsonKey(name: '_id') String? id,
    String? address,
    required SubmissionMeta meta,
    required String status,
    required List<SubmissionFile> files,
    String? error,
    required String createdAt,
    required String updatedAt,
    int? clampedScore,
    @JsonKey(name: 'grade_result') GradeResult? gradeResult,
    double? maxReward,
    double? reward,
    ClaimAuthorization? claimAuthorization,
  }) = _SubmissionStatus;

  factory SubmissionStatus.fromJson(Map<String, dynamic> json) =>
      _$SubmissionStatusFromJson(json);
}
