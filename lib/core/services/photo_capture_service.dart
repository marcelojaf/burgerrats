import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

import '../errors/exceptions.dart';
import '../errors/error_messages.dart';
import 'permission_service.dart';

/// Result of a photo capture operation
class PhotoCaptureResult {
  /// The captured photo file
  final File file;

  /// The original file name
  final String fileName;

  /// The file path
  final String path;

  /// The file size in bytes
  final int sizeInBytes;

  /// The MIME type of the image
  final String? mimeType;

  const PhotoCaptureResult({
    required this.file,
    required this.fileName,
    required this.path,
    required this.sizeInBytes,
    this.mimeType,
  });

  /// Read the file bytes
  Future<Uint8List> readAsBytes() async {
    return file.readAsBytes();
  }
}

/// Source for photo capture
enum PhotoSource {
  /// Capture from device camera
  camera,

  /// Select from device gallery
  gallery,
}

/// Configuration options for photo capture
class PhotoCaptureOptions {
  /// Maximum width for the captured image (in pixels)
  final double? maxWidth;

  /// Maximum height for the captured image (in pixels)
  final double? maxHeight;

  /// Image quality (0-100), applicable for JPEG compression
  final int? imageQuality;

  /// Preferred camera for capture (front or rear)
  final CameraDevice preferredCameraDevice;

  /// Whether to request full metadata (EXIF, location, etc.)
  final bool requestFullMetadata;

  const PhotoCaptureOptions({
    this.maxWidth,
    this.maxHeight,
    this.imageQuality = 85,
    this.preferredCameraDevice = CameraDevice.rear,
    this.requestFullMetadata = false,
  });

  /// Default options optimized for check-in photos
  static const PhotoCaptureOptions checkInDefaults = PhotoCaptureOptions(
    maxWidth: 1920,
    maxHeight: 1920,
    imageQuality: 85,
    preferredCameraDevice: CameraDevice.rear,
    requestFullMetadata: false,
  );
}

/// Service for capturing photos from camera or selecting from gallery
///
/// This service integrates with [PermissionService] to handle camera permissions
/// and provides a unified interface for photo capture operations.
///
/// Usage:
/// ```dart
/// final result = await photoCaptureService.capturePhoto(
///   context,
///   source: PhotoSource.camera,
/// );
/// if (result != null) {
///   // Use result.file for upload
/// }
/// ```
@lazySingleton
class PhotoCaptureService {
  final PermissionService _permissionService;
  final ImagePicker _imagePicker;

  PhotoCaptureService(this._permissionService)
      : _imagePicker = ImagePicker();

  /// Capture a photo from the specified source
  ///
  /// [context] - BuildContext for showing permission dialogs
  /// [source] - Whether to use camera or gallery
  /// [options] - Optional capture configuration
  ///
  /// Returns [PhotoCaptureResult] if photo was captured successfully.
  /// Returns null if the user cancelled the operation.
  /// Throws [CameraException] if an error occurs.
  /// Throws [PermissionException] if camera permission is not granted.
  Future<PhotoCaptureResult?> capturePhoto(
    BuildContext context, {
    required PhotoSource source,
    PhotoCaptureOptions options = PhotoCaptureOptions.checkInDefaults,
  }) async {
    // For camera source, we need to check/request permission
    if (source == PhotoSource.camera) {
      final permissionResult =
          await _permissionService.requestCameraWithRationale(context);

      if (permissionResult != PermissionResult.granted) {
        throw PermissionException(
          message: ErrorMessages.cameraPermissionDenied,
          code: 'camera-permission-denied',
          permissionType: 'camera',
        );
      }
    }

    try {
      final XFile? pickedFile = await _pickImage(source, options);

      if (pickedFile == null) {
        // User cancelled the operation
        return null;
      }

      return await _createResult(pickedFile);
    } on CameraException {
      rethrow;
    } catch (e, stackTrace) {
      throw CameraException(
        message: source == PhotoSource.camera
            ? ErrorMessages.cameraCaptureFailed
            : ErrorMessages.gallerySelectionFailed,
        code: source == PhotoSource.camera
            ? 'camera-capture-error'
            : 'gallery-selection-error',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Capture a photo from camera
  ///
  /// Convenience method that calls [capturePhoto] with [PhotoSource.camera].
  Future<PhotoCaptureResult?> captureFromCamera(
    BuildContext context, {
    PhotoCaptureOptions options = PhotoCaptureOptions.checkInDefaults,
  }) {
    return capturePhoto(
      context,
      source: PhotoSource.camera,
      options: options,
    );
  }

  /// Select a photo from gallery
  ///
  /// Convenience method that calls [capturePhoto] with [PhotoSource.gallery].
  Future<PhotoCaptureResult?> selectFromGallery(
    BuildContext context, {
    PhotoCaptureOptions options = PhotoCaptureOptions.checkInDefaults,
  }) {
    return capturePhoto(
      context,
      source: PhotoSource.gallery,
      options: options,
    );
  }

  /// Show a bottom sheet dialog allowing user to choose photo source
  ///
  /// Returns [PhotoSource] selected by user, or null if cancelled.
  Future<PhotoSource?> showSourceSelector(BuildContext context) async {
    return showModalBottomSheet<PhotoSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'Adicionar Foto',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                title: const Text('Tirar Foto'),
                subtitle: const Text('Use a camera do seu dispositivo'),
                onTap: () => Navigator.pop(context, PhotoSource.camera),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.photo_library_outlined,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
                title: const Text('Escolher da Galeria'),
                subtitle: const Text('Selecione uma foto existente'),
                onTap: () => Navigator.pop(context, PhotoSource.gallery),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  /// Capture a photo with source selector
  ///
  /// Shows a bottom sheet allowing the user to choose between camera and gallery,
  /// then captures/selects the photo from the chosen source.
  ///
  /// Returns [PhotoCaptureResult] if photo was captured/selected successfully.
  /// Returns null if the user cancelled at any point.
  Future<PhotoCaptureResult?> captureWithSourceSelector(
    BuildContext context, {
    PhotoCaptureOptions options = PhotoCaptureOptions.checkInDefaults,
  }) async {
    final source = await showSourceSelector(context);
    if (source == null) {
      return null;
    }

    if (!context.mounted) {
      return null;
    }

    return capturePhoto(
      context,
      source: source,
      options: options,
    );
  }

  /// Pick image from the specified source
  Future<XFile?> _pickImage(
    PhotoSource source,
    PhotoCaptureOptions options,
  ) async {
    final imageSource = source == PhotoSource.camera
        ? ImageSource.camera
        : ImageSource.gallery;

    return _imagePicker.pickImage(
      source: imageSource,
      maxWidth: options.maxWidth,
      maxHeight: options.maxHeight,
      imageQuality: options.imageQuality,
      preferredCameraDevice: options.preferredCameraDevice,
      requestFullMetadata: options.requestFullMetadata,
    );
  }

  /// Create a PhotoCaptureResult from the picked file
  Future<PhotoCaptureResult> _createResult(XFile pickedFile) async {
    final file = File(pickedFile.path);
    final stat = await file.stat();

    return PhotoCaptureResult(
      file: file,
      fileName: pickedFile.name,
      path: pickedFile.path,
      sizeInBytes: stat.size,
      mimeType: pickedFile.mimeType,
    );
  }
}
