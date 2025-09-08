import 'package:clones_desktop/domain/models/factory/factory_token.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'demonstration_reward.freezed.dart';
part 'demonstration_reward.g.dart';

@freezed
class DemonstrationReward with _$DemonstrationReward {
  const factory DemonstrationReward({
    required int time,
    @JsonKey(name: 'max_reward') required double maxReward,
    FactoryToken? token,
  }) = _DemonstrationReward;

  factory DemonstrationReward.fromJson(Map<String, dynamic> json) =>
      _$DemonstrationRewardFromJson(json);
}
