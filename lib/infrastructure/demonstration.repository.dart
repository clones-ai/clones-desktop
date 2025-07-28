import 'package:clones_desktop/domain/models/demonstration/demonstration.dart';
import 'package:clones_desktop/domain/models/demonstration/demonstration_reward.dart';
import 'package:clones_desktop/infrastructure/pool.repository.dart';
import 'package:clones_desktop/infrastructure/tauri_api_client.dart';
import 'package:clones_desktop/utils/api_client.dart';

class DemonstrationRepositoryImpl {
  DemonstrationRepositoryImpl(this._client, this._tauriClient);
  final ApiClient _client;
  final TauriApiClient _tauriClient;
  // TODO(reddwarf03): Not used ?
  Future<Demonstration> generateDemonstration({
    required String prompt,
    required String address,
    String? poolId,
    String? taskId,
  }) async {
    final apps = await _tauriClient.listApps();
    final appList = apps.map((app) => app.name).join('\n');

    final demonstration = await _client.post<Demonstration>(
      '/gym/quest',
      data: {
        'installed_applications': appList,
        'address': address,
        'prompt': prompt,
      },
      fromJson: (json) => Demonstration.fromJson(json as Map<String, dynamic>),
    );

    if (poolId != null) {
      final rewardInfo = await PoolsRepositoryImpl(_client).getReward(
        poolId: poolId,
        taskId: taskId,
      );
      return demonstration.copyWith(
        poolId: poolId,
        reward: DemonstrationReward(
          time: rewardInfo.time,
          maxReward: rewardInfo.maxReward,
        ),
        taskId: taskId,
      );
    }

    return demonstration;
  }

  // TODO(reddwarf03): Not used ?
  Future<Map<String, dynamic>> checkDemonstrationProgress(
    Demonstration demonstration,
  ) async {
    final screenshot = await _tauriClient.takeScreenshot();

    return _client.post<Map<String, dynamic>>(
      '/gym/progress',
      data: {
        'quest': demonstration.toJson(),
        'screenshots': [screenshot],
      },
    );
  }
}
