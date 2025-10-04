import 'dart:convert';
import 'package:clones_desktop/assets.dart';
import 'package:flutter/material.dart';

/// Widget to display keyboard and mouse events in a user-friendly format
class InputEventDisplay extends StatelessWidget {
  const InputEventDisplay({
    super.key,
    required this.eventData,
    required this.eventType,
  });

  final Map<String, dynamic> eventData;
  final String eventType;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Check if this is a keyboard event
    if (_isKeyboardEvent(eventType)) {
      return _buildKeyboardEventUI(theme);
    }

    // Check if this is a mouse event
    if (_isMouseEvent(eventType)) {
      return _buildMouseEventUI(theme);
    }

    // Check if this is an AXTree event
    if (_isAxTreeEvent(eventType)) {
      return _buildAxTreeEventUI(theme);
    }

    // Fallback to JSON for other events
    return _buildJsonFallback(theme);
  }

  bool _isKeyboardEvent(String eventType) {
    return eventType == 'keydown' || eventType == 'keyup';
  }

  bool _isMouseEvent(String eventType) {
    return eventType == 'mousedown' || eventType == 'mouseup';
  }

  bool _isAxTreeEvent(String eventType) {
    return eventType == 'axtree_interaction' ||
        eventType == 'axtree_pre_recording' ||
        eventType == 'axtree_post_recording';
  }

  Widget _buildKeyboardEventUI(ThemeData theme) {
    final key = eventData['key'] as String? ?? 'Unknown';
    final actualChar = eventData['actual_char'] as String? ?? '';
    final detectionMethod = eventData['detection_method'] as String? ?? '';
    final layoutDependent = eventData['layout_dependent'] as bool? ?? false;

    // Parse the actual character from the UnicodeInfo string
    final displayChar = _parseActualCharacter(actualChar);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main key display
        _buildKeyDisplay(key, displayChar, theme),

        const SizedBox(height: 8),

        // Details section
        _buildDetailsSection(
          key,
          displayChar,
          detectionMethod,
          layoutDependent,
          theme,
        ),
      ],
    );
  }

  Widget _buildKeyDisplay(String key, String displayChar, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          // Key icon
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              Icons.keyboard,
              size: 16,
              color: Colors.blue[700],
            ),
          ),
          const SizedBox(width: 12),

          // Key information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Key: ',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      _formatKeyName(key),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                  ],
                ),
                if (displayChar.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Character: ',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 10,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          displayChar,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                            fontFamily: 'monospace',
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMouseEventUI(ThemeData theme) {
    final button = eventData['button'] as String? ?? 'Unknown';
    final action = eventType == 'mousedown' ? 'Pressed' : 'Released';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main mouse display
        _buildMouseDisplay(button, action, theme),

        const SizedBox(height: 8),

        // Details section
        _buildMouseDetailsSection(button, action, theme),
      ],
    );
  }

  Widget _buildMouseDisplay(String button, String action, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          // Mouse icon
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              Icons.mouse,
              size: 16,
              color: Colors.blue[700],
            ),
          ),
          const SizedBox(width: 12),

          // Mouse information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Button: ',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      _formatMouseButton(button),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Action: ',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        action,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMouseDetailsSection(
    String button,
    String action,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(
            'Mouse Button',
            _formatMouseButton(button),
            Icons.ads_click,
            theme,
          ),
          _buildDetailRow(
            'Button Action',
            action,
            action == 'Pressed' ? Icons.touch_app : Icons.pan_tool,
            theme,
          ),
          _buildDetailRow(
            'Event Type',
            eventType,
            Icons.event,
            theme,
          ),
        ],
      ),
    );
  }

  Widget _buildAxTreeEventUI(ThemeData theme) {
    final tree = eventData['tree'] as List<dynamic>? ?? [];
    final duration = eventData['duration'] as int? ?? 0;

    // Extract applications from the tree
    final applications = tree
        .where(
          (item) =>
              item is Map<String, dynamic> && item['role'] == 'application',
        )
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main AXTree display
        _buildAxTreeDisplay(applications.length, duration, theme),

        const SizedBox(height: 8),

        // Applications list
        if (applications.isNotEmpty) ...[
          _buildApplicationsList(applications, theme),
          const SizedBox(height: 8),
        ],

        // Details section
        _buildAxTreeDetailsSection(duration, theme),
      ],
    );
  }

  Widget _buildAxTreeDisplay(int appCount, int duration, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          // AXTree icon
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              Icons.account_tree,
              size: 16,
              color: Colors.blue[700],
            ),
          ),
          const SizedBox(width: 12),

          // AXTree information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '$appCount app. detected',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationsList(List<dynamic> applications, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.apps,
                size: 12,
                color: ClonesColors.secondaryText,
              ),
              const SizedBox(width: 4),
              Text(
                'Detected Applications:',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ...applications.map((app) => _buildApplicationItem(app, theme)),
        ],
      ),
    );
  }

  Widget _buildApplicationItem(dynamic app, ThemeData theme) {
    final name = app['name'] as String? ?? 'Unknown';
    final hasWindow =
        app['children'] != null && (app['children'] as List).isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: hasWindow ? Colors.blue[400] : Colors.grey[400],
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              name,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 10,
                color: hasWindow ? Colors.blue[700] : Colors.grey[600],
                fontWeight: hasWindow ? FontWeight.w500 : FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (hasWindow)
            Icon(
              Icons.window,
              size: 10,
              color: Colors.blue[400],
            ),
        ],
      ),
    );
  }

  Widget _buildAxTreeDetailsSection(int duration, ThemeData theme) {
    final eventDescription = _getAxTreeEventDescription(eventType);
    final triggerDescription = _getAxTreeTriggerDescription(eventType);
    final triggerIcon = _getAxTreeTriggerIcon(eventType);

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(
            'Event Type',
            eventDescription,
            Icons.account_tree,
            theme,
          ),
          _buildDetailRow(
            'Capture Duration',
            '${duration}ms',
            Icons.timer,
            theme,
          ),
          _buildDetailRow(
            'Trigger',
            triggerDescription,
            triggerIcon,
            theme,
          ),
        ],
      ),
    );
  }

  String _getAxTreeEventDescription(String eventType) {
    switch (eventType) {
      case 'axtree_interaction':
        return 'Accessibility Tree Capture';
      case 'axtree_pre_recording':
        return 'Initial State Capture';
      case 'axtree_post_recording':
        return 'Final State Capture';
      default:
        return 'Accessibility Tree Capture';
    }
  }

  String _getAxTreeTriggerDescription(String eventType) {
    switch (eventType) {
      case 'axtree_interaction':
        return 'User Interaction';
      case 'axtree_pre_recording':
        return 'Recording Start';
      case 'axtree_post_recording':
        return 'Recording Stop';
      default:
        return 'User Interaction';
    }
  }

  IconData _getAxTreeTriggerIcon(String eventType) {
    switch (eventType) {
      case 'axtree_interaction':
        return Icons.touch_app;
      case 'axtree_pre_recording':
        return Icons.play_arrow;
      case 'axtree_post_recording':
        return Icons.stop;
      default:
        return Icons.touch_app;
    }
  }

  Widget _buildDetailsSection(
    String key,
    String displayChar,
    String detectionMethod,
    bool layoutDependent,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(
            'Physical Key',
            _formatKeyName(key),
            Icons.keyboard_alt,
            theme,
          ),
          if (displayChar.isNotEmpty)
            _buildDetailRow(
              'Character Output',
              displayChar,
              Icons.text_fields,
              theme,
            ),
          _buildDetailRow(
            'Detection Method',
            _formatDetectionMethod(detectionMethod),
            Icons.settings,
            theme,
          ),
          _buildDetailRow(
            'Layout Dependent',
            layoutDependent ? 'Yes' : 'No',
            Icons.language,
            theme,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    IconData icon,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            icon,
            size: 12,
            color: ClonesColors.secondaryText,
          ),
          const SizedBox(width: 6),
          Text(
            '$label: ',
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 10,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 10,
                fontFamily: value.contains('_') ? 'monospace' : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJsonFallback(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.code, size: 16, color: ClonesColors.secondaryText),
            const SizedBox(width: 6),
            Text(
              'Event Data:',
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: ClonesColors.secondaryText,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.all(4),
          child: Text(
            const JsonEncoder.withIndent('  ').convert(eventData),
            style: theme.textTheme.bodySmall?.copyWith(
              fontFamily: 'monospace',
            ),
          ),
        ),
      ],
    );
  }

  String _parseActualCharacter(String actualCharString) {
    if (actualCharString.isEmpty) return '';

    // Try to extract character from UnicodeInfo format
    // "UnicodeInfo { name: Some(\"A\"), unicode: [65], is_dead: false }"
    final nameMatch =
        RegExp(r'name: Some\("(.+?)"\)').firstMatch(actualCharString);
    if (nameMatch != null) {
      final char = nameMatch.group(1);
      if (char != null && char.isNotEmpty) {
        // Handle special characters that might not be printable
        if (char.length == 1 && char.codeUnitAt(0) >= 32) {
          return char;
        } else if (char.length > 1) {
          // For multi-character names, return the first character or a description
          return char;
        }
      }
    }

    return '';
  }

  String _formatKeyName(String key) {
    // Convert key names to more readable format
    switch (key) {
      case 'KeyA':
        return 'A';
      case 'KeyB':
        return 'B';
      case 'KeyC':
        return 'C';
      case 'KeyD':
        return 'D';
      case 'KeyE':
        return 'E';
      case 'KeyF':
        return 'F';
      case 'KeyG':
        return 'G';
      case 'KeyH':
        return 'H';
      case 'KeyI':
        return 'I';
      case 'KeyJ':
        return 'J';
      case 'KeyK':
        return 'K';
      case 'KeyL':
        return 'L';
      case 'KeyM':
        return 'M';
      case 'KeyN':
        return 'N';
      case 'KeyO':
        return 'O';
      case 'KeyP':
        return 'P';
      case 'KeyQ':
        return 'Q';
      case 'KeyR':
        return 'R';
      case 'KeyS':
        return 'S';
      case 'KeyT':
        return 'T';
      case 'KeyU':
        return 'U';
      case 'KeyV':
        return 'V';
      case 'KeyW':
        return 'W';
      case 'KeyX':
        return 'X';
      case 'KeyY':
        return 'Y';
      case 'KeyZ':
        return 'Z';
      case 'ShiftLeft':
        return '⇧ Left Shift';
      case 'ShiftRight':
        return '⇧ Right Shift';
      case 'ControlLeft':
        return '⌃ Left Ctrl';
      case 'ControlRight':
        return '⌃ Right Ctrl';
      case 'AltLeft':
        return '⌥ Left Alt';
      case 'AltRight':
        return '⌥ Right Alt';
      case 'CmdLeft':
        return '⌘ Left Cmd';
      case 'CmdRight':
        return '⌘ Right Cmd';
      case 'Space':
        return '⎵ Space';
      case 'Return':
        return '↩ Return';
      case 'Backspace':
        return '⌫ Backspace';
      case 'Tab':
        return '⇥ Tab';
      case 'Escape':
        return '⎋ Escape';
      case 'ArrowUp':
        return '↑';
      case 'ArrowDown':
        return '↓';
      case 'ArrowLeft':
        return '←';
      case 'ArrowRight':
        return '→';
      case 'SemiColon':
        return '; (Semicolon)';
      case 'Comma':
        return ', (Comma)';
      case 'Dot':
        return '. (Period)';
      case 'Slash':
        return '/ (Slash)';
      default:
        return key;
    }
  }

  String _formatDetectionMethod(String method) {
    switch (method) {
      case 'rdev_cross_platform':
        return 'Cross-platform (rdev)';
      case 'multiinput_windows':
        return 'Windows MultiInput';
      case 'macos_tis_api':
        return 'macOS TIS API';
      case 'macos_safe_fallback':
        return 'macOS Safe Fallback';
      default:
        return method;
    }
  }

  String _formatMouseButton(String button) {
    switch (button) {
      case 'Left':
        return '🖱️ Left Click';
      case 'Right':
        return '🖱️ Right Click';
      case 'Middle':
        return '🖱️ Middle Click';
      case 'ScrollUp':
        return '🖱️ Scroll Up';
      case 'ScrollDown':
        return '🖱️ Scroll Down';
      case 'Back':
        return '🖱️ Back Button';
      case 'Forward':
        return '🖱️ Forward Button';
      default:
        return button;
    }
  }
}
