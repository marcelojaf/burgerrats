import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/services/check_in_notification_service.dart';
import '../../../../core/services/firebase_storage_service.dart';
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

/// Enum to track which step of the submission process is currently active
enum SubmissionStep {
  /// Not submitting
  idle,

  /// Compressing the photo
  compressing,

  /// Uploading to Firebase Storage
  uploading,

  /// Creating Firestore document
  creatingDocument,

  /// Updating league points
  updatingPoints,
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
  final SubmissionStep submissionStep;
  final double uploadProgress;

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
    this.submissionStep = SubmissionStep.idle,
    this.uploadProgress = 0.0,
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
        createdCheckInId = null,
        submissionStep = SubmissionStep.idle,
        uploadProgress = 0.0;

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

  /// Returns a user-friendly message for the current submission step
  String get submissionStepMessage {
    return switch (submissionStep) {
      SubmissionStep.idle => '',
      SubmissionStep.compressing => 'Comprimindo foto...',
      SubmissionStep.uploading => 'Enviando foto (${(uploadProgress * 100).toInt()}%)...',
      SubmissionStep.creatingDocument => 'Salvando check-in...',
      SubmissionStep.updatingPoints => 'Atualizando pontos...',
    };
  }

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
    SubmissionStep? submissionStep,
    double? uploadProgress,
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
      submissionStep: submissionStep ?? this.submissionStep,
      uploadProgress: uploadProgress ?? this.uploadProgress,
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
        other.createdCheckInId == createdCheckInId &&
        other.submissionStep == submissionStep &&
        other.uploadProgress == uploadProgress;
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
        submissionStep,
        uploadProgress,
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

/// Provides the FirebaseStorageService instance from GetIt
final firebaseStorageServiceProvider = Provider<FirebaseStorageService>((ref) {
  return getIt<FirebaseStorageService>();
});

/// Provides the CheckInNotificationService instance from GetIt
final checkInNotificationServiceProvider =
    Provider<CheckInNotificationService>((ref) {
  return getIt<CheckInNotificationService>();
});

/// Notifier for the create check-in flow
class CreateCheckInNotifier extends StateNotifier<CreateCheckInState> {
  final CheckInRepository _checkInRepository;
  final LeagueRepository _leagueRepository;
  final ImageCompressionService _compressionService;
  final FirebaseStorageService _storageService;
  final CheckInNotificationService _notificationService;

