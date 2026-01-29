import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

import '../errors/exceptions.dart';
import '../errors/error_messages.dart';

/// Status result for permission requests
enum PermissionResult {
  /// Permission was granted
  granted,

  /// Permission was denied but can be requested again
  denied,

  /// Permission was permanently denied - user must enable in settings
  permanentlyDenied,

  /// Permission is restricted (iOS only - parental controls, etc.)
  restricted,

  /// Permission status is limited (iOS 14+ photo library)
  limited,
}

/// Service for handling app permissions
///
/// This service provides a unified interface for requesting and checking
/// camera permissions on iOS and Android. It handles the different
/// permission states and provides user-friendly Portuguese messages.
@lazySingleton
class PermissionService {
  /// Portuguese messages for camera permission dialogs
  static const String _cameraPermissionTitle = 'Permissao de Camera';
  static const String _cameraPermissionRationale =
      'Precisamos de acesso a sua camera para tirar fotos dos seus check-ins em restaurantes. '
      'Suas fotos ajudam a verificar suas visitas e tornam a experiencia mais divertida!';
  static const String _cameraPermissionSettingsMessage =
      'A permissao de camera foi negada permanentemente. '
      'Por favor, va ate as configuracoes do aplicativo para habilitar.';
  static const String _openSettingsButton = 'Abrir Configuracoes';
  static const String _cancelButton = 'Cancelar';
  static const String _allowButton = 'Permitir';

  /// Checks the current camera permission status without requesting
  Future<PermissionResult> checkCameraPermission() async {
    final status = await Permission.camera.status;
    return _mapPermissionStatus(status);
  }

  /// Requests camera permission from the user
  ///
  /// Returns [PermissionResult.granted] if permission was granted.
  /// Returns [PermissionResult.denied] if user denied but can be asked again.
  /// Returns [PermissionResult.permanentlyDenied] if user permanently denied.
  /// Returns [PermissionResult.restricted] if permission is restricted (iOS).
  ///
  /// Throws [PermissionException] if there's an error during the request.
  Future<PermissionResult> requestCameraPermission() async {
    try {
      final status = await Permission.camera.request();
      return _mapPermissionStatus(status);
    } catch (e, stackTrace) {
      throw PermissionException(
        message: ErrorMessages.cameraPermissionDenied,
        code: 'camera-permission-error',
        permissionType: 'camera',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Requests camera permission with a rationale dialog
  ///
  /// Shows an explanation dialog before requesting permission if
  /// the permission hasn't been permanently denied yet. This helps
  /// users understand why the app needs camera access.
  ///
  /// [context] - BuildContext for showing dialogs
  ///
  /// Returns [PermissionResult] indicating the final permission state.
  Future<PermissionResult> requestCameraWithRationale(
    BuildContext context,
  ) async {
    // Check current status first
    final currentStatus = await checkCameraPermission();

    // If already granted, no need to do anything
    if (currentStatus == PermissionResult.granted) {
      return PermissionResult.granted;
    }

    // If permanently denied and context is valid, show settings dialog
    if (currentStatus == PermissionResult.permanentlyDenied) {
      if (context.mounted) {
        final shouldOpenSettings = await _showSettingsDialog(context);
        if (shouldOpenSettings) {
          await openAppSettings();
          // Re-check after returning from settings
          return checkCameraPermission();
        }
      }
      return PermissionResult.permanentlyDenied;
    }

    // If restricted (iOS), inform user they can't grant permission
    if (currentStatus == PermissionResult.restricted) {
      if (context.mounted) {
        await _showRestrictedDialog(context);
      }
      return PermissionResult.restricted;
    }

    // Show rationale dialog before requesting (if context is still valid)
    // If context is not mounted, skip the rationale and request directly
    if (context.mounted) {
      final shouldRequest = await _showRationaleDialog(context);
      if (!shouldRequest) {
        return PermissionResult.denied;
      }
    }

    // Request the permission
    return requestCameraPermission();
  }

  /// Opens the app settings so user can manually enable permissions
  Future<bool> openSettings() async {
    return openAppSettings();
  }

  /// Checks if camera permission is granted
  Future<bool> isCameraGranted() async {
    return await Permission.camera.isGranted;
  }

  /// Checks if camera permission was permanently denied
  Future<bool> isCameraPermanentlyDenied() async {
    return await Permission.camera.isPermanentlyDenied;
  }

  /// Maps the permission_handler status to our PermissionResult
  PermissionResult _mapPermissionStatus(PermissionStatus status) {
    return switch (status) {
      PermissionStatus.granted => PermissionResult.granted,
      PermissionStatus.denied => PermissionResult.denied,
      PermissionStatus.permanentlyDenied => PermissionResult.permanentlyDenied,
      PermissionStatus.restricted => PermissionResult.restricted,
      PermissionStatus.limited => PermissionResult.limited,
      PermissionStatus.provisional => PermissionResult.granted,
    };
  }

  /// Shows the rationale dialog explaining why camera permission is needed
  Future<bool> _showRationaleDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text(_cameraPermissionTitle),
            content: const Text(_cameraPermissionRationale),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(_cancelButton),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(_allowButton),
              ),
            ],
          ),
        ) ??
        false;
  }

  /// Shows dialog prompting user to open settings
  Future<bool> _showSettingsDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text(_cameraPermissionTitle),
            content: const Text(_cameraPermissionSettingsMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(_cancelButton),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(_openSettingsButton),
              ),
            ],
          ),
        ) ??
        false;
  }

  /// Shows dialog for restricted permissions (iOS parental controls)
  Future<void> _showRestrictedDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(_cameraPermissionTitle),
        content: const Text(
          'O acesso a camera esta restrito neste dispositivo. '
          'Verifique as configuracoes de controle parental ou restricoes do dispositivo.',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendi'),
          ),
        ],
      ),
    );
  }
}
