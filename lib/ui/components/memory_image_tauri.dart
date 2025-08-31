import 'dart:typed_data';

import 'package:clones_desktop/application/tauri_api.dart';
import 'package:clones_desktop/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MemoryImageTauri extends ConsumerStatefulWidget {
  const MemoryImageTauri({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.errorBuilder,
  });
  final String imageUrl;
  final double? width;
  final double? height;
  final ImageErrorWidgetBuilder? errorBuilder;
  @override
  ConsumerState<MemoryImageTauri> createState() => _MemoryImageTauriState();
}

class _MemoryImageTauriState extends ConsumerState<MemoryImageTauri> {
  Uint8List? bytes;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      try {
        final bytes = await ref
            .read(tauriApiClientProvider)
            .fetchImageViaProxy(widget.imageUrl);
        if (mounted) {
          setState(() {
            this.bytes = bytes;
          });
        }
      } catch (e) {
        // Silently fail - widget will show error state or fallback
        if (mounted) {
          setState(() {
            bytes = Uint8List(0); // Empty bytes to trigger error builder
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return bytes != null
        ? bytes!.isEmpty
            ? widget.errorBuilder
                    ?.call(context, Exception('Failed to load image'), null) ??
                const SizedBox.shrink()
            : Image.memory(
                bytes!,
                width: widget.width,
                height: widget.height,
                errorBuilder: widget.errorBuilder ??
                    (context, error, stackTrace) => const SizedBox.shrink(),
              )
        : SizedBox(
            width: widget.width,
            height: widget.height,
            child: const CircularProgressIndicator(
              color: ClonesColors.primaryText,
              strokeWidth: 0.5,
            ),
          );
  }
}
