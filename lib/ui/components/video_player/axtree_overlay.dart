import 'dart:math';

import 'package:clones_desktop/domain/models/recording/recording_event.dart';
import 'package:flutter/material.dart';

/// Widget that renders an accessibility tree overlay on top of a video player
class AxTreeOverlay extends StatelessWidget {
  const AxTreeOverlay({
    super.key,
    required this.axTreeEvent,
    required this.videoSize,
    required this.recordingResolution,
    this.opacity = 0.7,
    this.showLabels = true,
  });

  final RecordingEvent axTreeEvent;
  final Size videoSize;
  final Size recordingResolution;
  final double opacity;
  final bool showLabels;

  @override
  Widget build(BuildContext context) {
    // Calculate scale to fit recording resolution to video display size
    final scale = min(
      videoSize.width / recordingResolution.width,
      videoSize.height / recordingResolution.height,
    );

    // Extract AxTree data from the event
    final axTreeData = axTreeEvent.data;

    final rawTree = axTreeData['tree'];
    if (rawTree == null) {
      return const SizedBox.shrink();
    }

    // Handle different tree structures
    List<dynamic> tree;
    if (rawTree is List<dynamic>) {
      tree = rawTree;
    } else if (rawTree is Map<String, dynamic>) {
      // If tree is a single object, wrap it in a list
      tree = [rawTree];
    } else {
      return const SizedBox.shrink();
    }

    // Flatten the tree structure into renderable boxes
    final boxes = _flattenAxTree(tree);

    return SizedBox(
      width: videoSize.width,
      height: videoSize.height,
      child: Stack(
        children: [
          // Semi-transparent background
          Container(
            color: Colors.black.withValues(alpha: opacity * 0.3),
          ),
          // Transform to scale from recording resolution to video size
          Transform.scale(
            scale: scale,
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: recordingResolution.width,
              height: recordingResolution.height,
              child: Stack(
                children: boxes.map(_buildElementBox).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Recursively flattens the AxTree structure into a list of boxes
  List<AxTreeBox> _flattenAxTree(List<dynamic> tree) {
    final boxes = <AxTreeBox>[];

    void processElement(dynamic element) {
      if (element is! Map<String, dynamic>) return;

      final elementMap = element;

      // Extract bbox if it exists and is valid
      final bboxData = elementMap['bbox'];
      if (bboxData != null) {
        double x = 0, y = 0, width = 0, height = 0;

        if (bboxData is Map<String, dynamic>) {
          // bbox as object: {x: 10, y: 20, width: 100, height: 50}
          x = (bboxData['x'] as num?)?.toDouble() ?? 0;
          y = (bboxData['y'] as num?)?.toDouble() ?? 0;
          width = (bboxData['width'] as num?)?.toDouble() ?? 0;
          height = (bboxData['height'] as num?)?.toDouble() ?? 0;
        } else if (bboxData is List<dynamic> && bboxData.length >= 4) {
          // bbox as array: [x, y, x2, y2]
          final x1 = (bboxData[0] as num?)?.toDouble() ?? 0;
          final y1 = (bboxData[1] as num?)?.toDouble() ?? 0;
          final x2 = (bboxData[2] as num?)?.toDouble() ?? 0;
          final y2 = (bboxData[3] as num?)?.toDouble() ?? 0;
          x = x1;
          y = y1;
          width = x2 - x1;
          height = y2 - y1;
        }

        // Only add boxes with valid dimensions
        if (width > 0 && height > 0) {
          boxes.add(
            AxTreeBox(
              x: x,
              y: y,
              width: width,
              height: height,
              name: elementMap['name'] as String? ?? '',
              role: elementMap['role'] as String? ?? '',
              description: elementMap['description'] as String? ?? '',
              value: elementMap['value']?.toString() ?? '',
            ),
          );
        }
      }

      // Recursively process children - handle all possible structures
      final rawChildren = elementMap['children'];
      if (rawChildren != null) {
        if (rawChildren is List<dynamic>) {
          // Standard case: children is a list
          for (final child in rawChildren) {
            processElement(child);
          }
        } else if (rawChildren is Map<String, dynamic>) {
          // Special case: children is a single object that may contain more children
          processElement(rawChildren);
        }
      }
    }

    for (final element in tree) {
      processElement(element);
    }
    return boxes;
  }

  Widget _buildElementBox(AxTreeBox box) {
    return Positioned(
      left: box.x,
      top: box.y,
      width: box.width,
      height: box.height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: _getColorForRole(box.role),
            width: 1.5,
          ),
          color: _getColorForRole(box.role).withValues(alpha: 0.1),
        ),
        child: showLabels && box.width > 40 && box.height > 20
            ? Padding(
                padding: const EdgeInsets.all(2),
                child: Text(
                  box.name.isNotEmpty ? box.name : box.role,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            : null,
      ),
    );
  }

  Color _getColorForRole(String role) {
    switch (role.toLowerCase()) {
      case 'button':
        return Colors.blue;
      case 'text':
      case 'textbox':
      case 'textfield':
        return Colors.green;
      case 'image':
        return Colors.purple;
      case 'link':
        return Colors.orange;
      case 'list':
      case 'listitem':
        return Colors.cyan;
      case 'menu':
      case 'menuitem':
        return Colors.red;
      case 'window':
      case 'pane':
        return Colors.grey;
      default:
        return Colors.white;
    }
  }
}

/// Data class for AxTree element boxes
class AxTreeBox {
  const AxTreeBox({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.name,
    required this.role,
    this.description = '',
    this.value = '',
  });

  final double x;
  final double y;
  final double width;
  final double height;
  final String name;
  final String role;
  final String description;
  final String value;
}
