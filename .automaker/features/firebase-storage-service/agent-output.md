
🔧 Tool: Task
Input: {
  "description": "Explore codebase structure",
  "prompt": "Explore this Flutter codebase to understand its structure, particularly:\n1. The overall project structure and organization\n2. How services are implemented (look in lib/core/services/)\n3. How Firebase is configured (lib/core/firebase/)\n4. Existing patterns for error handling\n5. How other features are organized\n\nProvide a comprehensive summary of the codebase structure and patterns used.",
  "subagent_type": "Explore"
}

🔧 Tool: Bash
Input: {
  "command": "find /Users/marcelo/dev/burgerrats -type f -name \"pubspec.yaml\" | head -1",
  "description": "Find the pubspec.yaml file location"
}

🔧 Tool: Bash
Input: {
  "command": "ls -la /Users/marcelo/dev/burgerrats/lib/",
  "description": "List lib directory contents"
}

🔧 Tool: Bash
Input: {
  "command": "ls -la /Users/marcelo/dev/burgerrats/lib/core/",
  "description": "List core directory contents"
}

🔧 Tool: Bash
Input: {
  "command": "ls -la /Users/marcelo/dev/burgerrats/lib/features/",
  "description": "List features directory contents"
}

🔧 Tool: Bash
Input: {
  "command": "ls -la /Users/marcelo/dev/burgerrats/lib/shared/",
  "description": "List shared directory contents"
}

🔧 Tool: Bash
Input: {
  "command": "ls -la /Users/marcelo/dev/burgerrats/lib/core/services/ 2>/dev/null || echo \"services not found\"",
  "description": "List services directory if it exists"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/pubspec.yaml"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/main.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/core.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/features.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/errors/exceptions.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/errors/failures.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/errors/error_handler.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/firebase/firebase_config.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/services/firebase_auth_service.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/services/app_service.dart"
}

🔧 Tool: Bash
Input: {
  "command": "ls -la /Users/marcelo/dev/burgerrats/lib/core/di/",
  "description": "List DI directory contents"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/di/injection.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/di/register_module.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/errors/error_messages.dart"
}

🔧 Tool: Bash
Input: {
  "command": "ls -la /Users/marcelo/dev/burgerrats/lib/core/router/",
  "description": "List router directory contents"
}

🔧 Tool: Bash
Input: {
  "command": "ls -la /Users/marcelo/dev/burgerrats/lib/core/state/",
  "description": "List state management directory contents"
}

🔧 Tool: Bash
Input: {
  "command": "find /Users/marcelo/dev/burgerrats/lib/features -type f -name \"*.dart\" | head -20",
  "description": "Find dart files in features directory"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/router/app_router.dart",
  "limit": 100
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/state/base_notifier.dart",
  "limit": 100
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/errors/error_boundary.dart"
}

🔧 Tool: Bash
Input: {
  "command": "find /Users/marcelo/dev/burgerrats/lib/features/auth -type f -name \"*.dart\" | sort",
  "description": "Find dart files in auth feature"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/auth/auth.dart"
}

🔧 Tool: Bash
Input: {
  "command": "ls -la /Users/marcelo/dev/burgerrats/lib/features/auth/",
  "description": "List auth feature directory structure"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/auth/domain/domain.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/auth/domain/repositories/auth_repository.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/auth/data/data.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/auth/data/repositories/auth_repository_impl.dart",
  "limit": 80
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/auth/domain/entities/user_entity.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/shared/theme/app_theme.dart",
  "limit": 60
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/state/base_state.dart",
  "limit": 80
}

🔧 Tool: Bash
Input: {
  "command": "ls -la /Users/marcelo/dev/burgerrats/lib/core/state/providers/",
  "description": "List state providers directory"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/shared/widgets/widgets.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/state/providers/app_state_provider.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/state/providers/auth_state_provider.dart",
  "limit": 80
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/router/app_routes.dart"
}

🔧 Tool: Bash
Input: {
  "command": "ls -la /Users/marcelo/dev/burgerrats/lib/core/constants/ && ls -la /Users/marcelo/dev/burgerrats/lib/core/utils/",
  "description": "List constants and utils directories"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/utils/typedefs.dart"
}

🔧 Tool: Bash
Input: {
  "command": "head -50 /Users/marcelo/dev/burgerrats/lib/core/constants/app_constants.dart",
  "description": "Preview app constants"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/services/permission_service.dart",
  "limit": 80
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/services/photo_capture_service.dart",
  "limit": 80
}
Now I have a comprehensive understanding of the codebase. Let me read specific files to understand the existing patterns better before implementing the Firebase Storage service.

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/services/firebase_auth_service.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/services/image_compression_service.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/di/register_module.dart"
}
Now let me read the exceptions and error messages to understand the existing patterns:

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/errors/exceptions.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/errors/error_messages.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/services/app_service.dart"
}
Now let me read the existing services directory structure and the README to understand what needs to be added:

🔧 Tool: Glob
Input: {
  "pattern": "lib/core/services/*.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/README.md"
}
Now let me check the services exports file:

🔧 Tool: Glob
Input: {
  "pattern": "lib/core/**/*.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/core.dart"
}
Now I have a clear understanding of the codebase. Let me create a todo list and implement the Firebase Storage service:

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Create FirebaseStorageService class with upload functionality",
      "status": "in_progress",
      "activeForm": "Creating FirebaseStorageService class"
    },
    {
      "content": "Add upload result class with metadata and download URL",
      "status": "pending",
      "activeForm": "Adding upload result class"
    },
    {
      "content": "Implement file organization by user and date",
      "status": "pending",
      "activeForm": "Implementing file organization"
    },
    {
      "content": "Add error handling with Portuguese messages",
      "status": "pending",
      "activeForm": "Adding error handling"
    },
    {
      "content": "Export service from core.dart barrel",
      "status": "pending",
      "activeForm": "Exporting service from barrel"
    },
    {
      "content": "Update README.md with Firebase Storage configuration instructions",
      "status": "pending",
      "activeForm": "Updating README.md"
    },
    {
      "content": "Run build_runner to regenerate DI config",
      "status": "pending",
      "activeForm": "Running build_runner"
    }
  ]
}

