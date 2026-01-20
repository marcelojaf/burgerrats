import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/state/providers/auth_state_provider.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/utils/validators.dart';

/// Login page for user authentication
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // Clear any previous errors
    ref.read(authNotifierProvider.notifier).clearError();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final success = await ref.read(authNotifierProvider.notifier).signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (success) {
      final authState = ref.read(authNotifierProvider);
      // Check if email is verified
      if (authState.user != null && !authState.user!.emailVerified) {
        context.go(AppRoutes.emailVerification);
      } else {
        context.go(AppRoutes.home);
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    // Clear any previous errors
    ref.read(authNotifierProvider.notifier).clearError();

    setState(() {
      _isGoogleLoading = true;
    });

    final success = await ref.read(authNotifierProvider.notifier).signInWithGoogle();

    if (!mounted) return;

    setState(() {
      _isGoogleLoading = false;
    });

    if (success) {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppSpacing.screenPadding,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/logo.png',
                    width: AppSpacing.xxxl,
                    height: AppSpacing.xxxl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.restaurant,
                        size: AppSpacing.xxxl,
                        color: context.colorScheme.primary,
                      );
                    },
                  ),
                  AppSpacing.gapVerticalMd,

                  // Title
                  Text(
                    'BurgerRats',
                    style: context.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  AppSpacing.gapVerticalSm,

                  // Subtitle
                  Text(
                    'Entre para avaliar hamburguerias',
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  AppSpacing.gapVerticalXl,

                  // Email field
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      prefixIcon: Icon(Icons.email_outlined),
                      hintText: 'seu@email.com',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autocorrect: false,
                    enableSuggestions: false,
                    validator: Validators.email,
                  ),
                  AppSpacing.gapVerticalMd,

                  // Password field
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      prefixIcon: const Icon(Icons.lock_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    validator: Validators.password,
                    onFieldSubmitted: (_) => _handleLogin(),
                  ),
                  AppSpacing.gapVerticalLg,

                  // Login button
                  FilledButton(
                    onPressed: _isLoading || authState.isLoading
                        ? null
                        : _handleLogin,
                    child: _isLoading || authState.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Entrar'),
                  ),
                  AppSpacing.gapVerticalMd,

                  // Forgot password link
                  TextButton(
                    onPressed: () => context.push(AppRoutes.forgotPassword),
                    child: const Text('Esqueceu a senha?'),
                  ),

                  // Divider
                  AppSpacing.gapVerticalMd,
                  Row(
                    children: [
                      Expanded(child: Divider(color: context.colorScheme.outline)),
                      Padding(
                        padding: AppSpacing.paddingHorizontalMd,
                        child: Text(
                          'ou',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: context.colorScheme.outline)),
                    ],
                  ),
                  AppSpacing.gapVerticalMd,

                  // Google Sign-In button
                  OutlinedButton.icon(
                    onPressed: _isGoogleLoading || authState.isLoading
                        ? null
                        : _handleGoogleSignIn,
                    icon: _isGoogleLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const _GoogleIcon(),
                    label: const Text('Continuar com Google'),
                  ),
                  AppSpacing.gapVerticalMd,

                  // Create account link
                  OutlinedButton(
                    onPressed: () => context.push(AppRoutes.register),
                    child: const Text('Criar conta'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom Google icon widget using the official Google colors
class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(20, 20),
      painter: _GoogleIconPainter(),
    );
  }
}

/// Custom painter for the Google "G" logo with proper colors
class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double s = size.width;

    // Google brand colors
    const Color blue = Color(0xFF4285F4);
    const Color red = Color(0xFFEA4335);
    const Color yellow = Color(0xFFFBBC05);
    const Color green = Color(0xFF34A853);

    final Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Draw the Google "G" shape using arcs
    final Rect rect = Rect.fromLTWH(0, 0, s, s);
    const double strokeWidth = 0.22;

    // Blue arc (right side)
    paint.color = blue;
    canvas.drawArc(
      rect,
      -0.4,
      1.2,
      true,
      paint,
    );

    // Green arc (bottom right)
    paint.color = green;
    canvas.drawArc(
      rect,
      0.8,
      1.0,
      true,
      paint,
    );

    // Yellow arc (bottom left)
    paint.color = yellow;
    canvas.drawArc(
      rect,
      1.8,
      0.8,
      true,
      paint,
    );

    // Red arc (top)
    paint.color = red;
    canvas.drawArc(
      rect,
      2.6,
      1.0,
      true,
      paint,
    );

    // White center circle to create the "G" effect
    paint.color = Colors.white;
    canvas.drawCircle(
      Offset(s / 2, s / 2),
      s * 0.35,
      paint,
    );

    // Blue horizontal bar for the "G"
    paint.color = blue;
    canvas.drawRect(
      Rect.fromLTWH(s * 0.48, s * 0.42, s * 0.52, s * 0.16),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
