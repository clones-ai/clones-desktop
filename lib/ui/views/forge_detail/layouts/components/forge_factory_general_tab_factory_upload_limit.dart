import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/domain/models/factory/factory.dart';
import 'package:clones_desktop/ui/components/app_text_field.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/views/forge_detail/bloc/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgeFactoryGeneralTabFactoryUploadLimit extends ConsumerStatefulWidget {
  const ForgeFactoryGeneralTabFactoryUploadLimit({super.key});

  @override
  ConsumerState<ForgeFactoryGeneralTabFactoryUploadLimit> createState() =>
      _ForgeFactoryGeneralTabFactoryUploadLimitState();
}

class _ForgeFactoryGeneralTabFactoryUploadLimitState
    extends ConsumerState<ForgeFactoryGeneralTabFactoryUploadLimit> {
  late final TextEditingController uploadLimitValueController;

  @override
  void dispose() {
    uploadLimitValueController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final forgeDetail = ref.read(forgeDetailNotifierProvider);
    uploadLimitValueController =
        TextEditingController(text: forgeDetail.uploadLimitValue.toString());
  }

  @override
  Widget build(BuildContext context) {
    final forgeDetail = ref.watch(forgeDetailNotifierProvider);
    final readOnly = forgeDetail.factory != null &&
        forgeDetail.factory!.status == FactoryStatus.active;
    if (forgeDetail.factory == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    return CardWidget(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ClonesColors.containerIcon3.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.speed,
                    color: ClonesColors.containerIcon3.withValues(alpha: 0.7),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upload Limits',
                      style: theme.textTheme.titleSmall,
                    ),
                    Text(
                      'Set factory-wide upload limits',
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Limit Type',
                        style: theme.textTheme.titleSmall,
                      ),
                      const SizedBox(height: 4),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: readOnly
                              ? null
                              : Border.all(
                                  color: theme.colorScheme.primaryContainer,
                                  width: 0.5,
                                ),
                          gradient: ClonesColors.gradientInputFormBackground,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: DropdownButton<String>(
                            value: forgeDetail.uploadLimitType,
                            isExpanded: true,
                            underline: const SizedBox(),
                            dropdownColor: Colors.black.withValues(alpha: 0.9),
                            style: theme.textTheme.bodyMedium,
                            items: [
                              DropdownMenuItem(
                                value: 'none',
                                child: Text(
                                  'None',
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'pertask',
                                child: Text(
                                  'Per Task',
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'perday',
                                child: Text(
                                  'Per Day',
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'total',
                                child: Text(
                                  'Total',
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ),
                            ],
                            onChanged: readOnly
                                ? null
                                : (val) {
                                    ref
                                        .read(
                                          forgeDetailNotifierProvider.notifier,
                                        )
                                        .setUploadLimitType(val ?? 'per-task');
                                  },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                if (forgeDetail.uploadLimitType != 'none')
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Limit Value',
                          style: theme.textTheme.titleSmall,
                        ),
                        const SizedBox(height: 4),
                        AppTextField(
                          controller: uploadLimitValueController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          readOnly: forgeDetail.factory != null &&
                              forgeDetail.factory!.status ==
                                  FactoryStatus.active,
                          style: theme.textTheme.bodyMedium,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 12,
                            ),
                            hintText: 'Value',
                          ),
                          onChanged: (val) {
                            ref
                                .read(forgeDetailNotifierProvider.notifier)
                                .setUploadLimitValue(int.tryParse(val) ?? 0);
                          },
                        ),
                      ],
                    ),
                  )
                else
                  const Expanded(child: SizedBox(width: double.infinity)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Builder(
                builder: (context) {
                  String explanation;
                  switch (forgeDetail.uploadLimitType) {
                    case 'pertask':
                      explanation =
                          'Limit the number of uploads per individual task.';
                      break;
                    case 'perday':
                      explanation =
                          'Limit the number of uploads per day across all tasks.';
                      break;
                    case 'total':
                      explanation =
                          'Limit the total number of uploads across all tasks.';
                      break;
                    case 'none':
                      explanation =
                          'No upload limits are set for this factory.';
                      break;
                    default:
                      explanation = '';
                  }
                  return Text(
                    explanation,
                    style: theme.textTheme.bodySmall,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
