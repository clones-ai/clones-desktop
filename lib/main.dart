import 'package:clones_desktop/application/deeplink_provider.dart';
import 'package:clones_desktop/application/route_provider.dart';
import 'package:clones_desktop/application/tauri_api.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/ui/main_layout.dart';
import 'package:clones_desktop/ui/views/demo_detail/layouts/demo_detail_view.dart';
import 'package:clones_desktop/ui/views/factory/layouts/factory_view.dart';
import 'package:clones_desktop/ui/views/factory_history/layouts/factory_history_view.dart';
import 'package:clones_desktop/ui/views/forge/layouts/forge_view.dart';
import 'package:clones_desktop/ui/views/forge_detail/layouts/forge_factory_detail_shell.dart';
import 'package:clones_desktop/ui/views/forge_detail/layouts/forge_factory_general_tab.dart';
import 'package:clones_desktop/ui/views/forge_detail/layouts/forge_factory_tasks_tab.dart';
import 'package:clones_desktop/ui/views/forge_detail/layouts/forge_factory_uploads_tab.dart';
import 'package:clones_desktop/ui/views/home/layouts/home_view.dart';
import 'package:clones_desktop/ui/views/leaderboards/layouts/leaderboards_view.dart';
import 'package:clones_desktop/ui/views/record_overlay/layouts/record_overlay_view.dart';
import 'package:clones_desktop/ui/views/referral/layouts/referral_view.dart';
import 'package:clones_desktop/ui/views/training_session/layouts/training_session_view.dart';
import 'package:clones_desktop/utils/window_alignment.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _router = GoRouter(
  initialLocation: HomeView.routeName,
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainLayout(
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: HomeView.routeName,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomeView(),
          ),
        ),
        GoRoute(
          path: FactoryView.routeName,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: FactoryView(),
          ),
        ),
        GoRoute(
          path: FactoryHistoryView.routeName,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: FactoryHistoryView(),
          ),
        ),
        GoRoute(
          path: DemoDetailView.routeName,
          pageBuilder: (context, state) {
            final recordingId = state.extra as String? ?? '';
            return NoTransitionPage(
              child: DemoDetailView(recordingId: recordingId),
            );
          },
        ),
        GoRoute(
          path: ForgeView.routeName,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ForgeView(),
          ),
        ),
        ShellRoute(
          pageBuilder: (context, state, child) {
            final factoryId = state.pathParameters['id']!;
            return NoTransitionPage(
              child: ForgeFactoryDetailShell(
                factoryId: factoryId,
                child: child,
              ),
            );
          },
          routes: [
            GoRoute(
              path: '/forge/:id/general',
              pageBuilder: (context, state) {
                return const NoTransitionPage(child: ForgeFactoryGeneralTab());
              },
            ),
            GoRoute(
              path: '/forge/:id/tasks',
              pageBuilder: (context, state) {
                return const NoTransitionPage(child: ForgeFactoryTasksTab());
              },
            ),
            GoRoute(
              path: '/forge/:id/uploads',
              pageBuilder: (context, state) {
                return const NoTransitionPage(child: ForgeFactoryUploadsTab());
              },
            ),
          ],
        ),
        GoRoute(
          path: LeaderboardsView.routeName,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: LeaderboardsView(),
          ),
        ),
        GoRoute(
          path: TrainingSessionView.routeName,
          pageBuilder: (context, state) {
            final extraData = state.extra as Map<String, dynamic>?;
            final appParam = extraData?['appParam'];
            final poolId = extraData?['poolId'];
            final prompt = extraData?['prompt'];
            return NoTransitionPage(
              child: TrainingSessionView(
                appParam: appParam,
                poolId: poolId,
                prompt: prompt,
              ),
            );
          },
        ),
        GoRoute(
          path: ReferralView.routeName,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ReferralView(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: RecordOverlayView.routeName,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: RecordOverlayView(),
      ),
    ),
  ],
);

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  runApp(const ProviderScope(child: ClonesApp()));
}

class ClonesApp extends ConsumerStatefulWidget {
  const ClonesApp({super.key});

  @override
  ConsumerState<ClonesApp> createState() => _ClonesAppState();
}

