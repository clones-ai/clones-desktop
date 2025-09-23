import 'package:clones_desktop/assets.dart';
import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  const AppText({super.key, required this.text, required this.style});
  final String text;
  final TextStyle? style;

  List<Part> parseText(String text) {
    final parts = <Part>[];
    var currentText = '';
    var inAppTag = false;
    var appName = '';

    for (var i = 0; i < text.length; i++) {
      if (!inAppTag && text.startsWith('<app>', i)) {
        if (currentText.isNotEmpty) {
          parts.add(Part(type: PartType.text, content: currentText));
          currentText = '';
        }
        inAppTag = true;
        i += 4; // skip <app>
      } else if (inAppTag && text.startsWith('</app>', i)) {
        parts.add(Part(type: PartType.app, content: appName.trim()));
        appName = '';
        inAppTag = false;
        i += 5; // skip </app>
      } else if (inAppTag) {
        appName += text[i];
      } else {
        currentText += text[i];
      }
    }
    if (currentText.isNotEmpty) {
      parts.add(Part(type: PartType.text, content: currentText));
    }
    return parts;
  }

  @override
  Widget build(BuildContext context) {
    final parts = parseText(text);

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 4,
      children: parts.map((part) {
        if (part.type == PartType.text) {
          return Text(
            part.content,
            style: style,
          );
        } else {
          final domain = part.content.toLowerCase();
          final googleFaviconUrl = 'https://www.google.com/s2/favicons?domain=$domain.com';
          final faviconUrl = 'http://127.0.0.1:19847/proxy-image?url=${Uri.encodeComponent(googleFaviconUrl)}';

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.5)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(
                  faviconUrl,
                  width: 16,
                  height: 16,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.apps,
                    size: 16,
                    color: ClonesColors.secondaryText,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  part.content,
                  style: style,
                ),
              ],
            ),
          );
        }
      }).toList(),
    );
  }
}

enum PartType { text, app }

class Part {
  Part({required this.type, required this.content});
  final PartType type;
  final String content;
}
