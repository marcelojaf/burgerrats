import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as path_utils;
import 'package:share_plus/share_plus.dart';

import '../../features/check_ins/domain/entities/check_in_entity.dart';

/// Service for generating branded shareable images from check-ins.
///
/// Creates images with app branding, check-in photo, restaurant info,
/// and league details for sharing to social media platforms.
@lazySingleton
class ShareableImageService {
  ShareableImageService();

  /// Shares a check-in with a branded image to social media platforms.
  ///
  /// Returns a [ShareResult] indicating the outcome of the share action.
  Future<ShareResult> shareCheckInWithBrandedImage({
    required CheckInEntity checkIn,
    required String leagueName,
    String? customMessage,
  }) async {
    try {
      final imagePath = await _generateShareableImage(
        checkIn: checkIn,
        leagueName: leagueName,
      );

      if (imagePath == null) {
        // Fallback to text-only share if image generation fails
        return _shareTextOnly(checkIn, customMessage);
      }

      final restaurantName = checkIn.displayRestaurantName ?? 'Burger Check-in';
      final message = customMessage ??
          'Confira esse burger no $restaurantName que encontrei no BurgerRats!';

      return Share.shareXFiles(
        [XFile(imagePath)],
        text: message,
        subject: 'Burger Check-in - $restaurantName',
      );
    } catch (e) {
      debugPrint('ShareableImageService: Error sharing: $e');
      return _shareTextOnly(checkIn, customMessage);
    }
  }

  /// Fallback to text-only share.
  Future<ShareResult> _shareTextOnly(CheckInEntity checkIn, String? customMessage) {
    final restaurantName = checkIn.displayRestaurantName ?? 'Burger Check-in';
    final message = customMessage ??
        'Confira esse burger no $restaurantName que encontrei no BurgerRats!';
    return Share.share(message, subject: 'Burger Check-in - $restaurantName');
  }

  /// Generates a shareable branded image from a check-in and league name.
  ///
  /// Returns the file path to the generated image, or null if generation fails.
  Future<String?> _generateShareableImage({
    required CheckInEntity checkIn,
    required String leagueName,
  }) async {
    try {
      // Download the check-in photo using cache manager
      final cacheManager = DefaultCacheManager();
      final file = await cacheManager.getSingleFile(checkIn.photoURL);
      final photoBytes = await file.readAsBytes();

      // Create the branded image
      final brandedImage = await _createBrandedImage(
        photoBytes: photoBytes,
        checkIn: checkIn,
        leagueName: leagueName,
      );
      if (brandedImage == null) return null;

      // Save to temp directory next to the cached file
      final tempDir = file.parent;
      final fileName = 'burgerrats_share_${checkIn.id}_${DateTime.now().millisecondsSinceEpoch}.png';
      final filePath = path_utils.join(tempDir.path, fileName);
      final outputFile = File(filePath);
      await outputFile.writeAsBytes(brandedImage);

      return filePath;
    } catch (e) {
      debugPrint('ShareableImageService: Error generating shareable image: $e');
      return null;
    }
  }

