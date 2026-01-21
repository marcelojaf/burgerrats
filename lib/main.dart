import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/di/injection.dart';
import 'core/errors/error_boundary.dart';
import 'core/errors/exceptions.dart';
import 'core/firebase/firebase_config.dart';
import 'core/router/app_router.dart';
import 'core/services/deep_link_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/reminder_scheduler_service.dart';
import 'core/state/providers/app_state_provider.dart';
import 'core/state/providers/notification_handler_provider.dart';
import 'shared/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfig.initialize();

  // Setup FCM background message handler - must be done before configureDependencies
  NotificationService.setBackgroundMessageHandler();

  await configureDependencies();

  // Initialize deep link service
  final deepLinkService = getIt<DeepLinkService>();
  final initialDeepLink = await deepLinkService.initialize();

  if (kDebugMode && initialDeepLink != null) {
    debugPrint('App opened with deep link: $initialDeepLink');
  }

  // Initialize reminder scheduler service
  final reminderSchedulerService = getIt<ReminderSchedulerService>();
  await reminderSchedulerService.initialize();

  // Setup notification message handlers (foreground and tap events)
  final notificationService = getIt<NotificationService>();
  await notificationService.setupMessageHandlers();

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

class BurgerRatsApp extends ConsumerStatefulWidget {
  const BurgerRatsApp({super.key});

  @override
  ConsumerState<BurgerRatsApp> createState() => _BurgerRatsAppState();
}

class _BurgerRatsAppState extends ConsumerState<BurgerRatsApp> {
  NotificationHandler? _notificationHandler;

  @override
  void initState() {
    super.initState();
    // Initialize notification handler after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeNotificationHandler();
    });
  }

  void _initializeNotificationHandler() {
    final notificationService = ref.read(notificationServiceProvider);
    final router = ref.read(routerProvider);

    _notificationHandler = NotificationHandler(
      notificationService: notificationService,
      router: router,
    );
    _notificationHandler!.initialize();
  }

  @override
  void dispose() {
    _notificationHandler?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch theme mode from app state
    final themeMode = ref.watch(themeModeProvider);

    // Watch locale from app state
    final locale = ref.watch(localeProvider);

    // Watch auth-aware router that automatically handles redirects
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'BurgerRats',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
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
