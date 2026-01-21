import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/state/providers/auth_state_provider.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/utils/validators.dart';

/// Forgot password page for password reset
class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSendResetLink() async {
    // Clear any previous errors
    ref.read(authNotifierProvider.notifier).clearError();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final success = await ref.read(authNotifierProvider.notifier).sendPasswordReset(
          email: _emailController.text.trim(),
        );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      if (success) {
        _emailSent = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Listen for auth errors and show snackbar
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
        title: Text(context.l10n.recoverPassword),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppSpacing.screenPadding,
            child: _emailSent ? _buildSuccessContent() : _buildFormContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Icon
          Icon(
            Icons.lock_reset,
            size: AppSpacing.xxxl,
            color: context.colorScheme.primary,
          ),
          AppSpacing.gapVerticalLg,

          // Title
          Text(
            context.l10n.forgotPasswordTitle,
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.gapVerticalSm,

          // Info text
          Text(
            context.l10n.forgotPasswordDescription,
            style: context.textTheme.bodyLarge?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.gapVerticalXl,

          // Email field
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: context.l10n.email,
              prefixIcon: const Icon(Icons.email_outlined),
              hintText: context.l10n.emailHint,
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            autocorrect: false,
            enableSuggestions: false,
            validator: Validators.email,
            onFieldSubmitted: (_) => _handleSendResetLink(),
          ),
          AppSpacing.gapVerticalLg,

          // Send button
          FilledButton(
            onPressed: _isLoading ? null : _handleSendResetLink,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : Text(context.l10n.sendLink),
          ),
          AppSpacing.gapVerticalMd,

          // Back to login link
          TextButton(
            onPressed: () => context.pop(),
            child: Text(context.l10n.backToLogin),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Success icon
        Icon(
          Icons.mark_email_read_outlined,
          size: AppSpacing.xxxl,
          color: context.colorScheme.primary,
        ),
        AppSpacing.gapVerticalLg,

        // Title
        Text(
          context.l10n.emailSent,
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        AppSpacing.gapVerticalSm,

        // Info text
        Text(
          context.l10n.recoveryLinkSentTo,
          style: context.textTheme.bodyLarge?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        AppSpacing.gapVerticalSm,

        // Email display
        Text(
          _emailController.text.trim(),
          style: context.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colorScheme.primary,
          ),
          textAlign: TextAlign.center,
        ),
        AppSpacing.gapVerticalMd,

        // Additional info
        Text(
          context.l10n.checkInboxAndSpam,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        AppSpacing.gapVerticalXl,

        // Back to login button
        FilledButton(
          onPressed: () => context.pop(),
          child: Text(context.l10n.backToLogin),
        ),
        AppSpacing.gapVerticalMd,

        // Resend link
        TextButton(
          onPressed: () {
            setState(() {
              _emailSent = false;
            });
          },
          child: Text(context.l10n.didNotReceiveResend),
        ),
      ],
    );
  }
}
