import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

/// Represents a parsed deep link with its type and associated data
class DeepLinkData {
  const DeepLinkData({
    required this.type,
    this.id,
    this.rawUri,
  });

  final DeepLinkType type;
  final String? id;
  final Uri? rawUri;

  @override
  String toString() => 'DeepLinkData(type: $type, id: $id, rawUri: $rawUri)';
}

/// Types of deep links supported by the app
enum DeepLinkType {
  /// League invitation link
  leagueInvite,

  /// Check-in share link
  checkInShare,

  /// Unknown or unsupported link type
  unknown,
}

/// Service for handling deep links in the application
///
/// This service listens for incoming deep links and provides
/// a stream for other parts of the app to react to them.
@lazySingleton
class DeepLinkService {
  DeepLinkService() : _appLinks = AppLinks();

  final AppLinks _appLinks;
  final _deepLinkController = StreamController<DeepLinkData>.broadcast();
  StreamSubscription<Uri>? _linkSubscription;
  Uri? _initialUri;
  bool _isInitialized = false;

  /// Stream of incoming deep links
  Stream<DeepLinkData> get deepLinkStream => _deepLinkController.stream;

  /// The initial deep link that opened the app (if any)
  Uri? get initialUri => _initialUri;

  /// Whether the service has been initialized
  bool get isInitialized => _isInitialized;

  /// Initializes the deep link service
  ///
  /// This should be called once at app startup.
  /// Returns the initial deep link if the app was opened via a link.
  Future<DeepLinkData?> initialize() async {
    if (_isInitialized) return null;

    try {
      // Get the initial link if the app was opened via deep link
      _initialUri = await _appLinks.getInitialLink();

      if (kDebugMode && _initialUri != null) {
        debugPrint('DeepLinkService: Initial URI: $_initialUri');
      }

      // Listen for subsequent deep links while app is running
      _linkSubscription = _appLinks.uriLinkStream.listen(
        _handleIncomingLink,
        onError: (error) {
          if (kDebugMode) {
            debugPrint('DeepLinkService: Error receiving link: $error');
          }
        },
      );

      _isInitialized = true;

      // Return parsed initial link if present
      if (_initialUri != null) {
        return parseDeepLink(_initialUri!);
      }

      return null;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('DeepLinkService: Error initializing: $e');
      }
      _isInitialized = true;
      return null;
    }
  }

  /// Handles incoming deep links while the app is running
  void _handleIncomingLink(Uri uri) {
    if (kDebugMode) {
      debugPrint('DeepLinkService: Received link: $uri');
    }

    final deepLinkData = parseDeepLink(uri);
    _deepLinkController.add(deepLinkData);
  }

  /// Parses a URI into a [DeepLinkData] object
  ///
  /// Supported link formats:
  /// - burgerrats://league/{leagueId} - League invitation
  /// - burgerrats://checkin/{checkInId} - Check-in share
  /// - https://burgerrats.app/league/{leagueId} - League invitation (web)
  /// - https://burgerrats.app/checkin/{checkInId} - Check-in share (web)
  DeepLinkData parseDeepLink(Uri uri) {
    final pathSegments = uri.pathSegments;

    if (kDebugMode) {
      debugPrint('DeepLinkService: Parsing URI: $uri');
      debugPrint('DeepLinkService: Path segments: $pathSegments');
      debugPrint('DeepLinkService: Host: ${uri.host}');
    }

    // Handle custom scheme (burgerrats://)
    if (uri.scheme == 'burgerrats') {
      return _parseCustomSchemeLink(uri, pathSegments);
    }

    // Handle HTTPS universal links
    if (uri.scheme == 'https' && uri.host == 'burgerrats.app') {
      return _parseHttpsLink(uri, pathSegments);
    }

    return DeepLinkData(type: DeepLinkType.unknown, rawUri: uri);
  }

  /// Parses custom scheme links (burgerrats://)
  DeepLinkData _parseCustomSchemeLink(Uri uri, List<String> pathSegments) {
    // For custom scheme, the "host" is actually the first path segment
    // e.g., burgerrats://league/123 -> host = "league", pathSegments = ["123"]
    final host = uri.host;

    if (host == 'league' && pathSegments.isNotEmpty) {
      return DeepLinkData(
        type: DeepLinkType.leagueInvite,
        id: pathSegments.first,
        rawUri: uri,
      );
    }

    if (host == 'checkin' && pathSegments.isNotEmpty) {
      return DeepLinkData(
        type: DeepLinkType.checkInShare,
        id: pathSegments.first,
        rawUri: uri,
      );
    }

    // Also handle path-based format: burgerrats:///league/123
    if (pathSegments.length >= 2) {
      final type = pathSegments[0];
      final id = pathSegments[1];

      if (type == 'league') {
        return DeepLinkData(
          type: DeepLinkType.leagueInvite,
          id: id,
          rawUri: uri,
        );
      }

      if (type == 'checkin') {
        return DeepLinkData(
          type: DeepLinkType.checkInShare,
          id: id,
          rawUri: uri,
        );
      }
    }

    return DeepLinkData(type: DeepLinkType.unknown, rawUri: uri);
  }

  /// Parses HTTPS universal links
  DeepLinkData _parseHttpsLink(Uri uri, List<String> pathSegments) {
    if (pathSegments.length >= 2) {
      final type = pathSegments[0];
      final id = pathSegments[1];

      if (type == 'league') {
        return DeepLinkData(
          type: DeepLinkType.leagueInvite,
          id: id,
          rawUri: uri,
        );
      }

      if (type == 'checkin') {
        return DeepLinkData(
          type: DeepLinkType.checkInShare,
          id: id,
          rawUri: uri,
        );
      }
    }

    return DeepLinkData(type: DeepLinkType.unknown, rawUri: uri);
  }

  /// Generates a shareable link for a league invitation
  ///
  /// Returns a custom scheme link that can be shared.
  String generateLeagueInviteLink(String leagueId) {
    return 'burgerrats://league/$leagueId';
  }

  /// Generates a shareable link for a check-in
  ///
  /// Returns a custom scheme link that can be shared.
  String generateCheckInShareLink(String checkInId) {
    return 'burgerrats://checkin/$checkInId';
  }

  /// Generates a web-compatible link for a league invitation
  String generateLeagueInviteWebLink(String leagueId) {
    return 'https://burgerrats.app/league/$leagueId';
  }

  /// Generates a web-compatible link for a check-in
  String generateCheckInShareWebLink(String checkInId) {
    return 'https://burgerrats.app/checkin/$checkInId';
  }

  /// Disposes the service and cleans up resources
  void dispose() {
    _linkSubscription?.cancel();
    _deepLinkController.close();
  }
}