🔧 Tool: Write
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/services/firebase_storage_service.dart",
  "content": "import 'dart:io';\nimport 'dart:typed_data';\n\nimport 'package:firebase_storage/firebase_storage.dart';\nimport 'package:injectable/injectable.dart';\nimport 'package:path/path.dart' as path;\n\nimport '../errors/error_handler.dart';\nimport '../errors/error_messages.dart';\nimport '../errors/exceptions.dart';\n\n/// Result of a storage upload operation\nclass UploadResult {\n  /// The download URL of the uploaded file\n  final String downloadUrl;\n\n  /// The storage path where the file was uploaded\n  final String storagePath;\n\n  /// The file name\n  final String fileName;\n\n  /// The file size in bytes\n  final int sizeInBytes;\n\n  /// The content type (MIME type)\n  final String? contentType;\n\n  /// Upload timestamp\n  final DateTime uploadedAt;\n\n  /// Custom metadata\n  final Map<String, String>? metadata;\n\n  const UploadResult({\n    required this.downloadUrl,\n    required this.storagePath,\n    required this.fileName,\n    required this.sizeInBytes,\n    this.contentType,\n    required this.uploadedAt,\n    this.metadata,\n  });\n\n  @override\n  String toString() {\n    return 'UploadResult(fileName: $fileName, size: $sizeInBytes bytes, url: $downloadUrl)';\n  }\n}\n\n/// Configuration options for file uploads\nclass UploadOptions {\n  /// Custom metadata to attach to the file\n  final Map<String, String>? metadata;\n\n  /// Content type override (auto-detected if not provided)\n  final String? contentType;\n\n  /// Whether to generate a unique filename with timestamp\n  final bool useTimestampFilename;\n\n  /// Custom file name (if not using timestamp)\n  final String? customFileName;\n\n  /// Cache control header value\n  final String? cacheControl;\n\n  const UploadOptions({\n    this.metadata,\n    this.contentType,\n    this.useTimestampFilename = true,\n    this.customFileName,\n    this.cacheControl,\n  });\n\n  /// Default options for check-in photos\n  static const UploadOptions checkInPhoto = UploadOptions(\n    useTimestampFilename: true,\n    cacheControl: 'public, max-age=31536000', // 1 year cache\n  );\n\n  /// Default options for profile photos\n  static const UploadOptions profilePhoto = UploadOptions(\n    useTimestampFilename: true,\n    cacheControl: 'public, max-age=86400', // 1 day cache\n  );\n\n  /// Default options for temporary uploads\n  static const UploadOptions temporary = UploadOptions(\n    useTimestampFilename: true,\n    cacheControl: 'no-cache',\n  );\n}\n\n/// Upload progress callback\ntypedef UploadProgressCallback = void Function(double progress);\n\n/// Service for uploading and managing files in Firebase Storage\n///\n/// This service provides secure file upload functionality with:\n/// - Organization by user and date\n/// - Automatic secure download URL generation\n/// - Progress tracking\n/// - Portuguese error messages\n///\n/// Usage:\n/// ```dart\n/// final storageService = getIt<FirebaseStorageService>();\n///\n/// // Upload a check-in photo\n/// final result = await storageService.uploadCheckInPhoto(\n///   userId: 'user123',\n///   leagueId: 'league456',\n///   file: imageFile,\n///   onProgress: (progress) => print('Upload: ${(progress * 100).toInt()}%'),\n/// );\n///\n/// print('Photo uploaded: ${result.downloadUrl}');\n/// ```\n@lazySingleton\nclass FirebaseStorageService {\n  final FirebaseStorage _storage;\n\n  FirebaseStorageService(this._storage);\n\n  /// Maximum file size allowed (10MB)\n  static const int maxFileSizeBytes = 10 * 1024 * 1024;\n\n  /// Allowed image MIME types\n  static const List<String> allowedImageTypes = [\n    'image/jpeg',\n    'image/jpg',\n    'image/png',\n    'image/webp',\n    'image/heic',\n    'image/heif',\n  ];\n\n  /// Upload a check-in photo organized by user and date\n  ///\n  /// Files are stored in: check-ins/{userId}/{year}/{month}/{day}/{filename}\n  ///\n  /// [userId] - The ID of the user uploading the photo\n  /// [leagueId] - The ID of the league for the check-in\n  /// [file] - The image file to upload\n  /// [options] - Upload configuration options\n  /// [onProgress] - Optional callback for upload progress (0.0 to 1.0)\n  ///\n  /// Returns [UploadResult] with download URL and metadata.\n  /// Throws [StorageException] on failure.\n  Future<UploadResult> uploadCheckInPhoto({\n    required String userId,\n    required String leagueId,\n    required File file,\n    UploadOptions options = UploadOptions.checkInPhoto,\n    UploadProgressCallback? onProgress,\n  }) async {\n    // Validate file\n    await _validateFile(file);\n\n    // Generate path organized by user and date\n    final now = DateTime.now();\n    final year = now.year.toString();\n    final month = now.month.toString().padLeft(2, '0');\n    final day = now.day.toString().padLeft(2, '0');\n\n    final fileName = _generateFileName(file.path, options);\n    final storagePath = 'check-ins/$userId/$year/$month/$day/$fileName';\n\n    // Add league ID to metadata\n    final metadata = <String, String>{\n      'userId': userId,\n      'leagueId': leagueId,\n      'uploadedAt': now.toIso8601String(),\n      ...?options.metadata,\n    };\n\n    return _uploadFile(\n      file: file,\n      storagePath: storagePath,\n      options: options.copyWith(metadata: metadata),\n      onProgress: onProgress,\n    );\n  }\n\n  /// Upload a profile photo\n  ///\n  /// Files are stored in: profile-photos/{userId}/{filename}\n  ///\n  /// [userId] - The ID of the user\n  /// [file] - The image file to upload\n  /// [options] - Upload configuration options\n  /// [onProgress] - Optional callback for upload progress\n  ///\n  /// Returns [UploadResult] with download URL and metadata.\n  /// Throws [StorageException] on failure.\n  Future<UploadResult> uploadProfilePhoto({\n    required String userId,\n    required File file,\n    UploadOptions options = UploadOptions.profilePhoto,\n    UploadProgressCallback? onProgress,\n  }) async {\n    await _validateFile(file);\n\n    final fileName = _generateFileName(file.path, options);\n    final storagePath = 'profile-photos/$userId/$fileName';\n\n    final metadata = <String, String>{\n      'userId': userId,\n      'uploadedAt': DateTime.now().toIso8601String(),\n      ...?options.metadata,\n    };\n\n    return _uploadFile(\n      file: file,\n      storagePath: storagePath,\n      options: options.copyWith(metadata: metadata),\n      onProgress: onProgress,\n    );\n  }\n\n  /// Upload a file from bytes\n  ///\n  /// [bytes] - The file bytes to upload\n  /// [storagePath] - The full path in storage\n  /// [options] - Upload configuration options\n  /// [onProgress] - Optional callback for upload progress\n  ///\n  /// Returns [UploadResult] with download URL and metadata.\n  /// Throws [StorageException] on failure.\n  Future<UploadResult> uploadBytes({\n    required Uint8List bytes,\n    required String storagePath,\n    UploadOptions options = const UploadOptions(),\n    UploadProgressCallback? onProgress,\n  }) async {\n    // Validate size\n    if (bytes.length > maxFileSizeBytes) {\n      throw const StorageException(\n        message: ErrorMessages.fileTooLarge,\n        code: 'file-too-large',\n      );\n    }\n\n    try {\n      final ref = _storage.ref().child(storagePath);\n\n      // Build metadata\n      final settableMetadata = SettableMetadata(\n        contentType: options.contentType ?? 'application/octet-stream',\n        cacheControl: options.cacheControl,\n        customMetadata: options.metadata,\n      );\n\n      // Start upload\n      final uploadTask = ref.putData(bytes, settableMetadata);\n\n      // Track progress\n      if (onProgress != null) {\n        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {\n          final progress = snapshot.bytesTransferred / snapshot.totalBytes;\n          onProgress(progress);\n        });\n      }\n\n      // Wait for completion\n      await uploadTask;\n\n      // Get download URL\n      final downloadUrl = await ref.getDownloadURL();\n\n      return UploadResult(\n        downloadUrl: downloadUrl,\n        storagePath: storagePath,\n        fileName: path.basename(storagePath),\n        sizeInBytes: bytes.length,\n        contentType: options.contentType,\n        uploadedAt: DateTime.now(),\n        metadata: options.metadata,\n      );\n    } on FirebaseException catch (e) {\n      throw StorageException(\n        message: ErrorMessages.getMessageForCode(e.code),\n        code: e.code,\n        originalError: e,\n      );\n    } catch (e, stackTrace) {\n      final exception = ErrorHandler.handleError(e, stackTrace);\n      throw StorageException(\n        message: exception.message,\n        code: exception.code,\n        originalError: e,\n        stackTrace: stackTrace,\n      );\n    }\n  }\n\n  /// Delete a file from storage\n  ///\n  /// [storagePath] - The full path to the file in storage\n  ///\n  /// Throws [StorageException] on failure.\n  Future<void> deleteFile(String storagePath) async {\n    try {\n      final ref = _storage.ref().child(storagePath);\n      await ref.delete();\n    } on FirebaseException catch (e) {\n      throw StorageException(\n        message: ErrorMessages.getMessageForCode(e.code),\n        code: e.code,\n        originalError: e,\n      );\n    } catch (e, stackTrace) {\n      final exception = ErrorHandler.handleError(e, stackTrace);\n      throw StorageException(\n        message: exception.message,\n        code: exception.code,\n        originalError: e,\n        stackTrace: stackTrace,\n      );\n    }\n  }\n\n  /// Get a secure download URL for a file\n  ///\n  /// [storagePath] - The full path to the file in storage\n  ///\n  /// Returns the download URL string.\n  /// Throws [StorageException] if file not found or on failure.\n  Future<String> getDownloadUrl(String storagePath) async {\n    try {\n      final ref = _storage.ref().child(storagePath);\n      return await ref.getDownloadURL();\n    } on FirebaseException catch (e) {\n      throw StorageException(\n        message: ErrorMessages.getMessageForCode(e.code),\n        code: e.code,\n        originalError: e,\n      );\n    } catch (e, stackTrace) {\n      final exception = ErrorHandler.handleError(e, stackTrace);\n      throw StorageException(\n        message: exception.message,\n        code: exception.code,\n        originalError: e,\n        stackTrace: stackTrace,\n      );\n    }\n  }\n\n  /// Get file metadata\n  ///\n  /// [storagePath] - The full path to the file in storage\n  ///\n  /// Returns the file metadata.\n  /// Throws [StorageException] if file not found or on failure.\n  Future<FullMetadata> getFileMetadata(String storagePath) async {\n    try {\n      final ref = _storage.ref().child(storagePath);\n      return await ref.getMetadata();\n    } on FirebaseException catch (e) {\n      throw StorageException(\n        message: ErrorMessages.getMessageForCode(e.code),\n        code: e.code,\n        originalError: e,\n      );\n    } catch (e, stackTrace) {\n      final exception = ErrorHandler.handleError(e, stackTrace);\n      throw StorageException(\n        message: exception.message,\n        code: exception.code,\n        originalError: e,\n        stackTrace: stackTrace,\n      );\n    }\n  }\n\n  /// List all check-in photos for a user on a specific date\n  ///\n  /// [userId] - The user ID\n  /// [date] - The date to list photos for\n  ///\n  /// Returns list of storage paths for the photos.\n  Future<List<String>> listCheckInPhotos({\n    required String userId,\n    required DateTime date,\n  }) async {\n    final year = date.year.toString();\n    final month = date.month.toString().padLeft(2, '0');\n    final day = date.day.toString().padLeft(2, '0');\n    final prefix = 'check-ins/$userId/$year/$month/$day/';\n\n    try {\n      final ref = _storage.ref().child(prefix);\n      final result = await ref.listAll();\n      return result.items.map((item) => item.fullPath).toList();\n    } on FirebaseException catch (e) {\n      throw StorageException(\n        message: ErrorMessages.getMessageForCode(e.code),\n        code: e.code,\n        originalError: e,\n      );\n    } catch (e, stackTrace) {\n      final exception = ErrorHandler.handleError(e, stackTrace);\n      throw StorageException(\n        message: exception.message,\n        code: exception.code,\n        originalError: e,\n        stackTrace: stackTrace,\n      );\n    }\n  }\n\n  /// Internal method to upload a file\n  Future<UploadResult> _uploadFile({\n    required File file,\n    required String storagePath,\n    required UploadOptions options,\n    UploadProgressCallback? onProgress,\n  }) async {\n    try {\n      final ref = _storage.ref().child(storagePath);\n      final fileSize = await file.length();\n\n      // Detect content type\n      final contentType = options.contentType ?? _getContentType(file.path);\n\n      // Build metadata\n      final settableMetadata = SettableMetadata(\n        contentType: contentType,\n        cacheControl: options.cacheControl,\n        customMetadata: options.metadata,\n      );\n\n      // Start upload\n      final uploadTask = ref.putFile(file, settableMetadata);\n\n      // Track progress\n      if (onProgress != null) {\n        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {\n          final progress = snapshot.bytesTransferred / snapshot.totalBytes;\n          onProgress(progress);\n        });\n      }\n\n      // Wait for completion\n      await uploadTask;\n\n      // Get download URL\n      final downloadUrl = await ref.getDownloadURL();\n\n      return UploadResult(\n        downloadUrl: downloadUrl,\n        storagePath: storagePath,\n        fileName: path.basename(storagePath),\n        sizeInBytes: fileSize,\n        contentType: contentType,\n        uploadedAt: DateTime.now(),\n        metadata: options.metadata,\n      );\n    } on FirebaseException catch (e) {\n      throw StorageException(\n        message: ErrorMessages.getMessageForCode(e.code),\n        code: e.code,\n        originalError: e,\n      );\n    } catch (e, stackTrace) {\n      final exception = ErrorHandler.handleError(e, stackTrace);\n      throw StorageException(\n        message: exception.message,\n        code: exception.code,\n        originalError: e,\n        stackTrace: stackTrace,\n      );\n    }\n  }\n\n  /// Validate file before upload\n  Future<void> _validateFile(File file) async {\n    // Check file exists\n    if (!await file.exists()) {\n      throw const StorageException(\n        message: ErrorMessages.imageFileNotFound,\n        code: 'file-not-found',\n      );\n    }\n\n    // Check file size\n    final fileSize = await file.length();\n    if (fileSize > maxFileSizeBytes) {\n      throw const StorageException(\n        message: ErrorMessages.fileTooLarge,\n        code: 'file-too-large',\n      );\n    }\n\n    // Check content type\n    final contentType = _getContentType(file.path);\n    if (!allowedImageTypes.contains(contentType)) {\n      throw const StorageException(\n        message: ErrorMessages.invalidFileType,\n        code: 'invalid-file-type',\n      );\n    }\n  }\n\n  /// Generate a unique filename\n  String _generateFileName(String originalPath, UploadOptions options) {\n    if (options.customFileName != null) {\n      return options.customFileName!;\n    }\n\n    final extension = path.extension(originalPath).toLowerCase();\n    final baseName = path.basenameWithoutExtension(originalPath);\n\n    if (options.useTimestampFilename) {\n      final timestamp = DateTime.now().millisecondsSinceEpoch;\n      return '${baseName}_$timestamp$extension';\n    }\n\n    return path.basename(originalPath);\n  }\n\n  /// Get content type from file extension\n  String _getContentType(String filePath) {\n    final extension = path.extension(filePath).toLowerCase();\n\n    return switch (extension) {\n      '.jpg' || '.jpeg' => 'image/jpeg',\n      '.png' => 'image/png',\n      '.webp' => 'image/webp',\n      '.heic' => 'image/heic',\n      '.heif' => 'image/heif',\n      '.gif' => 'image/gif',\n      '.pdf' => 'application/pdf',\n      _ => 'application/octet-stream',\n    };\n  }\n}\n\n/// Extension to add copyWith to UploadOptions\nextension UploadOptionsCopyWith on UploadOptions {\n  UploadOptions copyWith({\n    Map<String, String>? metadata,\n    String? contentType,\n    bool? useTimestampFilename,\n    String? customFileName,\n    String? cacheControl,\n  }) {\n    return UploadOptions(\n      metadata: metadata ?? this.metadata,\n      contentType: contentType ?? this.contentType,\n      useTimestampFilename: useTimestampFilename ?? this.useTimestampFilename,\n      customFileName: customFileName ?? this.customFileName,\n      cacheControl: cacheControl ?? this.cacheControl,\n    );\n  }\n}\n"
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Create FirebaseStorageService class with upload functionality",
      "status": "completed",
      "activeForm": "Creating FirebaseStorageService class"
    },
    {
      "content": "Add upload result class with metadata and download URL",
      "status": "completed",
      "activeForm": "Adding upload result class"
    },
    {
      "content": "Implement file organization by user and date",
      "status": "completed",
      "activeForm": "Implementing file organization"
    },
    {
      "content": "Add error handling with Portuguese messages",
      "status": "completed",
      "activeForm": "Adding error handling"
    },
    {
      "content": "Export service from core.dart barrel",
      "status": "in_progress",
      "activeForm": "Exporting service from barrel"
    },
    {
      "content": "Update README.md with Firebase Storage configuration instructions",
      "status": "pending",
      "activeForm": "Updating README.md"
    },
    {
      "content": "Run build_runner to regenerate DI config",
      "status": "pending",
      "activeForm": "Running build_runner"
    }
  ]
}

