// ignore_for_file: use_decorated_box

import 'dart:convert';

import 'package:clones_desktop/application/session/provider.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:clones_desktop/ui/components/wallet_not_connected.dart';
import 'package:clones_desktop/ui/views/demo_detail/bloc/provider.dart';
import 'package:clones_desktop/ui/views/demo_detail/bloc/state.dart';
import 'package:clones_desktop/utils/format_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DemoDetailEvents extends ConsumerWidget {
  const DemoDetailEvents({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected =
        ref.watch(sessionNotifierProvider.select((s) => s.isConnected));
    if (isConnected == false) {
      return const WalletNotConnected();
    }
    final theme = Theme.of(context);
    final demoDetail = ref.watch(demoDetailNotifierProvider);
    final events = demoDetail.events;
    final eventTypes = demoDetail.eventTypes;
    final enabledEventTypes = demoDetail.enabledEventTypes;
    final videoController = demoDetail.videoController;
    final startTime = demoDetail.startTime;

    // Build a map from filtered events to their original indices for deleted zone lookup
    final filteredEventIndices = <int>[];
    for (var i = 0; i < events.length; i++) {
      if (enabledEventTypes.contains(events[i].event)) {
        filteredEventIndices.add(i);
      }
    }
    final filteredEvents = filteredEventIndices.map((i) => events[i]).toList();

    // Get memoized set of events in deleted zones
    final eventsInDeletedZones = demoDetail.eventsInDeletedZones;

    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              demoDetail.recording?.location == 'cloud' 
                  ? Icons.cloud_outlined 
                  : Icons.event_busy,
              size: 48,
              color: ClonesColors.secondaryText,
            ),
            const SizedBox(height: 16),
            Text(
              demoDetail.recording?.location == 'cloud'
                  ? 'Event data not available for cloud recordings'
                  : 'No events to display.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: ClonesColors.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            'This events section lists the events (interactions like keyboard and mouse) that happened during the recording.',
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 10,
            ),
          ),
        ),
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
              final originalEventIndex = filteredEventIndices[index];

              // Use memoized deleted zone check (computed once per state change)
              final relativeTime = event.time - startTime;
              final isInDeletedZone =
                  eventsInDeletedZones.contains(originalEventIndex);

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
                        color: isInDeletedZone
                            ? Colors.redAccent.withValues(alpha: 0.4)
                            : ClonesColors.rewardInfo.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(16),
                        border: isInDeletedZone
                            ? Border.all(color: Colors.redAccent)
                            : null,
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
                          color: isInDeletedZone
                              ? Colors.redAccent
                              : ClonesColors.rewardInfo,
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
                          color: isInDeletedZone
                              ? Colors.redAccent.withValues(alpha: 0.4)
                              : ClonesColors.getEventTypeColor(event.event)
                                  .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(16),
                          border: isInDeletedZone
                              ? Border.all(color: Colors.redAccent)
                              : null,
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
                            color: isInDeletedZone
                                ? Colors.redAccent
                                : ClonesColors.getEventTypeColor(event.event),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      decoration: isInDeletedZone
                          ? BoxDecoration(
                              color: Colors.redAccent.withValues(alpha: 0.12),
                              border: Border.all(
                                color: Colors.redAccent.withValues(alpha: 0.3),
                              ),
                              borderRadius: BorderRadius.circular(12),
                            )
                          : null,
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
