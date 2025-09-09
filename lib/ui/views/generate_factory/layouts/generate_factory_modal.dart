import 'dart:ui';

import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/views/generate_factory/bloc/provider.dart';
import 'package:clones_desktop/ui/views/generate_factory/bloc/state.dart';
import 'package:clones_desktop/ui/views/generate_factory/layouts/generate_factory_modal_step1.dart';
import 'package:clones_desktop/ui/views/generate_factory/layouts/generate_factory_modal_step2.dart';
import 'package:clones_desktop/ui/views/generate_factory/layouts/generate_factory_modal_step3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GenerateFactoryModal extends ConsumerStatefulWidget {
  const GenerateFactoryModal({
    super.key,
    required this.onClose,
    this.skills,
  });
  final VoidCallback onClose;
  final String? skills;

  @override
  ConsumerState<GenerateFactoryModal> createState() =>
      _GenerateFactoryModalState();
}

class _GenerateFactoryModalState extends ConsumerState<GenerateFactoryModal> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      if (widget.skills != null) {
        ref
            .read(generateFactoryNotifierProvider.notifier)
            .setSkills(widget.skills!);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final generateFactory = ref.watch(generateFactoryNotifierProvider);
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    return Stack(
      children: [
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              color: Colors.black.withValues(alpha: 0.5),
            ),
          ),
        ),
        Center(
          child: CardWidget(
            padding: CardPadding.large,
            child: SizedBox(
              width:
                  generateFactory.currentStep == GenerateFactoryStep.generating
                      ? mediaQuery.size.width * 0.4
                      : mediaQuery.size.width * 0.8,
              height: generateFactory.currentStep == GenerateFactoryStep.preview
                  ? mediaQuery.size.height * 0.8
                  : null,
              child: Column(
                mainAxisSize:
                    generateFactory.currentStep == GenerateFactoryStep.preview
                        ? MainAxisSize.max
                        : MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Create a Factory',
                        style: theme.textTheme.titleLarge,
                      ),
                      IconButton(
                        onPressed: widget.onClose,
                        icon: Icon(
                          Icons.close,
                          color: ClonesColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (generateFactory.currentStep ==
                      GenerateFactoryStep.input) ...[
                    GenerateFactoryModalStep1(
                      onClose: widget.onClose,
                    ),
                  ] else if (generateFactory.currentStep ==
                      GenerateFactoryStep.generating) ...[
                    const GenerateFactoryModalStep2(),
                  ] else if (generateFactory.currentStep ==
                      GenerateFactoryStep.preview) ...[
                    Expanded(
                      child: GenerateFactoryModalStep3(
                        onClose: widget.onClose,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
