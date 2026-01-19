import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/di/injection.dart';
import 'core/errors/error_boundary.dart';
import 'core/errors/exceptions.dart';
import 'core/firebase/firebase_config.dart';
import 'core/router/app_router.dart';
import 'core/services/deep_link_service.dart';
import 'core/state/providers/app_state_provider.dart';
import 'shared/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfig.initialize();
  await configureDependencies();

  // Initialize deep link service
  final deepLinkService = getIt<DeepLinkService>();
  final initialDeepLink = await deepLinkService.initialize();

  if (kDebugMode && initialDeepLink != null) {
    debugPrint('App opened with deep link: $initialDeepLink');
  }

  // Run app with global error handling and Riverpod
  GlobalErrorHandler.runAppWithErrorHandling(
    const ProviderScope(child: BurgerRatsApp()),
    onError: _handleGlobalError,
  );
}

/// Handles global errors - can be extended for analytics/crash reporting
void _handleGlobalError(AppException error, StackTrace? stackTrace) {
  if (kDebugMode) {
    debugPrint('Global Error: ${error.runtimeType}');
    debugPrint('Message: ${error.message}');
    debugPrint('Code: ${error.code}');
  }
  // TODO: Add analytics/crash reporting here (e.g., Firebase Crashlytics)
}

class BurgerRatsApp extends ConsumerWidget {
  const BurgerRatsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch theme mode from app state
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'BurgerRats',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: AppRouter.router,
      builder: (context, child) {
        // Wrap the app with ErrorBoundary for uncaught widget errors
        return ErrorBoundary(
          onError: _handleGlobalError,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
