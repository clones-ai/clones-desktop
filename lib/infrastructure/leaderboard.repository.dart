import 'package:clones_desktop/domain/models/api/request_options.dart';
import 'package:clones_desktop/domain/models/factory/factory_token.dart';
import 'package:clones_desktop/domain/models/leaderboard/forge_leader_board.dart';
import 'package:clones_desktop/domain/models/leaderboard/stats_leader_board.dart';
import 'package:clones_desktop/domain/models/leaderboard/worker_leader_board.dart';
import 'package:clones_desktop/utils/api_client.dart';

class LeaderboardRepositoryImpl {
  LeaderboardRepositoryImpl(this._client);
  final ApiClient _client;

  Future<Map<String, dynamic>> getLeaderboardData() async {
    try {
      final data = await _client.get<Map<String, dynamic>>(
        '/demonstration/leaderboards',
        options: const RequestOptions(requiresAuth: true),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return {
        'workersLeaderboard': (data['workersLeaderboard'] as List)
            .map(
              (worker) => WorkerLeaderboard(
                rank: worker['rank'],
                address: worker['address'],
                tasks: worker['tasks'],
                rewards: worker['rewards'].toDouble(),
                avgScore: worker['avgScore'].toDouble(),
                tokens: (worker['tokens'] as List<dynamic>? ?? [])
                    .map((tokenData) => WorkerTokenReward(
                          token: FactoryToken.fromJson(tokenData),
                          totalReward: (tokenData['totalReward'] ?? 0).toDouble(),
                        ))
                    .toList(),
                totalUSD: (worker['totalUSD'] ?? 0).toDouble(),
              ),
            )
            .toList(),
        'forgeLeaderboard': (data['forgeLeaderboard'] as List)
            .map(
              (forge) => ForgeLeaderboard(
                rank: forge['rank'],
                name: forge['name'],
                tasks: forge['tasks'],
                payout: forge['payout'].toDouble(),
                token: forge['token'] != null 
                    ? FactoryToken.fromJson(forge['token'])
                    : null,
                payoutUSD: (forge['payoutUSD'] ?? 0).toDouble(),
              ),
            )
            .toList(),
        'stats': LeaderboardStats(
          totalWorkers: data['stats']['totalWorkers'],
          tasksCompleted: data['stats']['tasksCompleted'],
          totalRewards: data['stats']['totalRewards'].toDouble(),
          activeForges: data['stats']['activeForges'],
          totalUSDPayout: (data['stats']['totalUSDPayout'] ?? 0).toDouble(),
        ),
      };
    } catch (e) {
      throw Exception('Failed to load leaderboard data: $e');
    }
  }
}