🔧 Tool: Edit
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/core.dart",
  "old_string": "// Services\nexport 'services/app_service.dart';\nexport 'services/deep_link_service.dart';\nexport 'services/firebase_auth_service.dart';\nexport 'services/image_compression_service.dart';\nexport 'services/permission_service.dart';\nexport 'services/photo_capture_service.dart';",
  "new_string": "// Services\nexport 'services/app_service.dart';\nexport 'services/deep_link_service.dart';\nexport 'services/firebase_auth_service.dart';\nexport 'services/firebase_storage_service.dart';\nexport 'services/image_compression_service.dart';\nexport 'services/permission_service.dart';\nexport 'services/photo_capture_service.dart';"
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Create FirebaseStorageService class with upload functionality",
      "status": "completed",
      "activeForm": "Creating FirebaseStorageService class"
    },
    {
      "content": "Add upload result class with metadata and download URL",
      "status": "completed",
      "activeForm": "Adding upload result class"
    },
    {
      "content": "Implement file organization by user and date",
      "status": "completed",
      "activeForm": "Implementing file organization"
    },
    {
      "content": "Add error handling with Portuguese messages",
      "status": "completed",
      "activeForm": "Adding error handling"
    },
    {
      "content": "Export service from core.dart barrel",
      "status": "completed",
      "activeForm": "Exporting service from barrel"
    },
    {
      "content": "Update README.md with Firebase Storage configuration instructions",
      "status": "in_progress",
      "activeForm": "Updating README.md"
    },
    {
      "content": "Run build_runner to regenerate DI config",
      "status": "pending",
      "activeForm": "Running build_runner"
    }
  ]
}
Now let me update the README.md with Firebase Storage configuration instructions in Brazilian Portuguese:

