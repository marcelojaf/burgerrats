import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:burgerrats/features/onboarding/data/services/onboarding_service.dart';
import 'package:burgerrats/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:burgerrats/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:burgerrats/shared/theme/app_theme.dart';

// Mock classes
class MockOnboardingService extends Mock implements OnboardingService {}

void main() {
  late MockOnboardingService mockOnboardingService;

  setUp(() {
    mockOnboardingService = MockOnboardingService();
    when(() => mockOnboardingService.completeOnboarding())
        .thenAnswer((_) async {});
  });

  Widget createTestWidget({
    List<Override> overrides = const [],
  }) {
    return ProviderScope(
      overrides: [
        onboardingServiceProvider.overrideWithValue(mockOnboardingService),
        ...overrides,
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        home: const OnboardingPage(),
        routes: {
          '/login': (context) => const Scaffold(body: Text('Login')),
        },
      ),
    );
  }

  group('OnboardingPage', () {
    group('UI Elements', () {
      testWidgets('should display first onboarding page initially',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // First page content
        expect(find.text('Bem-vindo ao BurgerRats!'), findsOneWidget);
        expect(find.byIcon(Icons.restaurant_menu), findsOneWidget);
      });

      testWidgets('should display skip button', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        expect(find.text('Pular'), findsOneWidget);
      });

      testWidgets('should display next button on first pages', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        expect(find.text('Próximo'), findsOneWidget);
      });

      testWidgets('should display page indicators', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Should have 3 page indicators (AnimatedContainer)
        final indicatorFinder = find.byWidgetPredicate((widget) {
          if (widget is AnimatedContainer) {
            final decoration = widget.decoration;
            if (decoration is BoxDecoration) {
              return decoration.borderRadius != null;
            }
          }
          return false;
        });
        expect(indicatorFinder, findsNWidgets(3));
      });

      testWidgets('should have gradient background', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        final containerFinder = find.byWidgetPredicate((widget) {
          if (widget is Container && widget.decoration is BoxDecoration) {
            final decoration = widget.decoration as BoxDecoration;
            return decoration.gradient != null;
          }
          return false;
        });
        expect(containerFinder, findsOneWidget);
      });
    });

    group('Navigation between pages', () {
      testWidgets('should navigate to second page when tapping next',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Tap next button
        await tester.tap(find.text('Próximo'));
        await tester.pumpAndSettle();

        // Should show second page content
        expect(find.text('Compita em Ligas'), findsOneWidget);
        expect(find.byIcon(Icons.emoji_events), findsOneWidget);
      });

      testWidgets('should navigate to third page when tapping next twice',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Tap next twice
        await tester.tap(find.text('Próximo'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Próximo'));
        await tester.pumpAndSettle();

        // Should show third page content
        expect(find.text('Faça Check-ins'), findsOneWidget);
        expect(find.byIcon(Icons.camera_alt), findsOneWidget);
      });

      testWidgets('should show Começar button on last page', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Navigate to last page
        await tester.tap(find.text('Próximo'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Próximo'));
        await tester.pumpAndSettle();

        // Should show "Começar" instead of "Próximo"
        expect(find.text('Começar'), findsOneWidget);
        expect(find.text('Próximo'), findsNothing);
      });

      testWidgets('should support swipe navigation', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Swipe left to go to next page
        await tester.drag(find.byType(PageView), const Offset(-300, 0));
        await tester.pumpAndSettle();

        // Should show second page
        expect(find.text('Compita em Ligas'), findsOneWidget);
      });
    });

    group('Skip functionality', () {
      testWidgets('should call completeOnboarding when skip is tapped',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Tap skip
        await tester.tap(find.text('Pular'));
        await tester.pumpAndSettle();

        // Verify completeOnboarding was called
        verify(() => mockOnboardingService.completeOnboarding()).called(1);
      });

      testWidgets('should navigate to login when skip is tapped',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Tap skip
        await tester.tap(find.text('Pular'));
        await tester.pumpAndSettle();

        // Should navigate to login
        expect(find.text('Login'), findsOneWidget);
      });
    });

    group('Complete onboarding', () {
      testWidgets(
          'should call completeOnboarding when Começar is tapped on last page',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Navigate to last page
        await tester.tap(find.text('Próximo'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Próximo'));
        await tester.pumpAndSettle();

        // Tap Começar
        await tester.tap(find.text('Começar'));
        await tester.pumpAndSettle();

        // Verify completeOnboarding was called
        verify(() => mockOnboardingService.completeOnboarding()).called(1);
      });

      testWidgets('should navigate to login when completing onboarding',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Navigate to last page
        await tester.tap(find.text('Próximo'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Próximo'));
        await tester.pumpAndSettle();

        // Tap Começar
        await tester.tap(find.text('Começar'));
        await tester.pumpAndSettle();

        // Should navigate to login
        expect(find.text('Login'), findsOneWidget);
      });
    });

    group('Page content', () {
      testWidgets('first page should explain app features', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        expect(find.text('Bem-vindo ao BurgerRats!'), findsOneWidget);
        expect(
            find.textContaining('Registre suas visitas'), findsOneWidget);
        expect(
            find.text('Sua jornada burger começa aqui!'), findsOneWidget);
      });

      testWidgets('second page should explain leagues', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Navigate to second page
        await tester.tap(find.text('Próximo'));
        await tester.pumpAndSettle();

        expect(find.text('Compita em Ligas'), findsOneWidget);
        expect(find.textContaining('Crie ou participe de ligas'),
            findsOneWidget);
        expect(find.text('Forme sua equipe e suba no ranking!'), findsOneWidget);
      });

      testWidgets('third page should explain check-in mechanics',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Navigate to third page
        await tester.tap(find.text('Próximo'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Próximo'));
        await tester.pumpAndSettle();

        expect(find.text('Faça Check-ins'), findsOneWidget);
        expect(find.textContaining('Tire uma foto do seu burger'),
            findsOneWidget);
        expect(find.text('Um check-in por dia por liga!'), findsOneWidget);
      });
    });

    group('Theme Support', () {
      testWidgets('should render correctly in light theme', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              onboardingServiceProvider.overrideWithValue(mockOnboardingService),
            ],
            child: MaterialApp(
              theme: AppTheme.light,
              home: const OnboardingPage(),
            ),
          ),
        );
        await tester.pump();

        expect(find.text('Bem-vindo ao BurgerRats!'), findsOneWidget);
      });

      testWidgets('should render correctly in dark theme', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              onboardingServiceProvider.overrideWithValue(mockOnboardingService),
            ],
            child: MaterialApp(
              theme: AppTheme.dark,
              home: const OnboardingPage(),
            ),
          ),
        );
        await tester.pump();

        expect(find.text('Bem-vindo ao BurgerRats!'), findsOneWidget);
      });
    });
  });
}
