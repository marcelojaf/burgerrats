import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// A reusable widget for displaying cached network images with loading and error states.
///
/// Uses [CachedNetworkImage] for efficient loading with disk caching.
class CachedPhotoWidget extends StatelessWidget {
  const CachedPhotoWidget({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.onTap,
    this.heroTag,
  });

  /// The URL of the image to display.
  final String imageUrl;

  /// How the image should fit within its bounds.
  final BoxFit fit;

  /// Optional fixed width for the image container.
  final double? width;

  /// Optional fixed height for the image container.
  final double? height;

  /// Optional border radius for rounding corners.
  final BorderRadius? borderRadius;

  /// Custom placeholder widget shown while loading.
  final Widget? placeholder;

  /// Custom error widget shown when loading fails.
  final Widget? errorWidget;

  /// Callback when the image is tapped.
  final VoidCallback? onTap;

  /// Hero animation tag for shared element transitions.
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget imageWidget = CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      placeholder: (context, url) =>
          placeholder ??
          Container(
            color: colorScheme.surfaceContainerHighest,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      errorWidget: (context, url, error) =>
          errorWidget ??
          Container(
            color: colorScheme.surfaceContainerHighest,
            child: Center(
              child: Icon(
                Icons.broken_image_outlined,
                size: 48,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
    );

    // Apply border radius if provided
    if (borderRadius != null) {
      imageWidget = ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    // Wrap with Hero animation if tag provided
    if (heroTag != null) {
      imageWidget = Hero(
        tag: heroTag!,
        child: imageWidget,
      );
    }

    // Add tap gesture if callback provided
    if (onTap != null) {
      imageWidget = GestureDetector(
        onTap: onTap,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}

/// A compact version of [CachedPhotoWidget] optimized for grid/thumbnail views.
class CachedPhotoThumbnail extends StatelessWidget {
  const CachedPhotoThumbnail({
    super.key,
    required this.imageUrl,
    this.size = 100,
    this.borderRadius = 8,
    this.onTap,
    this.heroTag,
  });

  /// The URL of the image to display.
  final String imageUrl;

  /// Size of the thumbnail (width and height).
  final double size;

  /// Border radius for rounding corners.
  final double borderRadius;

  /// Callback when the thumbnail is tapped.
  final VoidCallback? onTap;

  /// Hero animation tag for shared element transitions.
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CachedPhotoWidget(
      imageUrl: imageUrl,
      width: size,
      height: size,
      fit: BoxFit.cover,
      borderRadius: BorderRadius.circular(borderRadius),
      onTap: onTap,
      heroTag: heroTag,
      placeholder: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      errorWidget: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Icon(
          Icons.broken_image_outlined,
          size: 24,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
