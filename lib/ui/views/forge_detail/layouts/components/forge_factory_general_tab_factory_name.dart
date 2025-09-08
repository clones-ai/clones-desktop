import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/domain/models/factory/factory.dart';
import 'package:clones_desktop/ui/components/app_text_field.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/views/forge_detail/bloc/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgeFactoryGeneralTabFactoryName extends ConsumerStatefulWidget {
  const ForgeFactoryGeneralTabFactoryName({super.key});

  @override
  ConsumerState<ForgeFactoryGeneralTabFactoryName> createState() =>
      _ForgeFactoryGeneralTabFactoryNameState();
}

class _ForgeFactoryGeneralTabFactoryNameState
    extends ConsumerState<ForgeFactoryGeneralTabFactoryName> {
  late final TextEditingController controller;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final forgeDetail = ref.read(forgeDetailNotifierProvider);
    controller = TextEditingController(text: forgeDetail.factoryName);
  }

  @override
  Widget build(BuildContext context) {
    final forgeDetail = ref.watch(forgeDetailNotifierProvider);
    final theme = Theme.of(context);
    if (forgeDetail.factory == null) return const SizedBox.shrink();

    return Expanded(
      child: CardWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ClonesColors.containerIcon4.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.person,
                    color: ClonesColors.containerIcon4.withValues(alpha: 0.7),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Factory Name',
                      style: theme.textTheme.titleSmall,
                    ),
                    Text(
                      'This name will be visible to users.',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: controller,
                    onChanged: (value) {
                      ref
                          .read(
                            forgeDetailNotifierProvider.notifier,
                          )
                          .setFactoryName(value);
                    },
                    style: theme.textTheme.bodyMedium,
                    readOnly: forgeDetail.factory != null &&
                        forgeDetail.factory!.status == FactoryStatus.active,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 12,
                      ),
                      hintText: 'Enter factory name',
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color!
                            .withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
