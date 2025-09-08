// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_leader_board.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LeaderboardStatsImpl _$$LeaderboardStatsImplFromJson(
        Map<String, dynamic> json) =>
    _$LeaderboardStatsImpl(
      totalWorkers: (json['totalWorkers'] as num).toInt(),
      tasksCompleted: (json['tasksCompleted'] as num).toInt(),
      totalRewards: (json['totalRewards'] as num).toDouble(),
      activeForges: (json['activeForges'] as num).toInt(),
      totalUSDPayout: (json['totalUSDPayout'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$LeaderboardStatsImplToJson(
        _$LeaderboardStatsImpl instance) =>
    <String, dynamic>{
      'totalWorkers': instance.totalWorkers,
      'tasksCompleted': instance.tasksCompleted,
      'totalRewards': instance.totalRewards,
      'activeForges': instance.activeForges,
      'totalUSDPayout': instance.totalUSDPayout,
    };
