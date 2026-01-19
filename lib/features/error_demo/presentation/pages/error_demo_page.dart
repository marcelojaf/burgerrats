import 'package:flutter/material.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../shared/widgets/error_widgets.dart';

/// Demo page to showcase the error handling framework
/// This page is for testing purposes only
class ErrorDemoPage extends StatefulWidget {
  const ErrorDemoPage({super.key});

  @override
  State<ErrorDemoPage> createState() => _ErrorDemoPageState();
}

class _ErrorDemoPageState extends State<ErrorDemoPage> {
  dynamic _currentError;
  bool _showInlineError = false;

  void _triggerNetworkError() {
    const exception = NetworkException(
      message: 'Sem conexão com a internet. Verifique sua conexão e tente novamente.',
      code: 'network-error',
    );
    ErrorDisplay.showSnackbar(context, exception, onRetry: () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tentando novamente...')),
      );
    });
  }

  void _triggerAuthError() {
    const exception = AuthException(
      message: 'E-mail ou senha incorretos.',
      code: 'invalid-credential',
    );
    ErrorDisplay.showSnackbar(context, exception);
  }

  void _triggerValidationError() {
    const exception = ValidationException(
      message: 'Dados inválidos. Por favor, verifique os campos.',
      code: 'validation-error',
      fieldErrors: {
        'email': 'E-mail inválido',
        'password': 'Senha muito curta',
      },
    );
    ErrorDisplay.showDialog(context, exception, title: 'Erro de Validação');
  }

  void _triggerServerError() {
    const exception = ServerException(
      message: 'Erro no servidor. Por favor, tente novamente mais tarde.',
      code: 'server-error',
      statusCode: 500,
    );
    ErrorDisplay.showCriticalDialog(context, exception);
  }

  void _triggerBusinessError() {
    const exception = BusinessException(
      message: 'Você já fez check-in hoje nesta liga.',
      code: 'already-checked-in',
    );
    setState(() {
      _currentError = exception;
      _showInlineError = true;
    });
  }

  void _clearInlineError() {
    setState(() {
      _currentError = null;
      _showInlineError = false;
    });
  }

  void _testErrorHandlerTransform() {
    // Test transforming a generic exception
    try {
      throw FormatException('Invalid JSON format');
    } catch (e, stackTrace) {
      final appException = ErrorHandler.handleError(e, stackTrace);
      ErrorDisplay.showSnackbar(context, appException);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demonstração de Erros'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Framework de Tratamento de Erros',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Toque nos botões para ver diferentes tipos de mensagens de erro em português.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Snackbar errors section
            _SectionHeader(title: 'Erros em Snackbar'),
            const SizedBox(height: 8),
            FilledButton.icon(
              key: const Key('network-error-btn'),
              onPressed: _triggerNetworkError,
              icon: const Icon(Icons.wifi_off),
              label: const Text('Erro de Rede'),
            ),
            const SizedBox(height: 8),
            FilledButton.tonal(
              key: const Key('auth-error-btn'),
              onPressed: _triggerAuthError,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline),
                  SizedBox(width: 8),
                  Text('Erro de Autenticação'),
                ],
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              key: const Key('format-error-btn'),
              onPressed: _testErrorHandlerTransform,
              icon: const Icon(Icons.code),
              label: const Text('Erro de Formato'),
            ),
            const SizedBox(height: 24),

            // Dialog errors section
            _SectionHeader(title: 'Erros em Diálogo'),
            const SizedBox(height: 8),
            FilledButton.icon(
              key: const Key('validation-error-btn'),
              onPressed: _triggerValidationError,
              icon: const Icon(Icons.warning_amber),
              label: const Text('Erro de Validação'),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              key: const Key('server-error-btn'),
              onPressed: _triggerServerError,
              icon: const Icon(Icons.cloud_off),
              label: const Text('Erro Crítico'),
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
            ),
            const SizedBox(height: 24),

            // Inline errors section
            _SectionHeader(title: 'Erros Inline'),
            const SizedBox(height: 8),
            FilledButton.tonal(
              key: const Key('business-error-btn'),
              onPressed: _triggerBusinessError,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.business),
                  SizedBox(width: 8),
                  Text('Erro de Negócio'),
                ],
              ),
            ),
            if (_showInlineError && _currentError != null) ...[
              const SizedBox(height: 16),
              InlineErrorWidget(
                key: const Key('inline-error-widget'),
                error: _currentError,
                onRetry: _clearInlineError,
              ),
            ],
            const SizedBox(height: 24),

            // Compact inline error
            if (_showInlineError && _currentError != null) ...[
              _SectionHeader(title: 'Erro Inline Compacto'),
              const SizedBox(height: 8),
              InlineErrorWidget(
                key: const Key('inline-error-compact'),
                error: _currentError,
                onRetry: _clearInlineError,
                compact: true,
              ),
            ],
            const SizedBox(height: 24),

            // Empty state with error
            _SectionHeader(title: 'Estado Vazio com Erro'),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: EmptyStateWidget(
                key: const Key('empty-state-widget'),
                message: 'Nenhum item encontrado',
                error: _showInlineError ? _currentError : null,
                action: _showInlineError ? _clearInlineError : null,
                actionLabel: 'Limpar erro',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