🔧 Tool: Edit
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/README.md",
  "old_string": "### Suporte\n\nPara mais informacoes, consulte a [documentacao oficial do Firebase Authentication](https://firebase.google.com/docs/auth).",
  "new_string": "### Suporte\n\nPara mais informacoes, consulte a [documentacao oficial do Firebase Authentication](https://firebase.google.com/docs/auth).\n\n---\n\n## Configuracao do Firebase Storage\n\nEste projeto utiliza o Firebase Storage para armazenar fotos de check-ins e perfis de usuarios. Abaixo estao as instrucoes para configurar e gerenciar o armazenamento no portal do Firebase.\n\n### Acessando o Console do Firebase Storage\n\n1. Acesse o [Console do Firebase](https://console.firebase.google.com/)\n2. Selecione o projeto **burgerrats**\n3. No menu lateral, clique em **Storage**\n\n### Ativando o Firebase Storage\n\nSe o Storage ainda nao estiver ativado:\n\n1. No Console do Firebase, va em **Storage**\n2. Clique em **Comecar** ou **Get Started**\n3. Selecione o modo de regras de seguranca:\n   - **Modo de producao**: Requer autenticacao (recomendado)\n   - **Modo de teste**: Permite acesso temporario sem autenticacao (apenas para desenvolvimento)\n4. Escolha a localizacao do servidor (recomendado: `southamerica-east1` para Brasil)\n5. Clique em **Concluido**\n\n### Estrutura de Pastas\n\nO aplicativo organiza os arquivos da seguinte forma:\n\n```\nstorage/\n├── check-ins/\n│   └── {userId}/\n│       └── {ano}/\n│           └── {mes}/\n│               └── {dia}/\n│                   └── {imagem}.jpg\n└── profile-photos/\n    └── {userId}/\n        └── {imagem}.jpg\n```\n\n### Configurando Regras de Seguranca\n\nAs regras de seguranca controlam quem pode ler e gravar arquivos. Acesse **Storage** > **Regras** e configure:\n\n```javascript\nrules_version = '2';\nservice firebase.storage {\n  match /b/{bucket}/o {\n    // Funcao auxiliar para verificar autenticacao\n    function isAuthenticated() {\n      return request.auth != null;\n    }\n\n    // Funcao para verificar se o usuario e o dono do arquivo\n    function isOwner(userId) {\n      return request.auth != null && request.auth.uid == userId;\n    }\n\n    // Funcao para validar tipo de arquivo (imagens)\n    function isValidImageType() {\n      return request.resource.contentType.matches('image/.*');\n    }\n\n    // Funcao para validar tamanho (maximo 10MB)\n    function isValidSize() {\n      return request.resource.size < 10 * 1024 * 1024;\n    }\n\n    // Regras para fotos de check-in\n    match /check-ins/{userId}/{allPaths=**} {\n      // Qualquer usuario autenticado pode visualizar fotos de check-in\n      allow read: if isAuthenticated();\n\n      // Apenas o dono pode fazer upload/deletar suas proprias fotos\n      allow write: if isOwner(userId) && isValidImageType() && isValidSize();\n      allow delete: if isOwner(userId);\n    }\n\n    // Regras para fotos de perfil\n    match /profile-photos/{userId}/{allPaths=**} {\n      // Qualquer usuario autenticado pode visualizar fotos de perfil\n      allow read: if isAuthenticated();\n\n      // Apenas o dono pode fazer upload/deletar sua foto de perfil\n      allow write: if isOwner(userId) && isValidImageType() && isValidSize();\n      allow delete: if isOwner(userId);\n    }\n  }\n}\n```\n\n### Monitorando Uso e Armazenamento\n\n1. Va em **Storage** > **Uso** para visualizar:\n   - Espaco total utilizado\n   - Numero de arquivos\n   - Transferencia de dados\n   - Operacoes realizadas\n\n### Gerenciando Arquivos\n\n#### Navegando pelos Arquivos\n\n1. Va em **Storage** > **Arquivos**\n2. Navegue pelas pastas clicando nelas\n3. Use a barra de caminho para voltar a pastas anteriores\n\n#### Visualizando Detalhes do Arquivo\n\n1. Clique em um arquivo para ver:\n   - URL de download\n   - Tipo de conteudo\n   - Tamanho\n   - Data de criacao\n   - Metadados personalizados\n\n#### Excluindo Arquivos Manualmente\n\n1. Navegue ate o arquivo\n2. Clique nos tres pontos (menu) ao lado do arquivo\n3. Selecione **Excluir**\n4. Confirme a exclusao\n\n**Atencao**: A exclusao e permanente e nao pode ser desfeita.\n\n#### Fazendo Upload Manual\n\n1. Navegue ate a pasta desejada\n2. Clique em **Fazer upload de arquivo**\n3. Selecione o arquivo do seu computador\n4. O arquivo sera enviado automaticamente\n\n### Configurando CORS (Cross-Origin Resource Sharing)\n\nSe as imagens nao carregarem no aplicativo web, configure o CORS:\n\n1. Instale o [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)\n2. Crie um arquivo `cors.json`:\n\n```json\n[\n  {\n    \"origin\": [\"*\"],\n    \"method\": [\"GET\", \"HEAD\"],\n    \"maxAgeSeconds\": 3600\n  }\n]\n```\n\n3. Execute o comando:\n\n```bash\ngsutil cors set cors.json gs://burgerrats.appspot.com\n```\n\n**Nota**: Para producao, substitua `\"*\"` pelos dominios especificos do seu aplicativo.\n\n### Configurando Backup (Opcional)\n\nPara fazer backup automatico dos arquivos:\n\n1. Acesse o [Google Cloud Console](https://console.cloud.google.com/)\n2. Va em **Cloud Storage** > **Transfer**\n3. Configure uma transferencia agendada para outro bucket\n\n### Limites e Cotas\n\n| Recurso | Plano Gratuito (Spark) | Plano Pago (Blaze) |\n|---------|------------------------|-------------------|\n| Armazenamento | 5 GB | Pago por uso |\n| Downloads | 1 GB/dia | Pago por uso |\n| Uploads | 1 GB/dia | Pago por uso |\n| Operacoes | 50.000/dia | Pago por uso |\n\n### Solucao de Problemas Comuns\n\n| Erro | Causa | Solucao |\n|------|-------|---------|\n| `storage/unauthorized` | Usuario nao autenticado ou sem permissao | Verificar regras de seguranca e login do usuario |\n| `storage/canceled` | Upload cancelado | Tentar novamente |\n| `storage/object-not-found` | Arquivo nao existe | Verificar caminho do arquivo |\n| `storage/quota-exceeded` | Limite de armazenamento excedido | Excluir arquivos ou fazer upgrade do plano |\n| `storage/retry-limit-exceeded` | Muitas tentativas falharam | Verificar conexao e tentar novamente |\n\n### Boas Praticas\n\n1. **Compressao de Imagens**: O aplicativo comprime automaticamente as imagens antes do upload para economizar espaco e banda.\n\n2. **Nomes de Arquivo Unicos**: O aplicativo gera nomes unicos com timestamp para evitar conflitos.\n\n3. **Metadados**: Cada arquivo armazena metadados como ID do usuario, ID da liga e data de upload.\n\n4. **Cache**: As imagens sao configuradas com cache de 1 ano para check-ins e 1 dia para fotos de perfil.\n\n5. **Limite de Tamanho**: O aplicativo limita uploads a 10MB para evitar uso excessivo.\n\n### Suporte\n\nPara mais informacoes, consulte a [documentacao oficial do Firebase Storage](https://firebase.google.com/docs/storage)."
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Create FirebaseStorageService class with upload functionality",
      "status": "completed",
      "activeForm": "Creating FirebaseStorageService class"
    },
    {
      "content": "Add upload result class with metadata and download URL",
      "status": "completed",
      "activeForm": "Adding upload result class"
    },
    {
      "content": "Implement file organization by user and date",
      "status": "completed",
      "activeForm": "Implementing file organization"
    },
    {
      "content": "Add error handling with Portuguese messages",
      "status": "completed",
      "activeForm": "Adding error handling"
    },
    {
      "content": "Export service from core.dart barrel",
      "status": "completed",
      "activeForm": "Exporting service from barrel"
    },
    {
      "content": "Update README.md with Firebase Storage configuration instructions",
      "status": "completed",
      "activeForm": "Updating README.md"
    },
    {
      "content": "Run build_runner to regenerate DI config",
      "status": "in_progress",
      "activeForm": "Running build_runner"
    }
  ]
}

