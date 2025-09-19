import 'package:clones_desktop/assets.dart';
import 'package:flutter/material.dart';

class ScoreIndicator extends StatelessWidget {
  const ScoreIndicator({
    super.key,
    required this.score,
    this.size = 80,
    this.strokeWidth = 8,
    this.label,
  });

  final double score;
  final double size;
  final double strokeWidth;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scoreInt = score.round();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: score / 100,
                strokeWidth: strokeWidth,
                backgroundColor:
                    ClonesColors.getScoreColor(scoreInt).withValues(alpha: 0.2),
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
                    fontSize: size * 0.18, // Responsive font size
                  ),
                ),
              ),
            ],
          ),
        ),
        if (label != null) ...[
          const SizedBox(height: 4),
          Text(
            label!,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ],
    );
  }
}
