import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/check_ins/presentation/pages/check_in_details_page.dart';
import '../../features/check_ins/presentation/pages/check_ins_page.dart';
import '../../features/check_ins/presentation/pages/create_check_in_page.dart';
import '../../features/error_demo/presentation/pages/error_demo_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/leagues/presentation/pages/create_league_page.dart';
import '../../features/leagues/presentation/pages/join_league_page.dart';
import '../../features/leagues/presentation/pages/league_details_page.dart';
import '../../features/leagues/presentation/pages/leagues_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/settings_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import 'app_routes.dart';

/// Application router configuration using go_router
class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      // Splash route
      GoRoute(
        path: AppRoutes.splash,
        name: RouteNames.splash,
        builder: (context, state) => const SplashPage(),
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

      // Main app routes with shell for bottom navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return _MainShell(child: child);
        },
        routes: [
          // Home route
          GoRoute(
            path: AppRoutes.home,
            name: RouteNames.home,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomePage(),
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
    ],
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
