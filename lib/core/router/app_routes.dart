/// Route path constants for the application
abstract class AppRoutes {
  AppRoutes._();

  // Authentication routes
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String emailVerification = '/email-verification';

  // Main app routes
  static const String home = '/home';
  static const String leagues = '/leagues';
  static const String leagueDetails = '/leagues/:leagueId';
  static const String checkIns = '/check-ins';
  static const String checkInDetails = '/check-ins/:checkInId';
  static const String createCheckIn = '/check-ins/create';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String settings = '/settings';

  // League routes
  static const String joinLeague = '/leagues/join';
  static const String createLeague = '/leagues/create';
  static const String leagueSettings = '/leagues/:leagueId/settings';
  static const String leagueReminders = '/leagues/:leagueId/reminders';

  // Deep link routes
  static const String leagueInvite = '/league/:leagueId';
  static const String checkInShare = '/checkin/:checkInId';
  static const String joinLeagueInvite = '/join/:inviteCode';

  // Development/Testing routes
  static const String errorDemo = '/error-demo';
}

/// Route name constants for named navigation
abstract class RouteNames {
  RouteNames._();

  // Authentication
  static const String splash = 'splash';
  static const String onboarding = 'onboarding';
  static const String login = 'login';
  static const String register = 'register';
  static const String forgotPassword = 'forgot-password';
  static const String emailVerification = 'email-verification';

  // Main app
  static const String home = 'home';
  static const String leagues = 'leagues';
  static const String leagueDetails = 'league-details';
  static const String checkIns = 'check-ins';
  static const String checkInDetails = 'check-in-details';
  static const String createCheckIn = 'create-check-in';
  static const String profile = 'profile';
  static const String editProfile = 'edit-profile';
  static const String settings = 'settings';

  // League
  static const String joinLeague = 'join-league';
  static const String createLeague = 'create-league';
  static const String leagueSettings = 'league-settings';
  static const String leagueReminders = 'league-reminders';

  // Deep link routes
  static const String leagueInvite = 'league-invite';
  static const String checkInShare = 'checkin-share';
  static const String joinLeagueInvite = 'join-league-invite';

  // Development/Testing
  static const String errorDemo = 'error-demo';
}
