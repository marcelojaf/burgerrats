import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/services/image_compression_service.dart';
import '../../../../core/services/photo_capture_service.dart';
import '../../../leagues/domain/entities/league_entity.dart';
import '../../../leagues/domain/repositories/league_repository.dart';
import '../../data/models/check_in_model.dart';
import '../../domain/repositories/check_in_repository.dart';

/// State enum for the create check-in flow
enum CreateCheckInStatus {
  /// Initial state, waiting for user input
  initial,

  /// Loading leagues or checking daily limits
  loading,

  /// Ready to capture photo or submit
  ready,

  /// Photo captured, ready to submit
  photoReady,

  /// Uploading photo and creating check-in
  submitting,

  /// Successfully created check-in
  success,

  /// An error occurred
  error,
}

/// State class for the create check-in flow
class CreateCheckInState {
  final CreateCheckInStatus status;
  final List<LeagueEntity> userLeagues;
  final String? selectedLeagueId;
  final LeagueEntity? selectedLeague;
  final PhotoCaptureResult? photo;
  final bool canCheckIn;
  final String? dailyLimitMessage;
  final String? restaurantName;
  final int? rating;
  final String? note;
  final String? errorMessage;
  final String? createdCheckInId;

  const CreateCheckInState({
    this.status = CreateCheckInStatus.initial,
    this.userLeagues = const [],
    this.selectedLeagueId,
    this.selectedLeague,
    this.photo,
    this.canCheckIn = true,
    this.dailyLimitMessage,
    this.restaurantName,
    this.rating,
    this.note,
    this.errorMessage,
    this.createdCheckInId,
  });

  const CreateCheckInState.initial()
      : status = CreateCheckInStatus.initial,
        userLeagues = const [],
        selectedLeagueId = null,
        selectedLeague = null,
        photo = null,
        canCheckIn = true,
        dailyLimitMessage = null,
        restaurantName = null,
        rating = null,
        note = null,
        errorMessage = null,
        createdCheckInId = null;

  bool get isLoading =>
      status == CreateCheckInStatus.loading ||
      status == CreateCheckInStatus.submitting;

  bool get hasPhoto => photo != null;

  bool get hasSelectedLeague => selectedLeagueId != null;

  bool get canSubmit =>
      hasPhoto &&
      hasSelectedLeague &&
      canCheckIn &&
      status != CreateCheckInStatus.submitting;

  bool get isSuccess => status == CreateCheckInStatus.success;