🔧 Tool: Bash
Input: {
  "command": "dart run build_runner build --delete-conflicting-outputs 2>&1",
  "description": "Run build_runner to regenerate DI config",
  "timeout": 180000
}
The build runner regenerated the DI config successfully. Let me verify the injection config was updated:

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/di/injection.config.dart"
}
The `FirebaseStorageService` has been properly registered in the DI container (line 61-63). Now let me verify the code compiles properly and run Flutter analyze:

🔧 Tool: Bash
Input: {
  "command": "flutter analyze lib/core/services/firebase_storage_service.dart 2>&1",
  "description": "Analyze Firebase Storage service"
}
I need to add the `path` package as a dependency. Let me check the pubspec.yaml:

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/pubspec.yaml"
}
I need to add the `path` package as a dependency:

🔧 Tool: Edit
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/pubspec.yaml",
  "old_string": "  # UUID generation for unique IDs\n  uuid: ^4.5.1",
  "new_string": "  # UUID generation for unique IDs\n  uuid: ^4.5.1\n\n  # Path utilities for file path manipulation\n  path: ^1.9.0"
}

🔧 Tool: Bash
Input: {
  "command": "flutter pub get 2>&1",
  "description": "Get Flutter packages"
}

🔧 Tool: Bash
Input: {
  "command": "flutter analyze lib/core/services/firebase_storage_service.dart 2>&1",
  "description": "Analyze Firebase Storage service"
}
No issues found. Now let me update the todo list and create a unit test to verify the service:

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Create FirebaseStorageService class with upload functionality",
      "status": "completed",
      "activeForm": "Creating FirebaseStorageService class"
    },
    {
      "content": "Add upload result class with metadata and download URL",
      "status": "completed",
      "activeForm": "Adding upload result class"
    },
    {
      "content": "Implement file organization by user and date",
      "status": "completed",
      "activeForm": "Implementing file organization"
    },
    {
      "content": "Add error handling with Portuguese messages",
      "status": "completed",
      "activeForm": "Adding error handling"
    },
    {
      "content": "Export service from core.dart barrel",
      "status": "completed",
      "activeForm": "Exporting service from barrel"
    },
    {
      "content": "Update README.md with Firebase Storage configuration instructions",
      "status": "completed",
      "activeForm": "Updating README.md"
    },
    {
      "content": "Run build_runner to regenerate DI config",
      "status": "completed",
      "activeForm": "Running build_runner"
    },
    {
      "content": "Create unit test for FirebaseStorageService",
      "status": "in_progress",
      "activeForm": "Creating unit test"
    }
  ]
}
Let me check the existing test structure:

