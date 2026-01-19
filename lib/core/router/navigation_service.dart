import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_router.dart';
import 'app_routes.dart';

/// Navigation service providing type-safe navigation methods
class NavigationService {
  NavigationService._();

  static GoRouter get router => AppRouter.router;

  // Authentication navigation
  static void goToLogin(BuildContext context) {
    context.go(AppRoutes.login);
  }

  static void pushRegister(BuildContext context) {
    context.push(AppRoutes.register);
  }

  static void pushForgotPassword(BuildContext context) {
    context.push(AppRoutes.forgotPassword);
  }

  // Main app navigation
  static void goToHome(BuildContext context) {
    context.go(AppRoutes.home);
  }

  static void goToLeagues(BuildContext context) {
    context.go(AppRoutes.leagues);
  }

  static void goToCheckIns(BuildContext context) {
    context.go(AppRoutes.checkIns);
  }

  static void goToProfile(BuildContext context) {
    context.go(AppRoutes.profile);
  }

  // Detail pages
  static void pushLeagueDetails(BuildContext context, String leagueId) {
    context.push(
      AppRoutes.leagueDetails.replaceFirst(':leagueId', leagueId),
    );
  }

  static void pushCheckInDetails(BuildContext context, String checkInId) {
    context.push(
      AppRoutes.checkInDetails.replaceFirst(':checkInId', checkInId),
    );
  }

  static void pushEditProfile(BuildContext context) {
    context.push(AppRoutes.editProfile);
  }

  static void pushSettings(BuildContext context) {
    context.push(AppRoutes.settings);
  }

  // General navigation
  static void pop(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    }
  }

  static void popUntilHome(BuildContext context) {
    while (context.canPop()) {
      context.pop();
    }
    context.go(AppRoutes.home);
  }
}

/// Extension on BuildContext for convenient navigation
extension NavigationExtension on BuildContext {
  // Authentication
  void goToLogin() => NavigationService.goToLogin(this);
  void pushRegister() => NavigationService.pushRegister(this);
  void pushForgotPassword() => NavigationService.pushForgotPassword(this);

  // Main app
  void goToHome() => NavigationService.goToHome(this);
  void goToLeagues() => NavigationService.goToLeagues(this);
  void goToCheckIns() => NavigationService.goToCheckIns(this);
  void goToProfile() => NavigationService.goToProfile(this);

  // Detail pages
  void pushLeagueDetails(String leagueId) =>
      NavigationService.pushLeagueDetails(this, leagueId);
  void pushCheckInDetails(String checkInId) =>
      NavigationService.pushCheckInDetails(this, checkInId);
  void pushEditProfile() => NavigationService.pushEditProfile(this);
  void pushSettings() => NavigationService.pushSettings(this);

  // General
  void popSafe() => NavigationService.pop(this);
  void popUntilHome() => NavigationService.popUntilHome(this);
}
