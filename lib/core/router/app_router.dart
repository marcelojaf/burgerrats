import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/email_verification_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/check_ins/presentation/pages/check_in_details_page.dart';
import '../../features/check_ins/presentation/pages/check_ins_page.dart';
import '../../features/check_ins/presentation/pages/create_check_in_page.dart';
import '../../features/activity_feed/presentation/pages/activity_feed_page.dart';
import '../../features/error_demo/presentation/pages/error_demo_page.dart';
import '../../features/leagues/presentation/pages/create_league_page.dart';
import '../../features/leagues/presentation/pages/join_league_page.dart';
import '../../features/leagues/presentation/pages/league_details_page.dart';
import '../../features/leagues/presentation/pages/league_settings_page.dart';
import '../../features/leagues/presentation/pages/leagues_page.dart';
import '../../features/reminders/presentation/pages/reminder_settings_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/settings_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../state/providers/auth_state_provider.dart';
import 'app_routes.dart';

/// Check if a route is public (doesn't require auth)
bool _isPublicRoute(String location) {
  // Login and its subroutes
  if (location.startsWith(AppRoutes.login)) return true;
  // Splash screen
  if (location == AppRoutes.splash) return true;
  // Onboarding screen (shown before login on first launch)
  if (location == AppRoutes.onboarding) return true;
  // Email verification (user is logged in but needs verification)
  if (location == AppRoutes.emailVerification) return true;
  return false;
}

/// Provider for the GoRouter instance with auth-aware redirects
///
/// This provider creates a GoRouter that:
/// - Listens to Firebase auth state changes
/// - Automatically redirects to login when user logs out
/// - Automatically redirects to home when user logs in from login page
/// - Protects authenticated routes from unauthenticated access
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    refreshListenable: _GoRouterRefreshStream(
      FirebaseAuth.instance.authStateChanges(),
    ),
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull != null;
      final location = state.matchedLocation;
      final isPublicRoute = _isPublicRoute(location);

      // If on splash, let it handle the redirect itself
      if (location == AppRoutes.splash) {
        return null;
      }

      // If not logged in and trying to access protected route
      if (!isLoggedIn && !isPublicRoute) {
        return AppRoutes.login;
      }

      // If logged in and trying to access login page
      if (isLoggedIn && location.startsWith(AppRoutes.login)) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: _routes,
    errorBuilder: (context, state) => _ErrorPage(error: state.error),
  );
});

/// Helper class to convert a Stream into a Listenable for GoRouter refresh
class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

