import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/services/notification_service.dart';
import '../../domain/entities/league_entity.dart';
import '../../domain/repositories/league_repository.dart';

/// Provides the LeagueRepository instance from GetIt
final leagueRepositoryProvider = Provider<LeagueRepository>((ref) {
  return getIt<LeagueRepository>();
});

/// Provides the NotificationService instance from GetIt
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return getIt<NotificationService>();
});

/// State for the join league flow
enum JoinLeagueStatus {
  /// Initial state, waiting for invite code input
  initial,

  /// Looking up the league by invite code
  searching,

  /// League found and preview is displayed
  previewReady,

  /// User confirmed, joining the league
  joining,

  /// Successfully joined the league
  success,

  /// An error occurred
  error,
}

/// State class for the join league flow
class JoinLeagueState {
  final JoinLeagueStatus status;
  final LeagueEntity? league;
  final String? errorMessage;
  final String inviteCode;

  const JoinLeagueState({
    this.status = JoinLeagueStatus.initial,
    this.league,
    this.errorMessage,
    this.inviteCode = '',
  });

  const JoinLeagueState.initial()
      : status = JoinLeagueStatus.initial,
        league = null,
        errorMessage = null,
        inviteCode = '';

  const JoinLeagueState.searching(this.inviteCode)
      : status = JoinLeagueStatus.searching,
        league = null,
        errorMessage = null;

  const JoinLeagueState.previewReady(this.league, this.inviteCode)
      : status = JoinLeagueStatus.previewReady,
        errorMessage = null;

  const JoinLeagueState.joining(this.league, this.inviteCode)
      : status = JoinLeagueStatus.joining,
        errorMessage = null;

  const JoinLeagueState.success(this.league, this.inviteCode)
      : status = JoinLeagueStatus.success,
        errorMessage = null;

  const JoinLeagueState.error(this.errorMessage, this.inviteCode)
      : status = JoinLeagueStatus.error,
        league = null;

  bool get isLoading =>
      status == JoinLeagueStatus.searching ||
      status == JoinLeagueStatus.joining;

  bool get canSearch =>
      status == JoinLeagueStatus.initial || status == JoinLeagueStatus.error;

  bool get canJoin => status == JoinLeagueStatus.previewReady;

  bool get hasLeague => league != null;

  JoinLeagueState copyWith({
    JoinLeagueStatus? status,
    LeagueEntity? league,
    String? errorMessage,
    String? inviteCode,
  }) {
    return JoinLeagueState(
      status: status ?? this.status,
      league: league ?? this.league,
      errorMessage: errorMessage ?? this.errorMessage,
      inviteCode: inviteCode ?? this.inviteCode,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JoinLeagueState &&
        other.status == status &&
        other.league?.id == league?.id &&
        other.errorMessage == errorMessage &&
        other.inviteCode == inviteCode;
  }

  @override
  int get hashCode => Object.hash(status, league?.id, errorMessage, inviteCode);
}

/// Notifier for the join league flow
///
/// Handles searching for a league by invite code and joining it.
class JoinLeagueNotifier extends StateNotifier<JoinLeagueState> {
  final LeagueRepository _repository;
  final NotificationService _notificationService;

  JoinLeagueNotifier(this._repository, this._notificationService)
      : super(const JoinLeagueState.initial());

  /// Searches for a league by its invite code
  ///
  /// Updates state to show the league preview if found.
  Future<void> searchByInviteCode(String inviteCode) async {
    final normalizedCode = inviteCode.trim().toUpperCase();

    if (normalizedCode.isEmpty) {
      state = JoinLeagueState.error(
        'Por favor, insira um codigo de convite',
        normalizedCode,
      );
      return;
    }

    if (normalizedCode.length < 6 || normalizedCode.length > 8) {
      state = JoinLeagueState.error(
        'O codigo de convite deve ter entre 6 e 8 caracteres',
        normalizedCode,
      );
      return;
    }

    state = JoinLeagueState.searching(normalizedCode);

    try {
      final league = await _repository.getLeagueByInviteCode(normalizedCode);

      if (league == null) {
        state = JoinLeagueState.error(
          'Liga nao encontrada. Verifique o codigo de convite.',
          normalizedCode,
        );
        return;
      }

      if (league.isFull) {
        state = JoinLeagueState.error(
          'Esta liga atingiu o limite maximo de membros.',
          normalizedCode,
        );
        return;
      }

      state = JoinLeagueState.previewReady(league, normalizedCode);
    } on AppException catch (e) {
      state = JoinLeagueState.error(
        ErrorHandler.getUserMessage(e),
        normalizedCode,
      );
    } catch (e) {
      state = JoinLeagueState.error(
        'Erro ao buscar liga. Tente novamente.',
        normalizedCode,
      );
    }
  }

  /// Joins the currently previewed league
  ///
  /// Requires a valid league to be loaded via [searchByInviteCode] first.
  Future<bool> joinLeague(String userId) async {
    if (state.league == null) {
      state = JoinLeagueState.error(
        'Nenhuma liga selecionada',
        state.inviteCode,
      );
      return false;
    }

    final league = state.league!;

    // Check if user is already a member
    if (league.isMember(userId)) {
      state = JoinLeagueState.error(
        'Voce ja e membro desta liga.',
        state.inviteCode,
      );
      return false;
    }

    state = JoinLeagueState.joining(league, state.inviteCode);

    try {
      await _repository.addMember(
        leagueId: league.id,
        userId: userId,
      );

      // Subscribe to league notifications (fire-and-forget)
      _subscribeToLeagueNotifications(league.id);

      state = JoinLeagueState.success(league, state.inviteCode);
      return true;
    } on BusinessException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'already-member':
          errorMessage = 'Voce ja e membro desta liga.';
        case 'league-full':
          errorMessage = 'Esta liga atingiu o limite maximo de membros.';
        case 'league-not-found':
          errorMessage = 'Liga nao encontrada.';
        default:
          errorMessage = ErrorHandler.getUserMessage(e);
      }
      state = JoinLeagueState.error(errorMessage, state.inviteCode);
      return false;
    } on AppException catch (e) {
      state = JoinLeagueState.error(
        ErrorHandler.getUserMessage(e),
        state.inviteCode,
      );
      return false;
    } catch (e) {
      state = JoinLeagueState.error(
        'Erro ao entrar na liga. Tente novamente.',
        state.inviteCode,
      );
      return false;
    }
  }

  /// Resets the state to initial
  void reset() {
    state = const JoinLeagueState.initial();
  }

  /// Clears any error and returns to initial state
  void clearError() {
    if (state.status == JoinLeagueStatus.error) {
      state = const JoinLeagueState.initial();
    }
  }

  /// Subscribes to league push notifications
  ///
  /// This is a fire-and-forget operation that doesn't affect the join flow.
  void _subscribeToLeagueNotifications(String leagueId) {
    _notificationService.subscribeToLeague(leagueId).catchError((e) {
      debugPrint('Failed to subscribe to league notifications: $e');
    });
  }
}

/// Provider for the JoinLeagueNotifier
final joinLeagueNotifierProvider =
    StateNotifierProvider.autoDispose<JoinLeagueNotifier, JoinLeagueState>(
  (ref) {
    final repository = ref.watch(leagueRepositoryProvider);
    final notificationService = ref.watch(notificationServiceProvider);
    return JoinLeagueNotifier(repository, notificationService);
  },
);
