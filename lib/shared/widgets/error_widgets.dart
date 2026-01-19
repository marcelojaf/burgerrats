import 'package:flutter/material.dart';

import '../../core/errors/error_handler.dart';
import '../../core/errors/exceptions.dart';

/// Utility class for displaying errors to users
class ErrorDisplay {
  ErrorDisplay._();

  /// Shows an error snackbar with the error message
  static void showSnackbar(
    BuildContext context,
    dynamic error, {
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
    VoidCallback? onRetry,
  }) {
    final message = ErrorHandler.getUserMessage(error);
    final theme = Theme.of(context);

    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: theme.colorScheme.onErrorContainer,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: theme.colorScheme.errorContainer,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      action: action ??
          (onRetry != null
              ? SnackBarAction(
                  label: 'Tentar novamente',
                  textColor: theme.colorScheme.onErrorContainer,
                  onPressed: onRetry,
                )
              : null),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  /// Shows an error dialog with more details
  static Future<void> showDialog(
    BuildContext context,
    dynamic error, {
    String? title,
    VoidCallback? onRetry,
    bool barrierDismissible = true,
  }) async {
    final message = ErrorHandler.getUserMessage(error);
    final theme = Theme.of(context);

    return showAdaptiveDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.error_outline,
          color: theme.colorScheme.error,
          size: 48,
        ),
        title: Text(title ?? 'Erro'),
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        actions: [
          if (onRetry != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onRetry();
              },
              child: const Text('Tentar novamente'),
            ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Shows a critical error dialog that requires acknowledgment
  static Future<void> showCriticalDialog(
    BuildContext context,
    dynamic error, {
    String? title,
    VoidCallback? onDismiss,
  }) async {
    final message = ErrorHandler.getUserMessage(error);
    final theme = Theme.of(context);

    return showAdaptiveDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.warning_amber_rounded,
          color: theme.colorScheme.error,
          size: 56,
        ),
        title: Text(title ?? 'Erro Crítico'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Por favor, entre em contato com o suporte se o problema persistir.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDismiss?.call();
            },
            child: const Text('Entendi'),
          ),
        ],
      ),
    );
  }

  /// Shows a network error with retry option
  static void showNetworkError(
    BuildContext context, {
    VoidCallback? onRetry,
  }) {
    showSnackbar(
      context,
      const NetworkException(
        message: 'Sem conexão com a internet',
        code: 'network-error',
      ),
      onRetry: onRetry,
    );
  }
}

/// A widget that displays an inline error message
class InlineErrorWidget extends StatelessWidget {
  const InlineErrorWidget({
    super.key,
    required this.error,
    this.onRetry,
    this.compact = false,
  });

  final dynamic error;
  final VoidCallback? onRetry;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final message = ErrorHandler.getUserMessage(error);
    final theme = Theme.of(context);

    if (compact) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: 16,
            color: theme.colorScheme.error,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.refresh, size: 16),
              onPressed: onRetry,
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: theme.colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ),
          if (onRetry != null)
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: theme.colorScheme.onErrorContainer,
              ),
              onPressed: onRetry,
            ),
        ],
      ),
    );
  }
}

/// A widget for empty state with optional error
class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    super.key,
    required this.message,
    this.icon,
    this.action,
    this.actionLabel,
    this.error,
  });

  final String message;
  final IconData? icon;
  final VoidCallback? action;
  final String? actionLabel;
  final dynamic error;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasError = error != null;
    final displayMessage =
        hasError ? ErrorHandler.getUserMessage(error) : message;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? (hasError ? Icons.error_outline : Icons.inbox_outlined),
              size: 64,
              color: hasError
                  ? theme.colorScheme.error
                  : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              displayMessage,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[
              const SizedBox(height: 24),
              FilledButton.tonal(
                onPressed: action,
                child: Text(actionLabel ?? 'Tentar novamente'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A widget that shows loading, error, or content states
class AsyncContentWidget<T> extends StatelessWidget {
  const AsyncContentWidget({
    super.key,
    required this.data,
    required this.builder,
    this.error,
    this.isLoading = false,
    this.onRetry,
    this.loadingWidget,
    this.emptyMessage,
  });

  final T? data;
  final Widget Function(BuildContext context, T data) builder;
  final dynamic error;
  final bool isLoading;
  final VoidCallback? onRetry;
  final Widget? loadingWidget;
  final String? emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return loadingWidget ??
          const Center(
            child: CircularProgressIndicator(),
          );
    }

    if (error != null) {
      return EmptyStateWidget(
        message: '',
        error: error,
        action: onRetry,
        actionLabel: 'Tentar novamente',
      );
    }

    if (data == null) {
      return EmptyStateWidget(
        message: emptyMessage ?? 'Nenhum dado encontrado',
        action: onRetry,
      );
    }

    return builder(context, data as T);
  }
}
