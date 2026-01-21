# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

BurgerRats is a Flutter mobile app for burger competitions between friends. It uses Firebase for backend services (Auth, Firestore, Storage, FCM).

**Supported Platforms:** iOS and Android only. Desktop and Web are not supported.

## Common Commands

```bash
# Install dependencies
flutter pub get

# Run code generation (required after modifying injectable/riverpod annotations)
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run

# Run all tests
flutter test

# Run a single test file
flutter test test/features/leagues/data/repositories/league_repository_impl_test.dart

# Analyze code
flutter analyze

# iOS specific - install pods
cd ios && pod install && cd ..
```

## Architecture

### Feature-Based Structure
The codebase follows Clean Architecture with a feature-based organization:

```
lib/
├── core/           # Shared infrastructure (DI, routing, services, state)
├── features/       # Feature modules (auth, leagues, check_ins, profile, etc.)
│   └── {feature}/
│       ├── data/           # Models, repository implementations
│       ├── domain/         # Entities, repository interfaces
│       └── presentation/   # Pages, providers, widgets
└── shared/         # Shared UI components, theme, extensions
```

### Key Patterns

**Dependency Injection:** Uses `get_it` + `injectable`. Services are registered as lazy singletons with `@LazySingleton`. Access via `getIt<ServiceType>()`.

**State Management:** Riverpod for UI state. Providers are defined in feature presentation layers. Auth state flows through `authStateProvider` and `authNotifierProvider`.

**Repository Pattern:** Abstract repository interfaces in `domain/repositories/`, concrete implementations in `data/repositories/` with `@LazySingleton(as: RepositoryInterface)`.

**Routing:** GoRouter with auth-aware redirects via `routerProvider`. Routes defined in `lib/core/router/app_router.dart`, constants in `app_routes.dart`.

### Code Generation

After modifying files with `@injectable`, `@LazySingleton`, or Riverpod annotations:
```bash
dart run build_runner build --delete-conflicting-outputs
```

Generated files:
- `lib/core/di/injection.config.dart` - DI container config

### Firebase Services

- **Auth:** `FirebaseAuthService` + `AuthRepository`
- **Firestore:** Direct injection via `getIt<FirebaseFirestore>()`
- **Storage:** `FirebaseStorageService`
- **FCM:** `NotificationService`

### Error Handling

Custom exceptions in `lib/core/errors/exceptions.dart`:
- `FirestoreException` - Firestore operations
- `BusinessException` - Business rule violations
- `PermissionException` - Permission checks

### Secrets Configuration

Sensitive configuration (API keys, DSNs) is stored in `.secrets/app_secrets.json` (gitignored).

**Setup:**
1. Copy `.secrets.example/app_secrets.json` to `.secrets/app_secrets.json`
2. Fill in the actual values

**Structure:**
```json
{
  "environment": "dev | stg | prod",
  "sentry": {
    "dsn": "https://YOUR_KEY@YOUR_ORG.ingest.sentry.io/YOUR_PROJECT_ID"
  }
}
```

**Environments:**
- `dev` - Development (full tracing)
- `stg` - Staging (full tracing)
- `prod` - Production (20% trace sampling)

### Testing

Uses `fake_cloud_firestore` for Firestore mocks and `mocktail` for mocking. Tests mirror the `lib/` structure under `test/`.

## Language

User-facing strings and error messages are in Portuguese (pt-BR).
