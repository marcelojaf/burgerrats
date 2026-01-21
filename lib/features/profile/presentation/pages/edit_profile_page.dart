import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/services/firebase_storage_service.dart';
import '../../../../core/services/image_compression_service.dart';
import '../../../../core/services/photo_capture_service.dart';
import '../../../../core/state/providers/auth_state_provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../providers/user_profile_provider.dart';

/// State for edit profile form
class EditProfileState {
  final bool isLoading;
  final bool isSaving;
  final bool isUploadingPhoto;
  final double uploadProgress;
  final String? errorMessage;
  final String? successMessage;
  final File? selectedPhoto;

  const EditProfileState({
    this.isLoading = false,
    this.isSaving = false,
    this.isUploadingPhoto = false,
    this.uploadProgress = 0.0,
    this.errorMessage,
    this.successMessage,
    this.selectedPhoto,
  });

  EditProfileState copyWith({
    bool? isLoading,
    bool? isSaving,
    bool? isUploadingPhoto,
    double? uploadProgress,
    String? errorMessage,
    String? successMessage,
    File? selectedPhoto,
    bool clearError = false,
    bool clearSuccess = false,
    bool clearPhoto = false,
  }) {
    return EditProfileState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isUploadingPhoto: isUploadingPhoto ?? this.isUploadingPhoto,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage:
          clearSuccess ? null : (successMessage ?? this.successMessage),
      selectedPhoto: clearPhoto ? null : (selectedPhoto ?? this.selectedPhoto),
    );
  }
}

/// Message key enum for localized messages
enum ProfileMessageKey {
  profileUpdatedSuccess,
  errorUpdatingProfile,
  photoUpdatedSuccess,
  errorUpdatingPhoto,
  errorUploadingPhoto,
}

/// Notifier for edit profile state
class EditProfileNotifier extends StateNotifier<EditProfileState> {
  final AuthNotifier _authNotifier;
  final FirebaseStorageService _storageService;
  final ImageCompressionService _compressionService;

  EditProfileNotifier(
    this._authNotifier,
    this._storageService,
    this._compressionService,
  ) : super(const EditProfileState());

  /// Gets localized message based on key
  static String getLocalizedMessage(ProfileMessageKey key, AppLocalizations l10n) {
    switch (key) {
      case ProfileMessageKey.profileUpdatedSuccess:
        return l10n.profileUpdatedSuccess;
      case ProfileMessageKey.errorUpdatingProfile:
        return l10n.errorUpdatingProfile;
      case ProfileMessageKey.photoUpdatedSuccess:
        return l10n.photoUpdatedSuccess;
      case ProfileMessageKey.errorUpdatingPhoto:
        return l10n.errorUpdatingPhoto;
      case ProfileMessageKey.errorUploadingPhoto:
        return l10n.errorUploadingPhoto;
    }
  }

  Future<ProfileMessageKey?> updateDisplayName(String displayName) async {
    state = state.copyWith(isSaving: true, clearError: true, clearSuccess: true);

    final success = await _authNotifier.updateDisplayName(displayName);

    state = state.copyWith(isSaving: false);

    return success ? ProfileMessageKey.profileUpdatedSuccess : ProfileMessageKey.errorUpdatingProfile;
  }

  void setSelectedPhoto(File photo) {
    state = state.copyWith(selectedPhoto: photo);
  }

  void clearSelectedPhoto() {
    state = state.copyWith(clearPhoto: true);
  }

  Future<ProfileMessageKey?> uploadProfilePhoto(String userId) async {
    if (state.selectedPhoto == null) return null;

    state = state.copyWith(
      isUploadingPhoto: true,
      uploadProgress: 0.0,
      clearError: true,
      clearSuccess: true,
    );

    try {
      // Compress the image first
      final compressionResult = await _compressionService.compressImage(
        state.selectedPhoto!.path,
        options: CompressionOptions.profilePhoto,
      );

      // Upload to Firebase Storage
      final uploadResult = await _storageService.uploadProfilePhoto(
        userId: userId,
        file: compressionResult.file,
        onProgress: (progress) {
          state = state.copyWith(uploadProgress: progress);
        },
      );

      // Update Auth profile with photo URL
      final success = await _authNotifier.updatePhotoURL(uploadResult.downloadUrl);

      if (success) {
        state = state.copyWith(
          isUploadingPhoto: false,
          uploadProgress: 1.0,
          clearPhoto: true,
        );
        return ProfileMessageKey.photoUpdatedSuccess;
      } else {
        state = state.copyWith(isUploadingPhoto: false);
        return ProfileMessageKey.errorUpdatingPhoto;
      }
    } catch (e) {
      state = state.copyWith(isUploadingPhoto: false);
      return ProfileMessageKey.errorUploadingPhoto;
    }
  }

  void clearMessages() {
    state = state.copyWith(clearError: true, clearSuccess: true);
  }
}

/// Provider for edit profile notifier
final editProfileNotifierProvider =
    StateNotifierProvider.autoDispose<EditProfileNotifier, EditProfileState>(
  (ref) {
    final authNotifier = ref.watch(authNotifierProvider.notifier);
    final storageService = getIt<FirebaseStorageService>();
    final compressionService = getIt<ImageCompressionService>();
    return EditProfileNotifier(authNotifier, storageService, compressionService);
  },
);

/// Provider for PhotoCaptureService
final photoCaptureServiceProvider = Provider<PhotoCaptureService>((ref) {
  return getIt<PhotoCaptureService>();
});

