import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/di/injection.dart';
import '../../../core/services/shareable_image_service.dart';
import '../../../features/check_ins/domain/entities/check_in_entity.dart';
import '../../../features/leagues/domain/repositories/league_repository.dart';

/// A fullscreen photo viewer with swipe navigation between photos.
///
/// Supports:
/// - Horizontal swipe navigation
/// - Pinch to zoom
/// - Double tap to zoom
/// - Share functionality
/// - Photo details overlay
class FullscreenPhotoViewer extends StatefulWidget {
  const FullscreenPhotoViewer({
    super.key,
    required this.checkIns,
    this.initialIndex = 0,
    this.showDetails = true,
    this.enableShare = true,
  });

  /// List of check-ins to display.
  final List<CheckInEntity> checkIns;

  /// Initial photo index to display.
  final int initialIndex;

  /// Whether to show photo details overlay.
  final bool showDetails;

  /// Whether to enable share functionality.
  final bool enableShare;

  @override
  State<FullscreenPhotoViewer> createState() => _FullscreenPhotoViewerState();
}

class _FullscreenPhotoViewerState extends State<FullscreenPhotoViewer> {
  late PageController _pageController;
  late int _currentIndex;
  bool _showOverlay = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);

    // Set fullscreen mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _pageController.dispose();
    // Restore system UI
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  void _toggleOverlay() {
    setState(() {
      _showOverlay = !_showOverlay;
    });
  }

  Future<void> _sharePhoto() async {
    final checkIn = widget.checkIns[_currentIndex];

    // Show loading indicator
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gerando imagem compartilhavel...'),
          duration: Duration(seconds: 1),
        ),
      );
    }

    // Get league name for branding
    final leagueRepository = getIt<LeagueRepository>();
    final league = await leagueRepository.getLeagueById(checkIn.leagueId);
    final leagueName = league?.name ?? 'Liga BurgerRats';

    // Share with branded image
    final shareService = getIt<ShareableImageService>();
    await shareService.shareCheckInWithBrandedImage(
      checkIn: checkIn,
      leagueName: leagueName,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentCheckIn = widget.checkIns[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Photo PageView
          GestureDetector(
            onTap: _toggleOverlay,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: widget.checkIns.length,
              itemBuilder: (context, index) {
                final checkIn = widget.checkIns[index];
                return _ZoomablePhoto(
                  imageUrl: checkIn.photoURL,
                  heroTag: 'photo_gallery_$index',
                );
              },
            ),
          ),

          // Top overlay (back button, share)
          AnimatedOpacity(
            opacity: _showOverlay ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: IgnorePointer(
              ignoring: !_showOverlay,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.7),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 1.0],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const Spacer(),
                        if (widget.checkIns.length > 1)
                          Text(
                            '${_currentIndex + 1} / ${widget.checkIns.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        const Spacer(),
                        if (widget.enableShare)
                          IconButton(
                            icon: const Icon(Icons.share, color: Colors.white),
                            onPressed: _sharePhoto,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Bottom overlay (photo details)
          if (widget.showDetails)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedOpacity(
                opacity: _showOverlay ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: IgnorePointer(
                  ignoring: !_showOverlay,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.8),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 1.0],
                      ),
                    ),
                    child: SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Restaurant name
                            if (currentCheckIn.displayRestaurantName != null)
                              Text(
                                currentCheckIn.displayRestaurantName!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                            const SizedBox(height: 8),

                            // Rating and timestamp row
                            Row(
                              children: [
                                // Rating
                                if (currentCheckIn.hasRating) ...[
                                  _RatingStars(rating: currentCheckIn.rating!),
                                  const SizedBox(width: 16),
                                ],

                                // Timestamp
                                Icon(
                                  Icons.access_time,
                                  size: 14,
                                  color: Colors.white.withValues(alpha: 0.7),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _formatTimestamp(currentCheckIn.timestamp),
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.7),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),

                            // Note (if present)
                            if (currentCheckIn.hasNote) ...[
                              const SizedBox(height: 8),
                              Text(
                                currentCheckIn.note!,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 14,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Page indicators (dots)
          if (widget.checkIns.length > 1)
            Positioned(
              left: 0,
              right: 0,
              bottom: widget.showDetails ? 140 : 24,
              child: AnimatedOpacity(
                opacity: _showOverlay ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: _PageIndicators(
                  count: widget.checkIns.length,
                  currentIndex: _currentIndex,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Agora mesmo';
        }
        return 'Ha ${difference.inMinutes} min';
      }
      return 'Ha ${difference.inHours}h';
    } else if (difference.inDays == 1) {
      return 'Ontem';
    } else if (difference.inDays < 7) {
      return 'Ha ${difference.inDays} dias';
    } else {
      return '${timestamp.day.toString().padLeft(2, '0')}/${timestamp.month.toString().padLeft(2, '0')}/${timestamp.year}';
    }
  }
}

/// Zoomable photo widget with pinch and double-tap zoom support.
class _ZoomablePhoto extends StatefulWidget {
  const _ZoomablePhoto({
    required this.imageUrl,
    this.heroTag,
  });

  final String imageUrl;
  final String? heroTag;

  @override
  State<_ZoomablePhoto> createState() => _ZoomablePhotoState();
}

class _ZoomablePhotoState extends State<_ZoomablePhoto>
    with SingleTickerProviderStateMixin {
  late TransformationController _transformationController;
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;

  final double _minScale = 1.0;
  final double _maxScale = 4.0;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() {
        if (_animation != null) {
          _transformationController.value = _animation!.value;
        }
      });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onDoubleTap() {
    final currentScale = _transformationController.value.getMaxScaleOnAxis();

    Matrix4 endValue;
    if (currentScale > _minScale) {
      // Zoom out to original
      endValue = Matrix4.identity();
    } else {
      // Zoom in to 2x
      endValue = Matrix4.identity()..scale(2.0);
    }

    _animation = Matrix4Tween(
      begin: _transformationController.value,
      end: endValue,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = CachedNetworkImage(
      imageUrl: widget.imageUrl,
      fit: BoxFit.contain,
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
      errorWidget: (context, url, error) => const Center(
        child: Icon(
          Icons.broken_image_outlined,
          size: 64,
          color: Colors.white54,
        ),
      ),
    );

    if (widget.heroTag != null) {
      imageWidget = Hero(
        tag: widget.heroTag!,
        child: imageWidget,
      );
    }

    return GestureDetector(
      onDoubleTap: _onDoubleTap,
      child: InteractiveViewer(
        transformationController: _transformationController,
        minScale: _minScale,
        maxScale: _maxScale,
        child: Center(child: imageWidget),
      ),
    );
  }
}

/// Rating stars display widget.
class _RatingStars extends StatelessWidget {
  const _RatingStars({required this.rating});

  final int rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star_rounded : Icons.star_outline_rounded,
          size: 16,
          color: index < rating
              ? Colors.amber
              : Colors.white.withValues(alpha: 0.3),
        );
      }),
    );
  }
}

/// Page indicator dots.
class _PageIndicators extends StatelessWidget {
  const _PageIndicators({
    required this.count,
    required this.currentIndex,
  });

  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    // Limit visible dots to avoid overflow
    const maxVisibleDots = 7;

    if (count <= maxVisibleDots) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(count, (index) {
          return _buildDot(index == currentIndex);
        }),
      );
    }

    // For many items, show scrolling dots
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (currentIndex > 0)
          Text(
            '...',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 12,
            ),
          ),
        ...List.generate(
          3,
          (i) {
            final index = currentIndex - 1 + i;
            if (index < 0 || index >= count) {
              return const SizedBox(width: 8);
            }
            return _buildDot(index == currentIndex);
          },
        ),
        if (currentIndex < count - 1)
          Text(
            '...',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 12,
            ),
          ),
      ],
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 10 : 6,
      height: isActive ? 10 : 6,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.4),
      ),
    );
  }
}
