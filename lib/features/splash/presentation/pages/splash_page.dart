import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/state/providers/auth_state_provider.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../onboarding/presentation/providers/onboarding_provider.dart';

/// Splash screen displayed during app initialization
///
/// This page displays the branded BurgerRats logo with animations
/// and listens to auth state changes to automatically redirect
/// to the appropriate screen:
/// - If authenticated: navigates to home
/// - If not authenticated: navigates to login
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  bool _hasNavigated = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Setup animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    // Start animation and initialize
    _animationController.forward();
    _initializeAndNavigate();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _initializeAndNavigate() async {
    // Minimum splash duration for UX (enough to see the animation)
    debugPrint('SplashPage: Starting initialization...');
    await Future.delayed(const Duration(milliseconds: 2000));

    if (!mounted) {
      debugPrint('SplashPage: Widget not mounted after delay');
      return;
    }

    debugPrint('SplashPage: Checking onboarding...');
    // First check if onboarding is needed
    await _checkOnboardingAndNavigate();
  }

  Future<void> _checkOnboardingAndNavigate() async {
    debugPrint('SplashPage: _checkOnboardingAndNavigate called, _hasNavigated=$_hasNavigated, mounted=$mounted');
    if (_hasNavigated || !mounted) return;

    // Check if this is the first launch (onboarding not completed)
    final onboardingService = ref.read(onboardingServiceProvider);
    debugPrint('SplashPage: Checking hasCompletedOnboarding...');
    final hasCompletedOnboarding = await onboardingService.hasCompletedOnboarding();
    debugPrint('SplashPage: hasCompletedOnboarding=$hasCompletedOnboarding');

    if (!mounted) {
      debugPrint('SplashPage: Widget not mounted after onboarding check');
      return;
    }

    // If first launch, show onboarding
    if (!hasCompletedOnboarding) {
      debugPrint('SplashPage: Navigating to onboarding');
      _hasNavigated = true;
      context.go(AppRoutes.onboarding);
      return;
    }

    // Otherwise, check auth state and navigate accordingly
    debugPrint('SplashPage: Checking auth state...');
    _checkAuthAndNavigate();
  }

  void _checkAuthAndNavigate() {
    if (_hasNavigated || !mounted) return;

    final authState = ref.read(authStateProvider);

    authState.when(
      data: (user) {
        if (!mounted) return;
        _hasNavigated = true;

        if (user != null) {
          context.go(AppRoutes.home);
        } else {
          context.go(AppRoutes.login);
        }
      },
      loading: () {
        // Still loading, will retry when state updates
      },
      error: (_, _) {
        if (!mounted) return;
        _hasNavigated = true;
        // On error, redirect to login
        context.go(AppRoutes.login);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Listen to auth state changes for navigation
    // Note: Only triggers navigation if onboarding was already completed
    ref.listen<AsyncValue<dynamic>>(authStateProvider, (previous, next) {
      if (!_hasNavigated) {
        _checkOnboardingAndNavigate();
      }
    });

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    AppColors.surfaceDark,
                    AppColors.surfaceContainerDark,
                  ]
                : [
                    AppColors.primaryContainer,
                    AppColors.surface,
                  ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo with background glow effect
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryContainer,
                            ),
                            child: Icon(
                              Icons.restaurant,
                              size: 100,
                              color: AppColors.primary,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                    // App name
                    Text(
                      'BurgerRats',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                            letterSpacing: 1.5,
                          ),
                    ),
                    const SizedBox(height: 8),
                    // Tagline
                    Text(
                      'Track Your Burger Journey',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.7),
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                    const SizedBox(height: 48),
                    // Loading indicator
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
