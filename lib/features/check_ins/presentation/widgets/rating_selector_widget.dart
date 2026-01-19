import 'package:flutter/material.dart';

/// Widget for selecting a rating (1-5 stars)
class RatingSelectorWidget extends StatelessWidget {
  const RatingSelectorWidget({
    super.key,
    required this.rating,
    required this.onRatingChanged,
    this.isEnabled = true,
  });

  final int? rating;
  final void Function(int? rating) onRatingChanged;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Avaliacao',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            if (rating != null) ...[
              const Spacer(),
              TextButton(
                onPressed: isEnabled ? () => onRatingChanged(null) : null,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Limpar',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(5, (index) {
            final starValue = index + 1;
            final isSelected = rating != null && starValue <= rating!;

            return GestureDetector(
              onTap: isEnabled
                  ? () {
                      if (rating == starValue) {
                        onRatingChanged(null);
                      } else {
                        onRatingChanged(starValue);
                      }
                    }
                  : null,
              child: Padding(
                padding: const EdgeInsets.only(right: 4),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isSelected ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 36,
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline.withValues(alpha: 0.5),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 4),
        Text(
          rating != null
              ? _getRatingLabel(rating!)
              : 'Toque nas estrelas para avaliar',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.outline,
          ),
        ),
      ],
    );
  }

  String _getRatingLabel(int rating) {
    switch (rating) {
      case 1:
        return 'Ruim';
      case 2:
        return 'Regular';
      case 3:
        return 'Bom';
      case 4:
        return 'Muito bom';
      case 5:
        return 'Excelente';
      default:
        return '';
    }
  }
}
