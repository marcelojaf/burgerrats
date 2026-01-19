import 'package:injectable/injectable.dart';

/// Core application service
///
/// This service provides application-wide functionality and
/// demonstrates how to create an injectable service.
@lazySingleton
class AppService {
  bool _isInitialized = false;

  /// Whether the app service has been initialized
  bool get isInitialized => _isInitialized;

  /// Initializes the app service
  ///
  /// This method should be called once at app startup.
  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;
  }
}
