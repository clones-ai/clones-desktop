import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/ui/components/menu_item.dart';
import 'package:clones_desktop/ui/views/factory/layouts/factory_view.dart';
import 'package:clones_desktop/ui/views/forge/layouts/forge_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  static const String routeName = '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    final menuItems = [
      MenuItem(
        'Create a Factory',
        'Design AI training environments and monetize your workflows.',
        Assets.menuForge,
        () {
          context.go(ForgeView.routeName);
        },
      ),
      MenuItem(
        'Farm Data',
        'Generate high-quality demonstrations and earn rewards.',
        Assets.menuFarm,
        () {
          context.go(FactoryView.routeName);
        },
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Clones',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Column(
              children: [
                Text(
                  'Clone yourself',
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'The first liquid AI infra where YOU create, trade & own the IP',
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 100),
                Wrap(
                  spacing: 20,
                  alignment: WrapAlignment.center,
                  children: [
                    SizedBox(
                      width: mediaQuery.size.width * 0.25,
                      height: mediaQuery.size.height * 0.4,
                      child: MenuItemWidget(item: menuItems[0]),
                    ),
                    SizedBox(
                      width: mediaQuery.size.width * 0.25,
                      height: mediaQuery.size.height * 0.4,
                      child: MenuItemWidget(item: menuItems[1]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