  CreateCheckInState copyWith({
    CreateCheckInStatus? status,
    List<LeagueEntity>? userLeagues,
    String? selectedLeagueId,
    LeagueEntity? selectedLeague,
    PhotoCaptureResult? photo,
    bool? canCheckIn,
    String? dailyLimitMessage,
    String? restaurantName,
    int? rating,
    String? note,
    String? errorMessage,
    String? createdCheckInId,
    bool clearPhoto = false,
    bool clearSelectedLeague = false,
    bool clearError = false,
    bool clearDailyLimitMessage = false,
    bool clearRestaurantName = false,
    bool clearRating = false,
    bool clearNote = false,
  }) {
    return CreateCheckInState(
      status: status ?? this.status,
      userLeagues: userLeagues ?? this.userLeagues,
      selectedLeagueId:
          clearSelectedLeague ? null : (selectedLeagueId ?? this.selectedLeagueId),
      selectedLeague:
          clearSelectedLeague ? null : (selectedLeague ?? this.selectedLeague),
      photo: clearPhoto ? null : (photo ?? this.photo),
      canCheckIn: canCheckIn ?? this.canCheckIn,
      dailyLimitMessage: clearDailyLimitMessage
          ? null
          : (dailyLimitMessage ?? this.dailyLimitMessage),
      restaurantName:
          clearRestaurantName ? null : (restaurantName ?? this.restaurantName),
      rating: clearRating ? null : (rating ?? this.rating),
      note: clearNote ? null : (note ?? this.note),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      createdCheckInId: createdCheckInId ?? this.createdCheckInId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CreateCheckInState &&
        other.status == status &&
        other.userLeagues.length == userLeagues.length &&
        other.selectedLeagueId == selectedLeagueId &&
        other.photo?.path == photo?.path &&
        other.canCheckIn == canCheckIn &&
        other.dailyLimitMessage == dailyLimitMessage &&
        other.restaurantName == restaurantName &&
        other.rating == rating &&
        other.note == note &&
        other.errorMessage == errorMessage &&
        other.createdCheckInId == createdCheckInId;
  }

  @override
  int get hashCode => Object.hash(
        status,
        userLeagues.length,
        selectedLeagueId,
        photo?.path,
        canCheckIn,
        dailyLimitMessage,
        restaurantName,
        rating,
        note,
        errorMessage,
        createdCheckInId,
      );
}

/// Provides the CheckInRepository instance from GetIt
final checkInRepositoryProvider = Provider<CheckInRepository>((ref) {
  return getIt<CheckInRepository>();
});

/// Provides the LeagueRepository instance from GetIt
final createCheckInLeagueRepositoryProvider = Provider<LeagueRepository>((ref) {
  return getIt<LeagueRepository>();
});

/// Provides the PhotoCaptureService instance from GetIt
final photoCaptureServiceProvider = Provider<PhotoCaptureService>((ref) {
  return getIt<PhotoCaptureService>();
});

/// Provides the ImageCompressionService instance from GetIt
final imageCompressionServiceProvider = Provider<ImageCompressionService>((ref) {
  return getIt<ImageCompressionService>();
});

/// Notifier for the create check-in flow
class CreateCheckInNotifier extends StateNotifier<CreateCheckInState> {
  final CheckInRepository _checkInRepository;
  final LeagueRepository _leagueRepository;
  final ImageCompressionService _compressionService;

  CreateCheckInNotifier(
    this._checkInRepository,
    this._leagueRepository,
    this._compressionService,
  ) : super(const CreateCheckInState.initial());

  /// Loads the user's leagues
  Future<void> loadUserLeagues(String userId) async {
    state = state.copyWith(status: CreateCheckInStatus.loading, clearError: true);

    try {
      final leagues = await _leagueRepository.getLeaguesForUser(userId);
      state = state.copyWith(
        status: CreateCheckInStatus.ready,
        userLeagues: leagues,
      );
    } on AppException catch (e) {
      state = state.copyWith(
        status: CreateCheckInStatus.error,
        errorMessage: ErrorHandler.getUserMessage(e),
      );
    } catch (e) {
      state = state.copyWith(
        status: CreateCheckInStatus.error,
        errorMessage: 'Erro ao carregar suas ligas. Tente novamente.',
      );
    }
  }

  /// Selects a league and checks daily limit
  Future<void> selectLeague(String leagueId, String userId) async {
    final league = state.userLeagues.firstWhere(
      (l) => l.id == leagueId,
      orElse: () => throw StateError('League not found'),
    );

    state = state.copyWith(
      selectedLeagueId: leagueId,
      selectedLeague: league,
      status: CreateCheckInStatus.loading,
      clearDailyLimitMessage: true,
      clearError: true,
    );

    try {
      final canCheckIn = await _checkInRepository.canUserCheckInTodayForLeague(
        userId,
        leagueId,
      );

      if (canCheckIn) {
        state = state.copyWith(
          status: state.hasPhoto
              ? CreateCheckInStatus.photoReady
              : CreateCheckInStatus.ready,
          canCheckIn: true,
        );
      } else {
        state = state.copyWith(
          status: CreateCheckInStatus.ready,
          canCheckIn: false,
          dailyLimitMessage: 'Voce ja fez check-in hoje nesta liga.',
        );
      }
    } on AppException catch (e) {
      state = state.copyWith(
        status: CreateCheckInStatus.error,
        errorMessage: ErrorHandler.getUserMessage(e),
      );
    } catch (e) {
      state = state.copyWith(
        status: CreateCheckInStatus.error,
        errorMessage: 'Erro ao verificar limite diario. Tente novamente.',
      );
    }
  }

