import 'package:freezed_annotation/freezed_annotation.dart';

part 'on_chain_reward.freezed.dart';
part 'on_chain_reward.g.dart';

@freezed
class OnChainReward with _$OnChainReward {
  const factory OnChainReward({
    required String tokenAddress,
    required String poolAddress,
    required double amount,
    double? grossAmount,
    double? feeAmount,
    double? netAmount,
    String? submissionId,
    String? txHash,
    int? timestamp,
    double? cumulativeAmount,
  }) = _OnChainReward;

  factory OnChainReward.fromJson(Map<String, dynamic> json) =>
      _$OnChainRewardFromJson(json);
}
