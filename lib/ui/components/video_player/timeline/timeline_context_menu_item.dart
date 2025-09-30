import 'package:flutter/material.dart';

class TimelineContextMenuItem extends StatefulWidget {
  const TimelineContextMenuItem({
    required this.icon,
    required this.text,
    this.textStyle,
    super.key,
  });

  final IconData icon;
  final String text;
  final TextStyle? textStyle;

  @override
  State<TimelineContextMenuItem> createState() =>
      _TimelineContextMenuItemState();
}

class _TimelineContextMenuItemState extends State<TimelineContextMenuItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: _isHovered
              ? Colors.grey.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(
              widget.icon,
              size: 18,
              color: _isHovered ? Colors.white : Colors.white70,
            ),
            const SizedBox(width: 8),
            Text(
              widget.text,
              style: widget.textStyle?.copyWith(
                color: _isHovered ? Colors.white : widget.textStyle?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
