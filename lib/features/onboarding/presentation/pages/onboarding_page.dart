import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/onboarding_page_content.dart';

/// Onboarding page shown on first app launch
///
/// Displays a series of slides explaining:
/// 1. App features overview
/// 2. How leagues work
/// 3. Check-in mechanics
///
/// Users can navigate through slides or skip to go directly to login.
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const int _totalPages = 3;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    await ref.read(onboardingServiceProvider).completeOnboarding();
    if (mounted) {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: TextButton(
                    onPressed: _skipOnboarding,
                    child: Text(
                      'Pular',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              // Page content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  children: const [
                    OnboardingPageContent(
                      imagePath: 'assets/images/logo.png',
                      title: 'Bem-vindo ao BurgerRats!',
                      description:
                          'Registre suas visitas a hamburguerias, avalie seus burgers favoritos e compartilhe suas experiencias com amigos.',
                      highlightText: 'Sua jornada burger começa aqui!',
                    ),
                    OnboardingPageContent(
                      icon: Icons.emoji_events,
                      title: 'Compita em Ligas',
                      description:
                          'Crie ou participe de ligas com seus amigos. Quem visitar mais hamburguerias no periodo da liga, ganha!',
                      highlightText: 'Forme sua equipe e suba no ranking!',
                    ),
                    OnboardingPageContent(
                      icon: Icons.camera_alt,
                      title: 'Faça Check-ins',
                      description:
                          'Tire uma foto do seu burger, avalie de 1 a 5 estrelas e registre o nome da hamburgueria. Cada check-in vale pontos na liga!',
                      highlightText: 'Um check-in por dia por liga!',
                    ),
                  ],
                ),
              ),

              // Page indicators and buttons
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    // Page indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _totalPages,
                        (index) => _PageIndicator(
                          isActive: index == _currentPage,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Navigation button
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _nextPage,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.md,
                          ),
                        ),
                        child: Text(
                          _currentPage == _totalPages - 1
                              ? 'Começar'
                              : 'Próximo',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Page indicator dot for the onboarding carousel
class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
