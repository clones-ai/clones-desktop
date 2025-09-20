import 'package:clones_desktop/assets.dart';
import 'package:flutter/material.dart';

class ScoreIndicator extends StatelessWidget {
  const ScoreIndicator({
    super.key,
    required this.score,
    this.size = 80,
    this.strokeWidth = 8,
    this.fontSize = 11,
    this.label,
    this.isHighlighted = false,
  });

  final double score;
  final double size;
  final double strokeWidth;
  final double fontSize;
  final String? label;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scoreInt = score.round();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: isHighlighted
              ? BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: ClonesColors.getScoreColor(scoreInt)
                          .withValues(alpha: 0.3),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                )
              : null,
          child: SizedBox(
            width: size,
            height: size,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: score / 100,
                  strokeWidth: strokeWidth,
                  backgroundColor: ClonesColors.getScoreColor(scoreInt)
                      .withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    ClonesColors.getScoreColor(scoreInt),
                  ),
                ),
                Center(
                  child: Text(
                    '$scoreInt%',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ClonesColors.getScoreColor(scoreInt),
                      fontSize: size * 0.18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (label != null) ...[
          const SizedBox(height: 10),
          Text(
            label!,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ],
    );
  }
}