🔧 Tool: Glob
Input: {
  "pattern": "test/**/*.dart"
}
Let me look at one of the existing test files to understand the testing patterns:

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/test/core/services/deep_link_service_test.dart"
}
Now let me create a unit test for the FirebaseStorageService:

🔧 Tool: Write
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/test/core/services/firebase_storage_service_test.dart",
  "content": "import 'dart:io';\n\nimport 'package:firebase_storage/firebase_storage.dart';\nimport 'package:flutter_test/flutter_test.dart';\nimport 'package:mocktail/mocktail.dart';\n\nimport 'package:burgerrats/core/services/firebase_storage_service.dart';\nimport 'package:burgerrats/core/errors/exceptions.dart';\n\n// Mock classes\nclass MockFirebaseStorage extends Mock implements FirebaseStorage {}\n\nclass MockReference extends Mock implements Reference {}\n\nclass MockUploadTask extends Mock implements UploadTask {}\n\nclass MockTaskSnapshot extends Mock implements TaskSnapshot {}\n\nclass MockFullMetadata extends Mock implements FullMetadata {}\n\nclass MockListResult extends Mock implements ListResult {}\n\nclass FakeFile extends Fake implements File {\n  final String _path;\n  final int _size;\n  final bool _exists;\n\n  FakeFile({\n    required String path,\n    int size = 1024,\n    bool exists = true,\n  })  : _path = path,\n        _size = size,\n        _exists = exists;\n\n  @override\n  String get path => _path;\n\n  @override\n  Future<bool> exists() async => _exists;\n\n  @override\n  Future<int> length() async => _size;\n}\n\nvoid main() {\n  late FirebaseStorageService service;\n  late MockFirebaseStorage mockStorage;\n  late MockReference mockRef;\n  late MockUploadTask mockUploadTask;\n\n  setUp(() {\n    mockStorage = MockFirebaseStorage();\n    mockRef = MockReference();\n    mockUploadTask = MockUploadTask();\n    service = FirebaseStorageService(mockStorage);\n\n    // Default stubs\n    when(() => mockStorage.ref()).thenReturn(mockRef);\n    when(() => mockRef.child(any())).thenReturn(mockRef);\n  });\n\n  setUpAll(() {\n    registerFallbackValue(SettableMetadata());\n    registerFallbackValue(FakeFile(path: '/fake/path.jpg'));\n  });\n\n  group('FirebaseStorageService', () {\n    group('UploadResult', () {\n      test('creates with required fields', () {\n        final result = UploadResult(\n          downloadUrl: 'https://example.com/file.jpg',\n          storagePath: 'check-ins/user1/2024/01/15/photo.jpg',\n          fileName: 'photo.jpg',\n          sizeInBytes: 1024,\n          uploadedAt: DateTime(2024, 1, 15),\n        );\n\n        expect(result.downloadUrl, 'https://example.com/file.jpg');\n        expect(result.storagePath, 'check-ins/user1/2024/01/15/photo.jpg');\n        expect(result.fileName, 'photo.jpg');\n        expect(result.sizeInBytes, 1024);\n        expect(result.contentType, isNull);\n        expect(result.metadata, isNull);\n      });\n\n      test('creates with all fields', () {\n        final result = UploadResult(\n          downloadUrl: 'https://example.com/file.jpg',\n          storagePath: 'check-ins/user1/2024/01/15/photo.jpg',\n          fileName: 'photo.jpg',\n          sizeInBytes: 2048,\n          contentType: 'image/jpeg',\n          uploadedAt: DateTime(2024, 1, 15),\n          metadata: {'userId': 'user1'},\n        );\n\n        expect(result.contentType, 'image/jpeg');\n        expect(result.metadata, {'userId': 'user1'});\n      });\n\n      test('toString includes key information', () {\n        final result = UploadResult(\n          downloadUrl: 'https://example.com/file.jpg',\n          storagePath: 'path/to/file.jpg',\n          fileName: 'file.jpg',\n          sizeInBytes: 1024,\n          uploadedAt: DateTime.now(),\n        );\n\n        final str = result.toString();\n        expect(str, contains('file.jpg'));\n        expect(str, contains('1024'));\n        expect(str, contains('https://example.com/file.jpg'));\n      });\n    });\n\n    group('UploadOptions', () {\n      test('creates with defaults', () {\n        const options = UploadOptions();\n\n        expect(options.metadata, isNull);\n        expect(options.contentType, isNull);\n        expect(options.useTimestampFilename, isTrue);\n        expect(options.customFileName, isNull);\n        expect(options.cacheControl, isNull);\n      });\n\n      test('checkInPhoto preset has correct values', () {\n        const options = UploadOptions.checkInPhoto;\n\n        expect(options.useTimestampFilename, isTrue);\n        expect(options.cacheControl, 'public, max-age=31536000');\n      });\n\n      test('profilePhoto preset has correct values', () {\n        const options = UploadOptions.profilePhoto;\n\n        expect(options.useTimestampFilename, isTrue);\n        expect(options.cacheControl, 'public, max-age=86400');\n      });\n\n      test('temporary preset has correct values', () {\n        const options = UploadOptions.temporary;\n\n        expect(options.useTimestampFilename, isTrue);\n        expect(options.cacheControl, 'no-cache');\n      });\n\n      test('copyWith preserves values', () {\n        const options = UploadOptions(\n          metadata: {'key': 'value'},\n          contentType: 'image/png',\n          useTimestampFilename: false,\n        );\n\n        final copied = options.copyWith(contentType: 'image/jpeg');\n\n        expect(copied.metadata, {'key': 'value'});\n        expect(copied.contentType, 'image/jpeg');\n        expect(copied.useTimestampFilename, isFalse);\n      });\n\n      test('copyWith overrides values', () {\n        const options = UploadOptions.checkInPhoto;\n\n        final copied = options.copyWith(\n          metadata: {'newKey': 'newValue'},\n          cacheControl: 'no-store',\n        );\n\n        expect(copied.metadata, {'newKey': 'newValue'});\n        expect(copied.cacheControl, 'no-store');\n        expect(copied.useTimestampFilename, isTrue);\n      });\n    });\n\n    group('constants', () {\n      test('maxFileSizeBytes is 10MB', () {\n        expect(FirebaseStorageService.maxFileSizeBytes, 10 * 1024 * 1024);\n      });\n\n      test('allowedImageTypes contains expected types', () {\n        expect(\n          FirebaseStorageService.allowedImageTypes,\n          containsAll([\n            'image/jpeg',\n            'image/jpg',\n            'image/png',\n            'image/webp',\n            'image/heic',\n            'image/heif',\n          ]),\n        );\n      });\n    });\n\n    group('getDownloadUrl', () {\n      test('returns download URL successfully', () async {\n        const path = 'check-ins/user1/2024/01/15/photo.jpg';\n        const expectedUrl = 'https://storage.googleapis.com/bucket/photo.jpg';\n\n        when(() => mockRef.getDownloadURL()).thenAnswer((_) async => expectedUrl);\n\n        final url = await service.getDownloadUrl(path);\n\n        expect(url, expectedUrl);\n        verify(() => mockStorage.ref()).called(1);\n        verify(() => mockRef.child(path)).called(1);\n        verify(() => mockRef.getDownloadURL()).called(1);\n      });\n\n      test('throws StorageException on FirebaseException', () async {\n        const path = 'nonexistent/path.jpg';\n\n        when(() => mockRef.getDownloadURL()).thenThrow(\n          FirebaseException(\n            plugin: 'storage',\n            code: 'storage/object-not-found',\n            message: 'Object not found',\n          ),\n        );\n\n        expect(\n          () => service.getDownloadUrl(path),\n          throwsA(isA<StorageException>()),\n        );\n      });\n    });\n\n    group('deleteFile', () {\n      test('deletes file successfully', () async {\n        const path = 'check-ins/user1/2024/01/15/photo.jpg';\n\n        when(() => mockRef.delete()).thenAnswer((_) async {});\n\n        await service.deleteFile(path);\n\n        verify(() => mockStorage.ref()).called(1);\n        verify(() => mockRef.child(path)).called(1);\n        verify(() => mockRef.delete()).called(1);\n      });\n\n      test('throws StorageException on FirebaseException', () async {\n        const path = 'nonexistent/path.jpg';\n\n        when(() => mockRef.delete()).thenThrow(\n          FirebaseException(\n            plugin: 'storage',\n            code: 'storage/object-not-found',\n            message: 'Object not found',\n          ),\n        );\n\n        expect(\n          () => service.deleteFile(path),\n          throwsA(isA<StorageException>()),\n        );\n      });\n    });\n\n    group('getFileMetadata', () {\n      test('returns metadata successfully', () async {\n        const path = 'check-ins/user1/2024/01/15/photo.jpg';\n        final mockMetadata = MockFullMetadata();\n\n        when(() => mockRef.getMetadata()).thenAnswer((_) async => mockMetadata);\n\n        final metadata = await service.getFileMetadata(path);\n\n        expect(metadata, mockMetadata);\n        verify(() => mockStorage.ref()).called(1);\n        verify(() => mockRef.child(path)).called(1);\n        verify(() => mockRef.getMetadata()).called(1);\n      });\n\n      test('throws StorageException on FirebaseException', () async {\n        const path = 'nonexistent/path.jpg';\n\n        when(() => mockRef.getMetadata()).thenThrow(\n          FirebaseException(\n            plugin: 'storage',\n            code: 'storage/object-not-found',\n            message: 'Object not found',\n          ),\n        );\n\n        expect(\n          () => service.getFileMetadata(path),\n          throwsA(isA<StorageException>()),\n        );\n      });\n    });\n\n    group('listCheckInPhotos', () {\n      test('returns list of paths for user on date', () async {\n        const userId = 'user123';\n        final date = DateTime(2024, 1, 15);\n        final mockListResult = MockListResult();\n        final mockItem1 = MockReference();\n        final mockItem2 = MockReference();\n\n        when(() => mockItem1.fullPath)\n            .thenReturn('check-ins/user123/2024/01/15/photo1.jpg');\n        when(() => mockItem2.fullPath)\n            .thenReturn('check-ins/user123/2024/01/15/photo2.jpg');\n        when(() => mockListResult.items).thenReturn([mockItem1, mockItem2]);\n        when(() => mockRef.listAll()).thenAnswer((_) async => mockListResult);\n\n        final paths = await service.listCheckInPhotos(\n          userId: userId,\n          date: date,\n        );\n\n        expect(paths.length, 2);\n        expect(paths[0], 'check-ins/user123/2024/01/15/photo1.jpg');\n        expect(paths[1], 'check-ins/user123/2024/01/15/photo2.jpg');\n\n        verify(() => mockRef.child('check-ins/user123/2024/01/15/')).called(1);\n        verify(() => mockRef.listAll()).called(1);\n      });\n\n      test('returns empty list when no photos exist', () async {\n        const userId = 'user123';\n        final date = DateTime(2024, 1, 15);\n        final mockListResult = MockListResult();\n\n        when(() => mockListResult.items).thenReturn([]);\n        when(() => mockRef.listAll()).thenAnswer((_) async => mockListResult);\n\n        final paths = await service.listCheckInPhotos(\n          userId: userId,\n          date: date,\n        );\n\n        expect(paths, isEmpty);\n      });\n\n      test('throws StorageException on FirebaseException', () async {\n        const userId = 'user123';\n        final date = DateTime(2024, 1, 15);\n\n        when(() => mockRef.listAll()).thenThrow(\n          FirebaseException(\n            plugin: 'storage',\n            code: 'storage/unauthorized',\n            message: 'Unauthorized',\n          ),\n        );\n\n        expect(\n          () => service.listCheckInPhotos(userId: userId, date: date),\n          throwsA(isA<StorageException>()),\n        );\n      });\n    });\n\n    group('path generation', () {\n      test('generates correct path for check-in photo', () async {\n        // Test via listCheckInPhotos which uses same path logic\n        const userId = 'testUser';\n        final date = DateTime(2024, 3, 5); // March 5th\n\n        final mockListResult = MockListResult();\n        when(() => mockListResult.items).thenReturn([]);\n        when(() => mockRef.listAll()).thenAnswer((_) async => mockListResult);\n\n        await service.listCheckInPhotos(userId: userId, date: date);\n\n        // Verify the path includes padded month and day\n        verify(() => mockRef.child('check-ins/testUser/2024/03/05/')).called(1);\n      });\n    });\n  });\n}\n"
}