  /// Creates a branded image with the check-in photo and app branding.
  Future<Uint8List?> _createBrandedImage({
    required Uint8List photoBytes,
    required CheckInEntity checkIn,
    required String leagueName,
  }) async {
    try {
      // Decode the original image
      final codec = await ui.instantiateImageCodec(photoBytes);
      final frame = await codec.getNextFrame();
      final originalImage = frame.image;

      // Define output dimensions (optimized for social media - 1080x1350 is good for Instagram)
      const outputWidth = 1080.0;
      const outputHeight = 1350.0;
      const photoSize = 900.0;
      const padding = 32.0;
      const headerHeight = 120.0;

      // Create a picture recorder
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);

      // Draw background gradient
      final backgroundPaint = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFE65100), // Primary orange
            Color(0xFFFF8A50), // Lighter orange
          ],
        ).createShader(const Rect.fromLTWH(0, 0, outputWidth, outputHeight));
      canvas.drawRect(
        const Rect.fromLTWH(0, 0, outputWidth, outputHeight),
        backgroundPaint,
      );

      // Draw header area with app branding
      _drawHeader(canvas, leagueName);

      // Calculate photo position (centered)
      final photoRect = Rect.fromCenter(
        center: const Offset(outputWidth / 2, headerHeight + padding + photoSize / 2),
        width: photoSize,
        height: photoSize,
      );

      // Draw photo with rounded corners
      _drawRoundedImage(canvas, originalImage, photoRect, 24.0);

      // Draw footer with check-in details
      _drawFooter(canvas, checkIn, headerHeight + padding * 2 + photoSize);

      // Create the image
      final picture = recorder.endRecording();
      final img = await picture.toImage(outputWidth.toInt(), outputHeight.toInt());
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

      originalImage.dispose();
      img.dispose();

      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint('ShareableImageService: Error creating branded image: $e');
      return null;
    }
  }

  /// Draws the header with app branding.
  void _drawHeader(Canvas canvas, String leagueName) {
    const headerHeight = 120.0;
    const outputWidth = 1080.0;

    // Draw semi-transparent overlay for header
    final headerPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.2);
    canvas.drawRect(
      const Rect.fromLTWH(0, 0, outputWidth, headerHeight),
      headerPaint,
    );

    // Draw app name "BurgerRats"
    final appNamePainter = TextPainter(
      text: const TextSpan(
        text: 'BurgerRats',
        style: TextStyle(
          color: Colors.white,
          fontSize: 48,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    appNamePainter.layout();
    appNamePainter.paint(
      canvas,
      Offset((outputWidth - appNamePainter.width) / 2, 20),
    );

    // Draw league name below
    final leaguePainter = TextPainter(
      text: TextSpan(
        text: leagueName,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.9),
          fontSize: 28,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    leaguePainter.layout(maxWidth: outputWidth - 64);
    leaguePainter.paint(
      canvas,
      Offset((outputWidth - leaguePainter.width) / 2, 75),
    );
  }

  /// Draws the footer with check-in details.
  void _drawFooter(Canvas canvas, CheckInEntity checkIn, double topOffset) {
    const outputWidth = 1080.0;
    const footerHeight = 180.0;
    const padding = 32.0;

    // Draw semi-transparent overlay for footer
    final footerPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.3);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(padding, topOffset, outputWidth - padding * 2, footerHeight),
        const Radius.circular(16),
      ),
      footerPaint,
    );

    var currentY = topOffset + 24.0;

    // Draw restaurant name
    final restaurantName = checkIn.displayRestaurantName ?? 'Check-in';
    final restaurantPainter = TextPainter(
      text: TextSpan(
        text: restaurantName,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 36,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
      ellipsis: '...',
    );
    restaurantPainter.layout(maxWidth: outputWidth - padding * 4);
    restaurantPainter.paint(canvas, Offset(padding * 2, currentY));
    currentY += restaurantPainter.height + 16;

    // Draw rating if present
    if (checkIn.hasRating) {
      _drawRating(canvas, checkIn.rating!, padding * 2, currentY);
      currentY += 40;
    }

    // Draw note preview if present
    if (checkIn.hasNote) {
      final notePainter = TextPainter(
        text: TextSpan(
          text: '"${checkIn.note}"',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.85),
            fontSize: 22,
            fontStyle: FontStyle.italic,
          ),
        ),
        textDirection: TextDirection.ltr,
        maxLines: 2,
        ellipsis: '...',
      );
      notePainter.layout(maxWidth: outputWidth - padding * 4);
      notePainter.paint(canvas, Offset(padding * 2, currentY));
    }
  }

  /// Draws star rating.
  void _drawRating(Canvas canvas, int rating, double x, double y) {
    const starSize = 32.0;
    const starSpacing = 4.0;

    for (int i = 0; i < 5; i++) {
      final starPaint = Paint()
        ..color = i < rating ? const Color(0xFFFFD54F) : Colors.white.withValues(alpha: 0.3)
        ..style = PaintingStyle.fill;

      final starX = x + i * (starSize + starSpacing);
      _drawStar(canvas, Offset(starX + starSize / 2, y + starSize / 2), starSize / 2, starPaint);
    }
  }

  /// Draws a 5-pointed star.
  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    const angle = math.pi / 5; // 36 degrees in radians

    for (int i = 0; i < 10; i++) {
      final r = i.isEven ? radius : radius * 0.4;
      final currentAngle = i * angle - math.pi / 2;
      final x = center.dx + r * math.cos(currentAngle);
      final y = center.dy + r * math.sin(currentAngle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  /// Draws an image with rounded corners.
  void _drawRoundedImage(Canvas canvas, ui.Image image, Rect destRect, double radius) {
    // Save canvas state
    canvas.save();

    // Create clipping path with rounded corners
    final rrect = RRect.fromRectAndRadius(destRect, Radius.circular(radius));
    canvas.clipRRect(rrect);

    // Calculate source rect to maintain aspect ratio (center crop)
    final imageAspect = image.width / image.height;
    final destAspect = destRect.width / destRect.height;

    Rect srcRect;
    if (imageAspect > destAspect) {
      // Image is wider, crop horizontally
      final srcWidth = image.height * destAspect;
      final srcX = (image.width - srcWidth) / 2;
      srcRect = Rect.fromLTWH(srcX, 0, srcWidth, image.height.toDouble());
    } else {
      // Image is taller, crop vertically
      final srcHeight = image.width / destAspect;
      final srcY = (image.height - srcHeight) / 2;
      srcRect = Rect.fromLTWH(0, srcY, image.width.toDouble(), srcHeight);
    }

    // Draw image
    canvas.drawImageRect(image, srcRect, destRect, Paint()..filterQuality = FilterQuality.high);

    // Draw border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    canvas.drawRRect(rrect, borderPaint);

    // Restore canvas state
    canvas.restore();
  }
}