class _ClonesAppState extends ConsumerState<ClonesApp> {
  @override
  void initState() {
    super.initState();
    _router.routeInformationProvider.addListener(_updateRoute);
    // Set initial route
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (kIsWeb) {
        _initializeWindow();
      }
      _updateRoute();
    });
  }

  Future<void> _initializeWindow() async {
    final displays = await ref.read(tauriApiClientProvider).getDisplaysSize();
    final smallestDisplay = displays.reduce((a, b) {
      final areaA = a.width * a.height;
      final areaB = b.width * b.height;
      return areaA < areaB ? a : b;
    });
    await ref.read(tauriApiClientProvider).resizeWindow(
          smallestDisplay.width,
          smallestDisplay.height,
        );
    await ref.read(tauriApiClientProvider).setWindowPosition(
          WindowAlignment.topCenter,
        );
    await ref.read(tauriApiClientProvider).setWindowResizable(true);
  }

  void _updateRoute() {
    if (!mounted) return;
    final location = _router.routeInformationProvider.value.uri.toString();
    // The router location can be empty at the very beginning.
    if (location.isEmpty) return;
    final current = ref.read(currentRouteProvider);
    if (current != location) {
      ref.read(currentRouteProvider.notifier).state = location;
    }
  }

  @override
  void dispose() {
    _router.routeInformationProvider.removeListener(_updateRoute);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen for deep link events and navigate accordingly.
    ref.listen(deepLinkProvider, (previous, next) {
      final url = next.value;
      if (url != null && url.isNotEmpty) {
        final uri = Uri.parse(url);

        // Handle `clones://open` by navigating to the main view.
        if (uri.host == 'open') {
          _router.go(FactoryView.routeName);
          return;
        }

        // Example deeplink: clones://training-session?poolId=some-id
        // You can expand this logic to handle different routes.
        if (uri.host == 'training-session') {
          _router.go(
            TrainingSessionView.routeName,
            extra: {
              'poolId': uri.queryParameters['poolId'],
              'prompt': uri.queryParameters['prompt'],
            },
          );
        } else {
          // Fallback or navigate to other routes based on the host
          _router.go('/${uri.host}');
        }
      }
    });

    final textTheme = Theme.of(context).textTheme.copyWith(
          bodySmall: ClonesFonts.getPrimaryFont(
            fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
            fontWeight: Theme.of(context).textTheme.bodySmall?.fontWeight,
            color: ClonesColors.secondaryText,
          ),
          bodyMedium: ClonesFonts.getPrimaryFont(
            fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
            fontWeight: Theme.of(context).textTheme.bodyMedium?.fontWeight,
            color: ClonesColors.secondaryText,
          ),
          bodyLarge: ClonesFonts.getPrimaryFont(
            fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
            fontWeight: Theme.of(context).textTheme.bodyLarge?.fontWeight,
            color: ClonesColors.secondaryText,
          ),
          titleLarge: ClonesFonts.getPrimaryFont(
            fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
            fontWeight: Theme.of(context).textTheme.titleLarge?.fontWeight,
            color: ClonesColors.primaryText,
          ),
          titleMedium: ClonesFonts.getPrimaryFont(
            fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
            fontWeight: Theme.of(context).textTheme.titleMedium?.fontWeight,
            color: ClonesColors.primaryText,
          ),
          titleSmall: ClonesFonts.getPrimaryFont(
            fontSize: Theme.of(context).textTheme.titleSmall?.fontSize,
            fontWeight: Theme.of(context).textTheme.titleSmall?.fontWeight,
            color: ClonesColors.primaryText,
          ),
          labelSmall: ClonesFonts.getMonoFont(
            fontSize: Theme.of(context).textTheme.labelSmall?.fontSize,
            fontWeight: Theme.of(context).textTheme.labelSmall?.fontWeight,
            color: ClonesColors.primaryText,
          ),
        );

    final mediaQuery = MediaQuery.of(context);

    return MaterialApp.router(
      title: 'Clones Desktop',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFbb4eff),
        ),
        textTheme: textTheme,
        snackBarTheme: SnackBarThemeData(
          width: mediaQuery.size.width * 0.5,
          backgroundColor: ClonesColors.tertiary.withValues(alpha: 0.7),
          elevation: 2,
          contentTextStyle: textTheme.bodyMedium,
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(
              color: ClonesColors.tertiary,
            ),
          ),
          closeIconColor: ClonesColors.primaryText,
        ),
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
