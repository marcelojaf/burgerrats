import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart'
    as compress;
import 'package:injectable/injectable.dart';

import '../errors/exceptions.dart';
import '../errors/error_messages.dart';

/// Result of an image compression operation
class CompressionResult {
  /// The compressed image file
  final File file;

  /// The original file path
  final String originalPath;

  /// The compressed file path
  final String compressedPath;

  /// Original file size in bytes
  final int originalSizeInBytes;

  /// Compressed file size in bytes
  final int compressedSizeInBytes;

  /// Compression ratio (0.0 to 1.0, where lower is more compressed)
  final double compressionRatio;

  /// Percentage of size saved
  final double savedPercentage;

  /// The width of the compressed image
  final int? width;

  /// The height of the compressed image
  final int? height;

  const CompressionResult({
    required this.file,
    required this.originalPath,
    required this.compressedPath,
    required this.originalSizeInBytes,
    required this.compressedSizeInBytes,
    required this.compressionRatio,
    required this.savedPercentage,
    this.width,
    this.height,
  });

  /// Read the compressed file bytes
  Future<Uint8List> readAsBytes() async {
    return file.readAsBytes();
  }

  @override
  String toString() {
    return 'CompressionResult(originalSize: $originalSizeInBytes, '
        'compressedSize: $compressedSizeInBytes, '
        'saved: ${savedPercentage.toStringAsFixed(1)}%)';
  }
}

/// Output format for compressed images
enum ImageFormat {
  /// JPEG format - best for photos with lossy compression
  jpeg,

  /// PNG format - lossless compression, larger file size
  png,

  /// WebP format - modern format with excellent compression
  webp,

  /// HEIC format - iOS native format with excellent compression
  heic,
}

/// Configuration options for image compression
class CompressionOptions {
  /// Maximum width for the compressed image (in pixels)
  /// If null, keeps the original width
  final int? maxWidth;

  /// Maximum height for the compressed image (in pixels)
  /// If null, keeps the original height
  final int? maxHeight;

  /// Quality level (1-100)
  /// Higher values mean better quality but larger file size
  final int quality;

  /// Output format for the compressed image
  final ImageFormat format;

  /// Whether to keep EXIF data (orientation, camera info, etc.)
  final bool keepExif;

  /// Minimum width threshold - images smaller than this won't be compressed
  final int? minWidth;

  /// Minimum height threshold - images smaller than this won't be compressed
  final int? minHeight;

  const CompressionOptions({
    this.maxWidth,
    this.maxHeight,
    this.quality = 85,
    this.format = ImageFormat.jpeg,
    this.keepExif = false,
    this.minWidth,
    this.minHeight,
  });

  /// Default options optimized for check-in photos
  /// Resizes to max 1920px, 85% quality JPEG
  static const CompressionOptions checkInDefaults = CompressionOptions(
    maxWidth: 1920,
    maxHeight: 1920,
    quality: 85,
    format: ImageFormat.jpeg,
    keepExif: false,
  );

  /// Options for thumbnail generation
  /// Resizes to max 300px, 70% quality JPEG
  static const CompressionOptions thumbnail = CompressionOptions(
    maxWidth: 300,
    maxHeight: 300,
    quality: 70,
    format: ImageFormat.jpeg,
    keepExif: false,
  );

  /// Options for profile photos
  /// Resizes to max 500px, 80% quality JPEG
  static const CompressionOptions profilePhoto = CompressionOptions(
    maxWidth: 500,
    maxHeight: 500,
    quality: 80,
    format: ImageFormat.jpeg,
    keepExif: false,
  );

  /// Options for maximum compression (smallest file size)
  /// Resizes to max 1280px, 60% quality JPEG
  static const CompressionOptions maxCompression = CompressionOptions(
    maxWidth: 1280,
    maxHeight: 1280,
    quality: 60,
    format: ImageFormat.jpeg,
    keepExif: false,
  );

