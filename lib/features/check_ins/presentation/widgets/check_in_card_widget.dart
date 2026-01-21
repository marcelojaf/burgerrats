import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/photo_gallery/cached_photo_widget.dart';
import '../../domain/entities/check_in_entity.dart';
import '../providers/check_in_history_provider.dart';

/// Widget for displaying a check-in card with photo, timestamp, and league info
class CheckInCardWidget extends ConsumerWidget {
  const CheckInCardWidget({
    super.key,
    required this.checkIn,
    this.onTap,
  });

  final CheckInEntity checkIn;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final leagueAsync = ref.watch(leagueByIdProvider(checkIn.leagueId));
    final l10n = context.l10n;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Photo with caching
            AspectRatio(
              aspectRatio: 16 / 9,
              child: CachedPhotoWidget(
                imageUrl: checkIn.photoURL,
                fit: BoxFit.cover,
              ),
            ),

            // Details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Restaurant name and rating row
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          checkIn.displayRestaurantName ?? 'Check-in',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (checkIn.hasRating) ...[
                        const SizedBox(width: 8),
                        _RatingDisplay(rating: checkIn.rating!),
                      ],
                    ],
                  ),

                  const SizedBox(height: 8),

                  // League name and timestamp row
                  Row(
                    children: [
                      // League chip
                      leagueAsync.when(
                        data: (league) => _LeagueChip(
                          leagueName: league?.name ?? l10n.league,
                        ),
                        loading: () => const _LeagueChip(
                          leagueName: '...',
                          isLoading: true,
                        ),
                        error: (_, _) => _LeagueChip(
                          leagueName: l10n.league,
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Timestamp
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _formatTimestamp(context, checkIn.timestamp),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  // Note (if present)
                  if (checkIn.hasNote) ...[
                    const SizedBox(height: 8),
                    Text(
                      checkIn.note!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(BuildContext context, DateTime timestamp) {
    final l10n = context.l10n;
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return l10n.justNow;
        }
        return l10n.minutesAgo(difference.inMinutes);
      }
      return l10n.hoursAgo(difference.inHours);
    } else if (difference.inDays == 1) {
      return l10n.yesterday;
    } else if (difference.inDays < 7) {
      return l10n.daysAgo(difference.inDays);
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return weeks == 1 ? l10n.weekAgo(weeks) : l10n.weeksAgo(weeks);
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return months == 1 ? l10n.monthAgo(months) : l10n.monthsAgo(months);
    } else {
      final years = (difference.inDays / 365).floor();
      return years == 1 ? l10n.yearAgo(years) : l10n.yearsAgo(years);
    }
  }
}

/// Widget for displaying the rating stars
class _RatingDisplay extends StatelessWidget {
  const _RatingDisplay({required this.rating});

  final int rating;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star_rounded : Icons.star_outline_rounded,
          size: 16,
          color: index < rating
              ? colorScheme.primary
              : colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
        );
      }),
    );
  }
}

/// Widget for displaying the league name chip
class _LeagueChip extends StatelessWidget {
  const _LeagueChip({
    required this.leagueName,
    this.isLoading = false,
  });

  final String leagueName;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.emoji_events_outlined,
            size: 14,
            color: colorScheme.onSecondaryContainer,
          ),
          const SizedBox(width: 4),
          if (isLoading)
            SizedBox(
              width: 40,
              height: 10,
              child: LinearProgressIndicator(
                backgroundColor: colorScheme.onSecondaryContainer.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation(colorScheme.onSecondaryContainer),
              ),
            )
          else
            Text(
              leagueName,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}
