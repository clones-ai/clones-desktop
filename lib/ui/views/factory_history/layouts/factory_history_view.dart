import 'package:clones_desktop/application/session/provider.dart';
import 'package:clones_desktop/application/tauri_api.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:clones_desktop/ui/components/design_widget/message_box/message_box.dart';
import 'package:clones_desktop/ui/components/wallet_not_connected.dart';
import 'package:clones_desktop/ui/views/factory_history/bloc/provider.dart';
import 'package:clones_desktop/ui/views/factory_history/bloc/state.dart';
import 'package:clones_desktop/ui/views/factory_history/layouts/components/recording_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FactoryHistoryView extends ConsumerWidget {
  const FactoryHistoryView({super.key});

  static const String routeName = '/history-factory';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionNotifierProvider);
    if (session.isConnected == false) {
      return const WalletNotConnected();
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 30),
          _buildToolbar(context, ref),
          _buildList(context, ref),
          const SizedBox(height: 10),
          _buildFooter(context, ref),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Factory History',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            letterSpacing: 0.5,
            color: VMColors.secondaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context, WidgetRef ref) {
    final factoryHistory = ref.watch(factoryHistoryNotifierProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        BtnPrimary(
          onTap: () => ref.read(tauriApiClientProvider).openRecordingsFolder(),
          buttonText: 'Open Recordings Folder',
          btnPrimaryType: BtnPrimaryType.outlinePrimary,
        ),
        const SizedBox(width: 10),
        if (factoryHistory.recordings.isNotEmpty)
          BtnPrimary(
            onTap: () => ref.read(tauriApiClientProvider).exportRecordings(),
            buttonText: 'Export Recordings',
            btnPrimaryType: BtnPrimaryType.outlinePrimary,
          ),
      ],
    );
  }

  Widget _buildList(BuildContext context, WidgetRef ref) {
    final factoryHistory = ref.watch(factoryHistoryNotifierProvider);

    if (factoryHistory.recordings.isEmpty) {
      return const Expanded(
        child: Center(
          child: MessageBox(
            messageBoxType: MessageBoxType.info,
            content: Text('No recordings found.'),
          ),
        ),
      );
    }
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: factoryHistory.recordings.length,
        itemBuilder: (context, index) {
          return RecordingCard(recording: factoryHistory.recordings[index]);
        },
      ),
    );
  }

  Widget _buildToolbar(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Search recordings',
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 6),
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      width: 0.5,
                    ),
                    gradient: VMColors.gradientInputFormBackground,
                  ),
                  child: TextField(
                    style: theme.textTheme.bodyMedium,
                    onChanged: (value) => ref
                        .read(factoryHistoryNotifierProvider.notifier)
                        .setSearchQuery(value),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 12,
                      ),
                      hintText: 'Factory name',
                      hintStyle:
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color!
                                    .withValues(alpha: 0.2),
                              ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sort by',
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 6),
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      width: 0.5,
                    ),
                    gradient: VMColors.gradientInputFormBackground,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: DropdownButton<String>(
                      value: ref
                          .watch(factoryHistoryNotifierProvider)
                          .sortOrder
                          .name,
                      isExpanded: true,
                      underline: const SizedBox(),
                      dropdownColor: Colors.black.withValues(alpha: 0.9),
                      style: theme.textTheme.bodyMedium,
                      items: [
                        DropdownMenuItem(
                          value: FactoryHistorySortOrder.newest.name,
                          child: Text(
                            'Newest First',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                        DropdownMenuItem(
                          value: FactoryHistorySortOrder.oldest.name,
                          child: Text(
                            'Oldest First',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          ref
                              .read(factoryHistoryNotifierProvider.notifier)
                              .setSortOrder(
                                FactoryHistorySortOrder.values.byName(val),
                              );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
