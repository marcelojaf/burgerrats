import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/services/photo_capture_service.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../leagues/domain/entities/league_entity.dart';
import '../providers/create_check_in_provider.dart';
import '../widgets/daily_limit_status_widget.dart';
import '../widgets/league_selector_widget.dart';
import '../widgets/photo_preview_widget.dart';
import '../widgets/rating_selector_widget.dart';

/// Page for creating a new check-in with camera preview, photo capture,
/// and league selection
class CreateCheckInPage extends ConsumerStatefulWidget {
  const CreateCheckInPage({super.key, this.preselectedLeagueId});

  /// Optional league ID to pre-select
  final String? preselectedLeagueId;

  @override
  ConsumerState<CreateCheckInPage> createState() => _CreateCheckInPageState();
}

class _CreateCheckInPageState extends ConsumerState<CreateCheckInPage> {
  final _restaurantController = TextEditingController();
  final _noteController = TextEditingController();
  late final PhotoCaptureService _photoCaptureService;

  String? get _currentUserId => FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _photoCaptureService = getIt<PhotoCaptureService>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserLeagues();
    });
  }

  @override
  void dispose() {
    _restaurantController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _loadUserLeagues() {
    final userId = _currentUserId;
    if (userId != null) {
      ref.read(createCheckInNotifierProvider.notifier).loadUserLeagues(userId);
    }
  }

  Future<void> _capturePhoto() async {
    try {
      final result = await _photoCaptureService.captureWithSourceSelector(context);
      if (result != null && mounted) {
        ref.read(createCheckInNotifierProvider.notifier).setPhoto(result);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.errorCapturingPhoto(e.toString())),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _onLeagueSelected(LeagueEntity league) {
    final userId = _currentUserId;
    if (userId != null) {
      ref
          .read(createCheckInNotifierProvider.notifier)
          .selectLeague(league.id, userId);
    }
  }

  void _onRestaurantNameChanged(String value) {
    ref.read(createCheckInNotifierProvider.notifier).setRestaurantName(value);
  }

  void _onRatingChanged(int? rating) {
    ref.read(createCheckInNotifierProvider.notifier).setRating(rating);
  }

  void _onNoteChanged(String value) {
    ref.read(createCheckInNotifierProvider.notifier).setNote(value);
  }

  void _clearPhoto() {
    ref.read(createCheckInNotifierProvider.notifier).clearPhoto();
  }

  Future<void> _submitCheckIn() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userId = currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.mustBeLoggedInToCheckIn),
        ),
      );
      return;
    }

    // Get user display name for notification
    final userName = currentUser?.displayName ??
        currentUser?.email?.split('@').first ??
        'Usuario';

    final success = await ref
        .read(createCheckInNotifierProvider.notifier)
        .submitCheckIn(userId, userName: userName);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.checkInSuccess),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
      context.pop(true);
    }
  }

  String _getSubmissionStepMessage(CreateCheckInState state, AppLocalizations l10n) {
    return switch (state.submissionStep) {
      SubmissionStep.idle => l10n.processing,
      SubmissionStep.compressing => l10n.compressingPhoto,
      SubmissionStep.uploading => l10n.uploadingPhoto((state.uploadProgress * 100).toInt()),
      SubmissionStep.creatingDocument => l10n.savingCheckIn,
      SubmissionStep.updatingPoints => l10n.updatingPoints,
    };
  }

  String? _getErrorMessage(CreateCheckInState state, AppLocalizations l10n) {
    // If there's an explicit error message (from exception), use it
    if (state.errorMessage != null) {
      return state.errorMessage;
    }
    // Otherwise, generate message based on error type
    return switch (state.errorType) {
      CheckInErrorType.none => null,
      CheckInErrorType.loadingLeagues => l10n.errorLoadingLeagues,
      CheckInErrorType.checkingDailyLimit => l10n.errorCheckingDailyLimit,
      CheckInErrorType.creatingCheckIn => l10n.errorCreatingCheckIn,
      CheckInErrorType.other => null, // Already has errorMessage
    };
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createCheckInNotifierProvider);
    final theme = Theme.of(context);
    final l10n = context.l10n;

    // Listen for errors
    ref.listen<CreateCheckInState>(
      createCheckInNotifierProvider,
      (previous, next) {
        final errorMessage = _getErrorMessage(next, l10n);
        final previousErrorMessage = previous != null ? _getErrorMessage(previous, l10n) : null;
        if (errorMessage != null && errorMessage != previousErrorMessage) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: theme.colorScheme.error,
            ),
          );
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.newCheckIn),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: state.status == CreateCheckInStatus.loading && state.userLeagues.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Photo Preview Section
                  _PhotoSection(
                    photo: state.photo,
                    onCapturePhoto: _capturePhoto,
                    onClearPhoto: _clearPhoto,
                    isLoading: state.status == CreateCheckInStatus.submitting,
                  ),
                  const SizedBox(height: 24),

                  // League Selection Section
                  Text(
                    l10n.selectLeague,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LeagueSelectorWidget(
                    leagues: state.userLeagues,
                    selectedLeagueId: state.selectedLeagueId,
                    onLeagueSelected: _onLeagueSelected,
                    isEnabled: !state.isLoading,
                  ),
                  const SizedBox(height: 16),

                  // Daily Limit Status
                  if (state.selectedLeagueId != null)
                    DailyLimitStatusWidget(
                      canCheckIn: state.canCheckIn,
                    ),

                  // Optional Fields Section
                  if (state.hasPhoto && state.canCheckIn) ...[
                    const SizedBox(height: 24),
                    Text(
                      l10n.detailsOptional,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Restaurant Name
                    TextField(
                      controller: _restaurantController,
                      decoration: InputDecoration(
                        labelText: l10n.restaurantName,
                        hintText: l10n.restaurantNameHint,
                        prefixIcon: const Icon(Icons.restaurant),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: _onRestaurantNameChanged,
                      enabled: !state.isLoading,
                    ),
                    const SizedBox(height: 16),

                    // Rating
                    RatingSelectorWidget(
                      rating: state.rating,
                      onRatingChanged: _onRatingChanged,
                      isEnabled: !state.isLoading,
                    ),
                    const SizedBox(height: 16),

                    // Note
                    TextField(
                      controller: _noteController,
                      decoration: InputDecoration(
                        labelText: l10n.observation,
                        hintText: l10n.observationHint,
                        prefixIcon: const Icon(Icons.note),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      maxLines: 3,
                      onChanged: _onNoteChanged,
                      enabled: !state.isLoading,
                    ),
                  ],

                  const SizedBox(height: 32),

                  // Submit Button
                  FilledButton(
                    onPressed: state.canSubmit ? _submitCheckIn : null,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: state.status == CreateCheckInStatus.submitting
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _getSubmissionStepMessage(state, l10n),
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          )
                        : Text(
                            l10n.makeCheckIn,
                            style: const TextStyle(fontSize: 16),
                          ),
                  ),

                  // Validation Messages
                  if (!state.canCheckIn)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        l10n.cannotCheckIn(l10n.alreadyCheckedInToday),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  if (!state.hasPhoto)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        l10n.takePhotoToCheckIn,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  if (!state.hasSelectedLeague && state.userLeagues.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        l10n.selectLeagueToCheckIn,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  if (state.userLeagues.isEmpty &&
                      state.status != CreateCheckInStatus.loading)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Column(
                        children: [
                          Icon(
                            Icons.emoji_events_outlined,
                            size: 48,
                            color: theme.colorScheme.outline,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.notPartOfAnyLeague,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () => context.push('/leagues/join'),
                            child: Text(l10n.joinALeague),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }
}

/// Photo section with preview and capture button
class _PhotoSection extends StatelessWidget {
  const _PhotoSection({
    required this.photo,
    required this.onCapturePhoto,
    required this.onClearPhoto,
    required this.isLoading,
  });

  final PhotoCaptureResult? photo;
  final VoidCallback onCapturePhoto;
  final VoidCallback onClearPhoto;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    if (photo != null) {
      return PhotoPreviewWidget(
        photoFile: File(photo!.path),
        onRetake: onClearPhoto,
        isLoading: isLoading,
      );
    }

    return GestureDetector(
      onTap: isLoading ? null : onCapturePhoto,
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
            width: 2,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.camera_alt,
                size: 48,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.takeBurgerPhoto,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.tapToAddPhoto,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