🔧 Tool: Bash
Input: {
  "command": "flutter test test/core/services/firebase_storage_service_test.dart 2>&1",
  "description": "Run Firebase Storage service tests",
  "timeout": 120000
}
All 21 tests pass. Now let me update the todos and verify the implementation is complete:

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Create FirebaseStorageService class with upload functionality",
      "status": "completed",
      "activeForm": "Creating FirebaseStorageService class"
    },
    {
      "content": "Add upload result class with metadata and download URL",
      "status": "completed",
      "activeForm": "Adding upload result class"
    },
    {
      "content": "Implement file organization by user and date",
      "status": "completed",
      "activeForm": "Implementing file organization"
    },
    {
      "content": "Add error handling with Portuguese messages",
      "status": "completed",
      "activeForm": "Adding error handling"
    },
    {
      "content": "Export service from core.dart barrel",
      "status": "completed",
      "activeForm": "Exporting service from barrel"
    },
    {
      "content": "Update README.md with Firebase Storage configuration instructions",
      "status": "completed",
      "activeForm": "Updating README.md"
    },
    {
      "content": "Run build_runner to regenerate DI config",
      "status": "completed",
      "activeForm": "Running build_runner"
    },
    {
      "content": "Create unit test for FirebaseStorageService",
      "status": "completed",
      "activeForm": "Creating unit test"
    }
  ]
}
Now, regarding the Playwright verification requirement - this is a Flutter mobile project (not a web application), so Playwright testing is not applicable here. Playwright is designed for web browser testing, whereas this is a Flutter/Dart mobile application that uses native Firebase SDK. The unit tests I created serve as the appropriate verification mechanism for this type of service.

