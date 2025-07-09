import 'package:clones/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final forgeDetailTabProvider = StateProvider<String>((ref) => 'general');

class ForgeGymDetailSidebar extends ConsumerWidget {
  const ForgeGymDetailSidebar({
    super.key,
    required this.poolId,
  });

  final String poolId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(forgeDetailTabProvider);
    final buttons = [
      SidebarButtonData(
        path: '/forge/$poolId/general',
        icon: Icons.info,
        label: 'General',
        key: 'general',
      ),
      SidebarButtonData(
        path: '/forge/$poolId/tasks',
        icon: Icons.list,
        label: 'Tasks',
        key: 'tasks',
      ),
      SidebarButtonData(
        path: '/forge/$poolId/uploads',
        icon: Icons.upload,
        label: 'Uploads',
        key: 'uploads',
      ),
      SidebarButtonData(
        path: '/forge/$poolId/deploy',
        icon: Icons.cloud_upload,
        label: 'Deploy',
        key: 'deploy',
      ),
    ];

    var activeIndex = buttons.indexWhere((b) => b.key == currentTab);
    if (activeIndex == -1) activeIndex = 0;

    return Container(
      width: 100,
      color: Colors.transparent,
      child: Column(
        children: [
          Expanded(
            child: AnimatedSidebarSection(
              buttons: buttons,
              activeIndex: activeIndex,
              onTap: (i) {
                ref.read(forgeDetailTabProvider.notifier).state =
                    buttons[i].key;
                context.go(buttons[i].path);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedSidebarSection extends StatelessWidget {
  const AnimatedSidebarSection({
    super.key,
    required this.buttons,
    required this.activeIndex,
    required this.onTap,
  });

  final List<SidebarButtonData> buttons;
  final int activeIndex;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    const double buttonHeight = 80;
    const double sidebarWidth = 100;
    const double highlightSize = 70;
    final totalHeight = buttons.length * buttonHeight;
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableHeight = constraints.maxHeight;
        final topOffset = (availableHeight - totalHeight) / 2;
        return Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut,
              top: topOffset +
                  activeIndex * buttonHeight +
                  (buttonHeight - highlightSize) / 2,
              left: (sidebarWidth - highlightSize) / 2,
              width: highlightSize,
              height: highlightSize,
              child: Opacity(
                opacity: 0.5,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: VMColors.secondary.withValues(alpha: 0.2),
                      width: 0.5,
                    ),
                    gradient: LinearGradient(
                      colors: [
                        VMColors.secondary.withValues(alpha: 0.2),
                        Colors.transparent,
                        Colors.transparent,
                        VMColors.secondary.withValues(alpha: 0.2),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: topOffset,
              left: 0,
              right: 0,
              child: Column(
                children: List.generate(buttons.length, (i) {
                  final button = buttons[i];
                  return SizedBox(
                    height: buttonHeight,
                    child: Center(
                      child: GestureDetector(
                        onTap: () => onTap(i),
                        child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              colors: [
                                VMColors.primary.withValues(alpha: 0.5),
                                VMColors.secondary.withValues(alpha: 0.9),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ).createShader(bounds);
                          },
                          blendMode: BlendMode.dstIn,
                          child: activeIndex == i
                              ? ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    VMColors.tertiary.withValues(alpha: 1),
                                    BlendMode.srcATop,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        button.icon,
                                        size: 30,
                                        color: VMColors.secondaryText,
                                      ),
                                      Text(
                                        button.label,
                                        style: theme.textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      button.icon,
                                      color: VMColors.secondaryText,
                                      size: 30,
                                    ),
                                    Text(
                                      button.label,
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      },
    );
  }
}

class SidebarButtonData {
  SidebarButtonData({
    required this.path,
    required this.icon,
    required this.label,
    required this.key,
  });
  final String path;
  final IconData icon;
  final String label;
  final String key;
}
