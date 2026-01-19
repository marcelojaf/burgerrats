import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as path;

import '../errors/error_handler.dart';
import '../errors/error_messages.dart';
import '../errors/exceptions.dart';

/// Result of a storage upload operation
class UploadResult {
  /// The download URL of the uploaded file
  final String downloadUrl;

  /// The storage path where the file was uploaded
  final String storagePath;

  /// The file name
  final String fileName;

  /// The file size in bytes
  final int sizeInBytes;

  /// The content type (MIME type)
  final String? contentType;

  /// Upload timestamp
  final DateTime uploadedAt;

  /// Custom metadata
  final Map<String, String>? metadata;

  const UploadResult({
    required this.downloadUrl,
    required this.storagePath,
    required this.fileName,
    required this.sizeInBytes,
    this.contentType,
    required this.uploadedAt,
    this.metadata,
  });

  @override
  String toString() {
    return 'UploadResult(fileName: $fileName, size: $sizeInBytes bytes, url: $downloadUrl)';
  }
}

/// Configuration options for file uploads
class UploadOptions {
  /// Custom metadata to attach to the file
  final Map<String, String>? metadata;

  /// Content type override (auto-detected if not provided)
  final String? contentType;

  /// Whether to generate a unique filename with timestamp
  final bool useTimestampFilename;

  /// Custom file name (if not using timestamp)
  final String? customFileName;

  /// Cache control header value
  final String? cacheControl;

  const UploadOptions({
    this.metadata,
    this.contentType,
    this.useTimestampFilename = true,
    this.customFileName,
    this.cacheControl,
  });

  /// Default options for check-in photos
  static const UploadOptions checkInPhoto = UploadOptions(
    useTimestampFilename: true,
    cacheControl: 'public, max-age=31536000', // 1 year cache
  );

  /// Default options for profile photos
  static const UploadOptions profilePhoto = UploadOptions(
    useTimestampFilename: true,
    cacheControl: 'public, max-age=86400', // 1 day cache
  );

  /// Default options for temporary uploads
  static const UploadOptions temporary = UploadOptions(
    useTimestampFilename: true,
    cacheControl: 'no-cache',
  );
}

/// Upload progress callback
typedef UploadProgressCallback = void Function(double progress);

/// Service for uploading and managing files in Firebase Storage
///
/// This service provides secure file upload functionality with:
/// - Organization by user and date
/// - Automatic secure download URL generation
/// - Progress tracking
/// - Portuguese error messages
///
/// Usage:
/// ```dart
/// final storageService = getIt<FirebaseStorageService>();
///
/// // Upload a check-in photo
/// final result = await storageService.uploadCheckInPhoto(
///   userId: 'user123',
///   leagueId: 'league456',
///   file: imageFile,
///   onProgress: (progress) => print('Upload: ${(progress * 100).toInt()}%'),
/// );
///
/// print('Photo uploaded: ${result.downloadUrl}');
/// ```
@lazySingleton
class FirebaseStorageService {
  final FirebaseStorage _storage;

  FirebaseStorageService(this._storage);

  /// Maximum file size allowed (10MB)
  static const int maxFileSizeBytes = 10 * 1024 * 1024;

  /// Allowed image MIME types
  static const List<String> allowedImageTypes = [
    'image/jpeg',
    'image/jpg',
    'image/png',
    'image/webp',
    'image/heic',
    'image/heif',
  ];

  /// Upload a check-in photo organized by user and date
  ///
  /// Files are stored in: check-ins/{userId}/{year}/{month}/{day}/{filename}
  ///
  /// [userId] - The ID of the user uploading the photo
  /// [leagueId] - The ID of the league for the check-in
  /// [file] - The image file to upload
  /// [options] - Upload configuration options
  /// [onProgress] - Optional callback for upload progress (0.0 to 1.0)
  ///
  /// Returns [UploadResult] with download URL and metadata.
  /// Throws [StorageException] on failure.
  Future<UploadResult> uploadCheckInPhoto({
    required String userId,
    required String leagueId,
    required File file,
    UploadOptions options = UploadOptions.checkInPhoto,
    UploadProgressCallback? onProgress,
  }) async {
    // Validate file
    await _validateFile(file);

    // Generate path organized by user and date
    final now = DateTime.now();
    final year = now.year.toString();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');

    final fileName = _generateFileName(file.path, options);
    final storagePath = 'check-ins/$userId/$year/$month/$day/$fileName';

    // Add league ID to metadata
    final metadata = <String, String>{
      'userId': userId,
      'leagueId': leagueId,
      'uploadedAt': now.toIso8601String(),
      ...?options.metadata,
    };

    return _uploadFile(
      file: file,
      storagePath: storagePath,
      options: options.copyWith(metadata: metadata),
      onProgress: onProgress,
    );
  }