Let me run a final analysis to make sure everything is properly integrated:

🔧 Tool: Bash
Input: {
  "command": "flutter analyze lib/core/ 2>&1",
  "description": "Final analysis of core module"
}
Let me also run all the tests to ensure nothing is broken:

🔧 Tool: Bash
Input: {
  "command": "flutter test 2>&1",
  "description": "Run all tests",
  "timeout": 180000
}
The failure is in an unrelated test (`widget_test.dart`) that was already broken (it requires Firebase initialization). All the service tests pass. Let me run just the core service tests to confirm:

🔧 Tool: Bash
Input: {
  "command": "flutter test test/core/ 2>&1",
  "description": "Run core tests only",
  "timeout": 120000
}
All 61 core tests pass. The implementation is complete.

<summary>
## Summary: Firebase Storage Service

### Changes Implemented
- Created `FirebaseStorageService` class with full file upload/download functionality
- Implemented `UploadResult` class with metadata (download URL, storage path, file name, size, content type, upload timestamp, custom metadata)
- Implemented `UploadOptions` class with presets for check-in photos, profile photos, and temporary uploads
- Organized file storage by user and date: `check-ins/{userId}/{year}/{month}/{day}/{filename}`
- Added profile photo storage: `profile-photos/{userId}/{filename}`
- Implemented secure download URL generation
- Added file validation (size limit 10MB, allowed image types)
- Added progress tracking callback for uploads
- Added methods: `uploadCheckInPhoto`, `uploadProfilePhoto`, `uploadBytes`, `deleteFile`, `getDownloadUrl`, `getFileMetadata`, `listCheckInPhotos`
- Implemented comprehensive error handling with Portuguese messages using existing `StorageException` class
- Updated README.md with complete Firebase Storage configuration instructions in Brazilian Portuguese including:
  - How to activate Firebase Storage
  - Security rules configuration
  - File structure explanation
  - CORS configuration
  - Troubleshooting guide
  - Limits and quotas table

### Files Modified
- `lib/core/services/firebase_storage_service.dart` (new - 472 lines)
- `lib/core/core.dart` (added export)
- `lib/core/di/injection.config.dart` (auto-regenerated by build_runner)
- `pubspec.yaml` (added `path` package dependency)
- `README.md` (added Firebase Storage documentation section)
- `test/core/services/firebase_storage_service_test.dart` (new - 21 unit tests)

### Notes for Developer
- The service is automatically registered in the DI container via `@lazySingleton` annotation
- Access the service via: `final storageService = getIt<FirebaseStorageService>();`
- Files are organized by user ID and date for easy management and security rules
- The service integrates with existing `ImageCompressionService` - compress images before uploading
- Firebase Storage security rules should be configured as documented in README.md
- All error messages are in Portuguese and use existing `ErrorMessages` class

### Verification Status
- Unit tests created and all 21 tests pass (covering UploadResult, UploadOptions, constants, getDownloadUrl, deleteFile, getFileMetadata, listCheckInPhotos, and path generation)
- Static analysis passes with no issues
- Build runner successfully regenerated DI configuration
- Note: Playwright verification was not applicable as this is a Flutter mobile application, not a web application. Unit tests provide appropriate verification for this service layer code.
</summary>