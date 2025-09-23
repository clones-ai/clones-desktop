import 'dart:ui';

import 'package:clones_desktop/application/onboarding_provider.dart';
import 'package:clones_desktop/application/privacy.dart';
import 'package:clones_desktop/ui/components/card.dart';
import 'package:clones_desktop/ui/components/design_widget/buttons/btn_primary.dart';
import 'package:clones_desktop/ui/components/privacy_policy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrivacyModal extends ConsumerStatefulWidget {
  const PrivacyModal({super.key});

  @override
  ConsumerState<PrivacyModal> createState() => _PrivacyModalState();
}

class _PrivacyModalState extends ConsumerState<PrivacyModal> {
  bool _privacyCheckboxChecked = false;

  @override
  Widget build(BuildContext context) {
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
              width: mediaQuery.size.width * 0.6,
              height: mediaQuery.size.height * 0.8,
              child: Column(
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Welcome to Clones',
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Please read and accept our Privacy Policy to continue',
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Privacy Policy Section
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.purple.withValues(alpha: 0.2),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const PrivacyPolicy(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Checkbox and accept button
                  Row(
                    children: [
                      Checkbox(
                        value: _privacyCheckboxChecked,
                        onChanged: (value) {
                          setState(() {
                            _privacyCheckboxChecked = value ?? false;
                          });
                        },
                        activeColor: Colors.purple,
                      ),
                      Expanded(
                        child: Text(
                          'I have read and accept the Privacy Policy',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 120,
                        child: BtnPrimary(
                          buttonText: 'Continue',
                          widthExpanded: true,
                          isLocked: !_privacyCheckboxChecked,
                          onTap: _privacyCheckboxChecked
                              ? () async {
                                  await ref.read(acceptPrivacyProvider.future);
                                  await ref
                                      .read(onboardingProvider.notifier)
                                      .onPrivacyAccepted();
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
