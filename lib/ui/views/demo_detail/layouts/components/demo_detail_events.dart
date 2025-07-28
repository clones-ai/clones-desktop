import 'dart:convert';

import 'package:clones_desktop/application/session/provider.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:clones_desktop/ui/components/wallet_not_connected.dart';
import 'package:clones_desktop/ui/views/demo_detail/bloc/provider.dart';
import 'package:clones_desktop/utils/format_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DemoDetailEvents extends ConsumerWidget {
  const DemoDetailEvents({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionNotifierProvider);
    if (session.isConnected == false) {
      return const WalletNotConnected();
    }
    final theme = Theme.of(context);
    final demoDetail = ref.watch(demoDetailNotifierProvider);
    final events = demoDetail.events;
    final eventTypes = demoDetail.eventTypes;
    final enabledEventTypes = demoDetail.enabledEventTypes;
    final videoController = demoDetail.videoController;
    final startTime = demoDetail.startTime;

    final filteredEvents =
        events.where((e) => enabledEventTypes.contains(e.event)).toList();

    if (events.isEmpty) {
      return Center(
        child: Text(
          'No events to display.',
          style: theme.textTheme.bodyMedium,
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: eventTypes.map((type) {
              final isEnabled = enabledEventTypes.contains(type);
              return OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor:
                      isEnabled ? ClonesColors.tertiary : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  side: BorderSide(
                    color: isEnabled
                        ? ClonesColors.primary
                        : ClonesColors.tertiary,
                    width: 0.1,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                ),
                onPressed: () {
                  ref
                      .read(demoDetailNotifierProvider.notifier)
                      .toggleEventType(type);
                },
                child: Text(
                  type,
                  style: theme.textTheme.bodySmall,
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: filteredEvents.length,
            itemBuilder: (context, index) {
              final event = filteredEvents[index];
              return Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: ClonesColors.rewardInfo.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF000000).withAlpha(60),
                            blurRadius: 6,
                            offset: const Offset(
                              0,
                              3,
                            ),
                          ),
                        ],
                      ),
                      child: Text(
                        event.event,
                        style: theme.textTheme.bodySmall!.copyWith(
                          color: ClonesColors.rewardInfo,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: GestureDetector(
                      onTap: () {
                        if (videoController != null && startTime > 0) {
                          final relativeTime = event.time - startTime;
                          videoController
                              .seekTo(Duration(milliseconds: relativeTime));
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: ClonesColors.getEventTypeColor(event.event)
                              .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF000000).withAlpha(60),
                              blurRadius: 6,
                              offset: const Offset(
                                0,
                                3,
                              ),
                            ),
                          ],
                        ),
                        child: Text(
                          formatTimeMs(event.time - startTime),
                          style: theme.textTheme.bodySmall!.copyWith(
                            color: ClonesColors.getEventTypeColor(event.event),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: CardWidget(
                      padding: CardPadding.small,
                      variant: CardVariant.secondary,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  const JsonEncoder.withIndent('  ')
                                      .convert(event.data),
                                  style: theme.textTheme.bodySmall!.copyWith(
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          BtnPrimary(
                            btnPrimaryType: BtnPrimaryType.outlinePrimary,
                            onTap: () async {
                              await Clipboard.setData(
                                ClipboardData(text: jsonEncode(event.data)),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Data copied!'),
                                ),
                              );
                            },
                            buttonText: 'Copy',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
