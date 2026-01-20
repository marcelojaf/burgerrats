import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/state/providers/auth_state_provider.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/theme/app_spacing.dart';

/// Email verification page shown after registration
class EmailVerificationPage extends ConsumerStatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  ConsumerState<EmailVerificationPage> createState() =>
      _EmailVerificationPageState();
}

class _EmailVerificationPageState extends ConsumerState<EmailVerificationPage> {
  Timer? _checkTimer;
  bool _isResending = false;
  bool _canResend = true;
  int _resendCooldown = 0;
  Timer? _cooldownTimer;

  @override
  void initState() {
    super.initState();
    _startVerificationCheck();
  }

  @override
  void dispose() {
    _checkTimer?.cancel();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _startVerificationCheck() {
    // Check every 3 seconds if email has been verified
    _checkTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      await ref.read(authNotifierProvider.notifier).reloadUser();

      if (!mounted) return;

      final authState = ref.read(authNotifierProvider);
      if (authState.user?.emailVerified == true) {
        _checkTimer?.cancel();
        context.go(AppRoutes.home);
      }
    });
  }

  Future<void> _handleResendEmail() async {
    if (!_canResend || _isResending) return;

    setState(() {
      _isResending = true;
    });

    final success =
        await ref.read(authNotifierProvider.notifier).sendEmailVerification();

    if (!mounted) return;

    setState(() {
      _isResending = false;
    });

    if (success) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('E-mail de verificação enviado!'),
          backgroundColor: context.colorScheme.primary,
        ),
      );

      // Start cooldown
      _startResendCooldown();
    }
  }

  void _startResendCooldown() {
    setState(() {
      _canResend = false;
      _resendCooldown = 60; // 60 seconds cooldown
    });

    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_resendCooldown > 0) {
        setState(() {
          _resendCooldown--;
        });
      } else {
        _cooldownTimer?.cancel();
        setState(() {
          _canResend = true;
        });
      }
    });
  }

  Future<void> _handleSignOut() async {
    await ref.read(authNotifierProvider.notifier).signOut();
    if (!mounted) return;
    context.go(AppRoutes.login);
  }

  Future<void> _handleCheckVerification() async {
    await ref.read(authNotifierProvider.notifier).reloadUser();

    if (!mounted) return;

    final authState = ref.read(authNotifierProvider);
    if (authState.user?.emailVerified == true) {
      context.go(AppRoutes.home);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('E-mail ainda não verificado'),
          backgroundColor: context.colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final userEmail = authState.user?.email ?? '';

    // Listen for auth errors
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (next.hasError && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: context.colorScheme.error,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificar e-mail'),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: _handleSignOut,
            child: const Text('Sair'),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppSpacing.screenPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Icon
                Icon(
                  Icons.mark_email_unread_outlined,
                  size: AppSpacing.xxxl,
                  color: context.colorScheme.primary,
                ),
                AppSpacing.gapVerticalLg,

                // Title
                Text(
                  'Verifique seu e-mail',
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                AppSpacing.gapVerticalSm,

                // Info text
                Text(
                  'Enviamos um link de verificação para:',
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                AppSpacing.gapVerticalSm,

                // Email display
                Text(
                  userEmail,
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                AppSpacing.gapVerticalMd,

                // Instructions
                Container(
                  padding: AppSpacing.cardPadding,
                  decoration: BoxDecoration(
                    color: context.colorScheme.surfaceContainerHighest,
                    borderRadius: AppSpacing.borderRadiusMd,
                  ),
                  child: Column(
                    children: [
                      _buildInstructionItem(
                        context,
                        '1',
                        'Abra seu aplicativo de e-mail',
                      ),
                      AppSpacing.gapVerticalSm,
                      _buildInstructionItem(
                        context,
                        '2',
                        'Procure pelo e-mail do BurgerRats',
                      ),
                      AppSpacing.gapVerticalSm,
                      _buildInstructionItem(
                        context,
                        '3',
                        'Clique no link de verificação',
                      ),
                    ],
                  ),
                ),
                AppSpacing.gapVerticalMd,

                // Additional info
                Text(
                  'Não encontrou? Verifique também a pasta de spam.',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                AppSpacing.gapVerticalXl,

                // Check verification button
                FilledButton(
                  onPressed: _handleCheckVerification,
                  child: const Text('Já verifiquei'),
                ),
                AppSpacing.gapVerticalMd,

                // Resend button
                OutlinedButton(
                  onPressed: _canResend && !_isResending
                      ? _handleResendEmail
                      : null,
                  child: _isResending
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          _canResend
                              ? 'Reenviar e-mail'
                              : 'Reenviar em ${_resendCooldown}s',
                        ),
                ),
                AppSpacing.gapVerticalLg,

                // Loading indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: context.colorScheme.outline,
                      ),
                    ),
                    AppSpacing.gapHorizontalSm,
                    Text(
                      'Verificando automaticamente...',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionItem(
    BuildContext context,
    String number,
    String text,
  ) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: context.colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        AppSpacing.gapHorizontalMd,
        Expanded(
          child: Text(
            text,
            style: context.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
