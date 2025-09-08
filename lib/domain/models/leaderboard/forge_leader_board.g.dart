// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forge_leader_board.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ForgeLeaderboardImpl _$$ForgeLeaderboardImplFromJson(
        Map<String, dynamic> json) =>
    _$ForgeLeaderboardImpl(
      rank: (json['rank'] as num).toInt(),
      name: json['name'] as String,
      tasks: (json['tasks'] as num).toInt(),
      payout: (json['payout'] as num).toDouble(),
      token: json['token'] == null
          ? null
          : FactoryToken.fromJson(json['token'] as Map<String, dynamic>),
      payoutUSD: (json['payoutUSD'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$ForgeLeaderboardImplToJson(
        _$ForgeLeaderboardImpl instance) =>
    <String, dynamic>{
      'rank': instance.rank,
      'name': instance.name,
      'tasks': instance.tasks,
      'payout': instance.payout,
      'token': instance.token,
      'payoutUSD': instance.payoutUSD,
    };
