import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/streak_entity.dart';

/// Data model for StreakGracePeriod with Firestore serialization
class StreakGracePeriodModel extends StreakGracePeriod {
  const StreakGracePeriodModel({
    super.gracePeriodHours,
    super.isInGracePeriod,
    super.gracePeriodExpiresAt,
  });

  /// Creates a model from a domain entity
  factory StreakGracePeriodModel.fromEntity(StreakGracePeriod entity) {
    return StreakGracePeriodModel(
      gracePeriodHours: entity.gracePeriodHours,
      isInGracePeriod: entity.isInGracePeriod,
      gracePeriodExpiresAt: entity.gracePeriodExpiresAt,
    );
  }

  /// Creates a model from JSON/Firestore data
  factory StreakGracePeriodModel.fromJson(Json json) {
    DateTime? gracePeriodExpiresAt;
    final expiresAtValue = json['gracePeriodExpiresAt'];
    if (expiresAtValue != null) {
      if (expiresAtValue is Timestamp) {
        gracePeriodExpiresAt = expiresAtValue.toDate();
      } else if (expiresAtValue is String) {
        gracePeriodExpiresAt = DateTime.parse(expiresAtValue);
      } else if (expiresAtValue is int) {
        gracePeriodExpiresAt =
            DateTime.fromMillisecondsSinceEpoch(expiresAtValue);
      }
    }

    return StreakGracePeriodModel(
      gracePeriodHours: json['gracePeriodHours'] as int? ?? 4,
      isInGracePeriod: json['isInGracePeriod'] as bool? ?? false,
      gracePeriodExpiresAt: gracePeriodExpiresAt,
    );
  }

  /// Converts to JSON for Firestore storage
  Json toJson() {
    return {
      'gracePeriodHours': gracePeriodHours,
      'isInGracePeriod': isInGracePeriod,
      'gracePeriodExpiresAt': gracePeriodExpiresAt != null
          ? Timestamp.fromDate(gracePeriodExpiresAt!)
          : null,
    };
  }

  /// Converts to domain entity
  StreakGracePeriod toEntity() {
    return StreakGracePeriod(
      gracePeriodHours: gracePeriodHours,
      isInGracePeriod: isInGracePeriod,
      gracePeriodExpiresAt: gracePeriodExpiresAt,
    );
  }
}

/// Data model for Streak with Firestore serialization
///
/// Handles conversion between:
/// - Firestore documents
/// - Domain StreakEntity
class StreakModel extends StreakEntity {
  const StreakModel({
    required super.id,
    required super.userId,
    super.currentStreak,
    super.longestStreak,
    super.lastCheckInDate,
    super.streakStartDate,
    super.longestStreakDate,
    super.gracePeriod,
    super.totalCheckIns,
    required super.updatedAt,
  });

  /// Creates a model from a domain entity
  factory StreakModel.fromEntity(StreakEntity entity) {
    return StreakModel(
      id: entity.id,
      userId: entity.userId,
      currentStreak: entity.currentStreak,
      longestStreak: entity.longestStreak,
      lastCheckInDate: entity.lastCheckInDate,
      streakStartDate: entity.streakStartDate,
      longestStreakDate: entity.longestStreakDate,
      gracePeriod: entity.gracePeriod,
      totalCheckIns: entity.totalCheckIns,
      updatedAt: entity.updatedAt,
    );
  }

  /// Creates a model from Firestore document data
  factory StreakModel.fromFirestore(DocumentSnapshot<Json> doc) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Document data is null for streak ${doc.id}');
    }
    return StreakModel.fromJson(data, doc.id);
  }

  /// Creates a model from JSON/Firestore data
  factory StreakModel.fromJson(Json json, [String? id]) {
    return StreakModel(
      id: id ?? json['id'] as String,
      userId: json['userId'] as String,
      currentStreak: json['currentStreak'] as int? ?? 0,
      longestStreak: json['longestStreak'] as int? ?? 0,
      lastCheckInDate: _parseDateTime(json['lastCheckInDate']),
      streakStartDate: _parseDateTime(json['streakStartDate']),
      longestStreakDate: _parseDateTime(json['longestStreakDate']),
      gracePeriod: json['gracePeriod'] != null
          ? StreakGracePeriodModel.fromJson(json['gracePeriod'] as Json)
          : const StreakGracePeriod(),
      totalCheckIns: json['totalCheckIns'] as int? ?? 0,
      updatedAt: _parseDateTime(json['updatedAt']) ?? DateTime.now(),
    );
  }

  /// Helper method to parse DateTime from various formats
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.parse(value);
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    return null;
  }

  /// Creates a new streak model for initial Firestore storage
  factory StreakModel.initial({
    required String id,
    required String userId,
  }) {
    return StreakModel(
      id: id,
      userId: userId,
      currentStreak: 0,
      longestStreak: 0,
      lastCheckInDate: null,
      streakStartDate: null,
      longestStreakDate: null,
      gracePeriod: const StreakGracePeriod(),
      totalCheckIns: 0,
      updatedAt: DateTime.now(),
    );
  }

  /// Converts to JSON for Firestore storage
  Json toJson() {
    return {
      'id': id,
      'userId': userId,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastCheckInDate': lastCheckInDate != null
          ? Timestamp.fromDate(lastCheckInDate!)
          : null,
      'streakStartDate': streakStartDate != null
          ? Timestamp.fromDate(streakStartDate!)
          : null,
      'longestStreakDate': longestStreakDate != null
          ? Timestamp.fromDate(longestStreakDate!)
          : null,
      'gracePeriod':
          StreakGracePeriodModel.fromEntity(gracePeriod).toJson(),
      'totalCheckIns': totalCheckIns,
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Converts to JSON for Firestore update
  Json toJsonForUpdate() {
    return {
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastCheckInDate': lastCheckInDate != null
          ? Timestamp.fromDate(lastCheckInDate!)
          : null,
      'streakStartDate': streakStartDate != null
          ? Timestamp.fromDate(streakStartDate!)
          : null,
      'longestStreakDate': longestStreakDate != null
          ? Timestamp.fromDate(longestStreakDate!)
          : null,
      'gracePeriod':
          StreakGracePeriodModel.fromEntity(gracePeriod).toJson(),
      'totalCheckIns': totalCheckIns,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    };
  }

  /// Converts to domain entity
  StreakEntity toEntity() {
    return StreakEntity(
      id: id,
      userId: userId,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      lastCheckInDate: lastCheckInDate,
      streakStartDate: streakStartDate,
      longestStreakDate: longestStreakDate,
      gracePeriod: gracePeriod is StreakGracePeriodModel
          ? (gracePeriod as StreakGracePeriodModel).toEntity()
          : gracePeriod,
      totalCheckIns: totalCheckIns,
      updatedAt: updatedAt,
    );
  }

  @override
  StreakModel copyWith({
    String? id,
    String? userId,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastCheckInDate,
    DateTime? streakStartDate,
    DateTime? longestStreakDate,
    StreakGracePeriod? gracePeriod,
    int? totalCheckIns,
    DateTime? updatedAt,
  }) {
    return StreakModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastCheckInDate: lastCheckInDate ?? this.lastCheckInDate,
      streakStartDate: streakStartDate ?? this.streakStartDate,
      longestStreakDate: longestStreakDate ?? this.longestStreakDate,
      gracePeriod: gracePeriod ?? this.gracePeriod,
      totalCheckIns: totalCheckIns ?? this.totalCheckIns,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
