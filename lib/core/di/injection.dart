import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

/// Global service locator instance
final GetIt getIt = GetIt.instance;

/// Configures the dependency injection container
///
/// This function should be called once at app startup before [runApp].
/// It registers all injectable services and repositories.
///
/// Environment-specific registrations can be configured using:
/// - [Environment.dev] for development
/// - [Environment.test] for testing
/// - [Environment.prod] for production
@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies({String? environment}) async {
  await getIt.init(environment: environment);
}
