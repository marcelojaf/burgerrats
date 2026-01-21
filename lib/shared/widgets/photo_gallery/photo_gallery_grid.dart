import 'package:flutter/material.dart';

import '../../../features/check_ins/domain/entities/check_in_entity.dart';
import '../../extensions/context_extensions.dart';
import 'cached_photo_widget.dart';
import 'fullscreen_photo_viewer.dart';

/// A grid view for displaying check-in photos in a gallery format.
///
/// Supports tapping to open fullscreen viewer with swipe navigation.
class PhotoGalleryGrid extends StatelessWidget {
  const PhotoGalleryGrid({
    super.key,
    required this.checkIns,
    this.crossAxisCount = 3,
    this.crossAxisSpacing = 4,
    this.mainAxisSpacing = 4,
    this.padding = const EdgeInsets.all(4),
    this.onCheckInTap,
    this.enableFullscreenPreview = true,
    this.physics,
    this.shrinkWrap = false,
  });

  /// List of check-ins to display in the gallery.
  final List<CheckInEntity> checkIns;

  /// Number of columns in the grid.
  final int crossAxisCount;

  /// Spacing between columns.
  final double crossAxisSpacing;

  /// Spacing between rows.
  final double mainAxisSpacing;

  /// Padding around the grid.
  final EdgeInsets padding;

  /// Callback when a check-in is tapped (if [enableFullscreenPreview] is false).
  final void Function(CheckInEntity checkIn, int index)? onCheckInTap;

  /// Whether to enable fullscreen photo preview on tap.
  final bool enableFullscreenPreview;

  /// Scroll physics for the grid.
  final ScrollPhysics? physics;

  /// Whether to shrink wrap the grid content.
  final bool shrinkWrap;

  void _openFullscreenViewer(BuildContext context, int initialIndex) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => FullscreenPhotoViewer(
          checkIns: checkIns,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (checkIns.isEmpty) {
      return const _EmptyGalleryView();
    }

    return GridView.builder(
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        childAspectRatio: 1,
      ),
      itemCount: checkIns.length,
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemBuilder: (context, index) {
        final checkIn = checkIns[index];
        return _PhotoGridItem(
          checkIn: checkIn,
          heroTag: 'photo_gallery_$index',
          onTap: () {
            if (enableFullscreenPreview) {
              _openFullscreenViewer(context, index);
            } else {
              onCheckInTap?.call(checkIn, index);
            }
          },
        );
      },
    );
  }
}

/// A sliver version of [PhotoGalleryGrid] for use in CustomScrollView.
class SliverPhotoGalleryGrid extends StatelessWidget {
  const SliverPhotoGalleryGrid({
    super.key,
    required this.checkIns,
    this.crossAxisCount = 3,
    this.crossAxisSpacing = 4,
    this.mainAxisSpacing = 4,
    this.onCheckInTap,
    this.enableFullscreenPreview = true,
  });

  /// List of check-ins to display in the gallery.
  final List<CheckInEntity> checkIns;

  /// Number of columns in the grid.
  final int crossAxisCount;

  /// Spacing between columns.
  final double crossAxisSpacing;

  /// Spacing between rows.
  final double mainAxisSpacing;

  /// Callback when a check-in is tapped (if [enableFullscreenPreview] is false).
  final void Function(CheckInEntity checkIn, int index)? onCheckInTap;

  /// Whether to enable fullscreen photo preview on tap.
  final bool enableFullscreenPreview;

  void _openFullscreenViewer(BuildContext context, int initialIndex) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => FullscreenPhotoViewer(
          checkIns: checkIns,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (checkIns.isEmpty) {
      return const SliverToBoxAdapter(
        child: _EmptyGalleryView(),
      );
    }

    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final checkIn = checkIns[index];
          return _PhotoGridItem(
            checkIn: checkIn,
            heroTag: 'photo_gallery_$index',
            onTap: () {
              if (enableFullscreenPreview) {
                _openFullscreenViewer(context, index);
              } else {
                onCheckInTap?.call(checkIn, index);
              }
            },
          );
        },
        childCount: checkIns.length,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        childAspectRatio: 1,
      ),
    );
  }
}

/// Individual photo item in the gallery grid.
class _PhotoGridItem extends StatelessWidget {
  const _PhotoGridItem({
    required this.checkIn,
    required this.heroTag,
    required this.onTap,
  });

  final CheckInEntity checkIn;
  final String heroTag;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Photo
        CachedPhotoWidget(
          imageUrl: checkIn.photoURL,
          fit: BoxFit.cover,
          borderRadius: BorderRadius.circular(4),
          heroTag: heroTag,
          onTap: onTap,
        ),

        // Rating badge (if present)
        if (checkIn.hasRating)
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.star_rounded,
                    size: 12,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${checkIn.rating}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// Empty state view for when gallery has no photos.
class _EmptyGalleryView extends StatelessWidget {
  const _EmptyGalleryView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: 64,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.noPhotosYet,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.checkInPhotosWillAppearHere,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
