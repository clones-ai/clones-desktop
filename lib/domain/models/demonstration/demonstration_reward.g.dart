// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'demonstration_reward.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DemonstrationRewardImpl _$$DemonstrationRewardImplFromJson(
        Map<String, dynamic> json) =>
    _$DemonstrationRewardImpl(
      time: (json['time'] as num).toInt(),
      maxReward: (json['max_reward'] as num).toDouble(),
      token: json['token'] == null
          ? null
          : FactoryToken.fromJson(json['token'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$DemonstrationRewardImplToJson(
        _$DemonstrationRewardImpl instance) =>
    <String, dynamic>{
      'time': instance.time,
      'max_reward': instance.maxReward,
      'token': instance.token,
    };
