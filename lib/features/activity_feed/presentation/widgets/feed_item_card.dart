import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../domain/entities/activity_feed_entry.dart';

/// Card widget displaying a single activity feed entry
class FeedItemCard extends StatelessWidget {
  final ActivityFeedEntry entry;

  const FeedItemCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _navigateToCheckIn(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with user info
            _FeedItemHeader(entry: entry),

            // Check-in photo
            _FeedItemPhoto(photoURL: entry.photoURL),

            // Content area
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Restaurant name and rating
                  if (entry.restaurantName != null || entry.hasRating)
                    _FeedItemRestaurantInfo(entry: entry),

                  // Note
                  if (entry.hasNote) ...[
                    const SizedBox(height: 8),
                    Text(
                      entry.note!,
                      style: theme.textTheme.bodyMedium,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  // League badge
                  const SizedBox(height: 8),
                  _LeagueBadge(leagueName: entry.leagueName),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCheckIn(BuildContext context) {
    context.push(AppRoutes.checkInDetails.replaceFirst(':checkInId', entry.id));
  }
}

/// Header section with user avatar, name, and timestamp
class _FeedItemHeader extends StatelessWidget {
  final ActivityFeedEntry entry;

  const _FeedItemHeader({required this.entry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // User avatar
          _UserAvatar(
            photoURL: entry.userPhotoURL,
            initials: entry.userInitials,
          ),
          const SizedBox(width: 12),

          // User name and timestamp
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.userName,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _formatTimestamp(entry.timestamp),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Agora';
    } else if (difference.inMinutes < 60) {
      return 'Ha ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Ha ${difference.inHours}h';
    } else if (difference.inDays == 1) {
      return 'Ontem';
    } else if (difference.inDays < 7) {
      return 'Ha ${difference.inDays} dias';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'Ha $weeks ${weeks == 1 ? 'semana' : 'semanas'}';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return 'Ha $months ${months == 1 ? 'mes' : 'meses'}';
    } else {
      final years = (difference.inDays / 365).floor();
      return 'Ha $years ${years == 1 ? 'ano' : 'anos'}';
    }
  }
}

/// User avatar with photo or initials fallback
class _UserAvatar extends StatelessWidget {
  final String? photoURL;
  final String initials;
  final double radius;

  const _UserAvatar({
    this.photoURL,
    required this.initials,
    this.radius = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (photoURL != null && photoURL!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(photoURL!),
        onBackgroundImageError: (_, _) {},
        child: null,
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: colorScheme.primaryContainer,
      child: Text(
        initials,
        style: TextStyle(
          color: colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.7,
        ),
      ),
    );
  }
}

/// Check-in photo display
class _FeedItemPhoto extends StatelessWidget {
  final String photoURL;

  const _FeedItemPhoto({required this.photoURL});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Image.network(
        photoURL,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Center(
              child: Icon(
                Icons.broken_image_outlined,
                size: 48,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Restaurant name and rating row
class _FeedItemRestaurantInfo extends StatelessWidget {
  final ActivityFeedEntry entry;

  const _FeedItemRestaurantInfo({required this.entry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        if (entry.restaurantName != null) ...[
          Icon(Icons.restaurant, size: 16, color: colorScheme.primary),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              entry.restaurantName!,
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ] else
          const Spacer(),
        if (entry.hasRating) ...[
          const SizedBox(width: 8),
          _RatingStars(rating: entry.rating!),
        ],
      ],
    );
  }
}

/// Star rating display
class _RatingStars extends StatelessWidget {
  final int rating;

  const _RatingStars({required this.rating});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_outline,
          size: 16,
          color: index < rating
              ? Colors.amber
              : colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        );
      }),
    );
  }
}

/// League badge chip
class _LeagueBadge extends StatelessWidget {
  final String leagueName;

  const _LeagueBadge({required this.leagueName});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
            Icons.emoji_events,
            size: 14,
            color: colorScheme.onSecondaryContainer,
          ),
          const SizedBox(width: 4),
          Text(
            leagueName,
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