// Navigator keys
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// Application routes definition
final _routes = <RouteBase>[
  // Splash route
  GoRoute(
    path: AppRoutes.splash,
    name: RouteNames.splash,
    builder: (context, state) => const SplashPage(),
  ),

  // Onboarding route (shown on first launch)
  GoRoute(
    path: AppRoutes.onboarding,
    name: RouteNames.onboarding,
    builder: (context, state) => const OnboardingPage(),
  ),

  // Authentication routes
  GoRoute(
    path: AppRoutes.login,
    name: RouteNames.login,
    builder: (context, state) => const LoginPage(),
    routes: [
      GoRoute(
        path: 'register',
        name: RouteNames.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: 'forgot-password',
        name: RouteNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
    ],
  ),

  // Email verification route (separate from login subroutes for better UX)
  GoRoute(
    path: AppRoutes.emailVerification,
    name: RouteNames.emailVerification,
    builder: (context, state) => const EmailVerificationPage(),
  ),

  // Main app routes with shell for bottom navigation
  ShellRoute(
    navigatorKey: _shellNavigatorKey,
    builder: (context, state, child) {
      return _MainShell(child: child);
    },
    routes: [
      // Home route - Activity Feed
      GoRoute(
        path: AppRoutes.home,
        name: RouteNames.home,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: ActivityFeedPage(),
        ),
      ),

      // Leagues routes
      GoRoute(
        path: AppRoutes.leagues,
        name: RouteNames.leagues,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: LeaguesPage(),
        ),
      ),

      // Check-ins routes
      GoRoute(
        path: AppRoutes.checkIns,
        name: RouteNames.checkIns,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: CheckInsPage(),
        ),
      ),

      // Profile routes
      GoRoute(
        path: AppRoutes.profile,
        name: RouteNames.profile,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: ProfilePage(),
        ),
      ),
    ],
  ),

  // Standalone routes (outside shell)
  GoRoute(
    path: AppRoutes.leagueDetails,
    name: RouteNames.leagueDetails,
    builder: (context, state) {
      final leagueId = state.pathParameters['leagueId'] ?? '';
      return LeagueDetailsPage(leagueId: leagueId);
    },
  ),

  GoRoute(
    path: AppRoutes.checkInDetails,
    name: RouteNames.checkInDetails,
    builder: (context, state) {
      final checkInId = state.pathParameters['checkInId'] ?? '';
      return CheckInDetailsPage(checkInId: checkInId);
    },
  ),

  // Create check-in route
  GoRoute(
    path: AppRoutes.createCheckIn,
    name: RouteNames.createCheckIn,
    builder: (context, state) {
      final leagueId = state.uri.queryParameters['leagueId'];
      return CreateCheckInPage(preselectedLeagueId: leagueId);
    },
  ),

  GoRoute(
    path: AppRoutes.editProfile,
    name: RouteNames.editProfile,
    builder: (context, state) => const EditProfilePage(),
  ),

  GoRoute(
    path: AppRoutes.settings,
    name: RouteNames.settings,
    builder: (context, state) => const SettingsPage(),
  ),

  // League routes
  GoRoute(
    path: AppRoutes.joinLeague,
    name: RouteNames.joinLeague,
    builder: (context, state) {
      final inviteCode = state.uri.queryParameters['code'];
      return JoinLeaguePage(initialCode: inviteCode);
    },
  ),

  GoRoute(
    path: AppRoutes.createLeague,
    name: RouteNames.createLeague,
    builder: (context, state) => const CreateLeaguePage(),
  ),

  // League settings route
  GoRoute(
    path: AppRoutes.leagueSettings,
    name: RouteNames.leagueSettings,
    builder: (context, state) {
      final leagueId = state.pathParameters['leagueId'] ?? '';
      return LeagueSettingsPage(leagueId: leagueId);
    },
  ),

  // League reminders route
  GoRoute(
    path: AppRoutes.leagueReminders,
    name: RouteNames.leagueReminders,
    builder: (context, state) {
      final leagueId = state.pathParameters['leagueId'] ?? '';
      return ReminderSettingsPageWrapper(leagueId: leagueId);
    },
  ),

  // Development/Testing routes
  GoRoute(
    path: AppRoutes.errorDemo,
    name: RouteNames.errorDemo,
    builder: (context, state) => const ErrorDemoPage(),
  ),

  // Deep link routes - These handle incoming deep links
  // League invitation deep link: burgerrats://league/{id} or https://burgerrats.app/league/{id}
  GoRoute(
    path: AppRoutes.leagueInvite,
    name: RouteNames.leagueInvite,
    redirect: (context, state) {
      final leagueId = state.pathParameters['leagueId'] ?? '';
      // Redirect to the actual league details page
      return AppRoutes.leagueDetails.replaceFirst(':leagueId', leagueId);
    },
  ),

  // Check-in share deep link: burgerrats://checkin/{id} or https://burgerrats.app/checkin/{id}
  GoRoute(
    path: AppRoutes.checkInShare,
    name: RouteNames.checkInShare,
    redirect: (context, state) {
      final checkInId = state.pathParameters['checkInId'] ?? '';
      // Redirect to the actual check-in details page
      return AppRoutes.checkInDetails.replaceFirst(':checkInId', checkInId);
    },
  ),

  // Join league via invite code deep link: burgerrats://join/{code} or https://burgerrats.app/join/{code}
  GoRoute(
    path: AppRoutes.joinLeagueInvite,
    name: RouteNames.joinLeagueInvite,
    redirect: (context, state) {
      final inviteCode = state.pathParameters['inviteCode'] ?? '';
      // Redirect to the join league page with the invite code
      return '${AppRoutes.joinLeague}?code=$inviteCode';
    },
  ),
];

/// Legacy router class for backwards compatibility
@Deprecated('Use routerProvider instead for auth-aware routing')
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: _routes,
    errorBuilder: (context, state) => _ErrorPage(error: state.error),
  );
}

/// Main shell widget with bottom navigation
class _MainShell extends StatelessWidget {
  const _MainShell({required this.child});

  final Widget child;

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith(AppRoutes.home)) return 0;
    if (location.startsWith(AppRoutes.leagues)) return 1;
    if (location.startsWith(AppRoutes.checkIns)) return 2;
    if (location.startsWith(AppRoutes.profile)) return 3;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
      case 1:
        context.go(AppRoutes.leagues);
      case 2:
        context.go(AppRoutes.checkIns);
      case 3:
        context.go(AppRoutes.profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (index) => _onItemTapped(context, index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.emoji_events_outlined),
            selectedIcon: Icon(Icons.emoji_events),
            label: 'Leagues',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_outlined),
            selectedIcon: Icon(Icons.restaurant),
            label: 'Check-ins',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

/// Error page displayed when navigation fails
class _ErrorPage extends StatelessWidget {
  const _ErrorPage({this.error});

  final Exception? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              error?.toString() ?? 'The requested page could not be found.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
