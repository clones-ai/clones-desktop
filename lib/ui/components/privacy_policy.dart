import 'package:clones_desktop/ui/components/recording_badge.dart';
import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Privacy Policy',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 60,
            left: 16,
            right: 16,
            bottom: 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sectionTitle('Overview', context),
                const SelectableText(
                  'This Privacy Policy explains how we collect, use, and protect data that you voluntarily '
                  'share through our software for the purpose of building an open-source dataset for AI '
                  'training through imitation learning.',
                ),
                const SizedBox(height: 16),
                sectionTitle('Data Collection', context),
                const SelectableText(
                  'Our service operates without user accounts or personal identification.',
                ),
                const SizedBox(height: 12),
                Column(
                  children: [
                    const SelectableText('Only when you see'),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.purple.withValues(alpha: 0.5),
                        ),
                      ),
                      child: const RecordingBadge(
                        state: RecordingState.recording,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const SelectableText('do we collect the following data:'),
                  ],
                ),
                const SizedBox(height: 8),
                bulletList([
                  '- Screen recordings',
                  '- Mouse movements and keyboard actions',
                  '- Window layout metadata and accessibility tree data',
                  '- System information (OS, CPU architecture, language settings)',
                ]),
                const SizedBox(height: 16),
                sectionTitle('Data Usage', context),
                const SelectableText(
                  'By uploading your recordings, you acknowledge and agree that:',
                ),
                orderedList([
                  'Your submitted recordings will be used to train artificial intelligence models',
                  'Your data will be used in two ways:',
                ]),
                const SizedBox(height: 8),
                subSection(
                  'Internal Usage',
                  [
                    '- Stored in our internal datasets with associated wallet public keys',
                    '- Used to train AI models',
                    '- Never shared publicly in raw form',
                    '- Model weights trained on this data may be released publicly',
                  ],
                  context,
                ),
                subSection(
                  'Public Datasets',
                  [
                    '- Processed to attempt to remove personally identifiable information (PII)',
                    '- Released under the MIT License',
                    '- Published on Hugging Face',
                    '- Available for commercial and non-commercial use',
                  ],
                  context,
                ),
                const SizedBox(height: 16),
                sectionTitle('Data Protection', context),
                const SelectableText(
                  'We implement several measures to protect your privacy:',
                ),
                subSection(
                  'Blocking and Filtering Tools:',
                  [
                    'Application and Window Blocking:',
                    '- Block specific applications or windows from recording',
                    '- Any data recorded while a blocked window is active is automatically excluded',
                    '- This includes all associated keyboard input, mouse movements, and metadata during those time periods',
                    'AI-Powered Semantic Filtering:',
                    '- Specify topics or keywords you want to block',
                    '- Our AI automatically detects and censors any recording segments that are semantically related to your blocked topics',
                    '- This helps prevent accidental capture of sensitive content even if expressed in different words',
                  ],
                  context,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget sectionTitle(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SelectableText(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  Widget bulletList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Expanded(child: SelectableText(item))],
            ),
          )
          .toList(),
    );
  }

  Widget orderedList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.asMap().entries.map((entry) {
        final index = entry.key + 1;
        final item = entry.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: SelectableText('$index. $item'),
        );
      }).toList(),
    );
  }

  Widget subSection(String subtitle, List<String> items, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
          bulletList(items),
        ],
      ),
    );
  }
}