/// Edit profile page for updating user information
class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  bool _hasNameChanges = false;
  String? _originalName;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _initializeForm(UserProfileData? profile) {
    if (profile != null && _originalName == null) {
      _originalName = profile.displayName ?? '';
      _nameController.text = _originalName!;
    }
  }

  void _onFieldChanged() {
    setState(() {
      _hasNameChanges = _nameController.text != (_originalName ?? '');
    });
  }

  bool get _hasChanges {
    final editState = ref.read(editProfileNotifierProvider);
    return _hasNameChanges || editState.selectedPhoto != null;
  }

  Future<void> _selectPhoto() async {
    final photoCaptureService = ref.read(photoCaptureServiceProvider);

    try {
      final result = await photoCaptureService.captureWithSourceSelector(
        context,
        options: const PhotoCaptureOptions(
          maxWidth: 500,
          maxHeight: 500,
          imageQuality: 80,
        ),
      );

      if (result != null && mounted) {
        ref.read(editProfileNotifierProvider.notifier).setSelectedPhoto(result.file);
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.errorSelectingPhoto(e.toString())),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final notifier = ref.read(editProfileNotifierProvider.notifier);
    final profile = ref.read(userBasicInfoProvider);
    final editState = ref.read(editProfileNotifierProvider);

    ProfileMessageKey? photoResult;
    ProfileMessageKey? nameResult;

    // Upload photo if selected
    if (editState.selectedPhoto != null && profile != null) {
      photoResult = await notifier.uploadProfilePhoto(profile.uid);
    }

    // Update display name if changed
    if (_hasNameChanges) {
      nameResult = await notifier.updateDisplayName(_nameController.text.trim());
    }

    final hasPhotoError = photoResult == ProfileMessageKey.errorUpdatingPhoto ||
        photoResult == ProfileMessageKey.errorUploadingPhoto;
    final hasNameError = nameResult == ProfileMessageKey.errorUpdatingProfile;

    if (!hasPhotoError && !hasNameError && mounted) {
      ref.invalidate(userProfileProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.profileUpdatedSuccess),
          backgroundColor: Colors.green,
        ),
      );
      context.pop();
    } else if (mounted) {
      // Show the first error encountered
      final errorKey = hasPhotoError ? photoResult! : nameResult!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(EditProfileNotifier.getLocalizedMessage(errorKey, context.l10n)),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userBasicInfoProvider);
    final editState = ref.watch(editProfileNotifierProvider);

    // Initialize form with current data
    _initializeForm(profile);

    final isBusy = editState.isSaving || editState.isUploadingPhoto;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.editProfile),
        actions: [
          TextButton(
            onPressed: isBusy || !_hasChanges ? null : _saveProfile,
            child: isBusy
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    context.l10n.save,
                    style: TextStyle(
                      color: _hasChanges
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
          ),
        ],
      ),
      body: profile == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          _ProfileAvatarEdit(
                            photoURL: profile.photoURL,
                            displayName: profile.displayNameOrEmail,
                            selectedPhoto: editState.selectedPhoto,
                            isUploading: editState.isUploadingPhoto,
                            uploadProgress: editState.uploadProgress,
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              child: IconButton(
                                icon: const Icon(Icons.camera_alt, size: 18),
                                color: Theme.of(context).colorScheme.onPrimary,
                                padding: EdgeInsets.zero,
                                onPressed: isBusy ? null : _selectPhoto,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (editState.selectedPhoto != null) ...[
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: isBusy
                            ? null
                            : () {
                                ref.read(editProfileNotifierProvider.notifier).clearSelectedPhoto();
                                setState(() {});
                              },
                        icon: const Icon(Icons.close, size: 16),
                        label: Text(context.l10n.removeSelectedPhoto),
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: context.l10n.name,
                        prefixIcon: const Icon(Icons.person),
                        border: const OutlineInputBorder(),
                      ),
                      textCapitalization: TextCapitalization.words,
                      enabled: !isBusy,
                      onChanged: (_) => _onFieldChanged(),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return context.l10n.pleaseEnterName;
                        }
                        if (value.trim().length < 2) {
                          return context.l10n.nameMustHaveMinChars(2);
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: profile.email,
                      decoration: InputDecoration(
                        labelText: context.l10n.email,
                        prefixIcon: const Icon(Icons.email),
                        border: const OutlineInputBorder(),
                      ),
                      enabled: false,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.emailCannotBeChanged,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _ProfileAvatarEdit extends StatelessWidget {
  const _ProfileAvatarEdit({
    required this.photoURL,
    required this.displayName,
    this.selectedPhoto,
    this.isUploading = false,
    this.uploadProgress = 0.0,
  });

  final String? photoURL;
  final String displayName;
  final File? selectedPhoto;
  final bool isUploading;
  final double uploadProgress;

  @override
  Widget build(BuildContext context) {
    // If there's a selected photo, show it
    if (selectedPhoto != null) {
      return Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: ClipOval(
              child: Image.file(
                selectedPhoto!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (isUploading)
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    value: uploadProgress,
                    strokeWidth: 3,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      );
    }

    // Show existing photo URL or initial avatar
    if (photoURL != null && photoURL!.isNotEmpty) {
      return CircleAvatar(
        radius: 50,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: photoURL!,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => _buildInitialAvatar(context),
          ),
        ),
      );
    }

    return _buildInitialAvatar(context);
  }

  Widget _buildInitialAvatar(BuildContext context) {
    final initial =
        displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';

    return CircleAvatar(
      radius: 50,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: Text(
        initial,
        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
      ),
    );
  }
}