  /// Upload a profile photo
  ///
  /// Files are stored in: profile-photos/{userId}/{filename}
  ///
  /// [userId] - The ID of the user
  /// [file] - The image file to upload
  /// [options] - Upload configuration options
  /// [onProgress] - Optional callback for upload progress
  ///
  /// Returns [UploadResult] with download URL and metadata.
  /// Throws [StorageException] on failure.
  Future<UploadResult> uploadProfilePhoto({
    required String userId,
    required File file,
    UploadOptions options = UploadOptions.profilePhoto,
    UploadProgressCallback? onProgress,
  }) async {
    await _validateFile(file);

    final fileName = _generateFileName(file.path, options);
    final storagePath = 'profile-photos/$userId/$fileName';

    final metadata = <String, String>{
      'userId': userId,
      'uploadedAt': DateTime.now().toIso8601String(),
      ...?options.metadata,
    };

    return _uploadFile(
      file: file,
      storagePath: storagePath,
      options: options.copyWith(metadata: metadata),
      onProgress: onProgress,
    );
  }

  /// Upload a file from bytes
  ///
  /// [bytes] - The file bytes to upload
  /// [storagePath] - The full path in storage
  /// [options] - Upload configuration options
  /// [onProgress] - Optional callback for upload progress
  ///
  /// Returns [UploadResult] with download URL and metadata.
  /// Throws [StorageException] on failure.
  Future<UploadResult> uploadBytes({
    required Uint8List bytes,
    required String storagePath,
    UploadOptions options = const UploadOptions(),
    UploadProgressCallback? onProgress,
  }) async {
    // Validate size
    if (bytes.length > maxFileSizeBytes) {
      throw const StorageException(
        message: ErrorMessages.fileTooLarge,
        code: 'file-too-large',
      );
    }

    try {
      final ref = _storage.ref().child(storagePath);

      // Build metadata
      final settableMetadata = SettableMetadata(
        contentType: options.contentType ?? 'application/octet-stream',
        cacheControl: options.cacheControl,
        customMetadata: options.metadata,
      );

      // Start upload
      final uploadTask = ref.putData(bytes, settableMetadata);

      // Track progress
      if (onProgress != null) {
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          final progress = snapshot.bytesTransferred / snapshot.totalBytes;
          onProgress(progress);
        });
      }

      // Wait for completion
      await uploadTask;

      // Get download URL
      final downloadUrl = await ref.getDownloadURL();

