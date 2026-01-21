import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Service for accessing app version information
///
/// This service provides the app version and build number from pubspec.yaml.
/// It's used to identify the release version for crash reporting and analytics.
///
/// Example usage:
/// ```dart
/// final versionService = getIt<AppVersionService>();
/// await versionService.initialize();
/// print(versionService.releaseVersion); // e.g., "1.0.0+1"
/// ```
@lazySingleton
class AppVersionService {
  PackageInfo? _packageInfo;

  /// Whether the service has been initialized
  bool get isInitialized => _packageInfo != null;

  /// The app name from pubspec.yaml
  String get appName => _packageInfo?.appName ?? 'unknown';

  /// The package name (bundle ID / application ID)
  String get packageName => _packageInfo?.packageName ?? 'unknown';

  /// The version number from pubspec.yaml (e.g., "1.0.0")
  String get version => _packageInfo?.version ?? '0.0.0';

  /// The build number from pubspec.yaml (e.g., "1")
  String get buildNumber => _packageInfo?.buildNumber ?? '0';

  /// The full release version string for Sentry (e.g., "1.0.0+1")
  ///
  /// This format matches the Sentry release naming convention and
  /// allows tracking crashes and performance by specific app version.
  String get releaseVersion {
    if (_packageInfo == null) return 'unknown';
    return '${_packageInfo!.version}+${_packageInfo!.buildNumber}';
  }

  /// Initializes the service by loading package info
  ///
  /// This should be called once at app startup, before Sentry initialization.
  Future<void> initialize() async {
    if (_packageInfo != null) return;

    try {
      _packageInfo = await PackageInfo.fromPlatform();
      debugPrint('AppVersionService: Loaded version $releaseVersion');
    } catch (e) {
      debugPrint('AppVersionService: Failed to load package info: $e');
    }
  }
}
