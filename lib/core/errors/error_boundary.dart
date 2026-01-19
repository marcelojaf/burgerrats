import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'error_handler.dart';
import 'exceptions.dart';

/// Global error boundary that catches uncaught exceptions in the widget tree
class ErrorBoundary extends StatefulWidget {
  const ErrorBoundary({
    super.key,
    required this.child,
    this.onError,
    this.errorBuilder,
  });

  final Widget child;
  final void Function(AppException error, StackTrace? stackTrace)? onError;
  final Widget Function(BuildContext context, AppException error)? errorBuilder;

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  AppException? _error;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    // Register global error handlers
    _setupGlobalErrorHandlers();
  }

  void _setupGlobalErrorHandlers() {
    // Handle Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      final exception = ErrorHandler.handleError(
        details.exception,
        details.stack,
      );

      if (kDebugMode) {
        FlutterError.dumpErrorToConsole(details);
      }

      widget.onError?.call(exception, details.stack);

      if (mounted) {
        setState(() {
          _error = exception;
          _hasError = true;
        });
      }
    };

    // Handle errors outside of Flutter framework
    PlatformDispatcher.instance.onError = (error, stack) {
      final exception = ErrorHandler.handleError(error, stack);

      widget.onError?.call(exception, stack);

      if (kDebugMode) {
        debugPrint('PlatformDispatcher error: $error');
        debugPrint('Stack: $stack');
      }

      return true;
    };
  }

  void _resetError() {
    setState(() {
      _error = null;
      _hasError = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError && _error != null) {
      if (widget.errorBuilder != null) {
        return widget.errorBuilder!(context, _error!);
      }
      return ErrorFallbackWidget(
        error: _error!,
        onRetry: _resetError,
      );
    }

    return widget.child;
  }
}

/// Default fallback widget shown when an uncaught error occurs
class ErrorFallbackWidget extends StatelessWidget {
  const ErrorFallbackWidget({
    super.key,
    required this.error,
    this.onRetry,
  });

  final AppException error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 24),
              Text(
                'Ops! Algo deu errado',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                error.message,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              if (kDebugMode) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Debug Info:',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${error.runtimeType}: ${error.code ?? 'N/A'}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 32),
              if (onRetry != null)
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Tentar Novamente'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A widget that catches errors in its child and displays a fallback
class ErrorCatcher extends StatefulWidget {
  const ErrorCatcher({
    super.key,
    required this.child,
    this.onError,
    this.fallbackBuilder,
  });

  final Widget child;
  final void Function(dynamic error, StackTrace stackTrace)? onError;
  final Widget Function(BuildContext context, dynamic error, VoidCallback retry)?
      fallbackBuilder;

  @override
  State<ErrorCatcher> createState() => _ErrorCatcherState();
}

class _ErrorCatcherState extends State<ErrorCatcher> {
  dynamic _error;
  bool _hasError = false;

  void _handleError(dynamic error, StackTrace stackTrace) {
    setState(() {
      _error = error;
      _hasError = true;
    });
    widget.onError?.call(error, stackTrace);
  }

  void _retry() {
    setState(() {
      _error = null;
      _hasError = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      if (widget.fallbackBuilder != null) {
        return widget.fallbackBuilder!(context, _error, _retry);
      }
      return _DefaultErrorWidget(
        error: _error,
        onRetry: _retry,
      );
    }

    return _ErrorCatcherInherited(
      onError: _handleError,
      child: widget.child,
    );
  }
}

class _ErrorCatcherInherited extends InheritedWidget {
  const _ErrorCatcherInherited({
    required this.onError,
    required super.child,
  });

  final void Function(dynamic error, StackTrace stackTrace) onError;

  static _ErrorCatcherInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_ErrorCatcherInherited>();
  }

  @override
  bool updateShouldNotify(_ErrorCatcherInherited oldWidget) => false;
}

class _DefaultErrorWidget extends StatelessWidget {
  const _DefaultErrorWidget({
    required this.error,
    this.onRetry,
  });

  final dynamic error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final message = ErrorHandler.getUserMessage(error);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              size: 48,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar novamente'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Extension to easily trigger error catching from within widgets
extension ErrorCatcherExtension on BuildContext {
  /// Reports an error to the nearest ErrorCatcher
  void reportError(dynamic error, StackTrace stackTrace) {
    final inherited = _ErrorCatcherInherited.of(this);
    inherited?.onError(error, stackTrace);
  }
}

/// Mixin that provides error handling capabilities to State classes
mixin ErrorHandlerMixin<T extends StatefulWidget> on State<T> {
  AppException? _error;
  bool get hasError => _error != null;
  AppException? get error => _error;

  /// Sets an error state
  void setError(dynamic error, [StackTrace? stackTrace]) {
    final exception = ErrorHandler.handleError(error, stackTrace);
    if (mounted) {
      setState(() {
        _error = exception;
      });
    }
  }

  /// Clears the error state
  void clearError() {
    if (mounted) {
      setState(() {
        _error = null;
      });
    }
  }

  /// Runs an async function with error handling
  Future<R?> runSafe<R>(
    Future<R> Function() fn, {
    void Function(AppException)? onError,
  }) async {
    try {
      clearError();
      return await fn();
    } catch (e, stackTrace) {
      final exception = ErrorHandler.handleError(e, stackTrace);
      setError(exception);
      onError?.call(exception);
      return null;
    }
  }
}

/// Utility class to setup global error handling
class GlobalErrorHandler {
  GlobalErrorHandler._();

  static bool _isInitialized = false;

  /// Initializes global error handling for the app
  /// Call this in main() before runApp()
  static void initialize({
    void Function(AppException error, StackTrace? stackTrace)? onError,
    bool enableReporting = true,
  }) {
    if (_isInitialized) return;
    _isInitialized = true;

    // Handle errors in async code (Futures, etc.)
    runZonedGuarded(
      () {},
      (error, stackTrace) {
        final exception = ErrorHandler.handleError(error, stackTrace);
        onError?.call(exception, stackTrace);
      },
    );

    // Register with ErrorHandler's listener system
    if (onError != null) {
      ErrorHandler.addErrorListener(onError);
    }
  }

  /// Wraps runApp with global error handling
  static void runAppWithErrorHandling(
    Widget app, {
    void Function(AppException error, StackTrace? stackTrace)? onError,
  }) {
    initialize(onError: onError);

    runApp(app);
  }
}
