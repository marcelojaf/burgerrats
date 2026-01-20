import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

/// Service for sending push notifications when a user checks in
///
/// This service creates notification requests in Firestore that will be
/// processed by Firebase Cloud Functions to send FCM notifications to
/// all members of the league.
///
/// The notification payload includes:
/// - User name who made the check-in
/// - League name
/// - Restaurant name (if provided)
/// - Check-in ID for navigation
///
/// Example usage:
/// ```dart
/// final service = getIt<CheckInNotificationService>();
/// await service.sendCheckInNotification(
///   checkInId: 'check-in-123',
///   userId: 'user-456',
///   userName: 'John Doe',
///   leagueId: 'league-789',
///   leagueName: 'Burger Lovers',
///   restaurantName: 'Five Guys',
/// );
/// ```
@lazySingleton
class CheckInNotificationService {
  final FirebaseFirestore _firestore;

  /// Collection for notification requests that Cloud Functions will process
  static const String _notificationRequestsCollection = 'notification_requests';

  CheckInNotificationService(this._firestore);

  /// Sends a check-in notification to all league members
  ///
  /// Creates a notification request document in Firestore that will be
  /// processed by a Cloud Function to send FCM messages to the league topic.
  ///
  /// The notification will NOT be sent to the user who made the check-in
  /// (this is handled by the Cloud Function).
  ///
  /// Parameters:
  /// - [checkInId]: The ID of the check-in for navigation
  /// - [userId]: The ID of the user who made the check-in
  /// - [userName]: Display name of the user (for notification content)
  /// - [leagueId]: The ID of the league where the check-in was made
  /// - [leagueName]: Name of the league (for notification content)
  /// - [restaurantName]: Optional restaurant name (for notification content)
  ///
  /// Throws [NotificationException] if the notification request fails.
  Future<void> sendCheckInNotification({
    required String checkInId,
    required String userId,
    required String userName,
    required String leagueId,
    required String leagueName,
    String? restaurantName,
  }) async {
    try {
      // Build notification title and body
      final title = '$userName fez check-in!';
      String body;
      if (restaurantName != null && restaurantName.isNotEmpty) {
        body = '$restaurantName - $leagueName';
      } else {
        body = 'Novo check-in na liga $leagueName';
      }

      // Create notification request document
      final notificationRequest = {
        'type': 'new_checkin',
        'title': title,
        'body': body,
        'topic': 'league_$leagueId',
        'data': {
          'type': 'new_checkin',
          'checkInId': checkInId,
          'leagueId': leagueId,
          'userId': userId,
        },
        'excludeUserId': userId, // Don't send to the user who made the check-in
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'pending', // Will be updated to 'sent' by Cloud Function
      };

      await _firestore
          .collection(_notificationRequestsCollection)
          .add(notificationRequest);

      debugPrint('Check-in notification request created for league: $leagueId');
    } catch (e, stackTrace) {
      debugPrint('Error creating check-in notification request: $e');
      // Don't throw - notification failure shouldn't break the check-in flow
      // Just log the error for monitoring
      debugPrint('Stack trace: $stackTrace');
    }
  }

  /// Sends a batch of check-in notifications for multiple leagues
  ///
  /// Useful when a check-in needs to notify multiple leagues (future feature).
  Future<void> sendBatchCheckInNotifications({
    required String checkInId,
    required String userId,
    required String userName,
    required List<LeagueNotificationInfo> leagues,
    String? restaurantName,
  }) async {
    for (final league in leagues) {
      await sendCheckInNotification(
        checkInId: checkInId,
        userId: userId,
        userName: userName,
        leagueId: league.leagueId,
        leagueName: league.leagueName,
        restaurantName: restaurantName,
      );
    }
  }
}

/// Information about a league for notification purposes
class LeagueNotificationInfo {
  final String leagueId;
  final String leagueName;

  const LeagueNotificationInfo({
    required this.leagueId,
    required this.leagueName,
  });
}
