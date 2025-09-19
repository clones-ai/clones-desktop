import 'package:clones_desktop/domain/models/submission/claim_authorization.dart';
import 'package:clones_desktop/domain/models/submission/grade_result.dart';
import 'package:clones_desktop/domain/models/submission/submission_file.dart';
import 'package:clones_desktop/domain/models/submission/submission_meta.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pool_submission.freezed.dart';
part 'pool_submission.g.dart';

@freezed
class PoolSubmission with _$PoolSubmission {
  const factory PoolSubmission({
    @JsonKey(name: '_id') required String id,
    required String address,
    required SubmissionMeta meta,
    required String status,
    required List<SubmissionFile> files,
    @JsonKey(name: 'grade_result') GradeResult? gradeResult,
    double? reward,
    double? maxReward,
    double? clampedScore,
    ClaimAuthorization? claimAuthorization,
    required String createdAt,
    required String updatedAt,
  }) = _PoolSubmission;

  factory PoolSubmission.fromJson(Map<String, dynamic> json) =>
      _$PoolSubmissionFromJson(json);
}