  CreateCheckInNotifier(
    this._checkInRepository,
    this._leagueRepository,
    this._compressionService,
    this._storageService,
    this._notificationService,
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

  /// Updates the upload progress
  void _updateUploadProgress(double progress) {
    if (mounted) {
      state = state.copyWith(uploadProgress: progress);
    }
  }

  /// Submits the check-in with step-by-step progress tracking
  ///
  /// The submission flow:
  /// 1. Compress the photo
  /// 2. Upload to Firebase Storage
  /// 3. Create Firestore document
  /// 4. Update league points
  /// 5. Send notification to league members (non-blocking)
  ///
  /// Errors at each step are handled gracefully with user-friendly messages.
  /// The [userName] parameter is used for the notification content.
  Future<bool> submitCheckIn(String userId, {String? userName}) async {
    if (!state.canSubmit) {
      return false;
    }

    state = state.copyWith(
      status: CreateCheckInStatus.submitting,
      submissionStep: SubmissionStep.compressing,
      uploadProgress: 0.0,
      clearError: true,
    );

    try {
      // Step 1: Compress the photo
      final compressionResult = await _compressionService.compressPhotoCapture(
        state.photo!,
      );

      if (!mounted) return false;

      // Step 2: Upload to Firebase Storage
      state = state.copyWith(submissionStep: SubmissionStep.uploading);

      final uploadResult = await _storageService.uploadCheckInPhoto(
        userId: userId,
        leagueId: state.selectedLeagueId!,
        file: File(compressionResult.compressedPath),
        onProgress: _updateUploadProgress,
      );

      if (!mounted) return false;

      // Step 3: Create the check-in document
      state = state.copyWith(submissionStep: SubmissionStep.creatingDocument);

      final checkInId = const Uuid().v4();
      final checkIn = CheckInModel.newCheckIn(
        id: checkInId,
        userId: userId,
        leagueId: state.selectedLeagueId!,
        photoURL: uploadResult.downloadUrl,
        restaurantName: state.restaurantName,
        rating: state.rating,
        note: state.note,
      );

      await _checkInRepository.createCheckIn(checkIn);

      if (!mounted) return false;

      // Step 4: Add points to the user in the league
      state = state.copyWith(submissionStep: SubmissionStep.updatingPoints);

      final league = state.selectedLeague!;
      await _leagueRepository.addMemberPoints(
        leagueId: league.id,
        userId: userId,
        pointsToAdd: league.settings.pointsPerCheckIn,
      );

      if (!mounted) return false;

      // Step 5: Send notification to league members (non-blocking)
      // This is done in a fire-and-forget manner to not block the UI
      _sendCheckInNotification(
        checkInId: checkInId,
        userId: userId,
        userName: userName ?? 'Usuario',
        league: league,
      );

      state = state.copyWith(
        status: CreateCheckInStatus.success,
        submissionStep: SubmissionStep.idle,
        createdCheckInId: checkInId,
      );

      return true;
    } on CompressionException catch (e) {
      state = state.copyWith(
        status: CreateCheckInStatus.photoReady,
        submissionStep: SubmissionStep.idle,
        errorMessage: e.message,
      );
      return false;
    } on StorageException catch (e) {
      state = state.copyWith(
        status: CreateCheckInStatus.photoReady,
        submissionStep: SubmissionStep.idle,
        errorMessage: e.message,
      );
      return false;
    } on FirestoreException catch (e) {
      state = state.copyWith(
        status: CreateCheckInStatus.photoReady,
        submissionStep: SubmissionStep.idle,
        errorMessage: e.message,
      );
      return false;
    } on BusinessException catch (e) {
      state = state.copyWith(
        status: CreateCheckInStatus.photoReady,
        submissionStep: SubmissionStep.idle,
        errorMessage: e.message,
      );
      return false;
    } on AppException catch (e) {
      state = state.copyWith(
        status: CreateCheckInStatus.photoReady,
        submissionStep: SubmissionStep.idle,
        errorMessage: ErrorHandler.getUserMessage(e),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        status: CreateCheckInStatus.photoReady,
        submissionStep: SubmissionStep.idle,
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

  /// Sends a notification to league members about the check-in
  ///
  /// This is a fire-and-forget operation that doesn't affect the check-in flow.
  /// Any errors are silently logged and don't propagate to the UI.
  void _sendCheckInNotification({
    required String checkInId,
    required String userId,
    required String userName,
    required LeagueEntity league,
  }) {
    // Fire and forget - don't await
    _notificationService.sendCheckInNotification(
      checkInId: checkInId,
      userId: userId,
      userName: userName,
      leagueId: league.id,
      leagueName: league.name,
      restaurantName: state.restaurantName,
    );
  }
}

/// Provider for the CreateCheckInNotifier
final createCheckInNotifierProvider =
    StateNotifierProvider.autoDispose<CreateCheckInNotifier, CreateCheckInState>(
  (ref) {
    final checkInRepository = ref.watch(checkInRepositoryProvider);
    final leagueRepository = ref.watch(createCheckInLeagueRepositoryProvider);
    final compressionService = ref.watch(imageCompressionServiceProvider);
    final storageService = ref.watch(firebaseStorageServiceProvider);
    final notificationService = ref.watch(checkInNotificationServiceProvider);
    return CreateCheckInNotifier(
      checkInRepository,
      leagueRepository,
      compressionService,
      storageService,
      notificationService,
    );
  },
);
