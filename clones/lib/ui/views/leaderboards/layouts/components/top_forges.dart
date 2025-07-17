import 'dart:ui';

import 'package:clones/assets.dart';
import 'package:clones/domain/models/leaderboard/forge_leader_board.dart';
import 'package:clones/ui/components/card.dart';
import 'package:clones/utils/format_num.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TopForges extends ConsumerStatefulWidget {
  const TopForges({
    super.key,
    required this.forges,
    this.onExpand,
    this.showTitle = true,
    this.listHeight,
  });

  final List<ForgeLeaderboard> forges;
  final VoidCallback? onExpand;
  final bool showTitle;
  final double? listHeight;

  @override
  ConsumerState<TopForges> createState() => _TopForgesState();
}

class _TopForgesState extends ConsumerState<TopForges> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 25,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLeaderboardTable(context),
            ],
          ),
        ),
        if (widget.showTitle)
          Positioned(
            top: 8,
            right: 20,
            child: Row(
              children: [
                const Text(
                  'Top Forges',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: VMColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon:
                      const Icon(Icons.open_in_full, color: VMColors.secondary),
                  onPressed: widget.onExpand,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildLeaderboardTable(BuildContext context) {
    return Column(
      children: [
        CardWidget(
          variant: CardVariant.black,
          padding: CardPadding.none,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTableHeader(context),
              SizedBox(
                height: widget.listHeight ?? 300,
                child: _buildForgesList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTableHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: const Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Text(
                  'Name',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: VMColors.primaryText,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Tasks Created',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: VMColors.primaryText,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Tokens Paid',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: VMColors.primaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForgesList() {
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      thickness: 8,
      radius: const Radius.circular(4),
      child: ListView.separated(
        controller: _scrollController,
        itemCount: widget.forges.length,
        itemBuilder: (context, index) {
          final forge = widget.forges[index];
          return Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    forge.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: VMColors.primaryText,
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${forge.tasks} Tasks',
                        style: TextStyle(
                          color: VMColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        formatNumberWithSeparator(forge.payout),
                        style: TextStyle(
                          color: VMColors.secondaryText,
                        ),
                      ),
                      const Text(
                        ' Tokens',
                        style: TextStyle(
                          color: VMColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return FractionallySizedBox(
            widthFactor: 0.8,
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.05),
                    Colors.white.withValues(alpha: 0.3),
                    Colors.white.withValues(alpha: 0.05),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class TopForgesFullscreen extends StatelessWidget {
  const TopForgesFullscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Stack(
      children: [
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              color: Colors.black.withValues(alpha: 0.3),
            ),
          ),
        ),
        Center(
          child: Container(
            width: mediaQuery.size.width * 0.9,
            height: mediaQuery.size.height * 0.85,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Material(
              color: Colors.transparent,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: TopForges(
                      forges: (ModalRoute.of(context)?.settings.arguments
                              as List<ForgeLeaderboard>?) ??
                          [],
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 24,
                    child: IconButton(
                      icon: const Icon(
                        Icons.close_fullscreen,
                        color: VMColors.secondary,
                        size: 32,
                      ),
                      tooltip: 'Close',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const Positioned(
                    top: 16,
                    left: 32,
                    child: Text(
                      'Top Forges',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: VMColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
