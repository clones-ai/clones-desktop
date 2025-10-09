import 'package:clones_desktop/domain/models/submission/claim_authorization.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

@freezed
class ClaimRewardModalState with _$ClaimRewardModalState {
  const factory ClaimRewardModalState({
    @Default(false) bool isShown,
    @Default(false) bool isClaiming,
    ClaimAuthorization? claimAuthorization,
    @Default(0.0) double rewardAmount,
    String? tokenSymbol,
    String? submissionId,
    String? error,
    String? estimatedGasCost,
    @Default(false) bool gasExceedsReward,
  }) = _ClaimRewardModalState;
}
