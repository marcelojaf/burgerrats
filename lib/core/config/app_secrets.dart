import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

/// Represents the Sentry configuration from secrets
class SentrySecrets {
  final String dsn;
  final double tracesSampleRate;

  const SentrySecrets({
    required this.dsn,
    required this.tracesSampleRate,
  });

  factory SentrySecrets.fromJson(Map<String, dynamic> json) {
    return SentrySecrets(
      dsn: json['dsn'] as String? ?? '',
      tracesSampleRate: (json['tracesSampleRate'] as num?)?.toDouble() ?? 1.0,
    );
  }

  /// Returns true if the DSN is configured
  bool get isConfigured => dsn.isNotEmpty;
}

/// Application secrets loaded from .secrets/app_secrets.json
class AppSecrets {
  final String environment;
  final SentrySecrets sentry;

  const AppSecrets({
    required this.environment,
    required this.sentry,
  });

  factory AppSecrets.fromJson(Map<String, dynamic> json) {
    return AppSecrets(
      environment: json['environment'] as String? ?? 'dev',
      sentry: SentrySecrets.fromJson(
        json['sentry'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  /// Returns true if this is a development environment
  bool get isDevelopment => environment == 'dev';

  /// Returns true if this is a staging environment
  bool get isStaging => environment == 'stg';

  /// Returns true if this is a production environment
  bool get isProduction => environment == 'prod';

  /// Empty secrets instance for when secrets file is not found
  static const AppSecrets empty = AppSecrets(
    environment: 'dev',
    sentry: SentrySecrets(dsn: '', tracesSampleRate: 1.0),
  );

  /// Loads secrets from the .secrets/app_secrets.json file
  ///
  /// Returns [AppSecrets.empty] if the file doesn't exist or cannot be parsed.
  static Future<AppSecrets> load() async {
    try {
      final file = File('.secrets/app_secrets.json');

      if (!await file.exists()) {
        debugPrint('Warning: .secrets/app_secrets.json not found');
        return AppSecrets.empty;
      }

      final contents = await file.readAsString();
      final json = jsonDecode(contents) as Map<String, dynamic>;

      return AppSecrets.fromJson(json);
    } catch (e) {
      debugPrint('Error loading app secrets: $e');
      return AppSecrets.empty;
    }
  }
}