      return UploadResult(
        downloadUrl: downloadUrl,
        storagePath: storagePath,
        fileName: path.basename(storagePath),
        sizeInBytes: bytes.length,
        contentType: options.contentType,
        uploadedAt: DateTime.now(),
        metadata: options.metadata,
      );
    } on FirebaseException catch (e) {
      throw StorageException(
        message: ErrorMessages.getMessageForCode(e.code),
        code: e.code,
        originalError: e,
      );
    } catch (e, stackTrace) {
      final exception = ErrorHandler.handleError(e, stackTrace);
      throw StorageException(
        message: exception.message,
        code: exception.code,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Delete a file from storage
  ///
  /// [storagePath] - The full path to the file in storage
  ///
  /// Throws [StorageException] on failure.
  Future<void> deleteFile(String storagePath) async {
    try {
      final ref = _storage.ref().child(storagePath);
      await ref.delete();
    } on FirebaseException catch (e) {
      throw StorageException(
        message: ErrorMessages.getMessageForCode(e.code),
        code: e.code,
        originalError: e,
      );
    } catch (e, stackTrace) {
      final exception = ErrorHandler.handleError(e, stackTrace);
      throw StorageException(
        message: exception.message,
        code: exception.code,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Get a secure download URL for a file
  ///
  /// [storagePath] - The full path to the file in storage
  ///
  /// Returns the download URL string.
  /// Throws [StorageException] if file not found or on failure.
  Future<String> getDownloadUrl(String storagePath) async {
    try {
      final ref = _storage.ref().child(storagePath);
      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw StorageException(
        message: ErrorMessages.getMessageForCode(e.code),
        code: e.code,
        originalError: e,
      );
    } catch (e, stackTrace) {
      final exception = ErrorHandler.handleError(e, stackTrace);
      throw StorageException(
        message: exception.message,
        code: exception.code,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Get file metadata
  ///
  /// [storagePath] - The full path to the file in storage
  ///
  /// Returns the file metadata.
  /// Throws [StorageException] if file not found or on failure.
  Future<FullMetadata> getFileMetadata(String storagePath) async {
    try {
      final ref = _storage.ref().child(storagePath);
      return await ref.getMetadata();
    } on FirebaseException catch (e) {
      throw StorageException(
        message: ErrorMessages.getMessageForCode(e.code),
        code: e.code,
        originalError: e,
      );
    } catch (e, stackTrace) {
      final exception = ErrorHandler.handleError(e, stackTrace);
      throw StorageException(
        message: exception.message,
        code: exception.code,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// List all check-in photos for a user on a specific date
  ///
  /// [userId] - The user ID
  /// [date] - The date to list photos for
  ///
  /// Returns list of storage paths for the photos.
  Future<List<String>> listCheckInPhotos({
    required String userId,
    required DateTime date,
  }) async {
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final prefix = 'check-ins/$userId/$year/$month/$day/';

    try {
      final ref = _storage.ref().child(prefix);
      final result = await ref.listAll();
      return result.items.map((item) => item.fullPath).toList();
    } on FirebaseException catch (e) {
      throw StorageException(
        message: ErrorMessages.getMessageForCode(e.code),
        code: e.code,
        originalError: e,
      );
    } catch (e, stackTrace) {
      final exception = ErrorHandler.handleError(e, stackTrace);
      throw StorageException(
        message: exception.message,
        code: exception.code,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Internal method to upload a file
  Future<UploadResult> _uploadFile({
    required File file,
    required String storagePath,
    required UploadOptions options,
    UploadProgressCallback? onProgress,
  }) async {
    try {
      final ref = _storage.ref().child(storagePath);
      final fileSize = await file.length();

      // Detect content type
      final contentType = options.contentType ?? _getContentType(file.path);

      // Build metadata
      final settableMetadata = SettableMetadata(
        contentType: contentType,
        cacheControl: options.cacheControl,
        customMetadata: options.metadata,
      );

      // Start upload
      final uploadTask = ref.putFile(file, settableMetadata);

      // Track progress
      if (onProgress != null) {
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          final progress = snapshot.bytesTransferred / snapshot.totalBytes;
          onProgress(progress);
        });
      }

      // Wait for completion
      await uploadTask;

      // Get download URL
      final downloadUrl = await ref.getDownloadURL();

      return UploadResult(
        downloadUrl: downloadUrl,
        storagePath: storagePath,
        fileName: path.basename(storagePath),
        sizeInBytes: fileSize,
        contentType: contentType,
        uploadedAt: DateTime.now(),
        metadata: options.metadata,
      );
    } on FirebaseException catch (e) {
      throw StorageException(
        message: ErrorMessages.getMessageForCode(e.code),
        code: e.code,
        originalError: e,
      );
    } catch (e, stackTrace) {
      final exception = ErrorHandler.handleError(e, stackTrace);
      throw StorageException(
        message: exception.message,
        code: exception.code,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Validate file before upload
  Future<void> _validateFile(File file) async {
    // Check file exists
    if (!await file.exists()) {
      throw const StorageException(
        message: ErrorMessages.imageFileNotFound,
        code: 'file-not-found',
      );
    }

    // Check file size
    final fileSize = await file.length();
    if (fileSize > maxFileSizeBytes) {
      throw const StorageException(
        message: ErrorMessages.fileTooLarge,
        code: 'file-too-large',
      );
    }

    // Check content type
    final contentType = _getContentType(file.path);
    if (!allowedImageTypes.contains(contentType)) {
      throw const StorageException(
        message: ErrorMessages.invalidFileType,
        code: 'invalid-file-type',
      );
    }
  }

  /// Generate a unique filename
  String _generateFileName(String originalPath, UploadOptions options) {
    if (options.customFileName != null) {
      return options.customFileName!;
    }

    final extension = path.extension(originalPath).toLowerCase();
    final baseName = path.basenameWithoutExtension(originalPath);

    if (options.useTimestampFilename) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      return '${baseName}_$timestamp$extension';
    }

    return path.basename(originalPath);
  }

  /// Get content type from file extension
  String _getContentType(String filePath) {
    final extension = path.extension(filePath).toLowerCase();

    return switch (extension) {
      '.jpg' || '.jpeg' => 'image/jpeg',
      '.png' => 'image/png',
      '.webp' => 'image/webp',
      '.heic' => 'image/heic',
      '.heif' => 'image/heif',
      '.gif' => 'image/gif',
      '.pdf' => 'application/pdf',
      _ => 'application/octet-stream',
    };
  }
}

/// Extension to add copyWith to UploadOptions
extension UploadOptionsCopyWith on UploadOptions {
  UploadOptions copyWith({
    Map<String, String>? metadata,
    String? contentType,
    bool? useTimestampFilename,
    String? customFileName,
    String? cacheControl,
  }) {
    return UploadOptions(
      metadata: metadata ?? this.metadata,
      contentType: contentType ?? this.contentType,
      useTimestampFilename: useTimestampFilename ?? this.useTimestampFilename,
      customFileName: customFileName ?? this.customFileName,
      cacheControl: cacheControl ?? this.cacheControl,
    );
  }
}
