import 'package:flutter/material.dart';

import '../../core/services/permission_service.dart';

/// A card widget for requesting camera permission
///
/// Shows a user-friendly explanation in Portuguese about why the
/// camera permission is needed and provides action buttons.
class CameraPermissionCard extends StatelessWidget {
  const CameraPermissionCard({
    super.key,
    required this.onRequestPermission,
    this.onOpenSettings,
    this.isPermanentlyDenied = false,
  });

  /// Callback when user taps the permission request button
  final VoidCallback onRequestPermission;

  /// Callback when user taps to open settings
  final VoidCallback? onOpenSettings;

  /// Whether the permission was permanently denied
  final bool isPermanentlyDenied;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outline.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.camera_alt_outlined,
                size: 40,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Acesso a Camera',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isPermanentlyDenied
                  ? 'A permissao de camera foi negada. Para usar esta funcionalidade, '
                      'voce precisa habilitar o acesso nas configuracoes do seu dispositivo.'
                  : 'Precisamos de acesso a sua camera para tirar fotos dos seus check-ins. '
                      'Suas fotos ajudam a verificar suas visitas e tornam a experiencia mais divertida!',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (isPermanentlyDenied)
              FilledButton.icon(
                onPressed: onOpenSettings,
                icon: const Icon(Icons.settings_outlined),
                label: const Text('Abrir Configuracoes'),
              )
            else
              FilledButton.icon(
                onPressed: onRequestPermission,
                icon: const Icon(Icons.camera_alt_outlined),
                label: const Text('Permitir Acesso'),
              ),
          ],
        ),
      ),
    );
  }
}

/// A full-screen widget for requesting camera permission
///
/// Use this when camera access is required to proceed with a feature.
class CameraPermissionScreen extends StatelessWidget {
  const CameraPermissionScreen({
    super.key,
    required this.onRequestPermission,
    this.onOpenSettings,
    this.onCancel,
    this.isPermanentlyDenied = false,
    this.title = 'Acesso a Camera Necessario',
  });

  /// Callback when user taps the permission request button
  final VoidCallback onRequestPermission;

  /// Callback when user taps to open settings
  final VoidCallback? onOpenSettings;

  /// Callback when user cancels
  final VoidCallback? onCancel;

  /// Whether the permission was permanently denied
  final bool isPermanentlyDenied;

  /// Screen title
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: onCancel != null
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: onCancel,
              )
            : null,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 48,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.camera_alt_rounded,
                        size: 64,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      isPermanentlyDenied
                          ? 'Permissao de Camera Negada'
                          : 'Permissao de Camera',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isPermanentlyDenied
                          ? 'Voce negou permanentemente o acesso a camera. '
                              'Para usar esta funcionalidade, voce precisa habilitar '
                              'a permissao nas configuracoes do seu dispositivo.'
                          : 'Para fazer check-ins com fotos, precisamos de acesso '
                              'a camera do seu dispositivo.\n\n'
                              'Suas fotos ajudam a verificar suas visitas e tornam '
                              'a experiencia mais interativa e divertida!',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    _buildFeatureList(theme),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: isPermanentlyDenied
                          ? FilledButton.icon(
                              onPressed: onOpenSettings,
                              icon: const Icon(Icons.settings_outlined),
                              label: const Text('Abrir Configuracoes'),
                              style: FilledButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                              ),
                            )
                          : FilledButton.icon(
                              onPressed: onRequestPermission,
                              icon: const Icon(Icons.camera_alt_outlined),
                              label: const Text('Permitir Acesso a Camera'),
                              style: FilledButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                    ),
                    if (onCancel != null && !isPermanentlyDenied) ...[
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: onCancel,
                        child: const Text('Agora nao'),
                      ),
                    ],
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFeatureList(ThemeData theme) {
    return Column(
      children: [
        _FeatureItem(
          icon: Icons.photo_camera_outlined,
          text: 'Tire fotos dos seus check-ins',
          theme: theme,
        ),
        _FeatureItem(
          icon: Icons.verified_outlined,
          text: 'Verifique suas visitas',
          theme: theme,
        ),
        _FeatureItem(
          icon: Icons.emoji_events_outlined,
          text: 'Compartilhe com amigos',
          theme: theme,
        ),
      ],
    );
  }
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({
    required this.icon,
    required this.text,
    required this.theme,
  });

  final IconData icon;
  final String text;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            text,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

/// A builder widget that handles camera permission state
///
/// This widget automatically checks the camera permission status and
/// displays appropriate content based on the result.
class CameraPermissionBuilder extends StatefulWidget {
  const CameraPermissionBuilder({
    super.key,
    required this.permissionService,
    required this.grantedBuilder,
    this.deniedBuilder,
    this.loadingBuilder,
  });

  /// The permission service instance
  final PermissionService permissionService;

  /// Builder for when permission is granted
  final Widget Function(BuildContext context) grantedBuilder;

  /// Builder for when permission is denied (optional - uses default if null)
  final Widget Function(
    BuildContext context,
    PermissionResult result,
    VoidCallback requestPermission,
    VoidCallback openSettings,
  )? deniedBuilder;

  /// Builder for loading state (optional - uses default if null)
  final Widget Function(BuildContext context)? loadingBuilder;

  @override
  State<CameraPermissionBuilder> createState() =>
      _CameraPermissionBuilderState();
}

class _CameraPermissionBuilderState extends State<CameraPermissionBuilder>
    with WidgetsBindingObserver {
  PermissionResult? _permissionResult;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Re-check permission when returning from settings
    if (state == AppLifecycleState.resumed) {
      _checkPermission();
    }
  }

  Future<void> _checkPermission() async {
    setState(() => _isLoading = true);
    final result = await widget.permissionService.checkCameraPermission();
    if (mounted) {
      setState(() {
        _permissionResult = result;
        _isLoading = false;
      });
    }
  }

  Future<void> _requestPermission() async {
    final result = await widget.permissionService.requestCameraPermission();
    if (mounted) {
      setState(() => _permissionResult = result);
    }
  }

  Future<void> _openSettings() async {
    await widget.permissionService.openSettings();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return widget.loadingBuilder?.call(context) ??
          const Center(child: CircularProgressIndicator());
    }

    if (_permissionResult == PermissionResult.granted) {
      return widget.grantedBuilder(context);
    }

    if (widget.deniedBuilder != null) {
      return widget.deniedBuilder!(
        context,
        _permissionResult!,
        _requestPermission,
        _openSettings,
      );
    }

    // Default denied UI
    return CameraPermissionCard(
      onRequestPermission: _requestPermission,
      onOpenSettings: _openSettings,
      isPermanentlyDenied:
          _permissionResult == PermissionResult.permanentlyDenied,
    );
  }
}