  /// Options for high quality (minimal compression)
  /// Resizes to max 2560px, 95% quality JPEG
  static const CompressionOptions highQuality = CompressionOptions(
    maxWidth: 2560,
    maxHeight: 2560,
    quality: 95,
    format: ImageFormat.jpeg,
    keepExif: true,
  );

  /// Create custom options with specific target file size in KB
  /// Uses quality estimation based on typical compression ratios
  static CompressionOptions forTargetSize(int targetKb) {
    // Estimate quality based on target size
    // These are rough estimates, actual results vary by image content
    int quality;
    int maxDimension;

    if (targetKb <= 100) {
      quality = 50;
      maxDimension = 800;
    } else if (targetKb <= 250) {
      quality = 65;
      maxDimension = 1200;
    } else if (targetKb <= 500) {
      quality = 75;
      maxDimension = 1600;
    } else if (targetKb <= 1000) {
      quality = 85;
      maxDimension = 1920;
    } else {
      quality = 90;
      maxDimension = 2560;
    }

    return CompressionOptions(
      maxWidth: maxDimension,
      maxHeight: maxDimension,
      quality: quality,
      format: ImageFormat.jpeg,
      keepExif: false,
    );
  }
}

/// Service for compressing and optimizing images before upload
///
/// This service provides efficient image compression with configurable
/// quality and size options to reduce storage costs and improve performance.
///
/// Usage:
/// ```dart
/// final result = await imageCompressionService.compressImage(
///   '/path/to/image.jpg',
///   options: CompressionOptions.checkInDefaults,
/// );
/// print('Saved ${result.savedPercentage}% of file size');
/// ```
@lazySingleton
class ImageCompressionService {
  ImageCompressionService();

