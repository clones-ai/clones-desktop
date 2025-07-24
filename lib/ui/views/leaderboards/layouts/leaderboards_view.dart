import 'dart:ui';

import 'package:clones_desktop/application/leaderboard.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/domain/models/leaderboard/forge_leader_board.dart';
import 'package:clones_desktop/domain/models/leaderboard/stats_leader_board.dart';
import 'package:clones_desktop/domain/models/leaderboard/worker_leader_board.dart';
import 'package:clones_desktop/ui/views/leaderboards/layouts/components/leaderboards_stat_active_forges.dart';
import 'package:clones_desktop/ui/views/leaderboards/layouts/components/leaderboards_stat_total_demos.dart';
import 'package:clones_desktop/ui/views/leaderboards/layouts/components/leaderboards_stat_total_paid_out.dart';
import 'package:clones_desktop/ui/views/leaderboards/layouts/components/leaderboards_stat_total_tasks.dart';
import 'package:clones_desktop/ui/views/leaderboards/layouts/components/top_forges.dart';
import 'package:clones_desktop/ui/views/leaderboards/layouts/components/top_workers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LeaderboardsView extends ConsumerStatefulWidget {
  const LeaderboardsView({super.key});

  static const String routeName = '/leaderboards';

  @override
  ConsumerState<LeaderboardsView> createState() => _LeaderboardsViewState();
}

class _LeaderboardsViewState extends ConsumerState<LeaderboardsView> {
  bool _loading = true;
  String? _error;

  List<WorkerLeaderboard> _topWorkers = [];
  List<ForgeLeaderboard> _topForges = [];
  LeaderboardStats? _stats;

  _FullScreenView _fullscreenView = _FullScreenView.none;

  @override
  void initState() {
    super.initState();
    _loadLeaderboardData();
  }

  Future<void> _loadLeaderboardData() async {
    try {
      final data =
          await ref.read(leaderboardRepositoryProvider).getLeaderboardData();
      setState(() {
        _topWorkers = (data['workersLeaderboard'] as List<WorkerLeaderboard>)
          ..sort((a, b) => b.avgScore.compareTo(a.avgScore));

        _topForges = (data['forgeLeaderboard'] as List<ForgeLeaderboard>)
          ..sort((a, b) => b.payout.compareTo(a.payout));

        _stats = data['stats'] as LeaderboardStats;
        _loading = false;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = 'Failed to load leaderboard data. Please try again later.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Leaderboards',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.5,
                          color: ClonesColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (_loading)
                    const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 0.5,
                      ),
                    )
                  else if (_error != null)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.triangleExclamation,
                            color: Colors.red[400],
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _error!,
                            style: TextStyle(
                              color: Colors.red[400],
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: _loadLeaderboardData,
                            icon: const Icon(FontAwesomeIcons.rotate),
                            label: const Text('Retry'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TopForges(
                                forges: _topForges,
                                onExpand: () => setState(
                                  () =>
                                      _fullscreenView = _FullScreenView.forges,
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: TopWorkers(
                                workers: _topWorkers,
                                onExpand: () => setState(
                                  () =>
                                      _fullscreenView = _FullScreenView.workers,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildGlobalStats(),
                      ],
                    ),
                ],
              ),
            ),
            _buildFullscreenOverlay(constraints),
          ],
        );
      },
    );
  }

  Widget _buildFullscreenOverlay(BoxConstraints constraints) {
    final isVisible = _fullscreenView != _FullScreenView.none;
    final title = _fullscreenView == _FullScreenView.forges
        ? 'Top Forges'
        : 'Top Workers';
    final content = _fullscreenView == _FullScreenView.forges
        ? TopForges(
            forges: _topForges,
            showTitle: false,
            listHeight: constraints.maxHeight - 250,
          )
        : TopWorkers(
            workers: _topWorkers,
            showTitle: false,
            listHeight: constraints.maxHeight - 250,
          );

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
      top: 0,
      left: isVisible ? 0 : constraints.maxWidth,
      width: constraints.maxWidth,
      height: constraints.maxHeight,
      child: IgnorePointer(
        ignoring: !isVisible,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: isVisible ? 1.0 : 0.0,
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.3),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: ClonesColors.primary,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.close_fullscreen,
                              color: ClonesColors.secondary,
                              size: 32,
                            ),
                            tooltip: 'Close',
                            onPressed: () => setState(
                              () => _fullscreenView = _FullScreenView.none,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: content,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlobalStats() {
    if (_stats == null) return const SizedBox.shrink();

    return SizedBox(
      height: 150,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 20,
        children: [
          LeaderboardsStatTotalDemos(stat: _stats!),
          LeaderboardsStatTotalTasks(stat: _stats!),
          LeaderboardsStatTotalPaidOut(stat: _stats!),
          LeaderboardsStatActiveForges(stat: _stats!),
        ],
      ),
    );
  }
}

enum _FullScreenView { none, forges, workers }
