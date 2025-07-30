import 'dart:async';

import 'package:clones_desktop/application/session/provider.dart';
import 'package:clones_desktop/application/tauri_api.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WalletNotConnected extends ConsumerWidget {
  const WalletNotConnected({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: 0.05,
          child: Image.asset(
            Assets.walletToConnectIconWB,
            width: mediaQuery.size.width,
            height: mediaQuery.size.height,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please, connect your Solana wallet to start using the app',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            BtnPrimary(
              onTap: () => _handleConnect(ref),
              buttonText: 'Connect',
            ),
          ],
        ),
      ],
    );
  }
}

Future<void> _handleConnect(WidgetRef ref) async {
  await ref.read(sessionNotifierProvider.notifier).getConnectionUrl();
  final session = ref.read(sessionNotifierProvider);

  final url = session.connectionUrl;
  debugPrint('url: $url');

  try {
    await ref.read(tauriApiClientProvider).openExternalUrl(url);
    await ref.read(sessionNotifierProvider.notifier).startPolling();
  } catch (e) {
    debugPrint('Failed to open external URL: $e');
  }
}
