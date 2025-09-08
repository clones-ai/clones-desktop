import 'package:freezed_annotation/freezed_annotation.dart';

part 'stats_leader_board.freezed.dart';
part 'stats_leader_board.g.dart';

@freezed
class LeaderboardStats with _$LeaderboardStats {
  const factory LeaderboardStats({
    required int totalWorkers,
    required int tasksCompleted,
    required double totalRewards,
    required int activeForges,
    @Default(0.0) double totalUSDPayout,
  }) = _LeaderboardStats;

  factory LeaderboardStats.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardStatsFromJson(json);
}
