// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:firebase_messaging/firebase_messaging.dart' as _i892;
import 'package:firebase_storage/firebase_storage.dart' as _i457;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:uuid/uuid.dart' as _i706;
import 'package:google_sign_in/google_sign_in.dart' as _i116;

import '../../features/activity_feed/data/repositories/activity_feed_repository_impl.dart'
    as _i920;
import '../../features/activity_feed/domain/repositories/activity_feed_repository.dart'
    as _i921;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/data/repositories/user_repository_impl.dart'
    as _i687;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/repositories/user_repository.dart' as _i926;
import '../../features/check_ins/data/repositories/check_in_repository_impl.dart'
    as _i128;
import '../../features/check_ins/domain/repositories/check_in_repository.dart'
    as _i649;
import '../../features/leagues/data/repositories/league_repository_impl.dart'
    as _i65;
import '../../features/leagues/domain/repositories/league_repository.dart'
    as _i381;
import '../../features/streak_tracker/data/repositories/streak_repository_impl.dart'
    as _i500;
import '../../features/streak_tracker/domain/repositories/streak_repository.dart'
    as _i501;
import '../../features/streak_tracker/domain/services/streak_tracker_service.dart'
    as _i502;
import '../services/app_service.dart' as _i479;
import '../services/check_in_notification_service.dart' as _i333;
import '../services/deep_link_service.dart' as _i391;
import '../services/firebase_auth_service.dart' as _i592;
import '../services/firebase_storage_service.dart' as _i879;
import '../services/image_compression_service.dart' as _i53;
import '../services/invite_code_generator_service.dart' as _i231;
import '../services/notification_service.dart' as _i738;
import '../services/permission_service.dart' as _i165;
import '../services/photo_capture_service.dart' as _i12;
import '../services/reminder_scheduler_service.dart' as _i423;
import '../services/shareable_image_service.dart' as _i525;
import '../services/theme_preferences_service.dart' as _i461;
import '../../features/reminders/data/repositories/reminder_settings_repository.dart'
    as _i424;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();

    // Pre-resolved async dependencies
    final sharedPreferences = await registerModule.sharedPreferences;
    gh.factory<_i460.SharedPreferences>(() => sharedPreferences);

    gh.lazySingleton<_i59.FirebaseAuth>(() => registerModule.firebaseAuth);
    gh.lazySingleton<_i974.FirebaseFirestore>(() => registerModule.firestore);
    gh.lazySingleton<_i706.Uuid>(() => registerModule.uuid);
    gh.lazySingleton<_i457.FirebaseStorage>(
      () => registerModule.firebaseStorage,
    );
    gh.lazySingleton<_i892.FirebaseMessaging>(
      () => registerModule.firebaseMessaging,
    );
    gh.lazySingleton<_i116.GoogleSignIn>(() => registerModule.googleSignIn);
    gh.lazySingleton<_i165.PermissionService>(() => _i165.PermissionService());
    gh.lazySingleton<_i391.DeepLinkService>(() => _i391.DeepLinkService());
    gh.lazySingleton<_i479.AppService>(() => _i479.AppService());
    gh.lazySingleton<_i53.ImageCompressionService>(
      () => _i53.ImageCompressionService(),
    );
    gh.lazySingleton<_i525.ShareableImageService>(
      () => _i525.ShareableImageService(),
    );
    gh.lazySingleton<_i879.FirebaseStorageService>(
      () => _i879.FirebaseStorageService(gh<_i457.FirebaseStorage>()),
    );
    gh.lazySingleton<_i231.InviteCodeGeneratorService>(
      () => _i231.InviteCodeGeneratorService(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i381.LeagueRepository>(
      () => _i65.LeagueRepositoryImpl(
        gh<_i974.FirebaseFirestore>(),
        gh<_i231.InviteCodeGeneratorService>(),
      ),
    );
    gh.lazySingleton<_i592.FirebaseAuthService>(
      () => _i592.FirebaseAuthService(gh<_i59.FirebaseAuth>()),
    );
    gh.lazySingleton<_i926.UserRepository>(
      () => _i687.UserRepositoryImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i787.AuthRepository>(
      () => _i153.AuthRepositoryImpl(
        gh<_i59.FirebaseAuth>(),
        gh<_i116.GoogleSignIn>(),
      ),
    );
    gh.lazySingleton<_i649.CheckInRepository>(
      () => _i128.CheckInRepositoryImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i501.StreakRepository>(
      () => _i500.StreakRepositoryImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i502.StreakTrackerService>(
      () => _i502.StreakTrackerService(
        gh<_i501.StreakRepository>(),
        gh<_i649.CheckInRepository>(),
        gh<_i706.Uuid>(),
      ),
    );
    gh.lazySingleton<_i12.PhotoCaptureService>(
      () => _i12.PhotoCaptureService(gh<_i165.PermissionService>()),
    );
    gh.lazySingleton<_i738.NotificationService>(
      () => _i738.NotificationService(
        gh<_i892.FirebaseMessaging>(),
        gh<_i974.FirebaseFirestore>(),
        gh<_i59.FirebaseAuth>(),
      ),
    );
    gh.lazySingleton<_i333.CheckInNotificationService>(
      () => _i333.CheckInNotificationService(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i921.ActivityFeedRepository>(
      () => _i920.ActivityFeedRepositoryImpl(
        gh<_i974.FirebaseFirestore>(),
        gh<_i926.UserRepository>(),
        gh<_i381.LeagueRepository>(),
      ),
    );
    gh.lazySingleton<_i424.ReminderSettingsRepository>(
      () => _i424.ReminderSettingsRepository(),
    );
    gh.lazySingleton<_i423.ReminderSchedulerService>(
      () => _i423.ReminderSchedulerService(
        gh<_i424.ReminderSettingsRepository>(),
      ),
    );
    gh.lazySingleton<_i461.ThemePreferencesService>(
      () => _i461.ThemePreferencesService(gh<_i460.SharedPreferences>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