  /// Compress an image file with the specified options
  ///
  /// [filePath] - Path to the source image file
  /// [options] - Compression configuration options
  ///
  /// Returns [CompressionResult] with the compressed file and metadata.
  /// Throws [CompressionException] if compression fails.
  Future<CompressionResult> compressImage(
    String filePath, {
    CompressionOptions options = CompressionOptions.checkInDefaults,
  }) async {
    final file = File(filePath);

    // Validate file exists
    if (!await file.exists()) {
      throw CompressionException(
        message: ErrorMessages.imageFileNotFound,
        code: 'image-file-not-found',
      );
    }

    // Get original file size
    final originalSize = await file.length();

    try {
      // Perform compression
      final compressedBytes = await _compressFile(file, options);

      if (compressedBytes == null) {
        throw CompressionException(
          message: ErrorMessages.compressionFailed,
          code: 'compression-failed',
        );
      }

      // Generate output path
      final outputPath = _generateOutputPath(filePath, options.format);

      // Write compressed file
      final compressedFile = File(outputPath);
      await compressedFile.writeAsBytes(compressedBytes);

      // Calculate compression stats
      final compressedSize = compressedBytes.length;
      final compressionRatio = compressedSize / originalSize;
      final savedPercentage = (1 - compressionRatio) * 100;

      return CompressionResult(
        file: compressedFile,
        originalPath: filePath,
        compressedPath: outputPath,
        originalSizeInBytes: originalSize,
        compressedSizeInBytes: compressedSize,
        compressionRatio: compressionRatio,
        savedPercentage: savedPercentage,
      );
    } catch (e, stackTrace) {
      if (e is CompressionException) rethrow;

      throw CompressionException(
        message: ErrorMessages.compressionFailed,
        code: 'compression-failed',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Compress image bytes directly
  ///
  /// [bytes] - Source image bytes
  /// [options] - Compression configuration options
  ///
  /// Returns compressed image bytes.
  /// Throws [CompressionException] if compression fails.
  Future<Uint8List> compressBytes(
    Uint8List bytes, {
    CompressionOptions options = CompressionOptions.checkInDefaults,
  }) async {
    try {
      final result = await compress.FlutterImageCompress.compressWithList(
        bytes,
        minWidth: options.maxWidth ?? 1920,
        minHeight: options.maxHeight ?? 1920,
        quality: options.quality,
        format: _mapFormat(options.format),
        keepExif: options.keepExif,
      );

      return result;
    } catch (e, stackTrace) {
      throw CompressionException(
        message: ErrorMessages.compressionFailed,
        code: 'compression-failed',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Compress a PhotoCaptureResult directly
  ///
  /// This is a convenience method that integrates with PhotoCaptureService.
  ///
  /// [captureResult] - Result from PhotoCaptureService.capturePhoto()
  /// [options] - Compression configuration options
  ///
  /// Returns [CompressionResult] with the compressed file.
  Future<CompressionResult> compressPhotoCapture(
    dynamic captureResult, {
    CompressionOptions options = CompressionOptions.checkInDefaults,
  }) async {
    // Access the path from PhotoCaptureResult
    final String path = captureResult.path as String;
    return compressImage(path, options: options);
  }

  /// Check if an image needs compression based on size threshold
  ///
  /// [filePath] - Path to the image file
  /// [maxSizeKb] - Maximum acceptable file size in KB
  ///
  /// Returns true if file exceeds the size threshold.
  Future<bool> needsCompression(String filePath, {int maxSizeKb = 500}) async {
    final file = File(filePath);
    if (!await file.exists()) return false;

    final size = await file.length();
    return size > maxSizeKb * 1024;
  }

  /// Get estimated compressed size without actually compressing
  ///
  /// This is a rough estimate based on typical compression ratios.
  /// Actual results vary significantly based on image content.
  ///
  /// [originalSizeBytes] - Size of the original image in bytes
  /// [options] - Compression options to estimate for
  ///
  /// Returns estimated compressed size in bytes.
  int estimateCompressedSize(
    int originalSizeBytes,
    CompressionOptions options,
  ) {
    // Base compression ratio depends on quality
    double ratio;
    if (options.quality >= 90) {
      ratio = 0.7;
    } else if (options.quality >= 80) {
      ratio = 0.5;
    } else if (options.quality >= 70) {
      ratio = 0.35;
    } else if (options.quality >= 60) {
      ratio = 0.25;
    } else {
      ratio = 0.2;
    }

    // Adjust for resize (if dimensions are smaller, file will be smaller)
    if (options.maxWidth != null && options.maxWidth! < 1920) {
      ratio *= (options.maxWidth! / 1920);
    }

    return (originalSizeBytes * ratio).round();
  }

  /// Compress file using flutter_image_compress
  Future<Uint8List?> _compressFile(
    File file,
    CompressionOptions options,
  ) async {
    return compress.FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: options.maxWidth ?? 1920,
      minHeight: options.maxHeight ?? 1920,
      quality: options.quality,
      format: _mapFormat(options.format),
      keepExif: options.keepExif,
    );
  }

  /// Map our format enum to flutter_image_compress format
  compress.CompressFormat _mapFormat(ImageFormat format) {
    return switch (format) {
      ImageFormat.jpeg => compress.CompressFormat.jpeg,
      ImageFormat.png => compress.CompressFormat.png,
      ImageFormat.webp => compress.CompressFormat.webp,
      ImageFormat.heic => compress.CompressFormat.heic,
    };
  }

  /// Generate output path based on input path and format
  String _generateOutputPath(String inputPath, ImageFormat format) {
    final lastDot = inputPath.lastIndexOf('.');
    final basePath = lastDot > 0 ? inputPath.substring(0, lastDot) : inputPath;
    final extension = _getExtension(format);
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    return '${basePath}_compressed_$timestamp.$extension';
  }

  /// Get file extension for format
  String _getExtension(ImageFormat format) {
    return switch (format) {
      ImageFormat.jpeg => 'jpg',
      ImageFormat.png => 'png',
      ImageFormat.webp => 'webp',
      ImageFormat.heic => 'heic',
    };
  }
}
