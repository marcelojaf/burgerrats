import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/services/notification_service.dart';
import '../../domain/entities/league_entity.dart';
import '../../domain/repositories/league_repository.dart';
import 'join_league_provider.dart';

/// State for the create league flow
enum CreateLeagueStatus {
  /// Initial state, form ready for input
  initial,

  /// Creating the league
  creating,

  /// League created successfully
  success,

  /// An error occurred
  error,
}

/// State class for the create league flow
class CreateLeagueState {
  final CreateLeagueStatus status;
  final LeagueEntity? league;
  final String? errorMessage;

  const CreateLeagueState({
    this.status = CreateLeagueStatus.initial,
    this.league,
    this.errorMessage,
  });

  const CreateLeagueState.initial()
      : status = CreateLeagueStatus.initial,
        league = null,
        errorMessage = null;

  const CreateLeagueState.creating()
      : status = CreateLeagueStatus.creating,
        league = null,
        errorMessage = null;

  const CreateLeagueState.success(this.league)
      : status = CreateLeagueStatus.success,
        errorMessage = null;

  const CreateLeagueState.error(this.errorMessage)
      : status = CreateLeagueStatus.error,
        league = null;

  bool get isLoading => status == CreateLeagueStatus.creating;

  bool get isSuccess => status == CreateLeagueStatus.success;

  bool get hasError => status == CreateLeagueStatus.error;

  bool get hasLeague => league != null;

  CreateLeagueState copyWith({
    CreateLeagueStatus? status,
    LeagueEntity? league,
    String? errorMessage,
  }) {
    return CreateLeagueState(
      status: status ?? this.status,
      league: league ?? this.league,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CreateLeagueState &&
        other.status == status &&
        other.league?.id == league?.id &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode => Object.hash(status, league?.id, errorMessage);
}

/// Notifier for the create league flow
///
/// Handles creating new leagues with name, description, and settings.
class CreateLeagueNotifier extends StateNotifier<CreateLeagueState> {
  final LeagueRepository _repository;
  final NotificationService _notificationService;

  CreateLeagueNotifier(this._repository, this._notificationService)
      : super(const CreateLeagueState.initial());

  /// Creates a new league with the given parameters
  ///
  /// Returns true if the league was created successfully.
  Future<bool> createLeague({
    required String name,
    String? description,
    required String createdBy,
    LeagueSettings? settings,
  }) async {
    // Validate name
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      state = const CreateLeagueState.error(
        'O nome da liga e obrigatorio',
      );
      return false;
    }

    if (trimmedName.length < 3) {
      state = const CreateLeagueState.error(
        'O nome da liga deve ter pelo menos 3 caracteres',
      );
      return false;
    }

    if (trimmedName.length > 50) {
      state = const CreateLeagueState.error(
        'O nome da liga deve ter no maximo 50 caracteres',
      );
      return false;
    }

    state = const CreateLeagueState.creating();

    try {
      final league = await _repository.createLeague(
        name: trimmedName,
        description: description?.trim(),
        createdBy: createdBy,
        settings: settings ?? const LeagueSettings.defaults(),
      );

      // Subscribe to league notifications (fire-and-forget)
      _subscribeToLeagueNotifications(league.id);

      state = CreateLeagueState.success(league);
      return true;
    } on BusinessException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'invalid-name':
          errorMessage = 'Nome da liga invalido.';
        case 'name-too-short':
          errorMessage = 'O nome da liga deve ter pelo menos 3 caracteres.';
        case 'name-too-long':
          errorMessage = 'O nome da liga deve ter no maximo 50 caracteres.';
        default:
          errorMessage = ErrorHandler.getUserMessage(e);
      }
      state = CreateLeagueState.error(errorMessage);
      return false;
    } on AppException catch (e) {
      state = CreateLeagueState.error(
        ErrorHandler.getUserMessage(e),
      );
      return false;
    } catch (e) {
      state = const CreateLeagueState.error(
        'Erro ao criar liga. Tente novamente.',
      );
      return false;
    }
  }

  /// Resets the state to initial
  void reset() {
    state = const CreateLeagueState.initial();
  }

  /// Clears any error and returns to initial state
  void clearError() {
    if (state.status == CreateLeagueStatus.error) {
      state = const CreateLeagueState.initial();
    }
  }

  /// Subscribes to league push notifications
  ///
  /// This is a fire-and-forget operation that doesn't affect the create flow.
  void _subscribeToLeagueNotifications(String leagueId) {
    _notificationService.subscribeToLeague(leagueId).catchError((e) {
      debugPrint('Failed to subscribe to league notifications: $e');
    });
  }
}

/// Provider for the CreateLeagueNotifier
final createLeagueNotifierProvider =
    StateNotifierProvider.autoDispose<CreateLeagueNotifier, CreateLeagueState>(
  (ref) {
    final repository = ref.watch(leagueRepositoryProvider);
    final notificationService = ref.watch(notificationServiceProvider);
    return CreateLeagueNotifier(repository, notificationService);
  },
);