  /// Sets the captured photo
  void setPhoto(PhotoCaptureResult photo) {
    state = state.copyWith(
      photo: photo,
      status: CreateCheckInStatus.photoReady,
      clearError: true,
    );
  }

  /// Clears the captured photo
  void clearPhoto() {
    state = state.copyWith(
      clearPhoto: true,
      status: state.hasSelectedLeague
          ? CreateCheckInStatus.ready
          : CreateCheckInStatus.initial,
    );
  }

  /// Sets the restaurant name
  void setRestaurantName(String? name) {
    state = state.copyWith(
      restaurantName: name,
      clearRestaurantName: name == null || name.isEmpty,
    );
  }

  /// Sets the rating
  void setRating(int? rating) {
    state = state.copyWith(
      rating: rating,
      clearRating: rating == null,
    );
  }

  /// Sets the note
  void setNote(String? note) {
    state = state.copyWith(
      note: note,
      clearNote: note == null || note.isEmpty,
    );
  }

  /// Submits the check-in
  Future<bool> submitCheckIn(String userId) async {
    if (!state.canSubmit) {
      return false;
    }

    state = state.copyWith(
      status: CreateCheckInStatus.submitting,
      clearError: true,
    );

    try {
      // 1. Compress the photo
      final compressionResult = await _compressionService.compressPhotoCapture(
        state.photo!,
      );

      // 2. Upload to Firebase Storage
      final checkInId = const Uuid().v4();
      final storagePath = 'checkIns/$userId/$checkInId/photo.jpg';
      final storageRef = FirebaseStorage.instance.ref().child(storagePath);

      await storageRef.putFile(
        File(compressionResult.compressedPath),
        SettableMetadata(contentType: 'image/jpeg'),
      );

      final photoURL = await storageRef.getDownloadURL();

      // 3. Create the check-in document
      final checkIn = CheckInModel.newCheckIn(
        id: checkInId,
        userId: userId,
        leagueId: state.selectedLeagueId!,
        photoURL: photoURL,
        restaurantName: state.restaurantName,
        rating: state.rating,
        note: state.note,
      );

      await _checkInRepository.createCheckIn(checkIn);

      // 4. Add points to the user in the league
      final league = state.selectedLeague!;
      await _leagueRepository.addMemberPoints(
        leagueId: league.id,
        userId: userId,
        pointsToAdd: league.settings.pointsPerCheckIn,
      );

      state = state.copyWith(
        status: CreateCheckInStatus.success,
        createdCheckInId: checkInId,
      );

      return true;
    } on AppException catch (e) {
      state = state.copyWith(
        status: CreateCheckInStatus.photoReady,
        errorMessage: ErrorHandler.getUserMessage(e),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        status: CreateCheckInStatus.photoReady,
        errorMessage: 'Erro ao criar check-in. Tente novamente.',
      );
      return false;
    }
  }

  /// Resets the state
  void reset() {
    state = const CreateCheckInState.initial();
  }

  /// Clears any error message
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

/// Provider for the CreateCheckInNotifier
final createCheckInNotifierProvider =
    StateNotifierProvider.autoDispose<CreateCheckInNotifier, CreateCheckInState>(
  (ref) {
    final checkInRepository = ref.watch(checkInRepositoryProvider);
    final leagueRepository = ref.watch(createCheckInLeagueRepositoryProvider);
    final compressionService = ref.watch(imageCompressionServiceProvider);
    return CreateCheckInNotifier(
      checkInRepository,
      leagueRepository,
      compressionService,
    );
  },
);
